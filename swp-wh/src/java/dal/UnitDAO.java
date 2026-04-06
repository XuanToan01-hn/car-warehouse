package dal;

import context.DBContext;
import model.Unit;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UnitDAO extends DBContext {

    public Unit getUnitById(int id) {
        String sql = "SELECT [UnitID], [Name], [Type] FROM [dbo].[Unit] WHERE [UnitID] = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Unit(rs.getInt("UnitID"),
                        rs.getString("Name"),
                        rs.getString("Type"));
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }

    public List<Unit> getAll() {
        List<Unit> list = new ArrayList<>();
        String sql = "SELECT * FROM [dbo].[Unit]";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Unit(rs.getInt("UnitID"),
                        rs.getString("Name"),
                        rs.getString("Type")));
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return list;
    }

    public List<Unit> getAll(String search, int offset, int limit) {
        List<Unit> list = new ArrayList<>();
        String sql = "SELECT * FROM Unit WHERE Name LIKE ? ORDER BY UnitID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + search + "%");
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Unit u = new Unit(
                        rs.getInt("UnitID"),
                        rs.getString("Name"),
                        rs.getString("Type")
                );
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Thêm phương thức đếm tổng số Unit khớp với từ khóa search
    public int count(String search) {
        String sql = "SELECT COUNT(*) FROM Unit WHERE Name LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + search + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Unit WHERE UnitID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void insertUnit(Unit unit) {
        String sql = "INSERT INTO Unit (Name, Type) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, unit.getName());
            ps.setString(2, unit.getType());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateUnit(Unit unit) {
        String sql = "UPDATE Unit SET Name = ?, Type = ? WHERE UnitID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, unit.getName());
            ps.setString(2, unit.getType());
            ps.setInt(3, unit.getId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

}
