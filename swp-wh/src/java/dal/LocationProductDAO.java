/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import context.DBContext;
import model.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Asus
 */
public class LocationProductDAO extends DBContext {
    private final LocationDAO locationDAO = new LocationDAO();
    private final ProductDetailDAO productDetailDAO = new ProductDetailDAO();

    public List<LocationProduct> getAll() {
        List<LocationProduct> list = new ArrayList<>();
        String sql = "SELECT * FROM Location_Product";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public int getStockAtLocation(int locId, int pdId) {
    String sql = "SELECT Quantity FROM Location_Product WHERE LocationID = ? AND ProductDetailID = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, locId);
        ps.setInt(2, pdId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (SQLException e) { e.printStackTrace(); }
    return 0;
}

    public int getStockQuantity(int productDetailId) {
        String sql = "SELECT SUM(Quantity) FROM Location_Product WHERE ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productDetailId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public LocationProduct getByCompositeId(int locationId, int productDetailId) {
        String sql = "SELECT * FROM Location_Product WHERE LocationID = ? AND ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            ps.setInt(2, productDetailId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void save(LocationProduct lp) {
        // Logic: Nếu tồn tại thì update quantity, chưa có thì insert
        LocationProduct existing = getByCompositeId(lp.getLocation().getId(), lp.getProductDetail().getId());
        if (existing != null) {
            updateQuantity(lp.getLocation().getId(), lp.getProductDetail().getId(), lp.getQuantity());
        } else {
            insert(lp);
        }
    }

    private void insert(LocationProduct lp) {
        String sql = "INSERT INTO Location_Product (LocationID, ProductDetailID, ProductID, Quantity) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, lp.getLocation().getId());
            ps.setInt(2, lp.getProductDetail().getId());
            ps.setInt(3, lp.getProductDetail().getProduct().getId());
            ps.setInt(4, lp.getQuantity());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateQuantity(int locId, int pdId, int newQty) {
        String sql = "UPDATE Location_Product SET Quantity = ? WHERE LocationID = ? AND ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, newQty);
            ps.setInt(2, locId);
            ps.setInt(3, pdId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int locId, int pdId) {
        String sql = "DELETE FROM Location_Product WHERE LocationID = ? AND ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locId);
            ps.setInt(2, pdId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private LocationProduct mapRow(ResultSet rs) throws SQLException {
        LocationProduct lp = new LocationProduct();
        lp.setQuantity(rs.getInt("Quantity"));
        lp.setLocation(locationDAO.getById(rs.getInt("LocationID")));
        lp.setProductDetail(productDetailDAO.getById(rs.getInt("ProductDetailID")));
        // Product lấy từ ProductDetail cho đồng bộ
        lp.setProduct(lp.getProductDetail().getProduct());
        return lp;
    }
    
    public List<LocationProduct> getByLocationId(int locId) {
    List<LocationProduct> list = new ArrayList<>();
    String sql = "SELECT * FROM Location_Product WHERE LocationID = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, locId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapRow(rs)); // mapRow đã có ProductDetail & Product của bạn
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}


}
