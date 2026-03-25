package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Location;
import model.LocationProduct;
import model.Product;
import model.ProductDetail;

public class LocationDAO extends DBContext {

    private Location mapResultSetToLocation(ResultSet rs) throws SQLException {
        Location l = new Location();
        l.setId(rs.getInt("LocationID"));
        l.setWarehouseId(rs.getInt("WarehouseID"));
        l.setLocationCode(rs.getString("LocationCode"));
        l.setLocationName(rs.getString("LocationName"));
        try {
            l.setWarehouseName(rs.getString("WarehouseName"));
        } catch (SQLException ignored) {}
        
        try {
            l.setMaxCapacity(rs.getObject("MaxCapacity") != null ? rs.getInt("MaxCapacity") : 0);
        } catch (SQLException ignored) {}
        
        try {
            l.setCurrentStock(rs.getInt("CurrentStock"));
        } catch (SQLException ignored) {}
        
        return l;
    }

    public List<Location> getAll() {
        List<Location> list = new ArrayList<>();
        if (connection == null) return list;

        String sql = "SELECT l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity, w.WarehouseName, "
                + "COALESCE(SUM(lp.Quantity), 0) AS CurrentStock "
                + "FROM Location l "
                + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
                + "LEFT JOIN Location_Product lp ON l.LocationID = lp.LocationID "
                + "GROUP BY l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity, w.WarehouseName";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToLocation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Location> search(int warehouseId, String keyword) {
        List<Location> list = new ArrayList<>();
        if (connection == null) return list;

        String pattern = "%" + (keyword == null ? "" : keyword) + "%";
        boolean filterWh = warehouseId > 0;

        String sql = "SELECT l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity, w.WarehouseName, "
                + "COALESCE(SUM(lp.Quantity), 0) AS CurrentStock "
                + "FROM Location l "
                + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
                + "LEFT JOIN Location_Product lp ON l.LocationID = lp.LocationID "
                + (filterWh ? "WHERE l.WarehouseID = ? AND (l.LocationCode LIKE ? OR l.LocationName LIKE ?) "
                            : "WHERE (l.LocationCode LIKE ? OR l.LocationName LIKE ?) ")
                + "GROUP BY l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity, w.WarehouseName";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (filterWh) {
                ps.setInt(1, warehouseId);
                ps.setString(2, pattern);
                ps.setString(3, pattern);
            } else {
                ps.setString(1, pattern);
                ps.setString(2, pattern);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToLocation(rs));
                }
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
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Location l = new Location();
                    l.setId(rs.getInt("LocationID"));
                    l.setWarehouseId(rs.getInt("WarehouseID"));
                    l.setLocationCode(rs.getString("LocationCode"));
                    l.setLocationName(rs.getString("LocationName"));
                    l.setMaxCapacity(rs.getObject("MaxCapacity") != null ? rs.getInt("MaxCapacity") : 0);
                    list.add(l);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Location getById(int id) {
        if (connection == null) return null;
        
        String sql = "SELECT l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity, "
                + "COALESCE(SUM(lp.Quantity), 0) AS CurrentStock "
                + "FROM Location l "
                + "LEFT JOIN Location_Product lp ON l.LocationID = lp.LocationID "
                + "WHERE l.LocationID = ? "
                + "GROUP BY l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToLocation(rs);
                }
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

    public List<LocationProduct> getProductsByLocation(int locationId) {
        List<LocationProduct> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT lp.LocationID, lp.ProductDetailID, lp.Quantity, "
                + "pd.ProductID, p.Code, p.Name AS ProductName, pd.SerialNumber, pd.Color "
                + "FROM Location_Product lp "
                + "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID "
                + "JOIN Product p ON p.ProductID = pd.ProductID "
                + "WHERE lp.LocationID = ? AND lp.Quantity > 0";
                
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, locationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LocationProduct lp = new LocationProduct();
                    lp.setQuantity(rs.getInt("Quantity"));

                    Product p = new Product();
                    p.setId(rs.getInt("ProductID"));
                    p.setCode(rs.getString("Code"));
                    p.setName(rs.getString("ProductName"));
                    lp.setProduct(p);

                    ProductDetail pd = new ProductDetail();
                    pd.setId(rs.getInt("ProductDetailID"));
                    pd.setSerialNumber(rs.getString("SerialNumber"));
                    pd.setColor(rs.getString("Color"));
                    lp.setProductDetail(pd);

                    list.add(lp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Location> getLocationsByProductDetail(int pdId) {
        List<Location> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT l.LocationID, l.LocationName, w.WarehouseName, lp.Quantity, l.MaxCapacity " +
                     "FROM Location_Product lp " +
                     "JOIN Location l ON lp.LocationID = l.LocationID " +
                     "LEFT JOIN Warehouse w ON l.WarehouseID = w.WarehouseID " +
                     "WHERE lp.ProductDetailID = ? AND lp.Quantity > 0";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pdId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Location l = new Location();
                    l.setId(rs.getInt("LocationID"));
                    l.setLocationName(rs.getString("LocationName"));
                    String whName = rs.getString("WarehouseName");
                    l.setWarehouseName(whName != null ? whName : "N/A");
                    l.setCurrentStock(rs.getInt("Quantity"));
                    l.setMaxCapacity(rs.getInt("MaxCapacity"));
                    list.add(l);
                }
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

    public List<LocationProduct> getAllInventoryWithDetails() {
        List<LocationProduct> list = new ArrayList<>();
        if (connection == null) return list;
        
        String sql = "SELECT lp.LocationID, lp.ProductDetailID, lp.Quantity, " +
                "l.LocationName, w.WarehouseName, " +
                "pd.ProductID, p.Name as ProductName, pd.SerialNumber, pd.Color " +
                "FROM Location_Product lp " +
                "JOIN Location l ON lp.LocationID = l.LocationID " +
                "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID " +
                "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID " +
                "JOIN Product p ON pd.ProductID = p.ProductID " +
                "WHERE lp.Quantity > 0 " +
                "ORDER BY p.Name, pd.SerialNumber";
                
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                LocationProduct lp = new LocationProduct();
                lp.setQuantity(rs.getInt("Quantity"));

                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setLocationName(rs.getString("LocationName"));
                l.setWarehouseName(rs.getString("WarehouseName"));
                lp.setLocation(l);

                Product p = new Product();
                p.setName(rs.getString("ProductName"));
                lp.setProduct(p);

                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                pd.setColor(rs.getString("Color"));
                lp.setProductDetail(pd);

                list.add(lp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
