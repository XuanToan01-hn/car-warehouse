package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Warehouse;
public class WarehouseDAO extends DBContext {

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

    public void delete(int id) {
        String sql = "DELETE FROM Warehouse WHERE WarehouseID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

