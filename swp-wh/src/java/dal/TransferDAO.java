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

    // Status Constants
    public static final int PENDING = 0; // Yêu cầu chuyển kho
    public static final int APPROVED = 1; // Đã duyệt (Phiếu bộ bộ)
    public static final int IN_TRANSIT = 2; // Đang chuyển (Đã xuất)
    public static final int COMPLETED = 3; // Đã nhập (Hoàn thành)
    public static final int CANCELLED = 4; // Đã hủy

    public boolean createAndExecuteInternalTransfer(TransferOrder order, List<TransferOrderDetail> details) {
        String sqlOrder = "INSERT INTO Transfer_Order (TransferCode, FromLocationID, ToLocationID, Status, CreateBy, Note, TransferDate) VALUES (?, ?, ?, 3, ?, ?, GETDATE())";
        String sqlDetail = "INSERT INTO Transfer_Order_Detail (TransferOrderID, ProductDetailID, Quantity) VALUES (?, ?, ?)";
        String sqlSub = "UPDATE Location_Product SET Quantity = Quantity - ? WHERE LocationID = ? AND ProductDetailID = ?";
        String sqlAdd = "MERGE INTO Location_Product AS target " +
                "USING (SELECT ? AS LocationID, ? AS ProductDetailID, ? AS Qty) AS source " +
                "ON (target.LocationID = source.LocationID AND target.ProductDetailID = source.ProductDetailID) " +
                "WHEN MATCHED THEN UPDATE SET Quantity = target.Quantity + source.Qty " +
                "WHEN NOT MATCHED THEN INSERT (LocationID, ProductDetailID, Quantity) VALUES (source.LocationID, source.ProductDetailID, source.Qty);";
        String sqlLog = "INSERT INTO Inventory_Transaction (ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode, TransactionDate) VALUES (?, ?, ?, ?, ?, GETDATE())";

        try {
            connection.setAutoCommit(false);
            
            String code = "IT-" + System.currentTimeMillis();
            PreparedStatement psOrder = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, code);
            psOrder.setInt(2, order.getFromLocationId());
            psOrder.setInt(3, order.getToLocationId());
            psOrder.setInt(4, order.getCreateBy());
            psOrder.setString(5, order.getNote());
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                int orderId = rs.getInt(1);
                
                PreparedStatement psDetail = connection.prepareStatement(sqlDetail);
                PreparedStatement psSub = connection.prepareStatement(sqlSub);
                PreparedStatement psAdd = connection.prepareStatement(sqlAdd);
                PreparedStatement psLog = connection.prepareStatement(sqlLog);

                for (TransferOrderDetail detail : details) {
                    // Detail
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, detail.getProductDetailId());
                    psDetail.setInt(3, detail.getQuantity());
                    psDetail.addBatch();

                    // Subtract from source
                    psSub.setInt(1, detail.getQuantity());
                    psSub.setInt(2, order.getFromLocationId());
                    psSub.setInt(3, detail.getProductDetailId());
                    psSub.addBatch();

                    // Add to destination
                    psAdd.setInt(1, order.getToLocationId());
                    psAdd.setInt(2, detail.getProductDetailId());
                    psAdd.setInt(3, detail.getQuantity());
                    psAdd.addBatch();

                    // Log OUT (3)
                    psLog.setInt(1, detail.getProductDetailId());
                    psLog.setInt(2, order.getFromLocationId());
                    psLog.setInt(3, 3); // TRANSFER_OUT
                    psLog.setInt(4, -detail.getQuantity());
                    psLog.setString(5, code);
                    psLog.addBatch();

                    // Log IN (4)
                    psLog.setInt(1, detail.getProductDetailId());
                    psLog.setInt(2, order.getToLocationId());
                    psLog.setInt(3, 4); // TRANSFER_IN
                    psLog.setInt(4, detail.getQuantity());
                    psLog.setString(5, code);
                    psLog.addBatch();
                }
                psDetail.executeBatch();
                psSub.executeBatch();
                psAdd.executeBatch();
                psLog.executeBatch();
                
                connection.commit();
                return true;
            }
            connection.rollback();
            return false;
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { }
            e.printStackTrace();
            return false;
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { }
        }
    }

    public boolean createTransferRequest(TransferOrder order, List<TransferOrderDetail> details) {
        String sqlOrder = "INSERT INTO Transfer_Order (TransferCode, FromLocationID, ToLocationID, Status, CreateBy, Note, TransferDate) VALUES (?, ?, ?, 0, ?, ?, GETDATE())";
        String sqlDetail = "INSERT INTO Transfer_Order_Detail (TransferOrderID, ProductDetailID, Quantity) VALUES (?, ?, ?)";

        try {
            connection.setAutoCommit(false);
            PreparedStatement psOrder = connection.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS);
            psOrder.setString(1, "TRF-" + System.currentTimeMillis());
            psOrder.setInt(2, order.getFromLocationId());
            psOrder.setInt(3, order.getToLocationId());
            psOrder.setInt(4, order.getCreateBy());
            psOrder.setString(5, order.getNote());
            psOrder.executeUpdate();

            ResultSet rs = psOrder.getGeneratedKeys();
            if (rs.next()) {
                int orderId = rs.getInt(1);
                PreparedStatement psDetail = connection.prepareStatement(sqlDetail);
                for (TransferOrderDetail detail : details) {
                    psDetail.setInt(1, orderId);
                    psDetail.setInt(2, detail.getProductDetailId());
                    psDetail.setInt(3, detail.getQuantity());
                    psDetail.addBatch();
                }
                psDetail.executeBatch();
            }
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

    public boolean approveRequest(int transferId) {
        String sql = "UPDATE Transfer_Order SET Status = ? WHERE TransferOrderID = ? AND Status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, APPROVED);
            ps.setInt(2, transferId);
            ps.setInt(3, PENDING);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelRequest(int transferId) {
        String sql = "UPDATE Transfer_Order SET Status = ? WHERE TransferOrderID = ? AND Status = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, CANCELLED);
            ps.setInt(2, transferId);
            ps.setInt(3, PENDING);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<TransferOrder> getTransfersById(int id) {
        List<TransferOrder> list = new ArrayList<>();
        // Use the same paging logic but filter ONLY by ID to get all product rows
        StringBuilder sql = new StringBuilder(
                "SELECT t.TransferOrderID, t.TransferCode, t.FromLocationID, t.ToLocationID, t.Status, t.TransferDate, t.Note, " +
                "fl.LocationName as FromLocationName, tl.LocationName as ToLocationName, " +
                "fl.WarehouseID as FromWarehouseID, tl.WarehouseID as ToWarehouseID, " +
                "fw.WarehouseName as FromWarehouseName, tw.WarehouseName as ToWarehouseName, " +
                "d.ProductDetailID as ProductDetailID, d.Quantity " +
                "FROM Transfer_Order t " +
                "LEFT JOIN Transfer_Order_Detail d ON t.TransferOrderID = d.TransferOrderID " +
                "JOIN Location fl ON t.FromLocationID = fl.LocationID " +
                "JOIN Location tl ON t.ToLocationID = tl.LocationID " +
                "JOIN Warehouse fw ON fl.WarehouseID = fw.WarehouseID " +
                "JOIN Warehouse tw ON tl.WarehouseID = tw.WarehouseID " +
                "WHERE t.TransferOrderID = ?");
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ps.setInt(1, id);
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
                to.setNote(rs.getString("Note"));
                list.add(to);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public TransferOrder getById(int id) {
        List<TransferOrder> list = getTransfersById(id);
        if(!list.isEmpty()) return list.get(0);
        return null;
    }

    public List<TransferOrder> getPendingTransfers() {
        return getTransfers(null, PENDING, null);
    }

    public List<TransferOrder> getApprovedTransfers() {
        return getTransfers(null, APPROVED, null);
    }

    public int getTransfersCount(String code, Integer status, Integer warehouseId, String type, String fromLoc, String toLoc, String productName) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(DISTINCT t.TransferOrderID) FROM Transfer_Order t " +
                "JOIN Location fl ON t.FromLocationID = fl.LocationID " +
                "JOIN Location tl ON t.ToLocationID = tl.LocationID " +
                "WHERE 1=1 ");

        if (code != null && !code.isEmpty()) sql.append(" AND t.TransferCode LIKE ? ");
        if (status != null) sql.append(" AND t.Status = ? ");
        if (warehouseId != null) sql.append(" AND (fl.WarehouseID = ? OR tl.WarehouseID = ?) ");
        if ("internal".equals(type)) sql.append(" AND fl.WarehouseID = tl.WarehouseID ");
        if ("external".equals(type)) sql.append(" AND fl.WarehouseID != tl.WarehouseID ");
        if (fromLoc != null && !fromLoc.isEmpty()) sql.append(" AND fl.LocationName LIKE ? ");
        if (toLoc != null && !toLoc.isEmpty()) sql.append(" AND tl.LocationName LIKE ? ");
        if (productName != null && !productName.isEmpty()) {
            sql.append(" AND EXISTS (SELECT 1 FROM Transfer_Order_Detail tod " +
                       "JOIN Product_Detail pd ON tod.ProductDetailID = pd.ProductDetailID " +
                       "JOIN Product p ON pd.ProductID = p.ProductID " +
                       "WHERE tod.TransferOrderID = t.TransferOrderID AND p.Name LIKE ?) ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (code != null && !code.isEmpty()) ps.setString(paramIndex++, "%" + code + "%");
            if (status != null) ps.setInt(paramIndex++, status);
            if (warehouseId != null) {
                ps.setInt(paramIndex++, warehouseId);
                ps.setInt(paramIndex++, warehouseId);
            }
            if (fromLoc != null && !fromLoc.isEmpty()) ps.setString(paramIndex++, "%" + fromLoc + "%");
            if (toLoc != null && !toLoc.isEmpty()) ps.setString(paramIndex++, "%" + toLoc + "%");
            if (productName != null && !productName.isEmpty()) ps.setString(paramIndex++, "%" + productName + "%");
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<TransferOrder> getTransfers(String code, Integer status, Integer warehouseId) {
        return getTransfersPaged(code, status, warehouseId, null, null, null, null, 1, Integer.MAX_VALUE);
    }

    public List<TransferOrder> getTransfersPaged(String code, Integer status, Integer warehouseId, String type, 
                                               String fromLoc, String toLoc, String productName, int page, int pageSize) {
        List<TransferOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT t.TransferOrderID, t.TransferCode, t.FromLocationID, t.ToLocationID, t.Status, t.TransferDate, t.Note, " +
                "fl.LocationName as FromLocationName, tl.LocationName as ToLocationName, " +
                "fl.WarehouseID as FromWarehouseID, tl.WarehouseID as ToWarehouseID, " +
                "fw.WarehouseName as FromWarehouseName, tw.WarehouseName as ToWarehouseName, " +
                "SUM(d.Quantity) as TotalQuantity, COUNT(d.ProductDetailID) as ItemCount, " +
                "MAX(d.ProductDetailID) as FirstProductDetailID, " +
                "MAX('[' + pd.SerialNumber + '] ' + p.Name + ' - ' + pd.Color) as ProductName " +
                "FROM Transfer_Order t " +
                "LEFT JOIN Transfer_Order_Detail d ON t.TransferOrderID = d.TransferOrderID " +
                "LEFT JOIN Product_Detail pd ON d.ProductDetailID = pd.ProductDetailID " +
                "LEFT JOIN Product p ON pd.ProductID = p.ProductID " +
                "JOIN Location fl ON t.FromLocationID = fl.LocationID " +
                "JOIN Location tl ON t.ToLocationID = tl.LocationID " +
                "JOIN Warehouse fw ON fl.WarehouseID = fw.WarehouseID " +
                "JOIN Warehouse tw ON tl.WarehouseID = tw.WarehouseID " +
                "WHERE 1=1 ");

        if (code != null && !code.isEmpty()) sql.append(" AND t.TransferCode LIKE ? ");
        if (status != null) sql.append(" AND t.Status = ? ");
        if (warehouseId != null) sql.append(" AND (fl.WarehouseID = ? OR tl.WarehouseID = ?) ");
        if ("internal".equals(type)) sql.append(" AND fl.WarehouseID = tl.WarehouseID ");
        if ("external".equals(type)) sql.append(" AND fl.WarehouseID != tl.WarehouseID ");

        sql.append(" GROUP BY t.TransferOrderID, t.TransferCode, t.FromLocationID, t.ToLocationID, t.Status, t.TransferDate, t.Note, " +
                   "fl.LocationName, tl.LocationName, fl.WarehouseID, tl.WarehouseID, fw.WarehouseName, tw.WarehouseName ");
        sql.append(" ORDER BY t.TransferDate DESC ");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (code != null && !code.isEmpty()) ps.setString(paramIndex++, "%" + code + "%");
            if (status != null) ps.setInt(paramIndex++, status);
            if (warehouseId != null) {
                ps.setInt(paramIndex++, warehouseId);
                ps.setInt(paramIndex++, warehouseId);
            }
            if (fromLoc != null && !fromLoc.isEmpty()) ps.setString(paramIndex++, "%" + fromLoc + "%");
            if (toLoc != null && !toLoc.isEmpty()) ps.setString(paramIndex++, "%" + toLoc + "%");
            if (productName != null && !productName.isEmpty()) ps.setString(paramIndex++, "%" + productName + "%");
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex++, pageSize);

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
                to.setProductId(rs.getInt("ItemCount")); // Use productId field to store item count
                to.setProductDetailId(rs.getInt("FirstProductDetailID"));
                to.setProductName(rs.getString("ProductName"));
                to.setQuantity(rs.getInt("TotalQuantity"));
                to.setNote(rs.getString("Note"));
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
            PreparedStatement psSub = connection.prepareStatement(sqlSub);
            PreparedStatement psLog = connection.prepareStatement(sqlLog);
            
            boolean hasData = false;
            int transferStatus = -1; // To store the status of the transfer order
            while (rs.next()) {
                hasData = true;
                if (transferStatus == -1) { // Get status from the first row
                    transferStatus = rs.getInt("Status");
                }
                if (transferStatus != APPROVED) {
                    connection.rollback(); // Rollback if status is not APPROVED
                    return false; // Only Approved can be shipped
                }
                int fromLoc = rs.getInt("FromLocationID");
                int pdId = rs.getInt("ProductDetailID");
                int qty = rs.getInt("Quantity");
                String code = rs.getString("TransferCode");

                // Subtract from source
                psSub.setInt(1, qty);
                psSub.setInt(2, fromLoc);
                psSub.setInt(3, pdId);
                psSub.addBatch();

                // Log Out (3: TRANSFER_OUT)
                psLog.setInt(1, pdId);
                psLog.setInt(2, fromLoc);
                psLog.setInt(3, 3);
                psLog.setInt(4, -qty);
                psLog.setString(5, code);
                psLog.addBatch();
            }

            if (hasData) {
                psSub.executeBatch();
                psLog.executeBatch();

                // Update Status to InTransit
                PreparedStatement psStatus = connection.prepareStatement(sqlUpdateStatus);
                psStatus.setInt(1, IN_TRANSIT);
                psStatus.setInt(2, transferId);
                psStatus.executeUpdate();

                connection.commit();
                return true;
            }
            return false;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
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
            PreparedStatement psAdd = connection.prepareStatement(sqlAdd);
            PreparedStatement psLog = connection.prepareStatement(sqlLog);
            
            boolean hasData = false;
            int transferStatus = -1; // To store the status of the transfer order
            while (rs.next()) {
                hasData = true;
                if (transferStatus == -1) { // Get status from the first row
                    transferStatus = rs.getInt("Status");
                }
                if (transferStatus != IN_TRANSIT) {
                    connection.rollback(); // Rollback if status is not IN_TRANSIT
                    return false; // Must be In Transit to be received
                }
                int toLoc = rs.getInt("ToLocationID");
                int pdId = rs.getInt("ProductDetailID");
                int qty = rs.getInt("Quantity");
                String code = rs.getString("TransferCode");

                // Add to dest
                psAdd.setInt(1, toLoc);
                psAdd.setInt(2, pdId);
                psAdd.setInt(3, qty);
                psAdd.addBatch();

                // Log In (4: TRANSFER_IN)
                psLog.setInt(1, pdId);
                psLog.setInt(2, toLoc);
                psLog.setInt(3, 4);
                psLog.setInt(4, qty);
                psLog.setString(5, code);
                psLog.addBatch();
            }

            if (hasData) {
                psAdd.executeBatch();
                psLog.executeBatch();

                // Update Status to Completed
                PreparedStatement psStatus = connection.prepareStatement(sqlUpdateStatus);
                psStatus.setInt(1, COMPLETED);
                psStatus.setInt(2, transferId);
                psStatus.executeUpdate();

                connection.commit();
                return true;
            }
            return false;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
            }
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
            PreparedStatement psSub = connection.prepareStatement(sqlSub);
            PreparedStatement psAdd = connection.prepareStatement(sqlAdd);
            PreparedStatement psLog = connection.prepareStatement(sqlLog);

            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                int fromLoc = rs.getInt("FromLocationID");
                int toLoc = rs.getInt("ToLocationID");
                int pdId = rs.getInt("ProductDetailID");
                int qty = rs.getInt("Quantity");
                String code = rs.getString("TransferCode");

                // B2: Trừ số lượng kho xuất
                psSub.setInt(1, qty);
                psSub.setInt(2, fromLoc);
                psSub.setInt(3, pdId);
                psSub.addBatch();

                // B3: Cộng số lượng kho nhập (MERGE SQL Server)
                psAdd.setInt(1, toLoc);
                psAdd.setInt(2, pdId);
                psAdd.setInt(3, qty);
                psAdd.addBatch();

                // B4: Ghi log giao dịch (2 dòng: Xuất và Nhập)
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
            }

            if (hasData) {
                psSub.executeBatch();
                psAdd.executeBatch();
                psLog.executeBatch();

                // B5: Đổi trạng thái phiếu thành Hoàn thành (2)
                PreparedStatement psStatus = connection.prepareStatement(sqlUpdateStatus);
                psStatus.setInt(1, transferId);
                psStatus.executeUpdate();

                connection.commit(); // Thành công toàn bộ
                return true;
            }
            return false;
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

    public int getReservedQuantity(int locId, int pdId) {
        String sql = "SELECT SUM(d.Quantity) as Reserved FROM Transfer_Order t " +
                "JOIN Transfer_Order_Detail d ON t.TransferOrderID = d.TransferOrderID " +
                "WHERE t.FromLocationID = ? AND d.ProductDetailID = ? AND t.Status = 1"; // Status 1: APPROVED
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locId);
            ps.setInt(2, pdId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt("Reserved");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPhysicalQuantity(int locId, int pdId) {
        String sql = "SELECT Quantity FROM Location_Product WHERE LocationID = ? AND ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locId);
            ps.setInt(2, pdId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt("Quantity");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}