package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import model.ProductDetail;
import model.PurchaseOrder;
import model.PurchaseOrderDetail;
import model.Supplier;
import model.Tax;
import model.User;

public class PurchaseOrderDAO extends DBContext {
    // Thời gian khóa (mặc định 1 phút để bạn test)
    public static final long LOCK_TIMEOUT = 1 * 60 * 1000; 


    // ===============================
    // MAP ROW
    // ===============================
    private PurchaseOrder mapRow(ResultSet rs) throws SQLException {
        PurchaseOrder po = new PurchaseOrder();
        po.setId(rs.getInt("PurchaseOrderID"));
        po.setOrderCode(rs.getString("OrderCode"));
        po.setStatus(rs.getInt("Status"));
        po.setTotalAmount(rs.getDouble("TotalAmount"));
        Timestamp ts = rs.getTimestamp("CreatedDate");
        if (ts != null)
            po.setCreatedDate(new java.util.Date(ts.getTime()));

        Supplier s = new Supplier();
        s.setId(rs.getInt("SupplierID"));
        s.setName(rs.getString("SupplierName"));
        po.setSupplier(s);

        int createdById = rs.getInt("CreateBy");
        if (!rs.wasNull()) {
            User u = new User();
            u.setId(createdById);
            po.setCreateBy(u);
        }

        int warehouseId = rs.getInt("WarehouseID");
        if (!rs.wasNull()) {
            model.Warehouse w = new model.Warehouse();
            w.setId(warehouseId);
            po.setWarehouse(w);
        }

        try {
            int lockedById = rs.getInt("UserID");
            if (!rs.wasNull()) {
                Timestamp lockedAt = rs.getTimestamp("LockedAt");
                // Nếu khóa vẫn còn hiệu lực (Dùng biến LOCK_TIMEOUT)
                if (lockedAt != null && (System.currentTimeMillis() - lockedAt.getTime()) < LOCK_TIMEOUT) {
                    User locked = new User();
                    locked.setId(lockedById);
                    try {
                        locked.setFullName(rs.getString("LockedByName"));
                    } catch (SQLException ignored) {
                    }
                    po.setLockedBy(locked);
                }
            }
        } catch (SQLException ignored) {
        }

        return po;
    }

