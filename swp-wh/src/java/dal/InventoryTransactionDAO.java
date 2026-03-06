package dal;

import context.DBContext;
import model.InventoryTransaction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Location;
import model.Product;
import model.ProductDetail;

public class InventoryTransactionDAO extends DBContext {

    public List<InventoryTransaction> getTransactions(int page, int pageSize, Integer type, String search) {
        List<InventoryTransaction> list = new ArrayList<>();
        String sql = "SELECT it.TransactionID, it.ProductDetailID, it.LocationID, it.TransactionType, it.Quantity, it.ReferenceCode, it.TransactionDate, "
                +
                "p.Name as ProductName, pd.ProductID, pd.Color, l.LocationName " +
                "FROM Inventory_Transaction it " +
                "JOIN Product_Detail pd ON it.ProductDetailID = pd.ProductDetailID " +
                "JOIN Product p ON pd.ProductID = p.ProductID " +
                "JOIN Location l ON it.LocationID = l.LocationID " +
                "WHERE (1=1) ";

        if (type != null && type != 0)
            sql += " AND it.TransactionType = " + type;
        if (search != null && !search.isEmpty())
            sql += " AND it.ReferenceCode LIKE ?";

        sql += " ORDER BY it.TransactionDate DESC " +
                " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIdx = 1;
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIdx++, "%" + search + "%");
            }
            ps.setInt(paramIdx++, (page - 1) * pageSize);
            ps.setInt(paramIdx++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryTransaction t = new InventoryTransaction();
                t.setId(rs.getInt("TransactionID"));

                // Map Product & Detail
                Product p = new Product();
                p.setName(rs.getString("ProductName"));
                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setColor(rs.getString("Color"));
                pd.setProduct(p);
                t.setProductDetail(pd);

                // Map Location
                Location loc = new Location();
                loc.setId(rs.getInt("LocationID"));
                loc.setLocationName(rs.getString("LocationName"));
                t.setLocation(loc);

                t.setTransactionType(rs.getInt("TransactionType"));
                t.setQuantity(rs.getInt("Quantity"));
                t.setReferenceCode(rs.getString("ReferenceCode"));
                t.setTransactionDate(rs.getTimestamp("TransactionDate"));

                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cần thêm hàm đếm tổng để phân trang
    public int getTotalTransactions(Integer type, String search) {
        String sql = "SELECT COUNT(*) FROM Inventory_Transaction WHERE (1=1) ";
        if (type != null && type != 0)
            sql += " AND TransactionType = " + type;
        if (search != null && !search.isEmpty())
            sql += " AND ReferenceCode LIKE ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (search != null && !search.isEmpty())
                ps.setString(1, "%" + search + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
