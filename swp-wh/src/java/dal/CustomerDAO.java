package dal;

import context.DBContext;
import model.Customer;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO extends DBContext {

    public Customer getById(int id) {
        String sql = "SELECT * FROM Customer WHERE CustomerID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Customer getByCode(String customerCode) {
        if (customerCode == null || customerCode.trim().isEmpty()) return null;
        String sql = "SELECT * FROM Customer WHERE CustomerCode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, customerCode.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Customer> getAll() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer ORDER BY CustomerID";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Customer c) {
        String sql = "INSERT INTO Customer (CustomerCode, Name, Phone, Email, Address) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, trim(c.getCustomerCode()));
            ps.setString(2, trim(c.getName()));
            ps.setString(3, trim(c.getPhone()));
            ps.setString(4, trim(c.getEmail()));
            ps.setString(5, trim(c.getAddress()));
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Customer c) {
        String sql = "UPDATE Customer SET CustomerCode = ?, Name = ?, Phone = ?, Email = ?, Address = ? WHERE CustomerID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, trim(c.getCustomerCode()));
            ps.setString(2, trim(c.getName()));
            ps.setString(3, trim(c.getPhone()));
            ps.setString(4, trim(c.getEmail()));
            ps.setString(5, trim(c.getAddress()));
            ps.setInt(6, c.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Customer WHERE CustomerID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Customer mapRow(ResultSet rs) throws SQLException {
        Customer c = new Customer();
        c.setId(rs.getInt("CustomerID"));
        c.setCustomerCode(rs.getString("CustomerCode"));
        c.setName(rs.getString("Name"));
        c.setPhone(rs.getString("Phone"));
        c.setEmail(rs.getString("Email"));
        c.setAddress(rs.getString("Address"));
        return c;
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
