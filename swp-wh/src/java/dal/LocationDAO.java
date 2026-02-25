package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Location;

public class LocationDAO extends DBContext {

    public List<Location> getAll() {
        List<Location> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT * FROM Location";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setWarehouseId(rs.getInt("WarehouseID"));
                l.setLocationCode(rs.getString("LocationCode"));
                l.setLocationName(rs.getString("LocationName"));
                l.setMaxCapacity(rs.getObject("MaxCapacity") != null ? rs.getInt("MaxCapacity") : 0);
                list.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Location l) {
        String sql = "INSERT INTO Location (WarehouseID, LocationCode, LocationName, MaxCapacity) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, l.getWarehouseId());
            ps.setString(2, l.getLocationCode());
            ps.setString(3, l.getLocationName());
            if (l.getMaxCapacity() == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, l.getMaxCapacity());
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Location> getByWarehouseId(int warehouseId) {
        List<Location> list = new ArrayList<>();
        if (connection == null) return list;
        String sql = "SELECT * FROM Location WHERE WarehouseID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setWarehouseId(rs.getInt("WarehouseID"));
                l.setLocationCode(rs.getString("LocationCode"));
                l.setLocationName(rs.getString("LocationName"));
                l.setMaxCapacity(rs.getObject("MaxCapacity") != null ? rs.getInt("MaxCapacity") : 0);
                list.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Location getById(int id) {
        if (connection == null) return null;
        String sql = "SELECT * FROM Location WHERE LocationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setWarehouseId(rs.getInt("WarehouseID"));
                l.setLocationCode(rs.getString("LocationCode"));
                l.setLocationName(rs.getString("LocationName"));
                l.setMaxCapacity(rs.getObject("MaxCapacity") != null ? rs.getInt("MaxCapacity") : 0);
                return l;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void update(Location l) {
        String sql = "UPDATE Location SET WarehouseID = ?, LocationCode = ?, LocationName = ?, MaxCapacity = ? WHERE LocationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, l.getWarehouseId());
            ps.setString(2, l.getLocationCode());
            ps.setString(3, l.getLocationName());
            if (l.getMaxCapacity() == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, l.getMaxCapacity());
            }
            ps.setInt(5, l.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<model.LocationProduct> getProductsByLocation(int locationId) {
        List<model.LocationProduct> list = new ArrayList<>();
        if (connection == null) return list;
        String sql = "SELECT lp.*, p.Code, p.Name as ProductName, pd.SerialNumber " +
                     "FROM Location_Product lp " +
                     "JOIN Product p ON lp.ProductID = p.ProductID " +
                     "LEFT JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID " +
                     "WHERE lp.LocationID = ? AND lp.Quantity > 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                model.LocationProduct lp = new model.LocationProduct();
                lp.setQuantity(rs.getInt("Quantity"));
                
                model.Product p = new model.Product();
                p.setId(rs.getInt("ProductID"));
                p.setCode(rs.getString("Code"));
                p.setName(rs.getString("ProductName"));
                lp.setProduct(p);
                
                model.ProductDetail pd = new model.ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                lp.setProductDetail(pd);
                
                list.add(lp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void delete(int id) {
        if (connection == null) return;
        String sql = "DELETE FROM Location WHERE LocationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
