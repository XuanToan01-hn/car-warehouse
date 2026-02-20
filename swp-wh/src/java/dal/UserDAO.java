/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Location;
import model.Role;
import model.User;
import model.Warehouse;

/**
 *
 * @author Asus
 */
public class UserDAO extends DBContext {

    public User loginAuth(String email, String password) {
        String sql = "select * from Users WHERE Email = ? AND Password = ?";
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);
            ResultSet resultSet = preparedStatement.executeQuery();
//            LocationDAO locationDAO = new LocationDAO();
            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("UserId"));
                user.setFullName(resultSet.getString("FullName"));
                user.setFullName(resultSet.getString("UserName"));
                user.setUserCode(resultSet.getString("UserCode")); // Thêm dòng này
                user.setPhone(resultSet.getString("Phone"));
                user.setImage(resultSet.getString("Image"));
                user.setEmail(resultSet.getString("Email"));
                user.setPassword(resultSet.getString("Password"));
                user.setMale(resultSet.getBoolean("Male"));
                user.setDateOfBirth(resultSet.getString("DateOfBirth"));
//                Location location = locationDAO.getById(resultSet.getInt("LocationID"));
//                user.setLocation(location);
                RoleDAO roleService = new RoleDAO();
                Role role = roleService.getById(resultSet.getInt("RoleId"));
                user.setRole(role);
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> searchUsers(String keyword, int offset, int limit) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users "
                + "WHERE FullName LIKE ? OR Email LIKE ? OR Phone LIKE ? "
                + "ORDER BY UserId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String likeKeyword = "%" + keyword + "%";
            ps.setString(1, likeKeyword);
            ps.setString(2, likeKeyword);
            ps.setString(3, likeKeyword);
            ps.setInt(4, offset);
            ps.setInt(5, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("UserId"));
                user.setFullName(rs.getString("FullName"));
                user.setUsername(rs.getString("UserName"));
                user.setUserCode(rs.getString("UserCode"));
                user.setPhone(rs.getString("Phone"));
                user.setImage(rs.getString("Image"));
                user.setEmail(rs.getString("Email"));
                user.setPassword(rs.getString("Password"));
                user.setMale(rs.getBoolean("Male"));
                user.setDateOfBirth(rs.getString("DateOfBirth"));
                WarehouseDAO warehouseDAO = new WarehouseDAO();
                Warehouse warehouse = warehouseDAO.getById(rs.getInt("WarehouseID"));
                user.setWarehouse(warehouse);
                RoleDAO roleService = new RoleDAO();
                Role role = roleService.getById(rs.getInt("RoleId"));
                user.setRole(role);
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> searchUsersWithRole(String keyword, int roleId, int offset, int limit) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE RoleId = ? AND "
                + "(FullName LIKE ? OR Email LIKE ? OR Phone LIKE ?) "
                + "ORDER BY UserId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String likeKeyword = "%" + keyword + "%";
            ps.setInt(1, roleId);
            ps.setString(2, likeKeyword);
            ps.setString(3, likeKeyword);
            ps.setString(4, likeKeyword);
            ps.setInt(5, offset);
            ps.setInt(6, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("UserId"));
                user.setFullName(rs.getString("FullName"));
                user.setUsername(rs.getString("UserName"));
                user.setUserCode(rs.getString("UserCode"));
                user.setPhone(rs.getString("Phone"));
                user.setImage(rs.getString("Image"));
                user.setEmail(rs.getString("Email"));
                user.setPassword(rs.getString("Password"));
                user.setMale(rs.getBoolean("Male"));
                user.setDateOfBirth(rs.getString("DateOfBirth"));
                user.setWarehouse(new Warehouse(rs.getInt("WarehouseID")));
                RoleDAO roleService = new RoleDAO();
                Role role = roleService.getById(rs.getInt("RoleId"));
                user.setRole(role);
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<User> getUserByRole(int roleId, int offset, int limit) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE RoleId = ? "
                + "ORDER BY UserId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("UserId"));
                user.setFullName(rs.getString("FullName"));
                user.setUsername(rs.getString("UserName"));
                user.setUserCode(rs.getString("UserCode"));
                user.setPhone(rs.getString("Phone"));
                user.setImage(rs.getString("Image"));
                user.setEmail(rs.getString("Email"));
                user.setPassword(rs.getString("Password"));
                user.setMale(rs.getBoolean("Male"));
                user.setDateOfBirth(rs.getString("DateOfBirth"));
                user.setWarehouse(new Warehouse(rs.getInt("WarehouseID")));
                RoleDAO roleService = new RoleDAO();
                Role role = roleService.getById(rs.getInt("RoleId"));
                user.setRole(role);
                list.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int countUsersByRole(int roleId) {
        String sql = "SELECT COUNT(*) FROM Users WHERE RoleId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countSearchUsers(String keyword) {
        String sql = "SELECT COUNT(*) FROM Users "
                + "WHERE FullName LIKE ? OR Email LIKE ? OR Phone LIKE ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String likeKeyword = "%" + keyword + "%";
            ps.setString(1, likeKeyword);
            ps.setString(2, likeKeyword);
            ps.setString(3, likeKeyword);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("UserID"));
                u.setUserCode(rs.getString("UserCode"));
                u.setFullName(rs.getString("FullName"));
                u.setUsername(rs.getString("Username"));
                u.setPassword(rs.getString("Password"));
                u.setEmail(rs.getString("Email"));
                u.setPhone(rs.getString("Phone"));
                u.setImage(rs.getString("Image"));
                u.setMale(rs.getBoolean("Male"));
                u.setDateOfBirth(rs.getString("DateOfBirth"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User getById(int id) {
        String sql = "SELECT * FROM Users WHERE UserID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("UserID"));
                u.setFullName(rs.getString("FullName"));
                u.setUsername(rs.getString("Username"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int countSearchUsersWithRole(String keyword, int roleId) {
        String sql = "SELECT COUNT(*) FROM Users "
                + "WHERE RoleId = ? AND (FullName LIKE ? OR Email LIKE ? OR Phone LIKE ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String likeKeyword = "%" + keyword + "%";
            ps.setInt(1, roleId);
            ps.setString(2, likeKeyword);
            ps.setString(3, likeKeyword);
            ps.setString(4, likeKeyword);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void insert(User u) {
        String sql = "INSERT INTO Users(UserCode,FullName,Username,Password,Email,Phone,Male,RoleID,WarehouseID) VALUES(?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getUserCode());
            ps.setString(2, u.getFullName());
            ps.setString(3, u.getUsername());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getEmail());
            ps.setString(6, u.getPhone());
            ps.setBoolean(7, u.isMale());
            ps.setInt(8, u.getRole().getId());
            ps.setInt(9, u.getWarehouse().getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(User u) {
        String sql = "UPDATE Users SET FullName=?,Email=?,Phone=?,RoleID=?,WarehouseID=? WHERE UserID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPhone());
            ps.setInt(4, u.getRole().getId());
            ps.setInt(5, u.getWarehouse().getId());
            ps.setInt(6, u.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "DELETE FROM Users WHERE UserID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
