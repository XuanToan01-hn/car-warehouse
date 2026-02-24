package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Location;
public class LocationDAO extends DBContext {

    private void calculateAggregatedCapacities(List<Location> locations) {
        // Initialize aggregated capacities with maxCapacity for BINs
        for (Location l : locations) {
            String type = l.getLocationType() != null ? l.getLocationType().trim() : "";
            if ("BIN".equals(type)) {
                l.setAggregatedCapacity(l.getMaxCapacity() != null ? l.getMaxCapacity() : 0);
            } else {
                l.setAggregatedCapacity(0);
            }
        }

        // Aggregate BINs to RACKs
        for (Location rack : locations) {
            String type = rack.getLocationType() != null ? rack.getLocationType().trim() : "";
            if ("RACK".equals(type)) {
                int sum = 0;
                for (Location bin : locations) {
                    String binType = bin.getLocationType() != null ? bin.getLocationType().trim() : "";
                    if ("BIN".equals(binType) && bin.getParentLocationId() != null && bin.getParentLocationId().equals(rack.getId())) {
                        sum += bin.getAggregatedCapacity();
                    }
                }
                rack.setAggregatedCapacity(sum);
            }
        }

        // Aggregate RACKs to ZONEs
        for (Location zone : locations) {
            String type = zone.getLocationType() != null ? zone.getLocationType().trim() : "";
            if ("ZONE".equals(type)) {
                int sum = 0;
                for (Location rack : locations) {
                    String rackType = rack.getLocationType() != null ? rack.getLocationType().trim() : "";
                    if ("RACK".equals(rackType) && rack.getParentLocationId() != null && rack.getParentLocationId().equals(zone.getId())) {
                        sum += rack.getAggregatedCapacity();
                    }
                }
                zone.setAggregatedCapacity(sum);
            }
        }
    }

    public List<Location> getAll() {
        List<Location> list = new ArrayList<>();
        if (connection == null) {
            System.err.println("[CRITICAL] LocationDAO connection is NULL!");
            return list;
        }
        String sql = "SELECT * FROM Location";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setWarehouseId(rs.getInt("WarehouseID"));
                l.setLocationCode(rs.getString("LocationCode"));
                l.setLocationName(rs.getString("LocationName"));
                int parentId = rs.getInt("ParentLocationID");
                if (rs.wasNull()) {
                    l.setParentLocationId(null);
                } else {
                    l.setParentLocationId(parentId);
                }
                String type = rs.getString("LocationType");
                l.setLocationType(type != null ? type.trim() : null);
                int maxCap = rs.getInt("MaxCapacity");
                if (rs.wasNull()) {
                    l.setMaxCapacity(null);
                } else {
                    l.setMaxCapacity(maxCap);
                }
                list.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        calculateAggregatedCapacities(list);
        return list;
    }

    public void insert(Location l) {
        String sql = "INSERT INTO Location (WarehouseID, LocationCode, LocationName, ParentLocationID, LocationType, MaxCapacity) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, l.getWarehouseId());
            ps.setString(2, l.getLocationCode());
            ps.setString(3, l.getLocationName());

            if (l.getParentLocationId() == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, l.getParentLocationId());
            }

            ps.setString(5, l.getLocationType());

            if (l.getMaxCapacity() == null) {
                ps.setNull(6, java.sql.Types.INTEGER);
            } else {
                ps.setInt(6, l.getMaxCapacity());
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Location> getByWarehouseId(int warehouseId) {
        List<Location> list = new ArrayList<>();
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
                int parentId = rs.getInt("ParentLocationID");
                if (rs.wasNull()) {
                    l.setParentLocationId(null);
                } else {
                    l.setParentLocationId(parentId);
                }
                String type = rs.getString("LocationType");
                l.setLocationType(type != null ? type.trim() : null);
                int maxCap = rs.getInt("MaxCapacity");
                if (rs.wasNull()) {
                    l.setMaxCapacity(null);
                } else {
                    l.setMaxCapacity(maxCap);
                }
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
                int parentId = rs.getInt("ParentLocationID");
                if (rs.wasNull()) {
                    l.setParentLocationId(null);
                } else {
                    l.setParentLocationId(parentId);
                }
                String type = rs.getString("LocationType");
                l.setLocationType(type != null ? type.trim() : null);
                int maxCap = rs.getInt("MaxCapacity");
                if (rs.wasNull()) {
                    l.setMaxCapacity(null);
                } else {
                    l.setMaxCapacity(maxCap);
                }
                return l;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // For getById, we might need all locations to calculate correctly if it's a Zone/Rack
        // But for details, the servlet usually gets more context if needed.
        // However, the simplest fix is to call calculate on a single element list if it's a BIN,
        // or just accept that full hierarchy is needed for Zone/Rack.
        // To keep it simple and consistent:
        return null;
    }

    public Location getByIdWithFullContext(int id) {
        List<Location> all = getAll();
        for (Location l : all) {
            if (l.getId() == id) return l;
        }
        return null;
    }

    public void update(Location l) {
        String sql = "UPDATE Location SET WarehouseID = ?, LocationCode = ?, LocationName = ?, ParentLocationID = ?, LocationType = ?, MaxCapacity = ? WHERE LocationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, l.getWarehouseId());
            ps.setString(2, l.getLocationCode());
            ps.setString(3, l.getLocationName());
            if (l.getParentLocationId() == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, l.getParentLocationId());
            }
            ps.setString(5, l.getLocationType());
            if (l.getMaxCapacity() == null) {
                ps.setNull(6, java.sql.Types.INTEGER);
            } else {
                ps.setInt(6, l.getMaxCapacity());
            }
            ps.setInt(7, l.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<model.LocationProduct> getProductsByLocation(int locationId) {
        List<model.LocationProduct> list = new ArrayList<>();
        String sql = "SELECT lp.*, p.Code, p.Name as ProductName, pd.SerialNumber " +
                     "FROM Location_Product lp " +
                     "JOIN Product p ON lp.ProductID = p.ProductID " +
                     "LEFT JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID " +
                     "WHERE lp.LocationID = ?";
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
        String sql = "DELETE FROM Location WHERE LocationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Location> getPotentialParents(int whId, String type) {
        List<Location> list = new ArrayList<>();
        String parentType = "";
        if ("RACK".equals(type)) parentType = "ZONE";
        else if ("BIN".equals(type)) parentType = "RACK";
        
        if (parentType.isEmpty()) return list;

        if (connection == null) return list;
        String sql = "SELECT * FROM Location WHERE WarehouseID = ? AND LocationType LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, whId);
            ps.setString(2, parentType + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Location l = new Location();
                l.setId(rs.getInt("LocationID"));
                l.setLocationCode(rs.getString("LocationCode"));
                l.setLocationName(rs.getString("LocationName"));
                list.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

