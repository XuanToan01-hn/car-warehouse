package dal;

import context.DBContext;
import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SalesOrderDAO extends DBContext {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final UserDAO userDAO = new UserDAO();
    
    
    
public SalesOrder getWarehouseOrderById(int id) {
    String sqlHeader = "SELECT so.*, u.FullName as CreatorName FROM Sales_Order so " +
                       "JOIN Users u ON so.CreateBy = u.UserID WHERE so.SalesOrderID = ?";
    
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
            SalesOrder so = mapRow(rs); // Dùng hàm mapRow cũ của bạn
            
            // Lấy chi tiết hàng hóa kèm tiến độ giao
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
    
    // Sửa lại hàm getDetailsByOrderId để lấy thêm DeliveredQty từ các phiếu Goods Issue
public List<SalesOrderDetail> getDetailsByOrderId(int orderId) {
    List<SalesOrderDetail> list = new ArrayList<>();
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
            d.setDeliveredQty(rs.getInt("DeliveredQty")); // Bạn cần thêm field này vào model SalesOrderDetail
            d.setProductDetail(pdd.getById(rs.getInt("ProductDetailID")));
            list.add(d);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}
    
    
    private ProductDetailDAO pdd = new ProductDetailDAO();
    public List<SalesOrder> getAll() {
        List<SalesOrder> list = new ArrayList<>();
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

public SalesOrder getById(int id) {
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
            
            // FIX LỖI Ở ĐÂY: Gọi đúng hàm setter cho list details
            so.setDetails(getDetailsByOrderId(id)); 
            
            return so;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}


    public void insert(SalesOrder order, List<SalesOrderDetail> details) {
        String sqlOrder = "INSERT INTO Sales_Order (OrderCode, CustomerID, Status, TotalAmount, Note, CreateBy) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlDetail = "INSERT INTO Sales_Order_Detail (SalesOrderID, ProductDetailID, Quantity, Price, SubTotal) VALUES (?, ?, ?, ?, ?)";
        
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement psOrder = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setString(1, order.getOrderCode());
                psOrder.setInt(2, order.getCustomer().getId());
                psOrder.setInt(3, order.getStatus());
                psOrder.setDouble(4, order.getTotalAmount());
                psOrder.setString(5, order.getNote());
                psOrder.setInt(6, order.getCreateBy().getId());
                psOrder.executeUpdate();
                
                ResultSet rs = psOrder.getGeneratedKeys();
                if (rs.next()) {
                    int orderId = rs.getInt(1);
                    try (PreparedStatement psDetail = connection.prepareStatement(sqlDetail)) {
                        for (SalesOrderDetail detail : details) {
                            psDetail.setInt(1, orderId);
                            psDetail.setInt(2, detail.getProductDetail().getId());
                            psDetail.setInt(3, detail.getQuantity());
                            psDetail.setDouble(4, detail.getPrice());
                            psDetail.setDouble(5, detail.getSubTotal());
                            psDetail.addBatch();
                        }
                        psDetail.executeBatch();
                    }
                }
                connection.commit();
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            } finally {
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
        
        return so;
    }
}