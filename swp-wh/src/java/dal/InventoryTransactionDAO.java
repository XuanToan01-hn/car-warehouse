package dal;

import context.DBContext;
import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InventoryTransactionDAO extends DBContext {

public List<InventoryTransaction> getTransactions(int page, int pageSize, Integer type, String searchOrder) {
    List<InventoryTransaction> list = new ArrayList<>();
    // SỬA JOIN: it.SalesOrderID = so.SalesOrderID
    String sql = "SELECT it.*, p.Name as ProductName, pd.Color, l.LocationName, "
               + "so.SalesOrderID, so.OrderCode " 
               + "FROM Inventory_Transaction it "
               + "LEFT JOIN Product_Detail pd ON it.ProductDetailID = pd.ProductDetailID "
               + "LEFT JOIN Product p ON pd.ProductID = p.ProductID "
               + "LEFT JOIN Location l ON it.LocationID = l.LocationID "
               + "LEFT JOIN Sales_Order so ON it.SalesOrderID = so.SalesOrderID " // JOIN QUA ID
               + "WHERE (1=1) ";

    if (type != null && type != 0) sql += " AND it.TransactionType = " + type;
    if (searchOrder != null && !searchOrder.isEmpty()) sql += " AND so.OrderCode LIKE ?";

    sql += " ORDER BY it.TransactionDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        int idx = 1;
        if (searchOrder != null && !searchOrder.isEmpty()) ps.setString(idx++, "%" + searchOrder + "%");
        ps.setInt(idx++, (page - 1) * pageSize);
        ps.setInt(idx++, pageSize);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            InventoryTransaction t = new InventoryTransaction();
            t.setId(rs.getInt("TransactionID"));
            t.setTransactionType(rs.getInt("TransactionType"));
            t.setQuantity(rs.getInt("Quantity"));
            t.setReferenceCode(rs.getString("ReferenceCode"));
            t.setTransactionDate(rs.getTimestamp("TransactionDate"));

            // Map Product & Detail
            Product p = new Product();
            p.setName(rs.getString("ProductName"));
            ProductDetail pd = new ProductDetail();
            pd.setColor(rs.getString("Color"));
            pd.setProduct(p);
            t.setProductDetail(pd);

            // Map Location
            Location loc = new Location();
            loc.setLocationName(rs.getString("LocationName"));
            t.setLocation(loc);

            // LẤY CODE TỪ BẢNG SALES_ORDER SAU KHI JOIN QUA ID
            int soId = rs.getInt("SalesOrderID");
            if (!rs.wasNull()) {
                SalesOrder so = new SalesOrder();
                so.setId(soId);
                so.setOrderCode(rs.getString("OrderCode")); // Lấy mã code ở đây
                t.setSalesOrder(so);
            }
            list.add(t);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}

    public int getTotalTransactions(Integer type, String searchOrder) {
        String sql = "SELECT COUNT(*) FROM Inventory_Transaction it "
                   + "LEFT JOIN Sales_Order so ON it.ReferenceCode = so.OrderCode WHERE (1=1) ";
        if (type != null && type != 0) sql += " AND it.TransactionType = " + type;
        if (searchOrder != null && !searchOrder.isEmpty()) sql += " AND so.OrderCode LIKE ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (searchOrder != null && !searchOrder.isEmpty()) {
                ps.setString(1, "%" + searchOrder + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // --- HÀM MAIN TEST ---
    public static void main(String[] args) {
        InventoryTransactionDAO dao = new InventoryTransactionDAO();
        
        // 1. Kiểm tra kết nối
        if (dao.connection == null) {
            System.out.println("FAILED: Không thể kết nối Database!");
            return;
        } else {
            System.out.println("SUCCESS: Đã kết nối Database.");
        }

        // 2. Test lấy dữ liệu không filter
        System.out.println("\n--- TEST: Lấy 5 bản ghi mới nhất ---");
        List<InventoryTransaction> list = dao.getTransactions(1, 5, 0, "");
        if (list.isEmpty()) {
            System.out.println("KẾT QUẢ: Bảng Inventory_Transaction đang trống!");
        } else {
            for (InventoryTransaction t : list) {
                String soCode = (t.getSalesOrder() != null) ? t.getSalesOrder().getOrderCode() : "N/A";
                System.out.println("ID: " + t.getId() 
                    + " | Ref: " + t.getReferenceCode() 
                    + " | SO Link: " + soCode 
                    + " | SP: " + t.getProductDetail().getProduct().getName());
            }
        }

        // 3. Test tổng số bản ghi
        System.out.println("\n--- TEST: Đếm tổng số bản ghi ---");
        System.out.println("Tổng cộng: " + dao.getTotalTransactions(0, ""));
    }
}