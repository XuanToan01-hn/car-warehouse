package dal;

import context.DBContext;
import model.InventoryTransaction;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Location;
import model.Product;
import model.ProductDetail;
import model.User;

public class InventoryTransactionDAO extends DBContext {

    // Thêm 2 tham số từ ngày, đến ngày
public List<InventoryTransaction> getTransactions(int page, int pageSize, Integer type, String search, String from, String to) {
    List<InventoryTransaction> list = new ArrayList<>();
    String sql = "SELECT it.TransactionID, it.ProductDetailID, it.LocationID, it.TransactionType, "
            + "it.Quantity, it.ReferenceCode, it.TransactionDate, it.CreateBy, "
            + "p.Name as ProductName, pd.ProductID, pd.Color, l.LocationName, u.FullName as CreatorName "
            + "FROM Inventory_Transaction it "
            + "JOIN Product_Detail pd ON it.ProductDetailID = pd.ProductDetailID "
            + "JOIN Product p ON pd.ProductID = p.ProductID "
            + "JOIN Location l ON it.LocationID = l.LocationID "
            + "LEFT JOIN Users u ON it.CreateBy = u.UserID "
            + "WHERE (1=1) ";

    if (type != null && type != 0) sql += " AND it.TransactionType = " + type;
    if (search != null && !search.isEmpty()) sql += " AND it.ReferenceCode LIKE ? ";
    // Lọc theo ngày (Sử dụng CAST để bỏ qua phần giờ nếu cần hoặc lọc chính xác)
    if (from != null && !from.isEmpty()) sql += " AND it.TransactionDate >= ? ";
    if (to != null && !to.isEmpty()) sql += " AND it.TransactionDate <= ? + ' 23:59:59' ";

    sql += " ORDER BY it.TransactionDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        int paramIdx = 1;
        if (search != null && !search.isEmpty()) ps.setString(paramIdx++, "%" + search + "%");
        if (from != null && !from.isEmpty()) ps.setString(paramIdx++, from);
        if (to != null && !to.isEmpty()) ps.setString(paramIdx++, to);
        
        ps.setInt(paramIdx++, (page - 1) * pageSize);
        ps.setInt(paramIdx++, pageSize);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            InventoryTransaction t = new InventoryTransaction();
            t.setId(rs.getInt("TransactionID"));
            
            Product p = new Product();
            p.setName(rs.getString("ProductName"));
            ProductDetail pd = new ProductDetail();
            pd.setId(rs.getInt("ProductDetailID"));
            pd.setColor(rs.getString("Color"));
            pd.setProduct(p);
            t.setProductDetail(pd);

            Location loc = new Location();
            loc.setId(rs.getInt("LocationID"));
            loc.setLocationName(rs.getString("LocationName"));
            t.setLocation(loc);

            t.setTransactionType(rs.getInt("TransactionType"));
            t.setQuantity(rs.getInt("Quantity"));
            t.setReferenceCode(rs.getString("ReferenceCode"));
            t.setTransactionDate(rs.getTimestamp("TransactionDate"));

            User creator = new User();
            creator.setId(rs.getInt("CreateBy"));
            creator.setFullName(rs.getString("CreatorName"));
            t.setCreateBy(creator);

            list.add(t);
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}



public int getTotalTransactions(Integer type, String search, String from, String to) {
    String sql = "SELECT COUNT(*) FROM Inventory_Transaction WHERE (1=1) ";
    if (type != null && type != 0) sql += " AND TransactionType = " + type;
    if (search != null && !search.isEmpty()) sql += " AND ReferenceCode LIKE ? ";
    if (from != null && !from.isEmpty()) sql += " AND TransactionDate >= ? ";
    if (to != null && !to.isEmpty()) sql += " AND TransactionDate <= ? + ' 23:59:59' ";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        int idx = 1;
        if (search != null && !search.isEmpty()) ps.setString(idx++, "%" + search + "%");
        if (from != null && !from.isEmpty()) ps.setString(idx++, from);
        if (to != null && !to.isEmpty()) ps.setString(idx++, to);
        
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (SQLException e) { e.printStackTrace(); }
    return 0;
}
}
