package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Tax;

public class TaxDAO extends DBContext {

    private Tax mapResultSetToTax(ResultSet rs) throws SQLException {
        Tax t = new Tax();
        t.setId(rs.getInt("TaxID"));
        t.setTaxName(rs.getString("TaxName"));
        t.setTaxRate(rs.getDouble("TaxRate"));
        t.setEffectiveFrom(rs.getDate("EffectiveFrom"));
        t.setExpiredDate(rs.getDate("ExpiredDate"));
        return t;
    }

    public Tax getById(int id) {
        if (connection == null) return null;
        String sql = "SELECT * FROM Tax WHERE TaxID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTax(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Tax> getAll() {
        List<Tax> list = new ArrayList<>();
        if (connection == null) return list;
        String sql = "SELECT * FROM Tax ORDER BY TaxID";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToTax(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Tax> search(String keyword) {
        List<Tax> list = new ArrayList<>();
        if (connection == null) return list;
        String sql = "SELECT * FROM Tax WHERE TaxName LIKE ? ORDER BY TaxID";
        String pattern = "%" + keyword + "%";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTax(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Tax t) {
        if (connection == null) return;
        String sql = "INSERT INTO Tax (TaxName, TaxRate, EffectiveFrom, ExpiredDate) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, safeTrim(t.getTaxName()));
            ps.setDouble(2, t.getTaxRate());
            
            if (t.getEffectiveFrom() != null) {
                ps.setDate(3, new java.sql.Date(t.getEffectiveFrom().getTime()));
            } else {
                ps.setDate(3, null);
            }
            if (t.getExpiredDate() != null) {
                ps.setDate(4, new java.sql.Date(t.getExpiredDate().getTime()));
            } else {
                ps.setDate(4, null);
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Tax t) {
        if (connection == null) return;
        String sql = "UPDATE Tax SET TaxName = ?, TaxRate = ?, EffectiveFrom = ?, ExpiredDate = ? WHERE TaxID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, safeTrim(t.getTaxName()));
            ps.setDouble(2, t.getTaxRate());
            if (t.getEffectiveFrom() != null) {
                ps.setDate(3, new java.sql.Date(t.getEffectiveFrom().getTime()));
            } else {
                ps.setNull(3, java.sql.Types.DATE);
            }
            if (t.getExpiredDate() != null) {
                ps.setDate(4, new java.sql.Date(t.getExpiredDate().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            ps.setInt(5, t.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        if (connection == null) return;
        String sql = "DELETE FROM Tax WHERE TaxID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static String safeTrim(String s) {
        return s == null ? "" : s.trim();
    }
}

