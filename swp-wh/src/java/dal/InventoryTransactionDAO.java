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


    // 1. Lưu log giao dịch (Dùng trong GoodsIssueDAO)
    public void insert(InventoryTransaction trans) {
        String sql = "INSERT INTO Inventory_Transaction (ProductID, ProductDetailID, LocationID, " +
                     "TransactionType, Quantity, ReferenceCode, TransactionDate) " +
                     "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, trans.getProduct().getId());
            ps.setInt(2, trans.getProductDetail().getId());
            ps.setInt(3, trans.getLocation().getId());
            ps.setString(4, trans.getTransactionType()); // 'ISSUE', 'RECEIPT', 'TRANSFER'
            ps.setInt(5, trans.getQuantity());
            ps.setString(6, trans.getReferenceCode());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 2. Lấy danh sách kèm Filter và Phân trang
    public List<InventoryTransaction> getFiltered(String type, String search, int page, int pageSize) {
        List<InventoryTransaction> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        // Query kết hợp join để lấy tên sản phẩm và tên kho
        String sql = "SELECT it.*, p.Name as ProductName, pd.Color, l.LocationName " +
                     "FROM Inventory_Transaction it " +
                     "JOIN Product p ON it.ProductID = p.ProductID " +
                     "JOIN Product_Detail pd ON it.ProductDetailID = pd.ProductDetailID " +
                     "JOIN Location l ON it.LocationID = l.LocationID " +
                     "WHERE (it.TransactionType LIKE ?) " +
                     "AND (p.Name LIKE ? OR it.ReferenceCode LIKE ?) " +
                     "ORDER BY it.TransactionDate DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, (type == null || type.isEmpty()) ? "%%" : type);
            ps.setString(2, "%" + (search == null ? "" : search) + "%");
            ps.setString(3, "%" + (search == null ? "" : search) + "%");
            ps.setInt(4, offset);
            ps.setInt(5, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryTransaction it = new InventoryTransaction();
                it.setId(rs.getInt("TransactionID"));
                it.setTransactionType(rs.getString("TransactionType"));
                it.setQuantity(rs.getInt("Quantity"));
                it.setReferenceCode(rs.getString("ReferenceCode"));
                it.setTransactionDate(rs.getTimestamp("TransactionDate"));

                // Mapping Object liên quan
                Product p = new Product();
                p.setName(rs.getString("ProductName"));
                it.setProduct(p);

                ProductDetail pd = new ProductDetail();
                pd.setColor(rs.getString("Color"));
                it.setProductDetail(pd);

                Location loc = new Location();
                loc.setLocationName(rs.getString("LocationName"));
                it.setLocation(loc);

                list.add(it);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Đếm tổng số bản ghi để phân trang
    public int getTotalCount(String type, String search) {
        String sql = "SELECT COUNT(*) FROM Inventory_Transaction it " +
                     "JOIN Product p ON it.ProductID = p.ProductID " +
                     "WHERE (it.TransactionType LIKE ?) " +
                     "AND (p.Name LIKE ? OR it.ReferenceCode LIKE ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, (type == null || type.isEmpty()) ? "%%" : type);
            ps.setString(2, "%" + (search == null ? "" : search) + "%");
            ps.setString(3, "%" + (search == null ? "" : search) + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
