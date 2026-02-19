package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Warehouse;
public class WarehouseDAO extends DBContext {

    public List<Warehouse> getAll() {
        List<Warehouse> list = new ArrayList<>();
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

