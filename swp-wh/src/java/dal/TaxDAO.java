package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Tax;

public class TaxDAO extends DBContext {

    public List<Tax> getAll() {
        List<Tax> list = new ArrayList<>();
        String sql = "SELECT * FROM Tax ORDER BY TaxName";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Tax t = new Tax();
                t.setId(rs.getInt("TaxID"));
                t.setTaxName(rs.getString("TaxName"));
                t.setTaxRate(rs.getDouble("TaxRate"));
                t.setEffectiveFrom(rs.getDate("EffectiveFrom"));
                t.setExpiredDate(rs.getDate("ExpiredDate"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Tax getById(int id) {
        String sql = "SELECT * FROM Tax WHERE TaxID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Tax t = new Tax();
                t.setId(rs.getInt("TaxID"));
                t.setTaxName(rs.getString("TaxName"));
                t.setTaxRate(rs.getDouble("TaxRate"));
                t.setEffectiveFrom(rs.getDate("EffectiveFrom"));
                t.setExpiredDate(rs.getDate("ExpiredDate"));
                return t;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
