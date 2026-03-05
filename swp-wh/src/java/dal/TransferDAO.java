/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Asus
 */
import context.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.TransferOrder;
import model.TransferOrderDetail;

public class TransferDAO extends DBContext {
    
    // Lấy danh sách phiếu chuyển kho (Join với bảng Location để lấy tên)
    public List<TransferOrder> getAllTransfers() {
        List<TransferOrder> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT o.*, f.LocationName as FromName, t.LocationName as ToName, u.FullName as Creator " +
                     "FROM Transfer_Order o " +
                     "JOIN Location f ON o.FromLocationID = f.LocationID " +
                     "JOIN Location t ON o.ToLocationID = t.LocationID " +
                     "LEFT JOIN Users u ON o.CreateBy = u.UserID " +
                     "ORDER BY o.TransferDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                TransferOrder o = new TransferOrder();
                o.setId(rs.getInt("TransferOrderID"));
                o.setTransferCode(rs.getString("TransferCode"));
                o.setFromLocationId(rs.getInt("FromLocationID"));
                o.setToLocationId(rs.getInt("ToLocationID"));
//                o.setFromLocationId(rs.getString("FromName")); // Dùng field này hiển thị JSP
//                o.setToLocationName(rs.getString("ToName"));     // Dùng field này hiển thị JSP
//                o.setTransferDate(rs.getTimestamp("TransferDate"));
                o.setStatus(rs.getInt("Status"));
                o.setCreateBy(rs.getInt("CreateBy"));
                // Bạn có thể set thêm Creator name vào model nếu cần
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean checkAvailableStock(int locationId, int productDetailId, int requiredQty) {
        String sql = "SELECT Quantity FROM Location_Product WHERE LocationID = ? AND ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            ps.setInt(2, productDetailId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("Quantity") >= requiredQty;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// 1. Tạo Transfer Request (Status = 1)
    public int createTransferRequest(TransferOrder order, List<TransferOrderDetail> details) {
        String sqlOrder = "INSERT INTO Transfer_Order (TransferCode, FromLocationID, ToLocationID, Status, CreateBy) VALUES (?, ?, ?, 1, ?)";
        String sqlDetail = "INSERT INTO Transfer_Order_Detail (TransferOrderID, ProductDetailID, Quantity) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false);
            PreparedStatement ps = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, order.getTransferCode());
            ps.setInt(2, order.getFromLocationId());
            ps.setInt(3, order.getToLocationId());
            ps.setInt(4, order.getCreateBy());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int orderId = rs.getInt(1);
                PreparedStatement psDet = connection.prepareStatement(sqlDetail);
                for (TransferOrderDetail d : details) {
                    psDet.setInt(1, orderId);
                    psDet.setInt(2, d.getProductDetailId());
                    psDet.setInt(3, d.getQuantity());
                    psDet.addBatch();
                }
                psDet.executeBatch();
            }
            connection.commit();
            return 1;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
        }
        return 0;
    }

    // 2. Record Stock Transfer (Quan trọng nhất - Cập nhật kho thực tế)
    public boolean recordTransfer(int transferOrderId, int userId) {
        String getDetails = "SELECT * FROM Transfer_Order_Detail d JOIN Transfer_Order o ON d.TransferOrderID = o.TransferOrderID WHERE o.TransferOrderID = ?";

        try {
            connection.setAutoCommit(false);

            // Lấy thông tin chi tiết phiếu chuyển
            PreparedStatement ps = connection.prepareStatement(getDetails);
            ps.setInt(1, transferOrderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int prodDetId = rs.getInt("ProductDetailID");
                int qty = rs.getInt("Quantity");

                int fromLoc = rs.getInt("FromLocationID");
                int toLoc = rs.getInt("ToLocationID");
                String code = rs.getString("TransferCode");
// Trong vòng lặp while (rs.next()) của recordTransfer:
                int currentQty = rs.getInt("Quantity");
                if (!checkAvailableStock(fromLoc, prodDetId, currentQty)) {
                    throw new SQLException("Not enough stock for Product Detail ID: " + prodDetId);
                }
                // A. Trừ kho vị trí cũ
                updateStock(fromLoc, prodDetId, -qty);
                // B. Cộng kho vị trí mới
                updateStock(toLoc, prodDetId, qty);

                // C. Ghi log Transaction (Type 3=IN, 4=OUT)
                logTransaction(prodDetId, fromLoc, 4, -qty, code, userId);
                logTransaction(prodDetId, toLoc, 3, qty, code, userId);
            }

            // D. Cập nhật trạng thái phiếu thành COMPLETED (Status = 3)
            String updateStatus = "UPDATE Transfer_Order SET Status = 3 WHERE TransferOrderID = ?";
            PreparedStatement psStatus = connection.prepareStatement(updateStatus);
            psStatus.setInt(1, transferOrderId);
            psStatus.executeUpdate();

            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
            return false;
        }
    }

    private void updateStock(int locId, int detId, int qty) throws SQLException {
        // Sử dụng MERGE (SQL Server) hoặc kiểm tra EXISTS để UPDATE/INSERT
        String sql = "IF EXISTS (SELECT 1 FROM Location_Product WHERE LocationID = ? AND ProductDetailID = ?) "
                + "UPDATE Location_Product SET Quantity = Quantity + ? WHERE LocationID = ? AND ProductDetailID = ? "
                + "ELSE INSERT INTO Location_Product (LocationID, ProductDetailID, Quantity) VALUES (?, ?, ?)";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, locId);
        ps.setInt(2, detId);
        ps.setInt(3, qty);
        ps.setInt(4, locId);
        ps.setInt(5, detId);
        ps.setInt(6, locId);
        ps.setInt(7, detId);
        ps.setInt(8, qty);
        ps.executeUpdate();
    }

    private void logTransaction(int detId, int locId, int type, int qty, String ref, int user) throws SQLException {
        String sql = "INSERT INTO Inventory_Transaction (ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode, CreateBy) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, detId);
        ps.setInt(2, locId);
        ps.setInt(3, type);
        ps.setInt(4, qty);
        ps.setString(5, ref);
        ps.setInt(6, user);
        ps.executeUpdate();
    }
}
