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
//                int pid = rs.getInt("ProductID");
//                if (!rs.wasNull()) {
//                    s.setProductId(pid);
//                }
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    public int insert(Supplier s) {
        // Đã xóa ProductID khỏi câu lệnh INSERT
        String sql = "INSERT INTO Supplier (Name, Address, Phone, Email) VALUES (?, ?, ?, ?)";
        try {
            // Lưu ý: với SQL Server, để lấy ID vừa tạo, bạn cần truyền mảng tên cột khóa chính hoặc Statement.RETURN_GENERATED_KEYS
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, s.getName());
            ps.setString(2, s.getAddress());
            ps.setString(3, s.getPhone());
            ps.setString(4, s.getEmail());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                // Với SQL Server (tuỳ driver), getInt(1) có thể lỗi nếu dùng RETURN_GENERATED_KEYS chung chung.
                // Thường RS sẽ trả về cột ID.
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }


    public void updateProductId(int supplierId, int productId) {
        String sql = "UPDATE Supplier SET ProductID = ? WHERE SupplierID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.setInt(2, supplierId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    public List<Supplier> searchByName(String keyword) {
        List<Supplier> list = new ArrayList<>();
        // MSSQL dùng SELECT TOP n thay vì LIMIT n ở cuối
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

    public List<Supplier> searchAndPaginate(String keyword, int offset, int limit) {
        List<Supplier> list = new ArrayList<>();
        // Cú pháp phân trang chuẩn của SQL Server 2012 trở lên
        String sql = "SELECT SupplierID, Name, Address, Phone, Email FROM Supplier "
                + "WHERE Name LIKE ? "
                + "ORDER BY SupplierID " // Bắt buộc phải có ORDER BY khi dùng OFFSET
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, offset); // Vị trí bắt đầu
            ps.setInt(3, limit);  // Số lượng lấy
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
        newSupplier.setName("Công ty TNHH Vật Tư Test");
        newSupplier.setAddress("123 Đường ABC, Hà Nội");
        newSupplier.setPhone("0987654321");
        newSupplier.setEmail("contact@testvattu.com");

        int generatedId = dao.insert(newSupplier);
        if (generatedId != -1) {
            System.out.println("✅ Đã thêm Supplier mới thành công với ID: " + generatedId);
        } else {
            System.out.println("❌ Thêm Supplier thất bại!");
        }

        System.out.println("\n=== 2. TEST GET ALL ===");
        List<Supplier> allSuppliers = dao.getAll();
        System.out.println("Tổng số nhà cung cấp hiện có: " + allSuppliers.size());
        for (Supplier s : allSuppliers) {
            System.out.println("ID: " + s.getId() + " | Name: " + s.getName() + " | Phone: " + s.getPhone());
        }

        if (generatedId != -1) {
            System.out.println("\n=== 3. TEST GET BY ID ===");
            Supplier foundSupplier = dao.getById(generatedId);
            if (foundSupplier != null) {
                System.out.println("✅ Tìm thấy Supplier: " + foundSupplier.getName() + " - " + foundSupplier.getEmail());
            }

            // ĐÃ XÓA BƯỚC 4: TEST UPDATE PRODUCT ID vì bảng Supplier không có ProductID
        }

        System.out.println("\n=== 5. TEST SEARCH BY NAME ===");
        String keyword = "Test";
        List<Supplier> searchResult = dao.searchByName(keyword);
        System.out.println("Kết quả tìm kiếm cho từ khóa '" + keyword + "': " + searchResult.size() + " dòng");
        for (Supplier s : searchResult) {
            System.out.println("- " + s.getName() + " (" + s.getEmail() + ")");
        }

        System.out.println("\n=== 6. TEST COUNT ===");
        int count = dao.count(keyword);
        System.out.println("✅ Tổng số lượng Supplier chứa từ khóa '" + keyword + "': " + count);

        System.out.println("\n=== 7. TEST SEARCH & PAGINATE ===");
        // Lấy trang 1, mỗi trang tối đa 5 bản ghi (offset = 0, limit = 5)
        List<Supplier> paginatedList = dao.searchAndPaginate(keyword, 0, 5);
        System.out.println("Kết quả phân trang (limit 5, offset 0):");
        for (Supplier s : paginatedList) {
            System.out.println("- ID: " + s.getId() + " | " + s.getName());
        }
    }
}