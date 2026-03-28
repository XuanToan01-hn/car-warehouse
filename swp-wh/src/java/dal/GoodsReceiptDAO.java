package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    /**
     * Sum of QuantityActual already delivered by completed/partial GROs
     * for a given PO, grouped by ProductDetailID.
     */
    public Map<Integer, Integer> getDeliveredQtyByPO(int poId) {
        Map<Integer, Integer> map = new HashMap<>();
        String sql = "SELECT grd.ProductDetailID, SUM(grd.QuantityActual) AS Delivered "
                + "FROM Goods_Receipt_Detail grd "
                + "JOIN Goods_Receipt gr ON grd.ReceiptID = gr.ReceiptID "
                + "WHERE gr.PurchaseOrderID = ? AND gr.Status IN (2, 4) "
                + "GROUP BY grd.ProductDetailID";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("ProductDetailID"), rs.getInt("Delivered"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    /**
     * Get current stock at a location for a list of ProductDetailIDs.
     */
    public Map<Integer, Integer> getStockAtLocation(int locationId, List<Integer> productDetailIds) {
        Map<Integer, Integer> map = new HashMap<>();
        if (productDetailIds == null || productDetailIds.isEmpty() || locationId <= 0)
            return map;
        String sql = "SELECT ProductDetailID, Quantity FROM Location_Product WHERE LocationID = ? AND ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int pdId : productDetailIds) {
                ps.setInt(1, locationId);
                ps.setInt(2, pdId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        map.put(pdId, rs.getInt("Quantity"));
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
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
        String sqlDetail = "SELECT d.ReceiptDetailID, pd.ProductID, d.ProductDetailID, "
                + "d.QuantityExpected, d.QuantityActual, "
                + "p.Code AS ProductCode, p.Name AS ProductName, "
                + "pd.LotNumber, pd.SerialNumber, pd.Color "
                + "FROM Goods_Receipt_Detail d "
                + "JOIN Product_Detail pd ON d.ProductDetailID = pd.ProductDetailID "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
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
                        pd.setLotNumber(rs.getString("LotNumber"));
                        pd.setSerialNumber(rs.getString("SerialNumber"));
                        pd.setColor(rs.getString("Color"));
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

        // --- Compute remainingQty & currentStock for each detail line ---
        if (gr.getPurchaseOrder() != null && !details.isEmpty()) {
            int poId = gr.getPurchaseOrder().getId();
            int locationId = (gr.getLocation() != null) ? gr.getLocation().getId() : 0;

            // Sum of QuantityActual already delivered by ALL completed/partial GROs
            // for the same PO, INCLUDING this GRO's current saved actual
            String sqlDelivered = "SELECT grd.ProductDetailID, SUM(grd.QuantityActual) AS Delivered "
                    + "FROM Goods_Receipt_Detail grd "
                    + "JOIN Goods_Receipt gr2 ON grd.ReceiptID = gr2.ReceiptID "
                    + "WHERE gr2.PurchaseOrderID = ? "
                    + "  AND gr2.Status IN (2, 4) "
                    + "GROUP BY grd.ProductDetailID";
            Map<Integer, Integer> deliveredMap = new HashMap<>();
            try (PreparedStatement psD = connection.prepareStatement(sqlDelivered)) {
                psD.setInt(1, poId);
                try (ResultSet rsD = psD.executeQuery()) {
                    while (rsD.next()) {
                        deliveredMap.put(rsD.getInt("ProductDetailID"), rsD.getInt("Delivered"));
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            // Stock at the receipt's location for each ProductDetailID
            String sqlStock = "SELECT Quantity FROM Location_Product WHERE LocationID = ? AND ProductDetailID = ?";

            // Also need HOW MUCH was ordered per ProductDetailID in the PO
            String sqlPoQty = "SELECT ProductDetailID, Quantity FROM Purchase_Order_Detail WHERE PurchaseOrderID = ?";
            Map<Integer, Integer> poQtyMap = new HashMap<>();
            try (PreparedStatement psPQ = connection.prepareStatement(sqlPoQty)) {
                psPQ.setInt(1, poId);
                try (ResultSet rsPQ = psPQ.executeQuery()) {
                    while (rsPQ.next()) {
                        poQtyMap.put(rsPQ.getInt("ProductDetailID"), rsPQ.getInt("Quantity"));
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            for (GoodsReceiptDetail d : details) {
                int pdId = (d.getProductDetail() != null) ? d.getProductDetail().getId() : 0;

                // Remaining = PO ordered qty - already delivered by other GROs
                int poOrderedQty = poQtyMap.getOrDefault(pdId, d.getQuantityExpected());
                int alreadyDelivered = deliveredMap.getOrDefault(pdId, 0);
                int remaining = poOrderedQty - alreadyDelivered;
                if (remaining < 0)
                    remaining = 0;
                d.setRemainingQty(remaining);

                // Current stock at location
                if (locationId > 0 && pdId > 0) {
                    try (PreparedStatement psS = connection.prepareStatement(sqlStock)) {
                        psS.setInt(1, locationId);
                        psS.setInt(2, pdId);
                        try (ResultSet rsS = psS.executeQuery()) {
                            if (rsS.next()) {
                                d.setCurrentStock(rsS.getInt("Quantity"));
                            }
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        // Load PO details (for PO section in detail page), if PO exists
        if (gr.getPurchaseOrder() != null) {
            int poId = gr.getPurchaseOrder().getId();
            String sqlPoDetails = "SELECT pod.PurchaseOrderDetailID, pod.Quantity, pod.Price, pod.SubTotal, "
                    + "pd.ProductID, p.Name AS ProductName, p.Code AS ProductCode, "
                    + "pd.ProductDetailID, pd.LotNumber, pd.SerialNumber, pd.Color "
                    + "FROM Purchase_Order_Detail pod "
                    + "LEFT JOIN Product_Detail pd ON pod.ProductDetailID = pd.ProductDetailID "
                    + "LEFT JOIN Product p ON pd.ProductID = p.ProductID "
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

                        int pdId = rs.getInt("ProductDetailID");
                        if (!rs.wasNull()) {
                            ProductDetail pd = new ProductDetail();
                            pd.setId(pdId);
                            pd.setLotNumber(rs.getString("LotNumber"));
                            pd.setSerialNumber(rs.getString("SerialNumber"));
                            pd.setColor(rs.getString("Color"));
                            pod.setProductDetail(pd);
                        }

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
                + "l.LocationName, "
                + "COALESCE((SELECT SUM(d.QuantityExpected) FROM Goods_Receipt_Detail d WHERE d.ReceiptID = gr.ReceiptID), 0) AS TotalExpected, "
                + "COALESCE((SELECT SUM(d.QuantityActual)   FROM Goods_Receipt_Detail d WHERE d.ReceiptID = gr.ReceiptID), 0) AS TotalActual "
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
                    gr.setTotalExpected(rs.getInt("TotalExpected"));
                    gr.setTotalActual(rs.getInt("TotalActual"));

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
     * Only POs with Status = 3 (Received) can be used.
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
                        + "pd.ProductDetailID, pd.ProductID, p.Code AS ProductCode, p.Name AS ProductName "
                        + "FROM Purchase_Order_Detail pod "
                        + "LEFT JOIN Product_Detail pd ON pod.ProductDetailID = pd.ProductDetailID "
                        + "LEFT JOIN Product p ON pd.ProductID = p.ProductID "
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
                            // Handle cases where ProductID might be missing in broken lines
                            int productId = rs2.getInt("ProductID");
                            if (!rs2.wasNull()) {
                                p.setId(productId);
                                p.setCode(rs2.getString("ProductCode"));
                                p.setName(rs2.getString("ProductName"));
                            } else {
                                p.setName("Unknown Product");
                                p.setCode("-");
                            }
                            d.setProduct(p);

                            int pdId = rs2.getInt("ProductDetailID");
                            if (!rs2.wasNull()) {
                                ProductDetail pd = new ProductDetail();
                                pd.setId(pdId);
                                d.setProductDetail(pd);
                            }

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
     * Create and confirm a Goods Receipt immediately.
     * - Status is 2 (Completed) if all items received, else 4 (Partially Received)
     * - Updates stock and inventory transactions
     * - Updates Purchase Order status
     *
     * @return generated ReceiptID, or -1 on failure
     */
    public int createAndConfirmReceipt(GoodsReceipt gr, List<GoodsReceiptDetail> details) {
        String sqlHeader = "INSERT INTO Goods_Receipt "
                + "(ReceiptCode, PurchaseOrderID, LocationID, ReceiptDate, Status, Note, CreateBy) "
                + "VALUES (?, ?, ?, GETDATE(), ?, ?, ?)";

        String sqlDetail = "INSERT INTO Goods_Receipt_Detail "
                + "(ReceiptID, ProductID, ProductDetailID, QuantityExpected, QuantityActual) "
                + "VALUES (?, ?, ?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            // Use the status passed in the object if it's already set (usually 2 or 4)
            int finalStatus = gr.getStatus();
            if (finalStatus <= 0) {
                // Fallback logic for safety
                int totalExp = 0;
                int totalAct = 0;
                for (GoodsReceiptDetail d : details) {
                    totalExp += d.getQuantityExpected();
                    totalAct += d.getQuantityActual();
                }
                finalStatus = (totalExp > 0 && totalAct >= totalExp) ? 2 : 4;
            }

            int receiptId = -1;
            try (PreparedStatement psHeader = connection.prepareStatement(sqlHeader, Statement.RETURN_GENERATED_KEYS)) {
                psHeader.setString(1, gr.getReceiptCode());
                psHeader.setInt(2, gr.getPurchaseOrder().getId());
                psHeader.setInt(3, gr.getLocation().getId());
                psHeader.setInt(4, finalStatus);
                psHeader.setString(5, gr.getNote());
                if (gr.getCreateBy() != null) {
                    psHeader.setInt(6, gr.getCreateBy().getId());
                } else {
                    psHeader.setNull(6, java.sql.Types.INTEGER);
                }
                psHeader.executeUpdate();

                ResultSet rs = psHeader.getGeneratedKeys();
                if (rs.next()) {
                    receiptId = rs.getInt(1);
                }
            }

            if (receiptId <= 0) {
                connection.rollback();
                return -1;
            }

            try (PreparedStatement psDetail = connection.prepareStatement(sqlDetail)) {
                for (GoodsReceiptDetail d : details) {
                    int productId = d.getProduct().getId();
                    Integer pdId = null;
                    if (d.getProductDetail() != null) {
                        pdId = d.getProductDetail().getId();
                    } else {
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

            // Apply stock updates (previousQtyMap = null means all qty is new)
            applyStockAndTransactions(gr.getLocation().getId(), gr.getReceiptCode(), receiptId, null,
                    gr.getPurchaseOrder().getId(),gr.getCreateBy().getId());

            // Recalculate PO status
            recalculatePurchaseOrderStatus(gr.getPurchaseOrder().getId());

            connection.commit();
            return receiptId;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return -1;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Update an existing partially received receipt:
     * - Update actual quantities for details (USING SET, NOT ADD)
     * - Update Goods_Receipt status to 2 (Completed) if now full
     * - Update stock based on DELTA
     */
    public boolean confirmDraft(int receiptId, List<GoodsReceiptDetail> updatedDetails) {
        // CHANGED: Use SET instead of += to prevent double-counting
        String sqlUpdateDetail = "UPDATE Goods_Receipt_Detail "
                + "SET QuantityActual = QuantityActual + ? "
                + "WHERE ReceiptDetailID = ? AND ReceiptID = ?";


        // For recalculating PO status
String sqlGetPoId = "SELECT PurchaseOrderID, LocationID, ReceiptCode, Status, CreateBy FROM Goods_Receipt WHERE ReceiptID = ?";
        // Query to decide final status: 2 = Completed, 4 = Partially Received

        String sqlQtyCheck = "SELECT "
                + "COALESCE(SUM(QuantityExpected), 0) AS TotalExp, "
                + "COALESCE(SUM(QuantityActual),   0) AS TotalAct "
                + "FROM Goods_Receipt_Detail WHERE ReceiptID = ?";

        try {
            connection.setAutoCommit(false);

            int poId;
            int locationId;
            String receiptCode;
            int currentStatus;
            int creatorId;
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
                    currentStatus = rs.getInt("Status");
                    creatorId = rs.getInt("CreateBy");
                }
            }

            // 1a. Map previous quantities to calculate DELTA later
            Map<Integer, Integer> previousQtyMap = new HashMap<>();
            String sqlReadOldQty = "SELECT ReceiptDetailID, QuantityActual FROM Goods_Receipt_Detail WHERE ReceiptID = ?";
            try (PreparedStatement psRead = connection.prepareStatement(sqlReadOldQty)) {
                psRead.setInt(1, receiptId);
                try (ResultSet rsOld = psRead.executeQuery()) {
                    while (rsOld.next()) {
                        previousQtyMap.put(rsOld.getInt("ReceiptDetailID"), rsOld.getInt("QuantityActual"));
                    }
                }
            }

            // 1b. Update detail actual quantities (SETting the new TOTAL for this receipt)
            try (PreparedStatement psDetail = connection.prepareStatement(sqlUpdateDetail)) {
                for (GoodsReceiptDetail d : updatedDetails) {
                    psDetail.setInt(1, d.getQuantityActual());
                    psDetail.setInt(2, d.getId());
                    psDetail.setInt(3, receiptId);
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }

            // 2. Determine final status
            int finalStatus;
            try (PreparedStatement psQty = connection.prepareStatement(sqlQtyCheck)) {
                psQty.setInt(1, receiptId);
                try (ResultSet rsQty = psQty.executeQuery()) {
                    if (rsQty.next()) {
                        int totExp = rsQty.getInt("TotalExp");
                        int totAct = rsQty.getInt("TotalAct");
                        finalStatus = (totExp > 0 && totAct >= totExp) ? 2 : 4;
                    } else {
                        finalStatus = 2; // fallback
                    }
                }
            }

            // 3. Update header status (allow updating Status 4)
            String sqlUpdateHeader = "UPDATE Goods_Receipt "
                    + "SET Status = ? "
                    + "WHERE ReceiptID = ? AND Status IN (1, 4)";
            try (PreparedStatement psHeader = connection.prepareStatement(sqlUpdateHeader)) {
                psHeader.setInt(1, finalStatus);
                psHeader.setInt(2, receiptId);
                psHeader.executeUpdate();
            }


            // 3. Update stock & inventory transactions based on DB state after update
            applyStockAndTransactions(locationId, receiptCode, receiptId, previousQtyMap, poId,creatorId);


            // 4. Recalculate purchase order status
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

        String sqlPod = "SELECT ProductID, ProductDetailID, Quantity FROM Purchase_Order_Detail WHERE PurchaseOrderID = ?";
        String sqlIns = "INSERT INTO Goods_Receipt_Detail "
                + "(ReceiptID, ProductID, ProductDetailID, QuantityExpected, QuantityActual) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement psSel = connection.prepareStatement(sqlPod);
                PreparedStatement psIns = connection.prepareStatement(sqlIns)) {
            psSel.setInt(1, poId);
            try (ResultSet rs = psSel.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("ProductID");
                    int productDetailId = rs.getInt("ProductDetailID");
                    int qty = rs.getInt("Quantity");

                    psIns.setInt(1, receiptId);
                    psIns.setInt(2, productId);
                    if (rs.wasNull()) {
                        psIns.setNull(3, java.sql.Types.INTEGER);
                    } else {
                        psIns.setInt(3, productDetailId);
                    }
                    psIns.setInt(4, qty);
                    psIns.setInt(5, qty);
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
     * Đọc lại các detail từ DB và:
     * - Cập nhật Location_Product theo DELTA (qty mới - qty đã nhập kho trước đó)
     * - Chèn Inventory_Transaction chỉ với lượng delta thực tế tăng thêm
     *
     * previousQtyMap: map từ ReceiptDetailID -> QuantityActual CŨ (trước khi
     * update).
     * Nếu null (lần confirm đầu tiên), coi như QuantityActual cũ = 0.
     */
    private void applyStockAndTransactions(int locationId, String receiptCode, int receiptId,
            Map<Integer, Integer> previousQtyMap, int poId,int userId) throws SQLException {
        // Lấy detail hiện tại (sau khi đã UPDATE QuantityActual)
        String sqlFetchDetails = "SELECT d.ReceiptDetailID, pd.ProductID, d.ProductDetailID, d.QuantityActual "
                + "FROM Goods_Receipt_Detail d "
                + "JOIN Product_Detail pd ON d.ProductDetailID = pd.ProductDetailID "
                + "WHERE d.ReceiptID = ?";

        // UPDATE stock: cộng delta, match cả ProductID cho chắc chắn
        String sqlUpdateStock = "UPDATE Location_Product "
                + "SET Quantity = Quantity + ? "
                + "WHERE LocationID = ? AND ProductDetailID = ?";

        // INSERT stock: chỉ (LocationID, ProductDetailID, Quantity) — ProductID lấy qua
        // Product_Detail
        String sqlInsertStock = "INSERT INTO Location_Product "
                + "(LocationID, ProductDetailID, Quantity) "
                + "VALUES (?, ?, ?)";

        String sqlTrans = "INSERT INTO Inventory_Transaction "
            + "(ProductID, ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode, TransactionDate, CreateBy) "
            + "VALUES (?, ?, ?, 1, ?, ?, GETDATE(), ?)";

        String sqlOldInfo = "SELECT p.Price, COALESCE((SELECT SUM(Quantity) FROM Location_Product "
                + "WHERE ProductDetailID = p.ProductDetailID), 0) AS TotalStock "
                + "FROM Product_Detail p WHERE p.ProductDetailID = ?";
        String sqlIncoming = "SELECT TOP 1 Price FROM Purchase_Order_Detail "
                + "WHERE PurchaseOrderID = ? AND ProductDetailID = ?";
        String sqlUpdatePrice = "UPDATE Product_Detail SET Price = ? WHERE ProductDetailID = ?";

        try (PreparedStatement psFetch = connection.prepareStatement(sqlFetchDetails);
                PreparedStatement psStockUpdate = connection.prepareStatement(sqlUpdateStock);
                PreparedStatement psStockInsert = connection.prepareStatement(sqlInsertStock);
                PreparedStatement psTrans = connection.prepareStatement(sqlTrans);
                PreparedStatement psOldInfo = connection.prepareStatement(sqlOldInfo);
                PreparedStatement psIncoming = connection.prepareStatement(sqlIncoming);
                PreparedStatement psUpdatePrice = connection.prepareStatement(sqlUpdatePrice)) {

            psFetch.setInt(1, receiptId);
            try (ResultSet rs = psFetch.executeQuery()) {
                while (rs.next()) {
                    int detailId = rs.getInt("ReceiptDetailID");
                    int productId = rs.getInt("ProductID");
                    int productDetailId = rs.getInt("ProductDetailID");
                    boolean isPdIdNull = rs.wasNull();
                    int qtyActualNew = rs.getInt("QuantityActual");

                    // Tính qty cũ đã được nhập kho trước đó (0 nếu là lần confirm đầu từ Draft)
                    int qtyActualOld = (previousQtyMap != null && previousQtyMap.containsKey(detailId))
                            ? previousQtyMap.get(detailId)
                            : 0;

                    // Delta = phần tăng thêm thực sự cần cộng vào kho
                    int delta = qtyActualNew - qtyActualOld;

                    if (delta <= 0) {
                        // Không có gì để thêm (số giảm hoặc không đổi)
                        continue;
                    }

                    // Nếu ProductDetailID đang null (dữ liệu cũ), cố gắng map sang một
                    // ProductDetail bất kỳ của Product.
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

                    // Cập nhật giá nhập trung bình
                    double oldPrice = 0.0;
                    int currentTotalStock = 0;
                    psOldInfo.setInt(1, productDetailId);
                    try (ResultSet rsOld = psOldInfo.executeQuery()) {
                        if (rsOld.next()) {
                            oldPrice = rsOld.getDouble("Price");
                            currentTotalStock = rsOld.getInt("TotalStock");
                        }
                    }
                    if (currentTotalStock < 0)
                        currentTotalStock = 0;

                    double incomingPrice = 0.0;
                    psIncoming.setInt(1, poId);
                    psIncoming.setInt(2, productDetailId);
                    try (ResultSet rsInc = psIncoming.executeQuery()) {
                        if (rsInc.next()) {
                            incomingPrice = rsInc.getDouble("Price");
                        } else {
                            incomingPrice = oldPrice;
                        }
                    }

                    double newPrice = ((oldPrice * currentTotalStock) + (incomingPrice * delta))
                            / (currentTotalStock + delta);
                    psUpdatePrice.setDouble(1, newPrice);
                    psUpdatePrice.setInt(2, productDetailId);
                    psUpdatePrice.executeUpdate();

                    // Cộng DELTA vào kho
                    psStockUpdate.setInt(1, delta);
                    psStockUpdate.setInt(2, locationId);
                    psStockUpdate.setInt(3, productDetailId);
                    int affected = psStockUpdate.executeUpdate();

                    if (affected == 0) {
                        // Chưa có record trong Location_Product → insert mới
                        psStockInsert.setInt(1, locationId);
                        psStockInsert.setInt(2, productDetailId);
                        psStockInsert.setInt(3, delta);
                        psStockInsert.executeUpdate();
                    }

                    // Ghi transaction với lượng delta thực nhận thêm
                    psTrans.setInt(1, productId);
                    psTrans.setInt(2, productDetailId);
                    psTrans.setInt(3, locationId);
                    psTrans.setInt(4, delta);
                    psTrans.setString(5, receiptCode);
                    psTrans.setInt(6, userId); 
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
                + "        WHERE gr.PurchaseOrderID = ? AND gr.Status IN (2, 4)), 0) AS ReceivedQty";

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
            return; // nothing to update
        }

        // 5 = Done (fully received) → hidden from GRO creation
        // 3 = Received (partially received, still needs GROs)
        int newStatus = (received >= ordered) ? 5 : 3;
        String sqlUpdatePO = "UPDATE Purchase_Order SET Status = ? WHERE PurchaseOrderID = ?";
        try (PreparedStatement psUpdate = connection.prepareStatement(sqlUpdatePO)) {
            psUpdate.setInt(1, newStatus);
            psUpdate.setInt(2, poId);
            psUpdate.executeUpdate();
        }
    }
}
