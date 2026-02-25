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

    public List<SalesOrder> getOrdersForIssue() {
        List<SalesOrder> list = new ArrayList<>();
        // Logic: Get orders with status 1 (Created) or 2 (Partially Delivered) 
        // focus on cumulative quantity check
        String sql = "SELECT * FROM (" +
                     "SELECT so.*, " +
                     "ISNULL((SELECT SUM(quantity) FROM Sales_Order_Detail sod WHERE sod.SalesOrderID = so.SalesOrderID), 0) as OrderedQty, " +
                     "ISNULL((SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = so.SalesOrderID), 0) as DeliveredQty " +
                     "FROM Sales_Order so " +
                     "WHERE so.Status IN (1, 2, 3)" +
                     ") t ORDER BY CreatedDate DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
        // Product Name | Lot/Serial | Ordered | Delivered | Remaining | Stock | ProductDetailID
        String sql = "SELECT p.Name, pd.LotNumber, pd.SerialNumber, sod.Quantity as Ordered, " +
                     "ISNULL((SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = sod.SalesOrderID AND gid.ProductDetailID = sod.ProductDetailID), 0) as Delivered, " +
                     "ISNULL((SELECT lp.Quantity FROM Location_Product lp WHERE lp.ProductDetailID = sod.ProductDetailID AND lp.LocationID = ?), 0) as Stock, " +
                     "sod.ProductDetailID " +
                     "FROM Sales_Order_Detail sod " +
                     "JOIN Product_Detail pd ON sod.ProductDetailID = pd.ProductDetailID " +
                     "JOIN Product p ON pd.ProductID = p.ProductID " +
                     "WHERE sod.SalesOrderID = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            ps.setInt(2, soId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Object[] row = new Object[7];
                row[0] = rs.getString("Name");
                row[1] = rs.getString("LotNumber") != null ? rs.getString("LotNumber") : rs.getString("SerialNumber");
                row[2] = rs.getInt("Ordered");
                row[3] = rs.getInt("Delivered");
                row[4] = rs.getInt("Ordered") - rs.getInt("Delivered"); // Remaining
                row[5] = rs.getInt("Stock");
                row[6] = rs.getInt("ProductDetailID");
                uiDetails.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return uiDetails;
    }

    public boolean confirmIssue(GoodsIssue gi, List<GoodsIssueDetail> details) {
        String sqlGI = "INSERT INTO Goods_Issue (IssueCode, SalesOrderID, LocationID, IssueDate, Status, Note, CreateBy) VALUES (?, ?, ?, GETDATE(), ?, ?, ?)";
        String sqlGID = "INSERT INTO Goods_Issue_Detail (IssueID, ProductDetailID, QuantityExpected, QuantityActual) VALUES (?, ?, ?, ?)";
        String sqlUpdateStock = "UPDATE Location_Product SET Quantity = Quantity - ? WHERE LocationID = ? AND ProductDetailID = ? AND ProductID = ?";
        String sqlTrans = "INSERT INTO Inventory_Transaction (ProductID, ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode, TransactionDate) VALUES (?, ?, ?, 'ISSUE', ?, ?, GETDATE())";
        String sqlUpdateSO = "UPDATE Sales_Order SET Status = ? WHERE SalesOrderID = ?";

        try {
            connection.setAutoCommit(false);
            int issueId;
            try (PreparedStatement psGI = connection.prepareStatement(sqlGI, Statement.RETURN_GENERATED_KEYS)) {
                psGI.setString(1, gi.getIssueCode());
                psGI.setInt(2, gi.getSalesOrder().getId());
                psGI.setInt(3, gi.getLocation().getId());
                psGI.setInt(4, gi.getStatus());
                psGI.setString(5, gi.getNote());
                psGI.setInt(6, gi.getCreateBy().getId());
                psGI.executeUpdate();
                ResultSet rs = psGI.getGeneratedKeys();
                if (!rs.next()) throw new SQLException("Failed to create Goods Issue header");
                issueId = rs.getInt(1);
            }

            try (PreparedStatement psGID = connection.prepareStatement(sqlGID);
                 PreparedStatement psStock = connection.prepareStatement(sqlUpdateStock);
                 PreparedStatement psTrans = connection.prepareStatement(sqlTrans)) {
                
                for (GoodsIssueDetail detail : details) {
                    // 1. Insert Detail
                    psGID.setInt(1, issueId);
                    psGID.setInt(2, detail.getProductDetail().getId());
                    psGID.setInt(3, detail.getQuantityExpected());
                    psGID.setInt(4, detail.getQuantityActual());
                    psGID.addBatch();

                    // 2. Update Stock
                    System.out.println("[DEBUG] Updating Stock - Loc: " + gi.getLocation().getId() + 
                                       ", PD: " + detail.getProductDetail().getId() + 
                                       ", P: " + detail.getProductDetail().getProduct().getId() + 
                                       ", Qty: " + detail.getQuantityActual());
                    psStock.setInt(1, detail.getQuantityActual());
                    psStock.setInt(2, gi.getLocation().getId());
                    psStock.setInt(3, detail.getProductDetail().getId());
                    psStock.setInt(4, detail.getProductDetail().getProduct().getId());
                    int affected = psStock.executeUpdate();
                    System.out.println("[DEBUG] Stock update affected rows: " + affected);
                    
                    if (affected == 0) {
                        throw new SQLException("Could not update stock for ProductID: " + 
                            detail.getProductDetail().getProduct().getId() + " at LocationID: " + gi.getLocation().getId());
                    }

                    // 3. Inventory Transaction
                    psTrans.setInt(1, detail.getProductDetail().getProduct().getId());
                    psTrans.setInt(2, detail.getProductDetail().getId());
                    psTrans.setInt(3, gi.getLocation().getId());
                    psTrans.setInt(4, detail.getQuantityActual());
                    psTrans.setString(5, gi.getIssueCode());
                    psTrans.addBatch();
                }
                psGID.executeBatch();
                psTrans.executeBatch();
            }

            // 4. Update Sales Order Status
            String sqlCheck = "SELECT " +
                              "(SELECT SUM(quantity) FROM Sales_Order_Detail WHERE SalesOrderID = ?) as Total, " +
                              "(SELECT SUM(gid.QuantityActual) FROM Goods_Issue gi JOIN Goods_Issue_Detail gid ON gi.IssueID = gid.IssueID WHERE gi.SalesOrderID = ?) as Shipped";
            int total = 0, shipped = 0;
            try (PreparedStatement psCheck = connection.prepareStatement(sqlCheck)) {
                psCheck.setInt(1, gi.getSalesOrder().getId());
                psCheck.setInt(2, gi.getSalesOrder().getId());
                ResultSet rs = psCheck.executeQuery();
                if (rs.next()) {
                    total = rs.getInt("Total");
                    shipped = rs.getInt("Shipped");
                }
            }
            int newStatus = (shipped >= total) ? 3 : 2; // 3: Completed, 2: Partially
            try (PreparedStatement psUpdateSO = connection.prepareStatement(sqlUpdateSO)) {
                psUpdateSO.setInt(1, newStatus);
                psUpdateSO.setInt(2, gi.getSalesOrder().getId());
                psUpdateSO.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException re) { re.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
