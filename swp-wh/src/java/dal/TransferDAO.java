package dal;

import context.DBContext;
import java.sql.*;

public class TransferDAO extends DBContext {

    public boolean executeTransfer(int fromLoc, int toLoc, int userId, String[] pdIds, String[] qtys) {
        String transferCode = "TRF-" + System.currentTimeMillis();
        try {
            connection.setAutoCommit(false);

            // 1. Insert Transfer_Order
            String sqlOrder = "INSERT INTO Transfer_Order (TransferCode, FromLocationID, ToLocationID, Status, CreateBy, TransferDate) VALUES (?, ?, ?, 2, ?, CURRENT_TIMESTAMP)";
            int orderId = 0;
            try (PreparedStatement ps = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, transferCode);
                ps.setInt(2, fromLoc);
                ps.setInt(3, toLoc);
                ps.setInt(4, userId);
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) orderId = rs.getInt(1);
            }

            for (int i = 0; i < pdIds.length; i++) {
                int pdId = Integer.parseInt(pdIds[i]);
                int qty = Integer.parseInt(qtys[i]);
                int pId = getProductId(pdId); // Lấy ProductID cha (Bắt buộc cho PK Location_Product)

                // 2. Insert Transfer_Order_Detail
                String sqlDetail = "INSERT INTO Transfer_Order_Detail (TransferOrderID, ProductDetailID, Quantity) VALUES (?, ?, ?)";
                try (PreparedStatement ps = connection.prepareStatement(sqlDetail)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, pdId);
                    ps.setInt(3, qty);
                    ps.executeUpdate();
                }

                // 3. Trừ kho xuất (FromLocationID)
                String sqlSub = "UPDATE Location_Product SET Quantity = Quantity - ? WHERE LocationID = ? AND ProductDetailID = ? AND Quantity >= ?";
                try (PreparedStatement ps = connection.prepareStatement(sqlSub)) {
                    ps.setInt(1, qty);
                    ps.setInt(2, fromLoc);
                    ps.setInt(3, pdId);
                    ps.setInt(4, qty);
                    if (ps.executeUpdate() == 0) throw new SQLException("Hết hàng tại kho xuất cho ID: " + pdId);
                }

                // 4. Cộng kho nhập (ToLocationID) - FIX: Thêm ProductID vào INSERT
                if (!checkExistInLocation(toLoc, pdId)) {
                    // BẢNG CỦA BẠN CÓ PK LÀ (LocationID, ProductID, ProductDetailID) NÊN PHẢI CÓ PID
                    String sqlIns = "INSERT INTO Location_Product (LocationID, ProductID, ProductDetailID, Quantity) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement ps = connection.prepareStatement(sqlIns)) {
                        ps.setInt(1, toLoc);
                        ps.setInt(2, pId); 
                        ps.setInt(3, pdId);
                        ps.setInt(4, qty);
                        ps.executeUpdate();
                    }
                } else {
                    String sqlUp = "UPDATE Location_Product SET Quantity = Quantity + ? WHERE LocationID = ? AND ProductDetailID = ?";
                    try (PreparedStatement ps = connection.prepareStatement(sqlUp)) {
                        ps.setInt(1, qty);
                        ps.setInt(2, toLoc);
                        ps.setInt(3, pdId);
                        ps.executeUpdate();
                    }
                }

                // 5. Log Transaction (Thêm cột CreateBy như trong DB của bạn)
                logTransaction(pId, pdId, fromLoc, 4, -qty, transferCode, userId); // Xuất
                logTransaction(pId, pdId, toLoc, 3, qty, transferCode, userId);  // Nhập
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { connection.rollback(); } catch (SQLException ex) {}
            return false;
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) {}
        }
    }

    private int getProductId(int pdId) throws SQLException {
        String sql = "SELECT ProductID FROM Product_Detail WHERE ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pdId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    private boolean checkExistInLocation(int locId, int pdId) throws SQLException {
        String sql = "SELECT 1 FROM Location_Product WHERE LocationID = ? AND ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locId);
            ps.setInt(2, pdId);
            return ps.executeQuery().next();
        }
    }

    private void logTransaction(int pId, int pdId, int locId, int type, int qty, String ref, int uId) throws SQLException {
        // DB của bạn có cột CreateBy và CurrentStatus
        String sql = "INSERT INTO Inventory_Transaction (ProductID, ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode, CreateBy, CurrentStatus, TransactionDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pId);
            ps.setInt(2, pdId);
            ps.setInt(3, locId);
            ps.setInt(4, type);
            ps.setInt(5, qty);
            ps.setString(6, ref);
            ps.setInt(7, uId);
            ps.setString(8, "COMPLETED");
            ps.executeUpdate();
        }
    }
}