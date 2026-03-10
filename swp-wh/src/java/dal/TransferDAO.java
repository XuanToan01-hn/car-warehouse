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

    // Status Constants
    public static final int APPROVED = 1;
    public static final int IN_TRANSIT = 2;
    public static final int COMPLETED = 3;

    public boolean createTransferRequest(TransferOrder order) {
        // ... (existing code but using constants)
        // Actually I'll keep it as is to avoid breaking changes if '1' meant something else before.
        // But the user said 'Approved' is what they want to start with.
        String sqlOrder = "INSERT INTO Transfer_Order (TransferCode, FromLocationID, ToLocationID, Status, CreateBy) VALUES (?, ?, ?, 1, ?)";
        String sqlDetail = "INSERT INTO Transfer_Order_Detail (TransferOrderID, ProductDetailID, Quantity) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false);
            PreparedStatement psOrder = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, "TRF-" + System.currentTimeMillis());
            psOrder.setInt(2, order.getFromLocationId());
            psOrder.setInt(3, order.getToLocationId());
            psOrder.setInt(4, order.getCreateBy());
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                int orderId = rs.getInt(1);
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

    public List<TransferOrder> getPendingTransfers() {
        return getTransfers(null, 1, null);
    }

    public List<TransferOrder> getTransfers(String code, Integer status, Integer warehouseId) {
        List<TransferOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.TransferOrderID, t.TransferCode, t.FromLocationID, t.ToLocationID, t.Status, t.TransferDate, " +
            "fl.LocationName as FromLocationName, tl.LocationName as ToLocationName, " +
            "fl.WarehouseID as FromWarehouseID, tl.WarehouseID as ToWarehouseID, " +
            "fw.WarehouseName as FromWarehouseName, tw.WarehouseName as ToWarehouseName, " +
            "d.ProductDetailID, d.Quantity " +
            "FROM Transfer_Order t " +
            "JOIN Transfer_Order_Detail d ON t.TransferOrderID = d.TransferOrderID " +
            "JOIN Location fl ON t.FromLocationID = fl.LocationID " +
            "JOIN Location tl ON t.ToLocationID = tl.LocationID " +
            "JOIN Warehouse fw ON fl.WarehouseID = fw.WarehouseID " +
            "JOIN Warehouse tw ON tl.WarehouseID = tw.WarehouseID " +
            "WHERE 1=1 "
        );

        if (code != null && !code.isEmpty()) sql.append(" AND t.TransferCode LIKE ? ");
        if (status != null) sql.append(" AND t.Status = ? ");
        if (warehouseId != null) {
            sql.append(" AND (fl.WarehouseID = ? OR tl.WarehouseID = ?) ");
        }
        
        sql.append(" ORDER BY t.TransferDate DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (code != null && !code.isEmpty()) ps.setString(paramIndex++, "%" + code + "%");
            if (status != null) ps.setInt(paramIndex++, status);
            if (warehouseId != null) {
                ps.setInt(paramIndex++, warehouseId);
                ps.setInt(paramIndex++, warehouseId);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TransferOrder to = new TransferOrder();
                to.setId(rs.getInt("TransferOrderID"));
                to.setTransferCode(rs.getString("TransferCode"));
                to.setFromLocationId(rs.getInt("FromLocationID"));
                to.setToLocationId(rs.getInt("ToLocationID"));
                to.setFromLocationName(rs.getString("FromLocationName"));
                to.setToLocationName(rs.getString("ToLocationName"));
                to.setFromWarehouseId(rs.getInt("FromWarehouseID"));
                to.setToWarehouseId(rs.getInt("ToWarehouseID"));
                to.setFromWarehouseName(rs.getString("FromWarehouseName"));
                to.setToWarehouseName(rs.getString("ToWarehouseName"));
                to.setStatus(rs.getInt("Status"));
                to.setProductDetailId(rs.getInt("ProductDetailID"));
                to.setQuantity(rs.getInt("Quantity"));
                // to.setTransferDate(rs.getTimestamp("TransferDate")); // Add getter if needed
                list.add(to);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean transferOut(int transferId) {
        String sqlGet = "SELECT t.FromLocationID, d.ProductDetailID, d.Quantity, t.TransferCode, t.Status " +
                        "FROM Transfer_Order t JOIN Transfer_Order_Detail d ON t.TransferOrderID = d.TransferOrderID " +
                        "WHERE t.TransferOrderID = ?";
        String sqlSub = "UPDATE Location_Product SET Quantity = Quantity - ? WHERE LocationID = ? AND ProductDetailID = ?";
        String sqlLog = "INSERT INTO Inventory_Transaction (ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode) VALUES (?,?,?,?,?)";
        String sqlUpdateStatus = "UPDATE Transfer_Order SET Status = ? WHERE TransferOrderID = ?";

        try {
            connection.setAutoCommit(false);
            PreparedStatement psGet = connection.prepareStatement(sqlGet);
            psGet.setInt(1, transferId);
            ResultSet rs = psGet.executeQuery();

            if (rs.next()) {
                if (rs.getInt("Status") != APPROVED) {
                    return false; // Already processed or not approved
                }
                int fromLoc = rs.getInt("FromLocationID");
                int pdId = rs.getInt("ProductDetailID");
                int qty = rs.getInt("Quantity");
                String code = rs.getString("TransferCode");

                // Subtract from source
                PreparedStatement psSub = connection.prepareStatement(sqlSub);
                psSub.setInt(1, qty);
                psSub.setInt(2, fromLoc);
                psSub.setInt(3, pdId);
                psSub.executeUpdate();

                // Log Out
                PreparedStatement psLog = connection.prepareStatement(sqlLog);
                psLog.setInt(1, pdId);
                psLog.setInt(2, fromLoc);
                psLog.setInt(3, 3); // TRANSFER_OUT
                psLog.setInt(4, -qty);
                psLog.setString(5, code);
                psLog.executeUpdate();

                // Update Status to InTransit
                PreparedStatement psStatus = connection.prepareStatement(sqlUpdateStatus);
                psStatus.setInt(1, IN_TRANSIT);
                psStatus.setInt(2, transferId);
                psStatus.executeUpdate();

                connection.commit();
                return true;
            }
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) {}
        }
        return false;
    }

    public boolean transferIn(int transferId) {
        String sqlGet = "SELECT t.ToLocationID, d.ProductDetailID, d.Quantity, t.TransferCode, t.Status " +
                        "FROM Transfer_Order t JOIN Transfer_Order_Detail d ON t.TransferOrderID = d.TransferOrderID " +
                        "WHERE t.TransferOrderID = ?";
        String sqlAdd = "MERGE INTO Location_Product AS target " +
                        "USING (SELECT ? AS LocationID, ? AS ProductDetailID, ? AS Qty) AS source " +
                        "ON (target.LocationID = source.LocationID AND target.ProductDetailID = source.ProductDetailID) " +
                        "WHEN MATCHED THEN UPDATE SET Quantity = target.Quantity + source.Qty " +
                        "WHEN NOT MATCHED THEN INSERT (LocationID, ProductDetailID, Quantity) VALUES (source.LocationID, source.ProductDetailID, source.Qty);";
        String sqlLog = "INSERT INTO Inventory_Transaction (ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode) VALUES (?,?,?,?,?)";
        String sqlUpdateStatus = "UPDATE Transfer_Order SET Status = ? WHERE TransferOrderID = ?";

        try {
            connection.setAutoCommit(false);
            PreparedStatement psGet = connection.prepareStatement(sqlGet);
            psGet.setInt(1, transferId);
            ResultSet rs = psGet.executeQuery();

            if (rs.next()) {
                if (rs.getInt("Status") != IN_TRANSIT) {
                    return false; // Not in transit
                }
                int toLoc = rs.getInt("ToLocationID");
                int pdId = rs.getInt("ProductDetailID");
                int qty = rs.getInt("Quantity");
                String code = rs.getString("TransferCode");

                // Add to destination
                PreparedStatement psAdd = connection.prepareStatement(sqlAdd);
                psAdd.setInt(1, toLoc);
                psAdd.setInt(2, pdId);
                psAdd.setInt(3, qty);
                psAdd.executeUpdate();

                // Log In
                PreparedStatement psLog = connection.prepareStatement(sqlLog);
                psLog.setInt(1, pdId);
                psLog.setInt(2, toLoc);
                psLog.setInt(3, 4); // TRANSFER_IN
                psLog.setInt(4, qty);
                psLog.setString(5, code);
                psLog.executeUpdate();

                // Update Status to Completed
                PreparedStatement psStatus = connection.prepareStatement(sqlUpdateStatus);
                psStatus.setInt(1, COMPLETED);
                psStatus.setInt(2, transferId);
                psStatus.executeUpdate();

                connection.commit();
                return true;
            }
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) {}
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) {}
        }
        return false;
    }

    public boolean executeTransfer(int transferId) {
        // ... (keep original code as is for backward compatibility)
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