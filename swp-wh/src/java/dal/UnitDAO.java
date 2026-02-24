package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Unit;

public class UnitDAO extends DBContext {

    public List<Unit> getAll() {
        List<Unit> list = new ArrayList<>();
        String sql = "SELECT * FROM Unit ORDER BY Name";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Unit u = new Unit();
                u.setId(rs.getInt("UnitID"));
                u.setName(rs.getString("Name"));
                u.setType(rs.getString("Type"));
                list.add(u);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Unit getById(int id) {
        String sql = "SELECT * FROM Unit WHERE UnitID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Unit u = new Unit();
                u.setId(rs.getInt("UnitID"));
                u.setName(rs.getString("Name"));
                u.setType(rs.getString("Type"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
