package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Supplier;

public class SupplierDAO extends DBContext {

    // ===============================
    // GET ALL
    // ===============================
    public List<Supplier> getAll() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT SupplierID, Name, Address, Phone, Email FROM Supplier ORDER BY Name";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("SupplierID"));
                s.setName(rs.getString("Name"));
                s.setAddress(rs.getString("Address"));
                s.setPhone(rs.getString("Phone"));
                s.setEmail(rs.getString("Email"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // GET BY ID
    // ===============================
    public Supplier getById(int id) {
        String sql = "SELECT SupplierID, Name, Address, Phone, Email FROM Supplier WHERE SupplierID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("SupplierID"));
                s.setName(rs.getString("Name"));
                s.setAddress(rs.getString("Address"));
                s.setPhone(rs.getString("Phone"));
                s.setEmail(rs.getString("Email"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===============================
    // INSERT — trả về SupplierID mới
    // ===============================
    public int insert(Supplier s) {
        String sql = "INSERT INTO Supplier (Name, Address, Phone, Email) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, s.getName());
            ps.setString(2, s.getAddress());
            ps.setString(3, s.getPhone());
            ps.setString(4, s.getEmail());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // Trả về ID tự tăng
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ===============================
    // UPDATE
    // ===============================
    public void update(Supplier s) {
        String sql = "UPDATE Supplier SET Name = ?, Address = ?, Phone = ?, Email = ? WHERE SupplierID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, s.getName());
            ps.setString(2, s.getAddress());
            ps.setString(3, s.getPhone());
            ps.setString(4, s.getEmail());
            ps.setInt(5, s.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // SEARCH by name (for autocomplete)
    // ===============================
    public List<Supplier> searchByName(String keyword) {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT TOP 20 SupplierID, Name, Phone, Email FROM Supplier WHERE Name LIKE ? ORDER BY Name";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("SupplierID"));
                s.setName(rs.getString("Name"));
                s.setPhone(rs.getString("Phone"));
                s.setEmail(rs.getString("Email"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // COUNT
    // ===============================
    public int count(String keyword) {
        String sql = "SELECT COUNT(*) FROM Supplier WHERE Name LIKE ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ===============================
    // SEARCH + PAGINATE
    // ===============================
    public List<Supplier> searchAndPaginate(String keyword, int offset, int limit) {
        List<Supplier> list = new ArrayList<>();
       String sql = "SELECT SupplierID, Name, Address, Phone, Email FROM Supplier WHERE Name LIKE ? ORDER BY SupplierID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("SupplierID"));
                s.setName(rs.getString("Name"));
                s.setAddress(rs.getString("Address"));
                s.setPhone(rs.getString("Phone"));
                s.setEmail(rs.getString("Email"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public static void main(String[] args) {
        SupplierDAO dao = new SupplierDAO();
        
        System.out.println("=== 1. TEST INSERT ===");
        Supplier newSupplier = new Supplier();
        newSupplier.setName("Nhà cung cấp Test 1");
        newSupplier.setAddress("123 Đường Test, Hà Nội");
        newSupplier.setPhone("0123456789");
        newSupplier.setEmail("test1@example.com");
        
        int insertedId = dao.insert(newSupplier);
        if (insertedId > 0) {
            System.out.println("=> Thêm thành công! ID mới tạo là: " + insertedId);
        } else {
            System.out.println("=> Thêm thất bại!");
        }

        System.out.println("\n=== 2. TEST GET BY ID ===");
        Supplier s = dao.getById(insertedId);
        if (s != null) {
            System.out.println("=> Lấy được: " + s.getName() + " - " + s.getEmail());
        }

        System.out.println("\n=== 3. TEST UPDATE ===");
        if (s != null) {
            s.setName("Nhà cung cấp Test 1 (Đã Update)");
            s.setEmail("updated_test@example.com");
            dao.update(s);
            Supplier updatedSupplier = dao.getById(insertedId);
            System.out.println("=> Sau update: " + updatedSupplier.getName() + " - " + updatedSupplier.getEmail());
        }

        System.out.println("\n=== 4. TEST COUNT & SEARCH BY NAME ===");
        String keyword = "Test";
        int count = dao.count(keyword);
        System.out.println("=> Có " + count + " nhà cung cấp chứa từ khoá '" + keyword + "'");
        
        List<Supplier> searchList = dao.searchByName(keyword);
        for (Supplier sub : searchList) {
            System.out.println("  - " + sub.getName());
        }

        System.out.println("\n=== 5. TEST GET ALL ===");
        List<Supplier> allSuppliers = dao.getAll();
        System.out.println("=> Tổng số nhà cung cấp trong DB: " + allSuppliers.size());
        
        System.out.println("\n=== 6. TEST SEARCH & PAGINATE ===");
        List<Supplier> pagedList = dao.searchAndPaginate("", 0, 5); // Lấy 5 dòng đầu tiên
        System.out.println("=> 5 nhà cung cấp đầu tiên (Offset 0, Limit 5):");
        for (Supplier sub : pagedList) {
            System.out.println("  - ID: " + sub.getId() + " | Tên: " + sub.getName());
        }
    }
}