package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Warehouse;
public class WarehouseDAO extends DBContext {

    // Lấy ID kho hàng lớn nhất hiện có để phục vụ việc sinh mã kho hàng tự động (WH-CAR-xxxx).
    public String getNextWarehouseCode() {
        String sql = "SELECT MAX(WarehouseID) FROM Warehouse";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int nextId = rs.getInt(1) + 1;
                return String.format("WH-CAR-%04d", nextId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "WH-CAR-0001";
    }
    
    // Lấy thông tin chi tiết một kho dựa trên WarehouseID.
    public Warehouse getById(int id) {
        String sql = "SELECT * FROM Warehouse WHERE WarehouseID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Warehouse w = new Warehouse();
                w.setId(rs.getInt("WarehouseID"));
                w.setWarehouseCode(rs.getString("WarehouseCode"));
                w.setWarehouseName(rs.getString("WarehouseName"));
                w.setAddress(rs.getString("Address"));
                w.setDescription(rs.getString("Description"));
                w.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return w;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Warehouse> getAll() {
        List<Warehouse> list = new ArrayList<>();
        if (connection == null) {
            System.err.println("[CRITICAL] WarehouseDAO connection is NULL!");
            return list;
        }
        // SQL lấy toàn bộ danh sách kho hàng.
        String sql = "SELECT * FROM Warehouse";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setId(rs.getInt("WarehouseID"));
                w.setWarehouseCode(rs.getString("WarehouseCode"));
                w.setWarehouseName(rs.getString("WarehouseName"));
                w.setAddress(rs.getString("Address"));
                w.setDescription(rs.getString("Description"));
                w.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tìm kiếm kho theo mã kho, tên kho hoặc địa chỉ.
    public List<Warehouse> search(String keyword) {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT * FROM Warehouse WHERE WarehouseCode LIKE ? OR WarehouseName LIKE ? OR Address LIKE ?";
        String pattern = "%" + keyword + "%";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setId(rs.getInt("WarehouseID"));
                w.setWarehouseCode(rs.getString("WarehouseCode"));
                w.setWarehouseName(rs.getString("WarehouseName"));
                w.setAddress(rs.getString("Address"));
                w.setDescription(rs.getString("Description"));
                w.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Warehouse w) {
        // SQL thêm mới thông tin một kho hàng.
        String sql = "INSERT INTO Warehouse (WarehouseCode, WarehouseName, Address, Description) "
                   + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, w.getWarehouseCode());
            ps.setString(2, w.getWarehouseName());
            ps.setString(3, w.getAddress());
            ps.setString(4, w.getDescription());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Warehouse w) {
        // SQL cập nhật thông tin cho một kho hàng đang tồn tại.
        String sql = "UPDATE Warehouse SET WarehouseCode = ?, WarehouseName = ?, Address = ?, Description = ? "
                   + "WHERE WarehouseID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, w.getWarehouseCode());
            ps.setString(2, w.getWarehouseName());
            ps.setString(3, w.getAddress());
            ps.setString(4, w.getDescription());
            ps.setInt(5, w.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Warehouse WHERE WarehouseID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra tên kho đã tồn tại hay chưa (phục vụ validation khi thêm/sửa).
    public boolean existsByName(String name) {
        String sql = "SELECT COUNT(*) FROM Warehouse WHERE WarehouseName = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean existsByName(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Warehouse WHERE WarehouseName = ? AND WarehouseID != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

