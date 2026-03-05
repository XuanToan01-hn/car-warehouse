package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Product;
import model.Category;
import model.Unit;
import model.Supplier;

public class ProductDAO extends DBContext {

    // Khởi tạo các DAO để dùng chung, tránh tạo mới liên tục trong vòng lặp
    CategoryDAO categoryDAO = new CategoryDAO();
    UnitDAO unitDAO = new UnitDAO();
    SupplierDAO supplierDAO = new SupplierDAO();


     public static void main(String[] args) {

        ProductDAO dao = new ProductDAO();

        // Test case 1: Không filter gì, lấy trang 1, 5 sản phẩm
        List<Product> list1 = dao.getFilteredProducts(null, null, null, 1, 5);
        System.out.println("=== Test 1: No filter ===");
        for (Product p : list1) {
            System.out.println("ID: " + p.getId()
                    + " | Name: " + p.getName()
                    + " | Code: " + p.getCode());
        }

        // Test case 2: Search theo tên
        List<Product> list2 = dao.getFilteredProducts("milk", null, null, 1, 5);
        System.out.println("\n=== Test 2: Search 'milk' ===");
        for (Product p : list2) {
            System.out.println("ID: " + p.getId()
                    + " | Name: " + p.getName()
                    + " | Code: " + p.getCode());
        }


    }

    // ===============================
    // 1. GET FILTERED PRODUCTS
    // ===============================
    public List<Product> getFilteredProducts(String search, String categoryId, String unitId, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Product WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (Name LIKE ? OR Code LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        // Category filter
        if (categoryId != null && !categoryId.isEmpty()) {
            sql.append(" AND CategoryID = ?");
            params.add(Integer.parseInt(categoryId));
        }
        
        // Unit filter
        if (unitId != null && !unitId.isEmpty()) {
            sql.append(" AND UnitID = ?");
            params.add(Integer.parseInt(unitId));
        }
        
        // Mặc định sắp xếp theo ID vì đã bỏ Price
        sql.append(" ORDER BY ProductID DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setCode(rs.getString("Code"));
                p.setName(rs.getString("Name"));
                p.setDescription(rs.getString("Description"));
                p.setImage(rs.getString("Image"));
                p.setMinStock(rs.getInt("MinStock"));
                p.setColor(rs.getString("Color"));

                p.setCategory(categoryDAO.getByID(rs.getInt("CategoryID")));
                p.setUnit(unitDAO.getUnitById(rs.getInt("UnitID")));

                int supId = rs.getInt("SupplierID");
                if (!rs.wasNull()) {
                    p.setSupplier(supplierDAO.getById(supId));
                }

                list.add(p);
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // ===============================
    // 2. GET TOTAL FILTERED
    // ===============================
    public int getTotalFilteredProducts(String search, String categoryId, String unitId, String supplierId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Product WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (Name LIKE ? OR Code LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        if (categoryId != null && !categoryId.isEmpty()) {
            sql.append(" AND CategoryID = ?");
            params.add(Integer.parseInt(categoryId));
        }
        
        if (unitId != null && !unitId.isEmpty()) {
            sql.append(" AND UnitID = ?");
            params.add(Integer.parseInt(unitId));
        }

        if (supplierId != null && !supplierId.isEmpty()) {
            sql.append(" AND SupplierID = ?");
            params.add(Integer.parseInt(supplierId));
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ===============================
    // 3. GET BY ID
    // ===============================
    public Product getById(int id) {
        String sql = "SELECT * FROM Product WHERE ProductID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===============================
    // 4. INSERT AND GET ID
    // ===============================
    public int insertAndGetId(Product p) {
        String sql = "INSERT INTO Product (Code, Name, Description, Image, CategoryID, UnitID, SupplierID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, p.getCode());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setString(4, p.getImage());
            ps.setObject(5, p.getCategory() != null ? p.getCategory().getId() : null);
            ps.setObject(6, p.getUnit() != null ? p.getUnit().getId() : null);
            ps.setObject(7, p.getSupplier() != null ? p.getSupplier().getId() : null);

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ===============================
    // 5. INSERT (NORMAL)
    // ===============================
    public void insert(Product p) {
        String sql = "INSERT INTO Product (Code, Name, Description, Image, CategoryID, UnitID, SupplierID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getCode());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setString(4, p.getImage());
            ps.setObject(5, p.getCategory() != null ? p.getCategory().getId() : null);
            ps.setObject(6, p.getUnit() != null ? p.getUnit().getId() : null);
            ps.setObject(7, p.getSupplier() != null ? p.getSupplier().getId() : null);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // 6. UPDATE
    // ===============================
    public void update(Product p) {
        String sql = "UPDATE Product SET Code=?, Name=?, Description=?, Image=?, CategoryID=?, UnitID=?, SupplierID=? WHERE ProductID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getCode());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setString(4, p.getImage());
            ps.setObject(5, p.getCategory() != null ? p.getCategory().getId() : null);
            ps.setObject(6, p.getUnit() != null ? p.getUnit().getId() : null);
            ps.setObject(7, p.getSupplier() != null ? p.getSupplier().getId() : null);
            ps.setInt(8, p.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // 7. DELETE
    // ===============================
    public void delete(int id) {
        String sql = "DELETE FROM Product WHERE ProductID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // 8. SEARCH + PAGINATION (ORIGINAL STYLE)
    // ===============================
    public List<Product> search(String keyword, int categoryId, int unitId, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        String sql = """
            SELECT * FROM Product
            WHERE (? IS NULL OR Name LIKE ? OR Code LIKE ?)
            AND (? = 0 OR CategoryID = ?)
            AND (? = 0 OR UnitID = ?)
            ORDER BY ProductID
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String search = "%" + keyword + "%";
            ps.setString(1, keyword);
            ps.setString(2, search);
            ps.setString(3, search);
            ps.setInt(4, categoryId);
            ps.setInt(5, categoryId);
            ps.setInt(6, unitId);
            ps.setInt(7, unitId);
            ps.setInt(8, (page - 1) * pageSize);
            ps.setInt(9, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // 9. GET PRODUCTS BY SUPPLIER
    // ===============================
    public List<Product> getProductsBySupplier(int supplierId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE SupplierID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
// 10. GET ALL
// ===============================
public List<Product> getAll() {
    List<Product> list = new ArrayList<>();
    String sql = "SELECT * FROM Product ORDER BY ProductID DESC";

    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            list.add(mapResultSetToProduct(rs));
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

    // Hàm dùng chung để map ResultSet sang Product (giúp code sạch hơn)
    private Product mapResultSetToProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setId(rs.getInt("ProductID"));
        p.setCode(rs.getString("Code"));
        p.setName(rs.getString("Name"));
        p.setDescription(rs.getString("Description"));
        p.setImage(rs.getString("Image"));
        p.setCategory(categoryDAO.getByID(rs.getInt("CategoryID")));
        p.setUnit(unitDAO.getUnitById(rs.getInt("UnitID")));
        p.setSupplier(supplierDAO.getById(rs.getInt("SupplierID")));
        return p;
    }
}