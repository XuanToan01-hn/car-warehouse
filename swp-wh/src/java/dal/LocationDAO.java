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
        if (connection == null)
            return list;

        String sql = "SELECT l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity, w.WarehouseName, "
                + "COALESCE(SUM(lp.Quantity), 0) AS CurrentStock "
                + "FROM Location l "
                + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
                + "LEFT JOIN Location_Product lp ON l.LocationID = lp.LocationID "
                + "GROUP BY l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity, w.WarehouseName";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setWarehouseId(rs.getInt("WarehouseID"));
                l.setLocationCode(rs.getString("LocationCode"));
                l.setLocationName(rs.getString("LocationName"));
                l.setWarehouseName(rs.getString("WarehouseName"));
                l.setMaxCapacity(rs.getObject("MaxCapacity") != null ? rs.getInt("MaxCapacity") : 0);
                l.setCurrentStock(rs.getInt("CurrentStock"));
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
        if (connection == null)
            return list;
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
        if (connection == null)
            return null;
        String sql = "SELECT l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity, "
                + "COALESCE(SUM(lp.Quantity), 0) AS CurrentStock "
                + "FROM Location l "
                + "LEFT JOIN Location_Product lp ON l.LocationID = lp.LocationID "
                + "WHERE l.LocationID = ? "
                + "GROUP BY l.LocationID, l.WarehouseID, l.LocationCode, l.LocationName, l.MaxCapacity";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setWarehouseId(rs.getInt("WarehouseID"));
                l.setLocationCode(rs.getString("LocationCode"));
                l.setLocationName(rs.getString("LocationName"));
                l.setMaxCapacity(rs.getObject("MaxCapacity") != null ? rs.getInt("MaxCapacity") : null);
                l.setCurrentStock(rs.getInt("CurrentStock"));
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
        if (connection == null)
            return list;
        // Location_Product chỉ có (LocationID, ProductDetailID, Quantity)
        // Lấy ProductID qua Product_Detail → Product, kèm Color
        String sql = "SELECT lp.LocationID, lp.ProductDetailID, lp.Quantity, "
                + "pd.ProductID, p.Code, p.Name AS ProductName, pd.SerialNumber, pd.Color "
                + "FROM Location_Product lp "
                + "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID "
                + "JOIN Product p ON p.ProductID = pd.ProductID "
                + "WHERE lp.LocationID = ? AND lp.Quantity > 0";
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
                pd.setColor(rs.getString("Color"));
                lp.setProductDetail(pd);

                list.add(lp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Location> getLocationsByProductDetail(int pdId) {
        List<Location> list = new ArrayList<>();
        if (connection == null) {
            System.err.println("[ERROR] LocationDAO: Connection is NULL!");
            return list;
        }
        // Sử dụng LEFT JOIN với Warehouse để chắc chắn không bị loại bỏ do thiếu WarehouseID
        String sql = "SELECT l.LocationID, l.LocationName, w.WarehouseName, lp.Quantity, l.MaxCapacity " +
                     "FROM Location_Product lp " +
                     "JOIN Location l ON lp.LocationID = l.LocationID " +
                     "LEFT JOIN Warehouse w ON l.WarehouseID = w.WarehouseID " +
                     "WHERE lp.ProductDetailID = ? AND lp.Quantity > 0";
        
        System.out.println("[DEBUG] LocationDAO: Running query for pdId=" + pdId);
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pdId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setLocationName(rs.getString("LocationName"));
                String whName = rs.getString("WarehouseName");
                l.setWarehouseName(whName != null ? whName : "N/A");
                l.setCurrentStock(rs.getInt("Quantity"));
                l.setMaxCapacity(rs.getInt("MaxCapacity"));
                list.add(l);
                System.out.println("[DEBUG] LocationDAO: Found loc=" + l.getLocationName() + " (ID=" + l.getId() + ") with qty=" + l.getCurrentStock());
            }
            if (list.isEmpty()) {
                System.out.println("[DEBUG] LocationDAO: No results found for pdId=" + pdId);
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] LocationDAO error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public void delete(int id) {
        if (connection == null)
            return;
        String sql = "DELETE FROM Location WHERE LocationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<model.LocationProduct> getAllInventoryWithDetails() {
        List<model.LocationProduct> list = new ArrayList<>();
        if (connection == null)
            return list;
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
                model.LocationProduct lp = new model.LocationProduct();
                lp.setQuantity(rs.getInt("Quantity"));

                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setLocationName(rs.getString("LocationName"));
                l.setWarehouseName(rs.getString("WarehouseName"));
                lp.setLocation(l);

                model.Product p = new model.Product();
                p.setName(rs.getString("ProductName"));
                lp.setProduct(p);

                model.ProductDetail pd = new model.ProductDetail();
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
