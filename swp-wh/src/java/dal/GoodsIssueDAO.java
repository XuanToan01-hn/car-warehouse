package dal;

import context.DBContext;
import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GoodsIssueDAO extends DBContext {

    // Giữ lại LocationDAO nếu cần dùng bổ trợ, 
    // nhưng trong code hiện tại các hàm bên dưới tự viết SQL JOIN nên cũng có thể cân nhắc bỏ nếu không gọi lẻ.
    private final LocationDAO locationDAO = new LocationDAO();

    /**
     * Lấy dữ liệu hiển thị lên form tạo phiếu xuất kho
     * Kết hợp thông tin: Đơn hàng + Đã giao + Tồn kho tại vị trí cụ thể
     */
    public List<Object[]> getDetailsForUI(int soId, int locationId) {
        List<Object[]> uiDetails = new ArrayList<>();
        String sql = "SELECT p.Name, pd.LotNumber, pd.SerialNumber, sod.Quantity as Ordered, "
                + "ISNULL((SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = sod.SalesOrderID AND gid.ProductDetailID = sod.ProductDetailID), 0) as Delivered, "
                + "ISNULL((SELECT lp.Quantity FROM Location_Product lp WHERE lp.ProductDetailID = sod.ProductDetailID AND lp.LocationID = ?), 0) as Stock, "
                + "sod.ProductDetailID, "
                + "pd.Color, "
                + "sod.Price "
                + "FROM Sales_Order_Detail sod "
                + "JOIN Product_Detail pd ON sod.ProductDetailID = pd.ProductDetailID "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "WHERE sod.SalesOrderID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            ps.setInt(2, soId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[9];
                row[0] = rs.getString("Name");
                row[1] = rs.getString("LotNumber") != null ? rs.getString("LotNumber") : rs.getString("SerialNumber");
                row[2] = rs.getInt("Ordered");
                row[3] = rs.getInt("Delivered");
                row[4] = rs.getInt("Ordered") - rs.getInt("Delivered"); // Remaining
                row[5] = rs.getInt("Stock");
                row[6] = rs.getInt("ProductDetailID");
                row[7] = rs.getString("Color");
                row[8] = rs.getDouble("Price");
                uiDetails.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return uiDetails;
    }

    /**
     * Thực hiện Transaction: Lưu phiếu xuất, Trừ kho, Ghi log, Cập nhật trạng thái đơn hàng
     */
    public boolean confirmIssue(GoodsIssue gi, List<GoodsIssueDetail> details) {
        String sqlGI = "INSERT INTO Goods_Issue (IssueCode, SalesOrderID, LocationID, IssueDate, Status, CreateBy) VALUES (?, ?, ?, GETDATE(), ?, ?)";
        String sqlGID = "INSERT INTO Goods_Issue_Detail (IssueID, ProductDetailID, QuantityExpected, QuantityActual) VALUES (?, ?, ?, ?)";
        String sqlUpdateStock = "UPDATE Location_Product SET Quantity = Quantity - ? WHERE LocationID = ? AND ProductDetailID = ?";
        String sqlLog = "INSERT INTO Inventory_Transaction (ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode) VALUES (?, ?, 2, ?, ?)";

        try {
            connection.setAutoCommit(false);
            int issueId = -1;

            // 1. Lưu Header phiếu xuất
            try (PreparedStatement psGI = connection.prepareStatement(sqlGI, Statement.RETURN_GENERATED_KEYS)) {
                psGI.setString(1, gi.getIssueCode());
                psGI.setInt(2, gi.getSalesOrder().getId());
                psGI.setInt(3, gi.getLocation().getId());
                psGI.setInt(4, gi.getStatus());
                psGI.setInt(5, gi.getCreateBy().getId());
                psGI.executeUpdate();

                ResultSet rs = psGI.getGeneratedKeys();
                if (rs.next()) issueId = rs.getInt(1);
            }

            // 2. Lưu Detail + Cập nhật kho + Ghi log
            try (PreparedStatement psGID = connection.prepareStatement(sqlGID);
                 PreparedStatement psStock = connection.prepareStatement(sqlUpdateStock);
                 PreparedStatement psLog = connection.prepareStatement(sqlLog)) {

                for (GoodsIssueDetail d : details) {
                    int pdId = d.getProductDetail().getId();
                    int qty = d.getQuantityActual();

                    // Detail
                    psGID.setInt(1, issueId);
                    psGID.setInt(2, pdId);
                    psGID.setInt(3, d.getQuantityExpected());
                    psGID.setInt(4, qty);
                    psGID.executeUpdate();

                    // Trừ kho
                    psStock.setInt(1, qty);
                    psStock.setInt(2, gi.getLocation().getId());
                    psStock.setInt(3, pdId);
                    if (psStock.executeUpdate() == 0) throw new SQLException("Lỗi trừ kho tại Location: " + gi.getLocation().getId());

                    // Ghi log
                    psLog.setInt(1, pdId);
                    psLog.setInt(2, gi.getLocation().getId());
                    psLog.setInt(3, qty);
                    psLog.setString(4, gi.getIssueCode());
                    psLog.executeUpdate();
                }
            }

            // 3. Cập nhật trạng thái đơn hàng (Hoàn thành hoặc Giao một phần)
            updateSalesOrderStatus(gi.getSalesOrder().getId());

            connection.commit();
            return true;
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { }
            e.printStackTrace();
            return false;
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { }
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