package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.GoodsReceipt;
import model.GoodsReceiptDetail;
import model.Location;
import model.Product;
import model.ProductDetail;
import model.PurchaseOrder;
import model.PurchaseOrderDetail;
import model.Supplier;
import model.User;

/**
 * Goods Receipt data access with support for:
 * - Creating draft receipts (Status = 1)
 * - Confirming drafts to completed (Status = 2) and updating stock
 * - Allowing multiple receipts per Purchase Order and updating PO status
 * based on cumulative received quantity.
 * - Cancelling drafts (Status = 3) without touching stock.
 */
public class GoodsReceiptDAO extends DBContext {

    // =========================
    // Utility
    // =========================

    public String generateReceiptCode() {
        String prefix = "GRO-";
        String sql = "SELECT COUNT(*) FROM Goods_Receipt";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }
            return prefix + String.format("%05d", count + 1);
        } catch (SQLException e) {
            e.printStackTrace();
            return prefix + "00001";
        }
    }

    /**
     * Tìm một ProductDetailID bất kỳ cho ProductID tương ứng.
     * Dùng cho luồng nhập kho (GRO) khi chỉ có ProductID mà chưa chọn lô chi tiết.
     */
    private Integer findFirstProductDetailId(int productId) throws SQLException {
        // Đổi LIMIT 1 thành SELECT TOP 1
        String sql = "SELECT TOP 1 ProductDetailID FROM Product_Detail WHERE ProductID = ? ORDER BY ProductDetailID ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ProductDetailID");
                }
            }
        }
        return null;
    }

    // =========================
    // Query single receipt
    // =========================

    public GoodsReceipt getById(int id) {
        String sql = "SELECT gr.ReceiptID, gr.ReceiptCode, gr.PurchaseOrderID, gr.LocationID, "
                + "gr.ReceiptDate, gr.Status, gr.Note, gr.CreateBy, "
                + "po.OrderCode, po.Status AS POStatus, po.SupplierID, s.Name AS SupplierName, "
                + "l.LocationName, l.LocationCode "
                + "FROM Goods_Receipt gr "
                + "LEFT JOIN Purchase_Order po ON gr.PurchaseOrderID = po.PurchaseOrderID "
                + "LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID "
                + "LEFT JOIN Location l ON gr.LocationID = l.LocationID "
                + "WHERE gr.ReceiptID = ?";
        GoodsReceipt gr = null;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    gr = new GoodsReceipt();
                    gr.setId(rs.getInt("ReceiptID"));
                    gr.setReceiptCode(rs.getString("ReceiptCode"));
                    gr.setStatus(rs.getInt("Status"));
                    Timestamp ts = rs.getTimestamp("ReceiptDate");
                    if (ts != null) {
                        gr.setReceiptDate(new java.util.Date(ts.getTime()));
                    }
                    gr.setNote(rs.getString("Note"));

                    // PO
                    int poId = rs.getInt("PurchaseOrderID");
                    if (!rs.wasNull()) {
                        PurchaseOrder po = new PurchaseOrder();
                        po.setId(poId);
                        po.setOrderCode(rs.getString("OrderCode"));
                        po.setStatus(rs.getInt("POStatus"));
                        Supplier s = new Supplier();
                        s.setId(rs.getInt("SupplierID"));
                        s.setName(rs.getString("SupplierName"));
                        po.setSupplier(s);
                        gr.setPurchaseOrder(po);
                    }

                    // Location
                    int locId = rs.getInt("LocationID");
                    if (!rs.wasNull()) {
                        Location loc = new Location();
                        loc.setId(locId);
                        loc.setLocationName(rs.getString("LocationName"));
                        loc.setLocationCode(rs.getString("LocationCode"));
                        gr.setLocation(loc);
                    }

                    // Created by (id only)
                    int createById = rs.getInt("CreateBy");
                    if (!rs.wasNull()) {
                        User u = new User();
                        u.setId(createById);
                        gr.setCreateBy(u);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (gr == null) {
            return null;
        }

        // Load details
        String sqlDetail = "SELECT d.ReceiptDetailID, d.ProductID, d.ProductDetailID, "
                + "d.QuantityExpected, d.QuantityActual, "
                + "p.Code AS ProductCode, p.Name AS ProductName "
                + "FROM Goods_Receipt_Detail d "
                + "LEFT JOIN Product p ON d.ProductID = p.ProductID "
                + "WHERE d.ReceiptID = ?";
        List<GoodsReceiptDetail> details = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sqlDetail)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GoodsReceiptDetail d = new GoodsReceiptDetail();
                    d.setId(rs.getInt("ReceiptDetailID"));
                    d.setReceipt(gr);

                    Product p = new Product();
                    p.setId(rs.getInt("ProductID"));
                    p.setCode(rs.getString("ProductCode"));
                    p.setName(rs.getString("ProductName"));
                    d.setProduct(p);

                    int pdId = rs.getInt("ProductDetailID");
                    if (!rs.wasNull()) {
                        ProductDetail pd = new ProductDetail();
                        pd.setId(pdId);
                        d.setProductDetail(pd);
                    }

                    d.setQuantityExpected(rs.getInt("QuantityExpected"));
                    d.setQuantityActual(rs.getInt("QuantityActual"));
                    details.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        gr.setDetails(details);

        // Load PO details (for PO section in detail page), if PO exists
        if (gr.getPurchaseOrder() != null) {
            int poId = gr.getPurchaseOrder().getId();
            String sqlPoDetails = "SELECT pod.PurchaseOrderDetailID, pod.Quantity, pod.Price, pod.SubTotal, "
                    + "p.ProductID, p.Name AS ProductName, p.Code AS ProductCode "
                    + "FROM Purchase_Order_Detail pod "
                    + "LEFT JOIN Product p ON pod.ProductID = p.ProductID "
                    + "WHERE pod.PurchaseOrderID = ?";
            List<PurchaseOrderDetail> poDetails = new ArrayList<>();
            try (PreparedStatement ps = connection.prepareStatement(sqlPoDetails)) {
                ps.setInt(1, poId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        PurchaseOrderDetail pod = new PurchaseOrderDetail();
                        pod.setId(rs.getInt("PurchaseOrderDetailID"));
                        pod.setPurchaseOrderId(poId);
                        pod.setQuantity(rs.getInt("Quantity"));
                        pod.setPrice(rs.getDouble("Price"));
                        pod.setSubTotal(rs.getDouble("SubTotal"));

                        Product p = new Product();
                        p.setId(rs.getInt("ProductID"));
                        p.setName(rs.getString("ProductName"));
                        p.setCode(rs.getString("ProductCode"));
                        pod.setProduct(p);

                        poDetails.add(pod);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            gr.getPurchaseOrder().setDetails(poDetails);
        }

        return gr;
    }

    // =========================
    // Listing + search
    // =========================

    public int count(String keyword, int status) {
        String sql = "SELECT COUNT(*) FROM Goods_Receipt gr "
                + "LEFT JOIN Purchase_Order po ON gr.PurchaseOrderID = po.PurchaseOrderID "
                + "WHERE (gr.ReceiptCode LIKE ? OR po.OrderCode LIKE ?) "
                + "AND (? = 0 OR gr.Status = ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setInt(3, status);
            ps.setInt(4, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<GoodsReceipt> searchAndPaginate(String keyword, int status, int offset, int limit) {
        List<GoodsReceipt> list = new ArrayList<>();
        String sql = "SELECT gr.ReceiptID, gr.ReceiptCode, gr.PurchaseOrderID, gr.LocationID, "
                + "gr.ReceiptDate, gr.Status, gr.Note, "
                + "po.OrderCode, po.Status AS POStatus, "
                + "l.LocationName "
                + "FROM Goods_Receipt gr "
                + "LEFT JOIN Purchase_Order po ON gr.PurchaseOrderID = po.PurchaseOrderID "
                + "LEFT JOIN Location l ON gr.LocationID = l.LocationID "
                + "WHERE (gr.ReceiptCode LIKE ? OR po.OrderCode LIKE ?) "
                + "AND (? = 0 OR gr.Status = ?) "
                + "ORDER BY gr.ReceiptDate DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setInt(3, status);
            ps.setInt(4, status);
            ps.setInt(5, offset);
            ps.setInt(6, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GoodsReceipt gr = new GoodsReceipt();
                    gr.setId(rs.getInt("ReceiptID"));
                    gr.setReceiptCode(rs.getString("ReceiptCode"));
                    gr.setStatus(rs.getInt("Status"));
                    Timestamp ts = rs.getTimestamp("ReceiptDate");
                    if (ts != null) {
                        gr.setReceiptDate(new java.util.Date(ts.getTime()));
                    }

                    PurchaseOrder po = new PurchaseOrder();
                    po.setId(rs.getInt("PurchaseOrderID"));
                    po.setOrderCode(rs.getString("OrderCode"));
                    po.setStatus(rs.getInt("POStatus"));
                    gr.setPurchaseOrder(po);

                    Location loc = new Location();
                    loc.setId(rs.getInt("LocationID"));
                    loc.setLocationName(rs.getString("LocationName"));
                    gr.setLocation(loc);

                    list.add(gr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // =========================
    // Purchase Orders for GRO
    // =========================

    /**
     * Get POs that are eligible for creating GRO.
     * Chỉ PO đã "Mark Received" (Status = 3) mới được chọn để tạo phiếu nhập kho.
     * Confirm (Status = 2) chỉ để khóa, không cho chỉnh sửa.
     */
    public List<PurchaseOrder> getConfirmedPOs() {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = "SELECT po.PurchaseOrderID, po.OrderCode, po.Status, po.TotalAmount, "
                + "po.SupplierID, s.Name AS SupplierName "
                + "FROM Purchase_Order po "
                + "LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID "
                + "WHERE po.Status = 3 "
                + "ORDER BY po.CreatedDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setId(rs.getInt("PurchaseOrderID"));
                po.setOrderCode(rs.getString("OrderCode"));
                po.setStatus(rs.getInt("Status"));
                po.setTotalAmount(rs.getDouble("TotalAmount"));
                Supplier s = new Supplier();
                s.setId(rs.getInt("SupplierID"));
                s.setName(rs.getString("SupplierName"));
                po.setSupplier(s);

                // Load details (for create page pre-load)
                String sqlDetails = "SELECT pod.PurchaseOrderDetailID, pod.Quantity, "
                        + "p.ProductID, p.Code AS ProductCode, p.Name AS ProductName "
                        + "FROM Purchase_Order_Detail pod "
                        + "LEFT JOIN Product p ON pod.ProductID = p.ProductID "
                        + "WHERE pod.PurchaseOrderID = ?";
                List<PurchaseOrderDetail> details = new ArrayList<>();
                try (PreparedStatement ps2 = connection.prepareStatement(sqlDetails)) {
                    ps2.setInt(1, po.getId());
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            PurchaseOrderDetail d = new PurchaseOrderDetail();
                            d.setId(rs2.getInt("PurchaseOrderDetailID"));
                            d.setPurchaseOrderId(po.getId());
                            d.setQuantity(rs2.getInt("Quantity"));
                            Product p = new Product();
                            p.setId(rs2.getInt("ProductID"));
                            p.setCode(rs2.getString("ProductCode"));
                            p.setName(rs2.getString("ProductName"));
                            d.setProduct(p);
                            details.add(d);
                        }
                    }
                }
                po.setDetails(details);

                list.add(po);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Create a draft Goods Receipt and its details.
     * - Status is always set to 1 (Draft)
     * - QuantityActual is initially copied from QuantityExpected
     * - Does NOT update stock or Purchase Order status
     *
     * @return generated ReceiptID, or -1 on failure
     */
    public int createDraft(GoodsReceipt gr, List<GoodsReceiptDetail> details) {
        String sqlHeader = "INSERT INTO Goods_Receipt "
                + "(ReceiptCode, PurchaseOrderID, LocationID, ReceiptDate, Status, Note, CreateBy) "
                + "VALUES (?, ?, ?, GETDATE(), ?, ?, ?)";

        String sqlDetail = "INSERT INTO Goods_Receipt_Detail "
                + "(ReceiptID, ProductID, ProductDetailID, QuantityExpected, QuantityActual) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement psHeader = connection.prepareStatement(sqlHeader, Statement.RETURN_GENERATED_KEYS)) {
            psHeader.setString(1, gr.getReceiptCode());
            psHeader.setInt(2, gr.getPurchaseOrder().getId());
            psHeader.setInt(3, gr.getLocation().getId());
            psHeader.setInt(4, 1); // Draft
            psHeader.setString(5, gr.getNote());
            // Tạm thời không set CreateBy để tránh lỗi FK khi chưa có user đăng nhập
            psHeader.setNull(6, java.sql.Types.INTEGER);
            psHeader.executeUpdate();

            ResultSet rs = psHeader.getGeneratedKeys();
            if (!rs.next()) {
                return -1;
            }
            int receiptId = rs.getInt(1);

            try (PreparedStatement psDetail = connection.prepareStatement(sqlDetail)) {
                for (GoodsReceiptDetail d : details) {
                    int productId = d.getProduct().getId();
                    Integer pdId = null;
                    if (d.getProductDetail() != null) {
                        pdId = d.getProductDetail().getId();
                    } else {
                        // Tự map sang một ProductDetailID bất kỳ của Product để phù hợp với cấu trúc tồn kho
                        pdId = findFirstProductDetailId(productId);
                    }

                    psDetail.setInt(1, receiptId);
                    psDetail.setInt(2, productId);
                    if (pdId != null) {
                        psDetail.setInt(3, pdId);
                    } else {
                        psDetail.setNull(3, java.sql.Types.INTEGER);
                    }
                    psDetail.setInt(4, d.getQuantityExpected());
                    psDetail.setInt(5, d.getQuantityActual());
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }

            return receiptId;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Confirm a draft receipt:
     * - Update actual quantities for details
     * - Update Goods_Receipt status to 2 (Completed) if still Draft
     * - Increment stock in Location_Product
     * - Insert Inventory_Transaction records (RECEIPT)
     * - Recalculate and update Purchase_Order status based on cumulative
     * received quantity across ALL completed receipts for that PO.
     */
    public boolean confirmDraft(int receiptId, List<GoodsReceiptDetail> updatedDetails) {
        String sqlUpdateDetail = "UPDATE Goods_Receipt_Detail "
                + "SET QuantityActual = ? "
                + "WHERE ReceiptDetailID = ? AND ReceiptID = ?";

        String sqlUpdateHeader = "UPDATE Goods_Receipt "
                + "SET Status = 2 "
                + "WHERE ReceiptID = ? AND Status = 1";

        // For recalculating PO status
        String sqlGetPoId = "SELECT PurchaseOrderID, LocationID, ReceiptCode FROM Goods_Receipt WHERE ReceiptID = ?";

        try {
            connection.setAutoCommit(false);

            int poId;
            int locationId;
            String receiptCode;
            try (PreparedStatement psPo = connection.prepareStatement(sqlGetPoId)) {
                psPo.setInt(1, receiptId);
                try (ResultSet rs = psPo.executeQuery()) {
                    if (!rs.next()) {
                        connection.rollback();
                        return false;
                    }
                    poId = rs.getInt("PurchaseOrderID");
                    locationId = rs.getInt("LocationID");
                    receiptCode = rs.getString("ReceiptCode");
                }
            }

            // 1. Update detail actual quantities
            try (PreparedStatement psDetail = connection.prepareStatement(sqlUpdateDetail)) {
                for (GoodsReceiptDetail d : updatedDetails) {
                    psDetail.setInt(1, d.getQuantityActual());
                    psDetail.setInt(2, d.getId());
                    psDetail.setInt(3, receiptId);
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }

            // 2. Update header status -> Completed (if still Draft)
            int affectedHeader;
            try (PreparedStatement psHeader = connection.prepareStatement(sqlUpdateHeader)) {
                psHeader.setInt(1, receiptId);
                affectedHeader = psHeader.executeUpdate();
            }
            if (affectedHeader == 0) {
                // Not a draft anymore or not found
                connection.rollback();
                return false;
            }

            // 3. Update stock & inventory transactions based on DB state after update
            applyStockAndTransactions(locationId, receiptCode, receiptId);

            // 4. Recalculate purchase order status based on cumulative received qty
            recalculatePurchaseOrderStatus(poId);

            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException re) {
                re.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Nếu phiếu nhập chưa có chi tiết (Goods_Receipt_Detail), tạo chi tiết từ PO
     * tương ứng.
     * Dùng cho phiếu tạo cũ chưa có bản ghi chi tiết — cho phép Hoàn thành sau.
     *
     * @return true nếu đã chèn ít nhất một dòng, false nếu phiếu đã có chi tiết
     *         hoặc lỗi
     */
    public boolean createDetailsFromPOIfMissing(int receiptId) {
        String sqlCount = "SELECT COUNT(*) FROM Goods_Receipt_Detail WHERE ReceiptID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlCount)) {
            ps.setInt(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0)
                    return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String sqlGr = "SELECT PurchaseOrderID FROM Goods_Receipt WHERE ReceiptID = ?";
        int poId;
        try (PreparedStatement ps = connection.prepareStatement(sqlGr)) {
            ps.setInt(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next())
                    return false;
                poId = rs.getInt("PurchaseOrderID");
                if (rs.wasNull())
                    return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String sqlPod = "SELECT ProductID, Quantity FROM Purchase_Order_Detail WHERE PurchaseOrderID = ?";
        // ProductDetailID để NULL ở cấp chi tiết; khi cập nhật tồn kho sẽ tự map sang ProductDetail phù hợp
        String sqlIns = "INSERT INTO Goods_Receipt_Detail "
                + "(ReceiptID, ProductID, ProductDetailID, QuantityExpected, QuantityActual) "
                + "VALUES (?, ?, NULL, ?, ?)";
        try (PreparedStatement psSel = connection.prepareStatement(sqlPod);
                PreparedStatement psIns = connection.prepareStatement(sqlIns)) {
            psSel.setInt(1, poId);
            try (ResultSet rs = psSel.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("ProductID");
                    int qty = rs.getInt("Quantity");

                    psIns.setInt(1, receiptId); // ReceiptID
                    psIns.setInt(2, productId); // ProductID
                    // VALUES (?, ?, NULL, ?, ?) -> chỉ có 4 tham số
                    psIns.setInt(3, qty);       // QuantityExpected
                    psIns.setInt(4, qty);       // QuantityActual
                    psIns.executeUpdate();
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cancel a draft receipt (Status 1 -> 3).
     * Does not touch stock because draft has no stock impact.
     */
    public boolean cancelReceipt(int receiptId) {
        String sql = "UPDATE Goods_Receipt SET Status = 3 WHERE ReceiptID = ? AND Status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, receiptId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Read back updated details from DB and:
     * - increase Location_Product
     * - insert Inventory_Transaction rows
     */
    private void applyStockAndTransactions(int locationId, String receiptCode, int receiptId) throws SQLException {
        String sqlFetchDetails = "SELECT ProductID, ProductDetailID, QuantityActual "
                + "FROM Goods_Receipt_Detail WHERE ReceiptID = ?";

        String sqlUpdateStock = "UPDATE Location_Product "
                + "SET Quantity = Quantity + ? "
                + "WHERE LocationID = ? AND (ProductDetailID = ? OR (ProductDetailID IS NULL AND ? IS NULL)) AND ProductID = ?";

        String sqlInsertStock = "INSERT INTO Location_Product "
                + "(LocationID, ProductDetailID, ProductID, Quantity) "
                + "VALUES (?, ?, ?, ?)";

        String sqlTrans = "INSERT INTO Inventory_Transaction "
                + "(ProductID, ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode, TransactionDate) "
                + "VALUES (?, ?, ?, 1, ?, ?, GETDATE())";

        try (PreparedStatement psFetch = connection.prepareStatement(sqlFetchDetails);
                PreparedStatement psStockUpdate = connection.prepareStatement(sqlUpdateStock);
                PreparedStatement psStockInsert = connection.prepareStatement(sqlInsertStock);
                PreparedStatement psTrans = connection.prepareStatement(sqlTrans)) {

            psFetch.setInt(1, receiptId);
            try (ResultSet rs = psFetch.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("ProductID");
                    int productDetailId = rs.getInt("ProductDetailID");
                    boolean isPdIdNull = rs.wasNull();
                    int qtyActual = rs.getInt("QuantityActual");

                    if (qtyActual <= 0) {
                        continue;
                    }

                    // Nếu ProductDetailID đang null (dữ liệu cũ), cố gắng map sang một ProductDetail bất kỳ của Product.
                    // Nếu vẫn không có ProductDetail → bỏ qua cập nhật tồn kho cho dòng này nhưng vẫn cho phép Confirm.
                    if (isPdIdNull) {
                        Integer fallbackPdId = findFirstProductDetailId(productId);
                        if (fallbackPdId != null) {
                            productDetailId = fallbackPdId;
                            isPdIdNull = false;
                        } else {
                            System.out.println("[WARN] Skip stock update for ProductID=" + productId
                                    + " at LocationID=" + locationId
                                    + " because no Product_Detail exists.");
                            continue;
                        }
                    }

                    psStockUpdate.setInt(1, qtyActual);
                    psStockUpdate.setInt(2, locationId);
                    psStockUpdate.setInt(3, productDetailId);
                    psStockUpdate.setInt(4, productDetailId);
                    psStockUpdate.setInt(5, productId);
                    int affected = psStockUpdate.executeUpdate();

                    if (affected == 0) {
                        psStockInsert.setInt(1, locationId);
                        psStockInsert.setInt(2, productDetailId);
                        psStockInsert.setInt(3, productId);
                        psStockInsert.setInt(4, qtyActual);
                        psStockInsert.executeUpdate();
                    }

                    psTrans.setInt(1, productId);
                    psTrans.setInt(2, productDetailId);
                    psTrans.setInt(3, locationId);
                    psTrans.setInt(4, qtyActual);
                    psTrans.setString(5, receiptCode);
                    psTrans.addBatch();
                }
            }

            psTrans.executeBatch();
        }
    }

    /**
     * Recalculate Purchase_Order.Status for a given PO:
     * - Sum ordered quantity from Purchase_Order_Detail
     * - Sum received quantity from ALL completed Goods_Receipt for that PO
     * - If received >= ordered and ordered > 0 => Status = 3 (Received)
     * - Else if ordered > 0 => Status = 2 (Confirmed / Partially Received)
     * - If ordered = 0 => keep current status.
     */
    private void recalculatePurchaseOrderStatus(int poId) throws SQLException {
        String sqlCheck = "SELECT "
                + "COALESCE((SELECT SUM(Quantity) FROM Purchase_Order_Detail WHERE PurchaseOrderID = ?), 0) AS OrderedQty, "
                + "COALESCE((SELECT SUM(grd.QuantityActual) "
                + "        FROM Goods_Receipt gr "
                + "        JOIN Goods_Receipt_Detail grd ON gr.ReceiptID = grd.ReceiptID "
                + "        WHERE gr.PurchaseOrderID = ? AND gr.Status = 2), 0) AS ReceivedQty";

        int ordered = 0;
        int received = 0;
        try (PreparedStatement ps = connection.prepareStatement(sqlCheck)) {
            ps.setInt(1, poId);
            ps.setInt(2, poId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ordered = rs.getInt("OrderedQty");
                    received = rs.getInt("ReceivedQty");
                }
            }
        }

        if (ordered <= 0) {
            // Nothing to update; keep current status
            return;
        }

        int newStatus = (received >= ordered) ? 3 : 2; // 3: Received, 2: Confirmed / Partially
        String sqlUpdatePO = "UPDATE Purchase_Order SET Status = ? WHERE PurchaseOrderID = ?";
        try (PreparedStatement psUpdate = connection.prepareStatement(sqlUpdatePO)) {
            psUpdate.setInt(1, newStatus);
            psUpdate.setInt(2, poId);
            psUpdate.executeUpdate();
        }
    }
}
