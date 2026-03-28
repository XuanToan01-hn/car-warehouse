package dal;

import context.DBContext;
import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SalesOrderDAO extends DBContext {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final UserDAO userDAO = new UserDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    
    public static void main(String[] args) {
        SalesOrderDAO SO = new SalesOrderDAO();
        List<SalesOrder> s = SO.getOrdersByWarehouse(2);
        for(SalesOrder sa : s){
            System.out.println(sa.getId());
        }
    }
    
    
    public List<SalesOrder> getOrdersByWarehouse(int warehouseId) {
    List<SalesOrder> list = new ArrayList<>();
    // Thêm điều kiện WHERE so.WarehouseID = ? và lọc các trạng thái cần xuất kho (ví dụ: 1-Chờ, 2-Giao một phần)
    // lọc các trạng thái cần xuất kho (ví dụ: 1-Chờ, 2-Giao một phần)
    //lấy tổng đơn đặt, tổng đơn xuất thưcj tế
    // SQL lấy danh sách đơn bán hàng của một kho cụ thể.
    // - OrderedQty: Tổng số lượng sản phẩm được đặt trong đơn hàng (tính từ bảng Sales_Order_Detail).
    // - DeliveredQty: Tổng số lượng sản phẩm thực tế đã được xuất kho (tính từ bảng Goods_Issue_Detail thông qua bảng Goods_Issue).
    String sql = "SELECT so.*, " +
                 "(SELECT SUM(quantity) FROM Sales_Order_Detail sod WHERE sod.SalesOrderID = so.SalesOrderID) as OrderedQty, " +
                 "(SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = so.SalesOrderID) as DeliveredQty " +
                 "FROM Sales_Order so " +
                 "WHERE so.WarehouseID = ? " + 
                 "ORDER BY so.CreatedDate DESC";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, warehouseId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SalesOrder so = mapRow(rs);
                so.setOrderedQty(rs.getInt("OrderedQty"));
                so.setDeliveredQty(rs.getInt("DeliveredQty"));
                list.add(so);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}
    //Lấy danh sách đơn bán (SalesOrder) theo kho (warehouseId)
    //đồng thời tính tổng số lượng đặt, lượng giao thực tế mỗi đơn
public SalesOrder getWarehouseOrderById(int id) {
     //lấy in4 đơn hàng
    // SQL Header: Lấy thông tin chung của đơn hàng và tên người tạo (CreatorName).
    String sqlHeader = "SELECT so.*, u.FullName as CreatorName FROM Sales_Order so " +
                       "JOIN Users u ON so.CreateBy = u.UserID WHERE so.SalesOrderID = ?";
    
   // tính xem mỗi dòng đã  đặt/giao bao nhiêu
    // SQL Details: Lấy danh sách sản phẩm trong đơn hàng kèm theo số lượng thực tế đã được giao (DeliveredQty).
    // ISNULL giúp trả về 0 nếu sản phẩm đó chưa được xuất kho lần nào.
    String sqlDetails = "SELECT sod.*, " +
                        "(SELECT ISNULL(SUM(gid.QuantityActual), 0) " +
                        " FROM Goods_Issue_Detail gid " +
                        " JOIN Goods_Issue gi ON gid.IssueID = gi.IssueID " +
                        " WHERE gi.SalesOrderID = sod.SalesOrderID " +
                        " AND gid.ProductDetailID = sod.ProductDetailID) as DeliveredQty " +
                        "FROM Sales_Order_Detail sod WHERE sod.SalesOrderID = ?";

    try (PreparedStatement ps = connection.prepareStatement(sqlHeader)) {
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            SalesOrder so = mapRow(rs); 
            
            
            List<SalesOrderDetail> details = new ArrayList<>();
            try (PreparedStatement psD = connection.prepareStatement(sqlDetails)) {
                psD.setInt(1, id);
                ResultSet rsD = psD.executeQuery();
                while (rsD.next()) {
                    SalesOrderDetail d = new SalesOrderDetail();
                    d.setQuantity(rsD.getInt("Quantity"));
                    d.setDeliveredQty(rsD.getInt("DeliveredQty"));
                    
                    // Load thông tin sản phẩm (Màu, Lô...)
                    d.setProductDetail(new ProductDetailDAO().getById(rsD.getInt("ProductDetailID")));
                    details.add(d);
                }
            }
            so.setDetails(details);
            return so;
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}
    
public List<SalesOrderDetail> getDetailsByOrderId(int orderId) {
    List<SalesOrderDetail> list = new ArrayList<>();
    // Lấy chi tiết hàng hóa vs tổng số lượng giao
    // SQL lấy chi tiết hàng hóa của một đơn hàng với tổng số lượng đã giao thực tế.
    // Lọc theo từng dòng sản phẩm chi tiết (ProductDetailID) trong cùng đơn hàng đó.
    String sql = "SELECT sod.*, " +
                 " (SELECT ISNULL(SUM(gid.QuantityActual), 0) FROM Goods_Issue gi " +
                 "  JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID " +
                 "  WHERE gi.SalesOrderID = sod.SalesOrderID AND gid.ProductDetailID = sod.ProductDetailID) as DeliveredQty " +
                 " FROM Sales_Order_Detail sod WHERE sod.SalesOrderID = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, orderId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            SalesOrderDetail d = new SalesOrderDetail();
            d.setId(rs.getInt(1));
            d.setQuantity(rs.getInt("Quantity"));
            d.setPrice(rs.getDouble("Price"));
            d.setSubTotal(rs.getDouble("SubTotal"));
            d.setDeliveredQty(rs.getInt("DeliveredQty"));
            d.setProductDetail(pdd.getById(rs.getInt("ProductDetailID")));
            list.add(d);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}
    
    //lấy tất cả đơn hàng, với mỗi đơn tính tổng lượng đặt/giao
    private ProductDetailDAO pdd = new ProductDetailDAO();
    public List<SalesOrder> getAll() {
        List<SalesOrder> list = new ArrayList<>();
        // SQL lấy toàn bộ đơn hàng, tính toán tổng lượng đặt và lượng xuất kho thực tế. 
        // Sắp xếp theo ngày tạo mới nhất (CreatedDate DESC).
        String sql = "SELECT so.*, " +
                     "(SELECT SUM(quantity) FROM Sales_Order_Detail sod WHERE sod.SalesOrderID = so.SalesOrderID) as OrderedQty, " +
                     "(SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = so.SalesOrderID) as DeliveredQty " +
                     "FROM Sales_Order so ORDER BY so.CreatedDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SalesOrder so = mapRow(rs);
                so.setOrderedQty(rs.getInt("OrderedQty"));
                so.setDeliveredQty(rs.getInt("DeliveredQty"));
                list.add(so);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
//lấy tất cả đơn hàng, với mỗi đơn tính tổng lượng đặt/giao theo status tương ứng
    public List<SalesOrder> getByStatus(int status) {
        List<SalesOrder> list = new ArrayList<>();
        // SQL lọc đơn hàng theo trạng thái (Status) như: 1-Chờ xử lý, 2-Đang giao...
        String sql = "SELECT so.*, " +
                     "(SELECT SUM(quantity) FROM Sales_Order_Detail sod WHERE sod.SalesOrderID = so.SalesOrderID) as OrderedQty, " +
                     "(SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = so.SalesOrderID) as DeliveredQty " +
                     "FROM Sales_Order so WHERE Status = ? ORDER BY so.CreatedDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SalesOrder so = mapRow(rs);
                    so.setOrderedQty(rs.getInt("OrderedQty"));
                    so.setDeliveredQty(rs.getInt("DeliveredQty"));
                    list.add(so);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
//Lấy 1 SalesOrder theo ID với in4, số lượng đặt và giao,
public SalesOrder getById(int id) {
    // SQL lấy chi tiết một đơn hàng cụ thể theo SalesOrderID.
    String sql = "SELECT so.*, " +
                 "(SELECT SUM(quantity) FROM Sales_Order_Detail sod WHERE sod.SalesOrderID = so.SalesOrderID) as OrderedQty, " +
                 "(SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = so.SalesOrderID) as DeliveredQty " +
                 "FROM Sales_Order so WHERE so.SalesOrderID = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            SalesOrder so = mapRow(rs);
            so.setOrderedQty(rs.getInt("OrderedQty"));
            so.setDeliveredQty(rs.getInt("DeliveredQty"));
// lấy  danh sách chi tiết sản phẩm
            so.setDetails(getDetailsByOrderId(id)); 
            
            return so;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}

    // THỰC HIỆN LƯU ĐƠN HÀNG (Sử dụng Transaction để đảm bảo tính toàn vẹn dữ liệu)
    public void insert(SalesOrder order, List<SalesOrderDetail> details) {
        // SQL 1: Chèn thông tin chung (Header) của đơn hàng
        String sqlOrder = "INSERT INTO Sales_Order (OrderCode, CustomerID, Status, TotalAmount, Note, CreateBy, WarehouseID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        // SQL 2: Chèn các dòng chi tiết sản phẩm (Details)
        String sqlDetail = "INSERT INTO Sales_Order_Detail (SalesOrderID, ProductDetailID, Quantity, Price, SubTotal) VALUES (?, ?, ?, ?, ?)";
        
        try {
            // Bước 0: BẮT ĐẦU TRANSACTION - Tắt chế độ tự động lưu (AutoCommit = false)
            connection.setAutoCommit(false);

            try (PreparedStatement psOrder = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                // Bước 1: CHÈN THÔNG TIN CHUNG (Sales_Order)
                psOrder.setString(1, order.getOrderCode());
                psOrder.setInt(2, order.getCustomer().getId());
                psOrder.setInt(3, order.getStatus());
                psOrder.setDouble(4, order.getTotalAmount());
                psOrder.setString(5, order.getNote());
                psOrder.setInt(6, order.getCreateBy().getId());
                if (order.getWarehouse() != null) {
                    psOrder.setInt(7, order.getWarehouse().getId());
                } else {
                    psOrder.setNull(7, java.sql.Types.INTEGER);
                }
                psOrder.executeUpdate();
                
                // Bước 2: LẤY ID TỰ SINH CỦA ĐƠN HÀNG VỬA CHÈN
                ResultSet rs = psOrder.getGeneratedKeys();
                if (rs.next()) {
                    int orderId = rs.getInt(1);
                    // Bước 3: CHÈN DỮ LIỆU CHI TIẾT SẢN PHẨM (Sử dụng Batch Update để tăng hiệu năng)
                    try (PreparedStatement psDetail = connection.prepareStatement(sqlDetail)) {
                        for (SalesOrderDetail detail : details) {
                            psDetail.setInt(1, orderId); // Gán ID đơn hàng cha cho dòng chi tiết
                            psDetail.setInt(2, detail.getProductDetail().getId());
                            psDetail.setInt(3, detail.getQuantity());
                            psDetail.setDouble(4, detail.getPrice());
                            psDetail.setDouble(5, detail.getSubTotal());
                            psDetail.addBatch(); // Cho vào hàng đợi (batch)
                        }
                        psDetail.executeBatch(); // Thực thi đồng loạt tất cả các dòng sản phẩm
                    }
                }
                
                // Bước 4a: CHỐT DỮ LIỆU (COMMIT) - Nếu chạy đến đây mà không có lỗi thì lưu vĩnh viễn
                connection.commit();
            } catch (SQLException e) {
                // Bước 4b: HỦY BỔ THAY ĐỔI (ROLLBACK) - Nếu có bất kỳ dòng nào lỗi, hủy toàn bộ đơn hàng
                connection.rollback();
                throw e; // Báo lỗi ra lớp bên ngoài xử lý
            } finally {
                // Trả lời lại trạng thái mặc định của kết nối
                connection.setAutoCommit(true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(int id, int status) {
        String sql = "UPDATE Sales_Order SET Status = ? WHERE SalesOrderID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean hasOrders(int customerId) {
        String sql = "SELECT COUNT(*) FROM Sales_Order WHERE CustomerID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private SalesOrder mapRow(ResultSet rs) throws SQLException {
        SalesOrder so = new SalesOrder();
        so.setId(rs.getInt("SalesOrderID"));
        so.setOrderCode(rs.getString("OrderCode"));
        so.setStatus(rs.getInt("Status"));
        so.setTotalAmount(rs.getDouble("TotalAmount"));
        so.setNote(rs.getString("Note"));
        so.setCreatedDate(rs.getTimestamp("CreatedDate"));
        
        int customerId = rs.getInt("CustomerID");
        so.setCustomer(customerDAO.getById(customerId));
        
        int userId = rs.getInt("CreateBy");
        so.setCreateBy(userDAO.getById(userId));

        int warehouseId = rs.getInt("WarehouseID");
        if (warehouseId > 0) {
            so.setWarehouse(warehouseDAO.getById(warehouseId));
        }
        return so;
    }
}