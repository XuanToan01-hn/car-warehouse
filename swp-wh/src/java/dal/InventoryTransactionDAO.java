package dal;

import context.DBContext;
import model.InventoryTransaction;
import java.sql.*;

public class InventoryTransactionDAO extends DBContext {

    public void insert(InventoryTransaction transaction) {
        String sql = "INSERT INTO Inventory_Transaction (ProductID, ProductDetailID, LocationID, TransactionType, Quantity, ReferenceCode, TransactionDate) " +
                     "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transaction.getProduct().getId());
            if (transaction.getProductDetail() != null) {
                ps.setInt(2, transaction.getProductDetail().getId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setInt(3, transaction.getLocation().getId());
            ps.setString(4, transaction.getTransactionType());
            ps.setInt(5, transaction.getQuantity());
            ps.setString(6, transaction.getReferenceCode());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
