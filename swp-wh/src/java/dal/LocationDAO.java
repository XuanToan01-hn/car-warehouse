package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Location;

/**
 * DAO đơn giản cho bảng Location.
 * Chỉ dùng JDBC thuần, dễ hiểu.
 */
public class LocationDAO extends DBContext {

    /**
     * Lấy tất cả location trong hệ thống.
     */
    public List<Location> getAll() {
        List<Location> list = new ArrayList<>();
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
                l.setLocationType(rs.getString("LocationType"));
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

    /**
     * Thêm mới một location.
     */
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

    /**
     * Lấy danh sách location theo warehouse.
     */
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
                l.setLocationType(rs.getString("LocationType"));
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

    /**
     * Xóa location theo ID.
     */
    public void delete(int id) {
        String sql = "DELETE FROM Location WHERE LocationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

