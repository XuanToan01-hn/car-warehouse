package dal;

import context.DBContext;
import model.Customer;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO extends DBContext {

    // Lấy ID khách hàng lớn nhất hiện có để phục vụ việc sinh mã khách hàng tự động (CUS-xxxx).
    public String getNextCustomerCode() {
        String sql = "SELECT MAX(CustomerID) FROM Customer";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int nextId = rs.getInt(1) + 1;
                //thiếu thì thêm số 0 phía trước
                return String.format("CUS-%04d", nextId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "CUS-0001";
    }

    // Lấy thông tin chi tiết một khách hàng dựa trên CustomerID (ID tự tăng).
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

    // Lấy thông tin khách hàng dựa trên mã định danh (CustomerCode).
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

    // Lấy toàn bộ danh sách khách hàng từ Database.
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

    // Tìm kiếm khách hàng theo nhiều tiêu chí: Mã, Tên hoặc Số điện thoại.
    public List<Customer> search(String keyword) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer WHERE CustomerCode LIKE ? OR Name LIKE ? OR Phone LIKE ? ORDER BY CustomerID";
        String pattern = "%" + keyword + "%";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm một khách hàng mới vào Database.
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

    // Cập nhật thông tin của một khách hàng hiện có.
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

    public boolean delete(int id) {
        String sql = "DELETE FROM Customer WHERE CustomerID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
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

    // Kiểm tra xem Email đã tồn tại hay chưa (tránh trùng lặp khi Add/Edit).
    public boolean isEmailExists(String email, int excludeId) {
        if (email == null || email.trim().isEmpty()) return false;
        String sql = "SELECT COUNT(*) FROM Customer WHERE Email = ? AND CustomerID != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    //số lượng dòng (count) mà >0
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Kiểm tra xem Số điện thoại đã tồn tại hay chưa (tránh trùng lặp khi Add/Edit).
    public boolean isPhoneExists(String phone, int excludeId) {
        if (phone == null || phone.trim().isEmpty()) return false;
        String sql = "SELECT COUNT(*) FROM Customer WHERE Phone = ? AND CustomerID != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone.trim());
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    //số lượng dòng (count) mà >0
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
