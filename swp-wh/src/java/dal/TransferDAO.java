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

public class TransferDAO extends DBContext {

    public boolean createTransferRequest(TransferOrder order) {
        String sqlOrder = "INSERT INTO Transfer_Order (TransferCode, FromLocationID, ToLocationID, Status, CreateBy) VALUES (?, ?, ?, 1, ?)";
        String sqlDetail = "INSERT INTO Transfer_Order_Detail (TransferOrderID, ProductDetailID, Quantity) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false);
            // 1. Tạo đơn tổng
            PreparedStatement psOrder = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, "TRF-" + System.currentTimeMillis());
            psOrder.setInt(2, order.getFromLocationId());
            psOrder.setInt(3, order.getToLocationId());
            psOrder.setInt(4, order.getCreateBy());
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                int orderId = rs.getInt(1);
                // 2. Tạo chi tiết đơn
                PreparedStatement psDetail = connection.prepareStatement(sqlDetail);
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, order.getProductDetailId());
                psDetail.setInt(3, order.getQuantity());
                psDetail.executeUpdate();
            }
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
        }
    }

    // 1. Lấy danh sách các yêu cầu chuyển kho đang chờ (Status = 1)
    public List<TransferOrder> getPendingTransfers() {
        List<TransferOrder> list = new ArrayList<>();
        String sql = "SELECT t.TransferOrderID, t.TransferCode, t.FromLocationID, t.ToLocationID, " +
                "d.ProductDetailID, d.Quantity, pd.ProductID " +
                "FROM Transfer_Order t " +
                "JOIN Transfer_Order_Detail d ON t.TransferOrderID = d.TransferOrderID " +
                "JOIN Product_Detail pd ON d.ProductDetailID = pd.ProductDetailID " +
                "WHERE t.Status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TransferOrder to = new TransferOrder();
                to.setId(rs.getInt("TransferOrderID"));
                to.setTransferCode(rs.getString("TransferCode"));
                to.setFromLocationId(rs.getInt("FromLocationID"));
                to.setToLocationId(rs.getInt("ToLocationID"));
                to.setProductDetailId(rs.getInt("ProductDetailID"));
                to.setProductId(rs.getInt("ProductID"));
                to.setQuantity(rs.getInt("Quantity"));
                list.add(to);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Thực thi chuyển kho: Trừ kho xuất, Cộng kho nhập, Ghi Log, Cập nhật Status
    public boolean executeTransfer(int transferId) {
        String sqlGet = "SELECT t.FromLocationID, t.ToLocationID, d.ProductID, d.ProductDetailID, d.Quantity, t.TransferCode "
                +
                "FROM Transfer_Order t JOIN Transfer_Order_Detail d ON t.TransferOrderID = d.TransferOrderID " +
                "WHERE t.TransferOrderID = ?";
        String sqlSub = "UPDATE Location_Product SET Quantity = Quantity - ? WHERE LocationID = ? AND ProductDetailID = ?";

        // SQL Server MERGE for sqlAdd
        String sqlAdd = "MERGE INTO Location_Product AS target " +
                "USING (SELECT ? AS LocationID, ? AS ProductDetailID, ? AS Qty) AS source " +
                "ON (target.LocationID = source.LocationID AND target.ProductDetailID = source.ProductDetailID) " +
                "WHEN MATCHED THEN " +
                "    UPDATE SET Quantity = target.Quantity + source.Qty " +
                "WHEN NOT MATCHED THEN " +
                "    INSERT (LocationID, ProductDetailID, Quantity) VALUES (source.LocationID, source.ProductDetailID, source.Qty);";

        String sqlLog = "INSERT INTO Inventory_Transaction (ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode) VALUES (?,?,?,?,?)";
        String sqlUpdateStatus = "UPDATE Transfer_Order SET Status = 2 WHERE TransferOrderID = ?";

        try {
            connection.setAutoCommit(false); // Bắt đầu Transaction

            // B1: Lấy thông tin phiếu
            PreparedStatement psGet = connection.prepareStatement(sqlGet);
            psGet.setInt(1, transferId);
            ResultSet rs = psGet.executeQuery();

            if (rs.next()) {
                int fromLoc = rs.getInt("FromLocationID");
                int toLoc = rs.getInt("ToLocationID");
                int pdId = rs.getInt("ProductDetailID");
                int qty = rs.getInt("Quantity");
                String code = rs.getString("TransferCode");

                // B2: Trừ số lượng kho xuất
                PreparedStatement psSub = connection.prepareStatement(sqlSub);
                psSub.setInt(1, qty);
                psSub.setInt(2, fromLoc);
                psSub.setInt(3, pdId);
                psSub.executeUpdate();

                // B3: Cộng số lượng kho nhập (MERGE SQL Server)
                PreparedStatement psAdd = connection.prepareStatement(sqlAdd);
                psAdd.setInt(1, toLoc);
                psAdd.setInt(2, pdId);
                psAdd.setInt(3, qty);
                psAdd.executeUpdate();

                // B4: Ghi log giao dịch (2 dòng: Xuất và Nhập)
                PreparedStatement psLog = connection.prepareStatement(sqlLog);
                // Log Xuất
                psLog.setInt(1, pdId);
                psLog.setInt(2, fromLoc);
                psLog.setInt(3, 3); // 3: TRANSFER_OUT
                psLog.setInt(4, -qty);
                psLog.setString(5, code);
                psLog.addBatch();
                // Log Nhập
                psLog.setInt(1, pdId);
                psLog.setInt(2, toLoc);
                psLog.setInt(3, 4); // 4: TRANSFER_IN
                psLog.setInt(4, qty);
                psLog.setString(5, code);
                psLog.addBatch();
                psLog.executeBatch();

                // B5: Đổi trạng thái phiếu thành Hoàn thành (2)
                PreparedStatement psStatus = connection.prepareStatement(sqlUpdateStatus);
                psStatus.setInt(1, transferId);
                psStatus.executeUpdate();

                connection.commit(); // Thành công toàn bộ
                return true;
            }
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}