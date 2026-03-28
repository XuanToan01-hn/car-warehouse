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
    
public static void main(String[] args) {
    UserDAO dao = new UserDAO();

    // Tạo user mới
    User u = new User();
    u.setUserCode("U001");
    u.setFullName("Nguyen Van A");
    u.setUsername("nguyenvana");
    u.setPassword("123456");
    u.setEmail("vana@gmail.com");
    u.setPhone("0123456789");
    u.setMale(1);
    u.setDateOfBirth("2000-01-01");

    // Set Role
    Role role = new Role();
    role.setId(1); // nhớ là role này phải tồn tại trong DB
    u.setRole(role);

    // Set Warehouse (có thể null nếu không bắt buộc)
    Warehouse wh = new Warehouse();
    wh.setId(1); // phải tồn tại trong DB
    u.setWarehouse(wh);

    // Gọi insert
    boolean result = dao.insert(u);

    if (result) {
        System.out.println("Insert thành công!");
    } else {
        System.out.println("Insert thất bại!");
    }
}
    public User loginAuth(String email, String password) {
String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ?";
try {
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("UserId"));
                user.setFullName(resultSet.getString("FullName"));
                user.setUsername(resultSet.getString("UserName"));
                user.setUserCode(resultSet.getString("UserCode"));
                user.setPhone(resultSet.getString("Phone"));
                user.setImage(resultSet.getString("Image"));
                user.setEmail(resultSet.getString("Email"));
                user.setPassword(resultSet.getString("Password"));
                user.setMale(resultSet.getInt("Male"));
                user.setDateOfBirth(resultSet.getString("DateOfBirth"));
                user.setIsActive(resultSet.getBoolean("IsActive"));
                WarehouseDAO warehouseDAO = new WarehouseDAO();
                Warehouse warehouse = warehouseDAO.getById(resultSet.getInt("WarehouseID"));
                user.setWarehouse(warehouse);
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

    public boolean isUserCodeExist(String userCode) {
        String sql = "SELECT 1 FROM Users WHERE UserCode = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, userCode);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isPhoneExist(String phone) {
        String sql = "SELECT 1 FROM Users WHERE Phone = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, phone);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePasswordByAmdin(int userId, String password) {
        String sql = "UPDATE Users SET Password = ? WHERE UserId = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, password);
            st.setInt(2, userId);
            int rowsAffected = st.executeUpdate(); // trả về số dòng bị ảnh hưởng
            return rowsAffected > 0; // true nếu update thành công
        } catch (SQLException e) {
            System.out.println(e);
            return false; // có lỗi xảy ra
        }
    }

    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM Users WHERE Email = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
                user.setMale(rs.getInt("Male"));
                user.setDateOfBirth(rs.getString("DateOfBirth"));
                                user.setIsActive(rs.getBoolean("IsActive"));

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
    
    public boolean isUsernameExist(String username) {
    String sql = "SELECT 1 FROM Users WHERE Username = ?";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setString(1, username);
        ResultSet rs = st.executeQuery();
        return rs.next();
    } catch (Exception e) {
        return false;
    }
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
                user.setMale(rs.getInt("Male"));
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
                user.setMale(rs.getInt("Male"));
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
    
        public int getTotalUserCount() {
        String sql = "SELECT COUNT(*) FROM Users";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<User> getAll() {
    List<User> list = new ArrayList<>();
    String sql = "SELECT * FROM Users";
    try (PreparedStatement ps = connection.prepareStatement(sql); 
         ResultSet rs = ps.executeQuery()) {

        RoleDAO roleDAO = new RoleDAO(); // Khởi tạo DAO để lấy Role

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
            u.setMale(rs.getInt("Male"));
            u.setDateOfBirth(rs.getString("DateOfBirth"));
            
            // QUAN TRỌNG: Phải set Role nếu không v.getRole() sẽ bị null
            int roleId = rs.getInt("RoleID");
            u.setRole(roleDAO.getById(roleId)); 

            list.add(u);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

//    public User getById(int id) {
//        String sql = "SELECT * FROM Users WHERE UserID=?";
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                User u = new User();
//                u.setId(rs.getInt("UserID"));
//                u.setFullName(rs.getString("FullName"));
//                u.setUsername(rs.getString("Username"));
//                return u;
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }

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

    public List<User> getUserByPage(int page, int pageSize) {
        String sql = "SELECT\n"
                + "* FROM Users\n"
                + "ORDER  BY UserID\n"
                + "OFFSET ? ROWS FETCH NEXT ? \n"
                + "ROWS ONLY";
        List<User> listU = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, (page - 1) * pageSize);
            st.setInt(2, pageSize);
            RoleDAO roleService = new RoleDAO();
            ResultSet rs = st.executeQuery();
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
                user.setMale(rs.getInt("Male"));
                user.setDateOfBirth(rs.getString("DateOfBirth"));
                user.setIsActive(rs.getBoolean("IsActive"));
                user.setWarehouse(new Warehouse(rs.getInt("WarehouseID")));
                Role role = roleService.getById(rs.getInt("RoleId"));
                user.setRole(role);
                listU.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listU;
    }
    
    public User getById(int id) {
    String sql = "SELECT * FROM Users WHERE UserID=?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            User u = new User();
            u.setId(rs.getInt("UserID"));
            u.setUserCode(rs.getString("UserCode")); // Quan trọng để so sánh trùng lặp
            u.setFullName(rs.getString("FullName"));
            u.setUsername(rs.getString("Username"));
            u.setEmail(rs.getString("Email"));      // Quan trọng
            u.setPhone(rs.getString("Phone"));      // Quan trọng
            u.setMale(rs.getInt("Male"));
            u.setDateOfBirth(rs.getString("DateOfBirth"));
            
            // Khởi tạo Role và Warehouse cơ bản để tránh NullPointerException
            u.setRole(new Role(rs.getInt("RoleID")));
            u.setWarehouse(new Warehouse(rs.getInt("WarehouseID")));
            return u;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
    
public boolean insert(User u) {
    // Đã bỏ IsActive và dấu ? cuối cùng
    String sql = "INSERT INTO Users(UserCode, FullName, Username, Password, Email, Phone, Male, DateOfBirth, RoleID, WarehouseID) "
               + "VALUES(?,?,?,?,?,?,?,?,?,?)";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, u.getUserCode());
        ps.setString(2, u.getFullName());
        ps.setString(3, u.getUsername());
        ps.setString(4, u.getPassword());
        ps.setString(5, u.getEmail());
        ps.setString(6, u.getPhone());
        ps.setInt(7, u.getMale());
        ps.setString(8, u.getDateOfBirth());
        ps.setInt(9, u.getRole().getId());

        if (u.getWarehouse() != null && u.getWarehouse().getId() > 0) {
            ps.setInt(10, u.getWarehouse().getId());
        } else {
            ps.setNull(10, java.sql.Types.INTEGER);
        }

        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        // In lỗi ra để debug nếu vẫn thất bại
        System.err.println("Lỗi Insert: " + e.getMessage());
        return false;
    }
}

