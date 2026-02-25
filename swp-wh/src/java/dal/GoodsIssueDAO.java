package dal;
import context.DBContext;
import model.*;
import java.sql.*;
import java.util.List;

public class GoodsIssueDAO extends DBContext {
    public boolean createGoodsIssue(GoodsIssue gi, List<GoodsIssueDetail> details) {
        String sqlGI = "INSERT INTO Goods_Issue (IssueCode, SalesOrderID, LocationID, Status, CreateBy) VALUES (?, ?, ?, 3, ?)";
        String sqlGID = "INSERT INTO Goods_Issue_Detail (IssueID, ProductDetailID, QuantityExpected, QuantityActual) VALUES (?, ?, ?, ?)";
        String sqlStock = "UPDATE Location_Product SET Quantity = Quantity - ? WHERE LocationID = ? AND ProductDetailID = ?";
        String sqlLog = "INSERT INTO Inventory_Transaction (ProductID, ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode) VALUES (?, ?, ?, 'ISSUE', ?, ?)";

        try {
            connection.setAutoCommit(false);
            int giId = 0;
            try (PreparedStatement ps = connection.prepareStatement(sqlGI, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, gi.getIssueCode());
                ps.setInt(2, gi.getSalesOrder().getId());
                ps.setInt(3, gi.getLocation().getId());
                ps.setInt(4, gi.getCreateBy().getId());
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) giId = rs.getInt(1);
            }

            for (GoodsIssueDetail d : details) {
                try (PreparedStatement psD = connection.prepareStatement(sqlGID)) {
                    psD.setInt(1, giId);
                    psD.setInt(2, d.getProductDetail().getId());
                    psD.setInt(3, d.getQuantityActual());
                    psD.setInt(4, d.getQuantityActual());
                    psD.executeUpdate();
                }
                try (PreparedStatement psS = connection.prepareStatement(sqlStock)) {
                    psS.setInt(1, d.getQuantityActual());
                    psS.setInt(2, gi.getLocation().getId());
                    psS.setInt(3, d.getProductDetail().getId());
                    psS.executeUpdate();
                }
                try (PreparedStatement psL = connection.prepareStatement(sqlLog)) {
                    psL.setInt(1, d.getProductDetail().getProduct().getId());
                    psL.setInt(2, d.getProductDetail().getId());
                    psL.setInt(3, gi.getLocation().getId());
                    psL.setInt(4, d.getQuantityActual());
                    psL.setString(5, gi.getIssueCode());
                    psL.executeUpdate();
                }
            }
            connection.commit();
            return true;
        } catch (SQLException e) {
            try { connection.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            return false;
        } finally {
            try { connection.setAutoCommit(true); } catch (Exception e) {}
        }
    }
}