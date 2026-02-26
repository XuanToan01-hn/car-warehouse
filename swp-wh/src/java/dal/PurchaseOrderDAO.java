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
import model.PurchaseOrder;
import model.PurchaseOrderDetail;
import model.Supplier;
import model.Tax;
import model.User;

public class PurchaseOrderDAO extends DBContext {

    // ===============================
    // MAP ROW → PurchaseOrder
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

        // Supplier
        Supplier s = new Supplier();
        s.setId(rs.getInt("SupplierID"));
        s.setName(rs.getString("SupplierName"));
        po.setSupplier(s);

        // CreatedBy user (chỉ ID, có thể null)
        int createdById = rs.getInt("CreateBy");
        if (!rs.wasNull()) {
            User u = new User();
            u.setId(createdById);
            po.setCreateBy(u);
        }

        return po;
    }

    // ===============================
    // GET ALL (với JOIN Supplier)
    // ===============================
    public List<PurchaseOrder> getAll() {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = """
                    SELECT po.PurchaseOrderID, po.OrderCode, po.Status, po.TotalAmount,
                           po.CreatedDate, po.CreateBy,
                           po.SupplierID, s.Name AS SupplierName
                    FROM Purchase_Order po
                    LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID
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

    // ===============================
    // SEARCH + PAGINATE
    // ===============================
    public List<PurchaseOrder> searchAndPaginate(String keyword, int status, int offset, int limit) {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = """
            SELECT po.PurchaseOrderID, po.OrderCode, po.Status, po.TotalAmount,
                   po.CreatedDate, po.CreateBy,
                   po.SupplierID, s.Name AS SupplierName
            FROM Purchase_Order po
            LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID
            WHERE (po.OrderCode LIKE ? OR s.Name LIKE ?)
              AND (? = 0 OR po.Status = ?)
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
            ps.setInt(5, offset);
            ps.setInt(6, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next())
                list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // COUNT
    // ===============================
    public int count(String keyword, int status) {
        String sql = """
                    SELECT COUNT(*) FROM Purchase_Order po
                    LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID
                    WHERE (po.OrderCode LIKE ? OR s.Name LIKE ?)
                      AND (? = 0 OR po.Status = ?)
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setInt(3, status);
            ps.setInt(4, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ===============================
    // GET BY ID (kèm details)
    // ===============================
    public PurchaseOrder getById(int id) {
        String sql = """
                    SELECT po.PurchaseOrderID, po.OrderCode, po.Status, po.TotalAmount,
                           po.CreatedDate, po.CreateBy,
                           po.SupplierID, s.Name AS SupplierName,
                           s.Phone AS SupplierPhone, s.Email AS SupplierEmail, s.Address AS SupplierAddress
                    FROM Purchase_Order po
                    LEFT JOIN Supplier s ON po.SupplierID = s.SupplierID
                    WHERE po.PurchaseOrderID = ?
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PurchaseOrder po = mapRow(rs);
                // Điền đầy đủ supplier info
                po.getSupplier().setPhone(rs.getString("SupplierPhone"));
                po.getSupplier().setEmail(rs.getString("SupplierEmail"));
                po.getSupplier().setAddress(rs.getString("SupplierAddress"));
                // Load details
                po.setDetails(getDetailsByOrderId(id));
                return po;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===============================
    // GET DETAILS BY ORDER ID
    // ===============================
    public List<PurchaseOrderDetail> getDetailsByOrderId(int purchaseOrderId) {
        List<PurchaseOrderDetail> list = new ArrayList<>();
        String sql = """
                    SELECT pod.PurchaseOrderDetailID, pod.PurchaseOrderID, pod.Quantity,
                           pod.Price, pod.SubTotal, pod.ProductID, pod.TaxID,
                           p.Name AS ProductName, p.Code AS ProductCode,
                           t.TaxName, t.TaxRate
                    FROM Purchase_Order_Detail pod
                    LEFT JOIN Product p ON pod.ProductID = p.ProductID
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

                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setName(rs.getString("ProductName"));
                p.setCode(rs.getString("ProductCode"));
                pod.setProduct(p);

                int taxId = rs.getInt("TaxID");
                if (!rs.wasNull()) {
                    Tax t = new Tax();
                    t.setId(taxId);
                    t.setTaxName(rs.getString("TaxName"));
                    t.setTaxRate(rs.getDouble("TaxRate"));
                    pod.setTax(t);
                }

                list.add(pod);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // INSERT PURCHASE ORDER — trả về ID mới
    // ===============================
    public int insert(PurchaseOrder po) {
        String sql = """
                    INSERT INTO Purchase_Order (OrderCode, SupplierID, Status, TotalAmount, CreateBy)
                    VALUES (?, ?, ?, ?, ?)
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, po.getOrderCode());
            ps.setInt(2, po.getSupplier().getId());
            ps.setInt(3, po.getStatus());
            ps.setDouble(4, po.getTotalAmount());
            if (po.getCreateBy() != null) {
                ps.setInt(5, po.getCreateBy().getId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ===============================
    // INSERT DETAIL
    // ===============================
    public void insertDetail(PurchaseOrderDetail pod) {
        String sql = """
                    INSERT INTO Purchase_Order_Detail (PurchaseOrderID, ProductID, Quantity, Price, TaxID, SubTotal)
                    VALUES (?, ?, ?, ?, ?, ?)
                """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, pod.getPurchaseOrderId());
            ps.setInt(2, pod.getProduct().getId());
            ps.setInt(3, pod.getQuantity());
            ps.setDouble(4, pod.getPrice());
            if (pod.getTax() != null) {
                ps.setInt(5, pod.getTax().getId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            ps.setDouble(6, pod.getSubTotal());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // UPDATE STATUS
    // ===============================
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
    // ===============================
// MAIN TEST
// ===============================
    public static void main(String[] args) {
        PurchaseOrderDAO dao = new PurchaseOrderDAO();

        System.out.println("===== TEST getAll() =====");
        List<PurchaseOrder> list = dao.getAll();
        for (PurchaseOrder po : list) {
            System.out.println("ID: " + po.getId()
                    + " | Code: " + po.getOrderCode()
                    + " | Supplier: " + (po.getSupplier() != null ? po.getSupplier().getName() : "null")
                    + " | Total: " + po.getTotalAmount()
                    + " | Status: " + po.getStatus());
        }

        System.out.println("\n===== TEST searchAndPaginate() =====");
        List<PurchaseOrder> searchList = dao.searchAndPaginate("", 0, 0, 5);
        for (PurchaseOrder po : searchList) {
            System.out.println("ID: " + po.getId() + " | Code: " + po.getOrderCode());
        }

        System.out.println("\n===== TEST count() =====");
        int total = dao.count("", 0);
        System.out.println("Total orders: " + total);

        System.out.println("\n===== TEST getById() =====");
        PurchaseOrder detail = dao.getById(22); // đổi ID nếu cần
        if (detail != null) {
            System.out.println("Order Code: " + detail.getOrderCode());
            System.out.println("Supplier: " + detail.getSupplier().getName());
            System.out.println("Details:");
            if (detail.getDetails() != null) {
                for (PurchaseOrderDetail d : detail.getDetails()) {
                    System.out.println("  Product: " + d.getProduct().getName()
                            + " | Qty: " + d.getQuantity()
                            + " | Price: " + d.getPrice());
                }
            }
        } else {
            System.out.println("Order not found!");
        }

        System.out.println("\n===== TEST insert() =====");
        PurchaseOrder newPO = new PurchaseOrder();
        newPO.setOrderCode("PO_TEST_" + System.currentTimeMillis());
        newPO.setStatus(1);
        newPO.setTotalAmount(1000);

        Supplier supplier = new Supplier();
        supplier.setId(1); // đảm bảo SupplierID = 1 tồn tại trong DB
        newPO.setSupplier(supplier);

        User user = new User();
        user.setId(1); // đảm bảo UserID = 1 tồn tại
        newPO.setCreateBy(user);

        int newId = dao.insert(newPO);
        System.out.println("Inserted PurchaseOrder ID: " + newId);

        if (newId > 0) {
            System.out.println("\n===== TEST insertDetail() =====");
            PurchaseOrderDetail pod = new PurchaseOrderDetail();
            pod.setPurchaseOrderId(newId);

            Product product = new Product();
            product.setId(1); // đảm bảo ProductID = 1 tồn tại
            pod.setProduct(product);

            pod.setQuantity(5);
            pod.setPrice(200);
            pod.setSubTotal(1000);

            dao.insertDetail(pod);
            System.out.println("Inserted detail for Order ID: " + newId);

            System.out.println("\n===== TEST updateStatus() =====");
            dao.updateStatus(newId, 2);
            System.out.println("Updated status to 2 for Order ID: " + newId);
        }

        System.out.println("\n===== DONE TEST =====");
    }
}