public boolean update(User u) {
    // 1. Câu lệnh SQL đầy đủ các trường bạn đã set trong Servlet
    String sql = "UPDATE Users SET UserCode=?, FullName=?, Username=?, Male=?, "
               + "DateOfBirth=?, Email=?, Phone=?, RoleID=?, WarehouseID=? "
               + "WHERE UserID=?";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, u.getUserCode());
        ps.setString(2, u.getFullName());
        ps.setString(3, u.getUsername());
        ps.setInt(4, u.getMale());
        ps.setString(5, u.getDateOfBirth());
        ps.setString(6, u.getEmail());
        ps.setString(7, u.getPhone());
        ps.setInt(8, u.getRole().getId());
        if (u.getWarehouse() != null && u.getWarehouse().getId() > 0) {
            ps.setInt(9, u.getWarehouse().getId());
        } else {
            ps.setNull(9, java.sql.Types.INTEGER);
        }
        ps.setInt(10, u.getId());

        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
    } catch (Exception e) {
        System.err.println("LỖI UPDATE THỰC TẾ: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

    public boolean delete(int id) {
        String sql = "DELETE FROM Users WHERE UserID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            return  true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean changeStatus(int id, int status) {
    String sql = "UPDATE Users SET IsActive = ? WHERE UserID = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, status);
        ps.setInt(2, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
    
}