    public List<PurchaseOrder> getAll() {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = """
                    SELECT po.PurchaseOrderID, po.OrderCode, po.Status, po.TotalAmount,
                           po.CreatedDate, po.CreateBy, po.WarehouseID,
                           po.SupplierID, s.Name AS SupplierName,
                           po.UserID, lu.FullName AS LockedByName, po.LockedAt
                    FROM Purchase_Order po
                    LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID
                    LEFT JOIN Users lu ON po.UserID = lu.UserID
                    ORDER BY po.CreatedDate DESC
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PurchaseOrder> getPendingPOs(int warehouseId) {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = """
                SELECT po.PurchaseOrderID, po.OrderCode, po.Status, po.TotalAmount,
                       po.CreatedDate, po.CreateBy, po.WarehouseID,
                       po.SupplierID, s.Name AS SupplierName,
                       po.UserID, lu.FullName AS LockedByName, po.LockedAt,
                       ISNULL((SELECT SUM(pod.Quantity) FROM Purchase_Order_Detail pod WHERE pod.PurchaseOrderID = po.PurchaseOrderID), 0) AS OrderedQty,
                       ISNULL((SELECT SUM(grd.QuantityActual)
                               FROM Goods_Receipt gr
                               JOIN Goods_Receipt_Detail grd ON gr.ReceiptID = grd.ReceiptID
                               WHERE gr.PurchaseOrderID = po.PurchaseOrderID AND gr.Status IN (2, 4)), 0) AS ReceivedQty
                FROM Purchase_Order po
                LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID
                LEFT JOIN Users lu ON po.UserID = lu.UserID
                WHERE po.Status IN (2, 3)
                AND (? = 0 OR po.WarehouseID = ?)
                ORDER BY po.CreatedDate DESC
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, warehouseId);
            ps.setInt(2, warehouseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PurchaseOrder po = mapRow(rs);
                po.setOrderedQty(rs.getInt("OrderedQty"));
                po.setReceivedQty(rs.getInt("ReceivedQty"));
                list.add(po);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PurchaseOrder> searchAndPaginate(String keyword, int status, int offset, int limit, int warehouseId) {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = """
                SELECT po.PurchaseOrderID, po.OrderCode, po.Status, po.TotalAmount,
                       po.CreatedDate, po.CreateBy, po.WarehouseID,
                       po.SupplierID, s.Name AS SupplierName,
                       po.UserID, lu.FullName AS LockedByName, po.LockedAt,
                       ISNULL((SELECT SUM(pod.Quantity) FROM Purchase_Order_Detail pod WHERE pod.PurchaseOrderID = po.PurchaseOrderID), 0) AS OrderedQty,
                       ISNULL((SELECT SUM(grd.QuantityActual)
                               FROM Goods_Receipt gr
                               JOIN Goods_Receipt_Detail grd ON gr.ReceiptID = grd.ReceiptID
                               WHERE gr.PurchaseOrderID = po.PurchaseOrderID AND gr.Status IN (2, 4)), 0) AS ReceivedQty
                FROM Purchase_Order po
                LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID
                LEFT JOIN Users lu ON po.UserID = lu.UserID
                WHERE (po.OrderCode LIKE ? OR s.Name LIKE ?)
                  AND (? = 0 OR po.Status = ?)
                  AND (? = 0 OR po.WarehouseID = ?)
                ORDER BY po.CreatedDate DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setInt(3, status);
            ps.setInt(4, status);
            ps.setInt(5, warehouseId);
            ps.setInt(6, warehouseId);
            ps.setInt(7, offset);
            ps.setInt(8, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PurchaseOrder po = mapRow(rs);
                po.setOrderedQty(rs.getInt("OrderedQty"));
                po.setReceivedQty(rs.getInt("ReceivedQty"));
                list.add(po);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int count(String keyword, int status, int warehouseId) {
        String sql = """
                    SELECT COUNT(*) FROM Purchase_Order po
                    LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID
                    WHERE (po.OrderCode LIKE ? OR s.Name LIKE ?)
                      AND (? = 0 OR po.Status = ?)
                      AND (? = 0 OR po.WarehouseID = ?)
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setInt(3, status);
            ps.setInt(4, status);
            ps.setInt(5, warehouseId);
            ps.setInt(6, warehouseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public PurchaseOrder getById(int id) {
        String sql = """
                    SELECT po.PurchaseOrderID, po.OrderCode, po.Status, po.TotalAmount,
                           po.CreatedDate, po.CreateBy, po.WarehouseID,
                           po.SupplierID, s.Name AS SupplierName,
                           s.Phone AS SupplierPhone, s.Email AS SupplierEmail, s.Address AS SupplierAddress,
                           po.UserID, lu.FullName AS LockedByName, po.LockedAt
                    FROM Purchase_Order po
                    LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID
                    LEFT JOIN Users lu ON po.UserID = lu.UserID
                    WHERE po.PurchaseOrderID = ?
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PurchaseOrder po = mapRow(rs);
                po.getSupplier().setPhone(rs.getString("SupplierPhone"));
                po.getSupplier().setEmail(rs.getString("SupplierEmail"));
                po.getSupplier().setAddress(rs.getString("SupplierAddress"));
                po.setDetails(getDetailsByOrderId(id));
                return po;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<PurchaseOrderDetail> getDetailsByOrderId(int purchaseOrderId) {
        List<PurchaseOrderDetail> list = new ArrayList<>();
        String sql = """
                    SELECT pod.PurchaseOrderDetailID, pod.PurchaseOrderID, pod.Quantity,
                           pod.Price, pod.SubTotal, pod.TaxID, pod.ProductDetailID,
                           p.Name AS ProductName, p.Code AS ProductCode, p.ProductID,
                           t.TaxName, t.TaxRate,
                           pd.LotNumber, pd.SerialNumber, pd.Color,
                           ISNULL((SELECT SUM(grd.QuantityActual)
                                   FROM Goods_Receipt_Detail grd
                                   JOIN Goods_Receipt gr ON grd.ReceiptID = gr.ReceiptID
                                   WHERE gr.PurchaseOrderID = pod.PurchaseOrderID
                                     AND gr.Status IN (2, 4)
                                     AND grd.ProductDetailID = pod.ProductDetailID), 0) AS ReceivedQty
                    FROM Purchase_Order_Detail pod
                    LEFT JOIN Product_Detail pd ON pod.ProductDetailID = pd.ProductDetailID
                    LEFT JOIN Product p ON pd.ProductID = p.ProductID
                    LEFT JOIN Tax t ON pod.TaxID = t.TaxID
                    WHERE pod.PurchaseOrderID = ?
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, purchaseOrderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PurchaseOrderDetail pod = new PurchaseOrderDetail();
                pod.setId(rs.getInt("PurchaseOrderDetailID"));
                pod.setPurchaseOrderId(rs.getInt("PurchaseOrderID"));
                pod.setQuantity(rs.getInt("Quantity"));
                pod.setPrice(rs.getDouble("Price"));
                pod.setSubTotal(rs.getDouble("SubTotal"));

                int productId = rs.getInt("ProductID");
                if (!rs.wasNull()) {
                    Product p = new Product();
                    p.setId(productId);
                    p.setName(rs.getString("ProductName"));
                    p.setCode(rs.getString("ProductCode"));
                    pod.setProduct(p);
                }

                int taxId = rs.getInt("TaxID");
                if (!rs.wasNull()) {
                    Tax t = new Tax();
                    t.setId(taxId);
                    t.setTaxName(rs.getString("TaxName"));
                    t.setTaxRate(rs.getDouble("TaxRate"));
                    pod.setTax(t);
                }

                int pdId = rs.getInt("ProductDetailID");
                if (!rs.wasNull()) {
                    ProductDetail pd = new ProductDetail();
                    pd.setId(pdId);
                    pd.setLotNumber(rs.getString("LotNumber"));
                    pd.setSerialNumber(rs.getString("SerialNumber"));
                    pd.setColor(rs.getString("Color"));
                    pod.setProductDetail(pd);
                }
                pod.setReceivedQuantity(rs.getInt("ReceivedQty"));
                list.add(pod);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insert(PurchaseOrder po) {
        String sql = "INSERT INTO Purchase_Order (OrderCode, SupplierID, Status, TotalAmount, CreateBy, WarehouseID) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, po.getOrderCode());
            ps.setInt(2, po.getSupplier().getId());
            ps.setInt(3, po.getStatus());
            ps.setDouble(4, po.getTotalAmount());
            if (po.getCreateBy() != null)
                ps.setInt(5, po.getCreateBy().getId());
            else
                ps.setNull(5, java.sql.Types.INTEGER);
            if (po.getWarehouse() != null)
                ps.setInt(6, po.getWarehouse().getId());
            else
                ps.setNull(6, java.sql.Types.INTEGER);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void insertDetail(PurchaseOrderDetail pod) {
        String sql = "INSERT INTO Purchase_Order_Detail (PurchaseOrderID, Quantity, Price, SubTotal, ProductDetailID) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, pod.getPurchaseOrderId());
            ps.setInt(2, pod.getQuantity());
            ps.setDouble(3, pod.getPrice());
            ps.setDouble(4, pod.getSubTotal());
            if (pod.getProductDetail() != null)
                ps.setInt(5, pod.getProductDetail().getId());
            else
                ps.setNull(5, java.sql.Types.INTEGER);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(int id, int status) {
        String sql = "UPDATE Purchase_Order SET Status = ? WHERE PurchaseOrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean existsByOrderCode(String orderCode) {
        String sql = "SELECT COUNT(*) FROM Purchase_Order WHERE OrderCode = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, orderCode);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsByOrderCodeExcluding(String orderCode, int excludePoId) {
        String sql = "SELECT COUNT(*) FROM Purchase_Order WHERE OrderCode = ? AND PurchaseOrderID != ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, orderCode);
            ps.setInt(2, excludePoId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(PurchaseOrder po) {
        String sql = "UPDATE Purchase_Order SET OrderCode = ?, SupplierID = ?, TotalAmount = ? WHERE PurchaseOrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, po.getOrderCode());
            ps.setInt(2, po.getSupplier().getId());
            ps.setDouble(3, po.getTotalAmount());
            ps.setInt(4, po.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void deleteDetailsByOrderId(int purchaseOrderId) {
        String sql = "DELETE FROM Purchase_Order_Detail WHERE PurchaseOrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, purchaseOrderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // LOCK / UNLOCK PO
    // ===============================

    public String lockPO(int poId, int userId) {
        String sqlCheck = "SELECT po.UserID, u.FullName AS LockedByName, po.LockedAt FROM Purchase_Order po LEFT JOIN Users u ON po.UserID = u.UserID WHERE po.PurchaseOrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sqlCheck);
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int lockedBy = rs.getInt("UserID");
                Timestamp lockedAt = rs.getTimestamp("LockedAt");
                if (!rs.wasNull() && lockedBy != userId) {
                    if (lockedAt != null && (System.currentTimeMillis() - lockedAt.getTime()) < LOCK_TIMEOUT) {
                        return rs.getString("LockedByName");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String sqlLock = "UPDATE Purchase_Order SET UserID = ?, LockedAt = GETDATE() WHERE PurchaseOrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sqlLock);
            ps.setInt(1, userId);
            ps.setInt(2, poId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void unlockPO(int poId, int userId) {
        String sql = "UPDATE Purchase_Order SET UserID = NULL, LockedAt = NULL WHERE PurchaseOrderID = ? AND (UserID = ? OR UserID IS NULL)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, poId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void forceUnlockPO(int poId) {
        String sql = "UPDATE Purchase_Order SET UserID = NULL, LockedAt = NULL WHERE PurchaseOrderID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, poId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void unlockAllByUser(int userId) {
        String sql = "UPDATE Purchase_Order SET UserID = NULL, LockedAt = NULL WHERE UserID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
