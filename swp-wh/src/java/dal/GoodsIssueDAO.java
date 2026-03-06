package dal;

import context.DBContext;
import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GoodsIssueDAO extends DBContext {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ProductDetailDAO productDetailDAO = new ProductDetailDAO();
    private final LocationDAO locationDAO = new LocationDAO();

    public static void main(String[] args) {
        GoodsIssueDAO dao = new GoodsIssueDAO();

        // 1. Tạo đối tượng GoodsIssue giả lập
        GoodsIssue gi = new GoodsIssue();
        gi.setIssueCode("TEST-GIN-" + System.currentTimeMillis());

        // Giả sử SalesOrder ID = 1
        SalesOrder so = new SalesOrder();
        so.setId(1);
        so.setStatus(2); // Giả lập trạng thái hiện tại là 2
        gi.setSalesOrder(so);

        // Giả sử Location ID = 1
        Location loc = new Location();
        loc.setId(1);
        gi.setLocation(loc);

        // Giả sử User ID = 1 (Người tạo)
        User u = new User();
        u.setId(1);
        gi.setCreateBy(u);

        gi.setStatus(1); // Trạng thái phiếu xuất: Created

        // 2. Tạo danh sách chi tiết GoodsIssueDetail
        List<GoodsIssueDetail> details = new ArrayList<>();

        // Giả sử ProductDetail ID = 1, xuất 4 cái, nợ cũ là 5
        GoodsIssueDetail d1 = new GoodsIssueDetail();
        ProductDetail pd1 = new ProductDetail();
        pd1.setId(1);
        d1.setProductDetail(pd1);
        d1.setQuantityActual(4);
        d1.setQuantityExpected(5);

        details.add(d1);

        // 3. Thực hiện gọi hàm confirm
        System.out.println("--- BẮT ĐẦU TEST INSERT ---");
        boolean result = dao.confirmIssue(gi, details);

        if (result) {
            System.out.println("SUCCESS: Đã lưu phiếu xuất, trừ kho và ghi log thành công!");
        } else {
            System.err.println("FAILED: Có lỗi xảy ra. Kiểm tra console ở trên để xem StackTrace SQL!");
        }
    }

    public List<SalesOrder> getOrdersForIssue() {
        List<SalesOrder> list = new ArrayList<>();
        // Logic: Get orders with status 1 (Created) or 2 (Partially Delivered)
        // focus on cumulative quantity check
        String sql = "SELECT * FROM ("
                + "SELECT so.*, "
                + "ISNULL((SELECT SUM(quantity) FROM Sales_Order_Detail sod WHERE sod.SalesOrderID = so.SalesOrderID), 0) as OrderedQty, "
                + "ISNULL((SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = so.SalesOrderID), 0) as DeliveredQty "
                + "FROM Sales_Order so "
                + "WHERE so.Status IN (1, 2, 3)"
                + ") t ORDER BY CreatedDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SalesOrder so = new SalesOrder();
                so.setId(rs.getInt("SalesOrderID"));
                so.setOrderCode(rs.getString("OrderCode"));
                so.setStatus(rs.getInt("Status"));
                so.setCreatedDate(rs.getTimestamp("CreatedDate"));
                so.setCustomer(customerDAO.getById(rs.getInt("CustomerID")));
                so.setOrderedQty(rs.getInt("OrderedQty"));
                so.setDeliveredQty(rs.getInt("DeliveredQty"));
                list.add(so);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Object[]> getDetailsForUI(int soId, int locationId) {
        List<Object[]> uiDetails = new ArrayList<>();
        // Thêm pd.Color vào cuối câu SELECT
        String sql = "SELECT p.Name, pd.LotNumber, pd.SerialNumber, sod.Quantity as Ordered, "
                + "ISNULL((SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = sod.SalesOrderID AND gid.ProductDetailID = sod.ProductDetailID), 0) as Delivered, "
                + "ISNULL((SELECT lp.Quantity FROM Location_Product lp WHERE lp.ProductDetailID = sod.ProductDetailID AND lp.LocationID = ?), 0) as Stock, "
                + "sod.ProductDetailID, "
                + "pd.Color "
                + // Cột mới ở đây (vị trí index 7)
                "FROM Sales_Order_Detail sod "
                + "JOIN Product_Detail pd ON sod.ProductDetailID = pd.ProductDetailID "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "WHERE sod.SalesOrderID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            ps.setInt(2, soId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[8]; // Tăng kích thước mảng lên 8
                row[0] = rs.getString("Name");
                row[1] = rs.getString("LotNumber") != null ? rs.getString("LotNumber") : rs.getString("SerialNumber");
                row[2] = rs.getInt("Ordered");
                row[3] = rs.getInt("Delivered");
                row[4] = rs.getInt("Ordered") - rs.getInt("Delivered");
                row[5] = rs.getInt("Stock");
                row[6] = rs.getInt("ProductDetailID");
                row[7] = rs.getString("Color"); // Gán giá trị màu
                uiDetails.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return uiDetails;
    }

    public boolean confirmIssue(GoodsIssue gi, List<GoodsIssueDetail> details) {

        String sqlGI = "INSERT INTO Goods_Issue (IssueCode, SalesOrderID, LocationID, IssueDate, Status, CreateBy) "
                + "VALUES (?, ?, ?, GETDATE(), ?, ?)";

        String sqlGID = "INSERT INTO Goods_Issue_Detail "
                + "(IssueID, ProductDetailID, QuantityExpected, QuantityActual) "
                + "VALUES (?, ?, ?, ?)";

        String sqlUpdateStock = "UPDATE Location_Product "
                + "SET Quantity = Quantity - ? "
                + "WHERE LocationID = ? AND ProductDetailID = ?";

        // ✅ LOG ĐÚNG THEO SCHEMA
        String sqlLog = "INSERT INTO Inventory_Transaction "
                + "(ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode) "
                + "VALUES (?, ?, 2, ?, ?)";

        try {
            connection.setAutoCommit(false);

            int issueId = -1;

            // ===== 1. INSERT HEADER =====
            try (PreparedStatement psGI = connection.prepareStatement(sqlGI, Statement.RETURN_GENERATED_KEYS)) {

                psGI.setString(1, gi.getIssueCode());
                psGI.setInt(2, gi.getSalesOrder().getId());
                psGI.setInt(3, gi.getLocation().getId());
                psGI.setInt(4, gi.getStatus());
                psGI.setInt(5, gi.getCreateBy().getId());

                psGI.executeUpdate();

                ResultSet rs = psGI.getGeneratedKeys();
                if (rs.next()) {
                    issueId = rs.getInt(1);
                }
            }

            // ===== 2. DETAIL + STOCK + LOG =====
            try (PreparedStatement psGID = connection.prepareStatement(sqlGID);
                    PreparedStatement psStock = connection.prepareStatement(sqlUpdateStock);
                    PreparedStatement psLog = connection.prepareStatement(sqlLog)) {

                for (GoodsIssueDetail d : details) {
                    int pdId = d.getProductDetail().getId();
                    int qty = d.getQuantityActual();

                    // 2.1 Insert detail
                    psGID.setInt(1, issueId);
                    psGID.setInt(2, pdId);
                    psGID.setInt(3, d.getQuantityExpected());
                    psGID.setInt(4, qty);
                    psGID.executeUpdate();

                    // 2.2 Trừ kho
                    psStock.setInt(1, qty);
                    psStock.setInt(2, gi.getLocation().getId());
                    psStock.setInt(3, pdId);

                    int affected = psStock.executeUpdate();
                    if (affected == 0) {
                        throw new SQLException("Không tìm thấy dòng tồn kho cho ProductDetailID: " + pdId
                                + " tại Location: " + gi.getLocation().getId());
                    }

                    // 2.3 Ghi log inventory
                    // Lưu ý: Cẩn thận thứ tự tham số (?)
                    psLog.setInt(1, pdId); // Cho cột ProductDetailID
                    psLog.setInt(2, gi.getLocation().getId()); // Cho cột LocationID
                    psLog.setInt(3, qty); // Cho cột Quantity
                    psLog.setString(4, gi.getIssueCode()); // Cho cột ReferenceCode

                    int logAffected = psLog.executeUpdate();
                    if (logAffected == 0) {
                        System.err.println("CẢNH BÁO: Không thể ghi Log cho SP ID: " + pdId);
                    }
                }
            }

            // ===== 3. UPDATE SALES ORDER STATUS =====
            updateSalesOrderStatus(gi.getSalesOrder().getId());

            connection.commit();
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
            }
            e.printStackTrace();
            return false;

        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception e) {
            }
        }
    }

    private void updateSalesOrderStatus(int soId) throws SQLException {
        String sqlCheck = "SELECT "
                + "(SELECT SUM(quantity) FROM Sales_Order_Detail WHERE SalesOrderID = ?) as Total, "
                + "(SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = ?) as Shipped";

        int total = 0, shipped = 0;
        try (PreparedStatement ps = connection.prepareStatement(sqlCheck)) {
            ps.setInt(1, soId);
            ps.setInt(2, soId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("Total");
                shipped = rs.getInt("Shipped");
            }
        }

        int newStatus = (shipped >= total) ? 3 : 2; // 3: Completed, 2: Partially Delivered
        String sqlUpdate = "UPDATE Sales_Order SET Status = ? WHERE SalesOrderID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlUpdate)) {
            ps.setInt(1, newStatus);
            ps.setInt(2, soId);
            ps.executeUpdate();
        }
    }
}
