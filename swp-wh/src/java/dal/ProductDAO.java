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

        if (categoryId != null && !categoryId.isEmpty()) {
            sql.append(" AND CategoryID = ?");
            params.add(Integer.parseInt(categoryId));
        }

        if (unitId != null && !unitId.isEmpty()) {
            sql.append(" AND UnitID = ?");
            params.add(Integer.parseInt(unitId));
        }

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
    public int getTotalFilteredProducts(String search, String categoryId, String unitId) {
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
            if (rs.next())
                return rs.getInt(1);
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
    // 7. DELETE (trả boolean: true nếu thành công)
    // ===============================
    public boolean delete(int id) {
        String sql = "DELETE FROM Product WHERE ProductID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
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
    // ===============================
    // HÀM MAIN ĐỂ TEST CÁC CHỨC NĂNG
    // ===============================
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();

        System.out.println("========== BẮT ĐẦU TEST ProductDAO ==========");

        // --- Chuẩn bị dữ liệu mẫu (Lưu ý: Bạn cần đổi ID 1, 2... cho khớp với DB của bạn) ---
        Category testCat = new Category(); testCat.setId(1);
        Unit testUnit = new Unit(); testUnit.setId(1);
        Supplier testSup = new Supplier(); testSup.setId(1);

        // 1. Test getAll()
        System.out.println("\n1. Test getAll():");
        List<Product> allProducts = dao.getAll();
        System.out.println("-> Tổng số sản phẩm hiện có: " + allProducts.size());

        // 2. Test insertAndGetId()
        System.out.println("\n2. Test insertAndGetId():");
        Product p1 = new Product();
        p1.setCode("SP_TEST_01");
        p1.setName("Sản phẩm Test 01");
        p1.setDescription("Mô tả SP 01");
        p1.setImage("img_01.png");
        p1.setCategory(testCat);
        p1.setUnit(testUnit);
        p1.setSupplier(testSup);

        int insertedId = dao.insertAndGetId(p1);
        System.out.println("-> Đã thêm sản phẩm mới. ID được tạo: " + insertedId);

        // 3. Test getById()
        System.out.println("\n3. Test getById(" + insertedId + "):");
        Product fetchedProduct = dao.getById(insertedId);
        if (fetchedProduct != null) {
            System.out.println("-> Lấy thành công: " + fetchedProduct.getName() + " - Code: " + fetchedProduct.getCode());
        } else {
            System.out.println("-> Không tìm thấy!");
        }

        // 4. Test update()
        System.out.println("\n4. Test update():");
        if (fetchedProduct != null) {
            fetchedProduct.setName("Sản phẩm Test 01 (Đã sửa)");
            fetchedProduct.setDescription("Mô tả đã cập nhật");
            dao.update(fetchedProduct);
            Product updatedProduct = dao.getById(insertedId);
            System.out.println("-> Tên sau khi sửa: " + updatedProduct.getName());
        }

        // 5. Test insert() (Normal)
        System.out.println("\n5. Test insert() (Không lấy ID):");
        Product p2 = new Product();
        p2.setCode("SP_TEST_02");
        p2.setName("Sản phẩm Test 02");
        p2.setCategory(testCat);
        p2.setUnit(testUnit);
        p2.setSupplier(testSup);
        dao.insert(p2);
        System.out.println("-> Đã insert thành công (SP_TEST_02).");

        // 6. Test getFilteredProducts() & getTotalFilteredProducts()
        System.out.println("\n6. Test getFilteredProducts & getTotalFilteredProducts:");
        String search = "Test";
        String catIdStr = "1";
        String unitIdStr = "1";

        int totalFiltered = dao.getTotalFilteredProducts(search, catIdStr, unitIdStr);
        System.out.println("-> Tổng số tìm thấy với từ khóa '" + search + "': " + totalFiltered);

        List<Product> filteredList = dao.getFilteredProducts(search, catIdStr, unitIdStr, 1, 5); // Trang 1, 5 records
        System.out.println("-> Kích thước danh sách lọc (Page 1, Size 5): " + filteredList.size());
        for (Product p : filteredList) {
            System.out.println("   - " + p.getId() + " | " + p.getName() + " | " + p.getCode());
        }

        // 7. Test search() (Original style)
        System.out.println("\n7. Test search() (Original style):");
        List<Product> searchOldStyle = dao.search("Test", 1, 1, 1, 5);
        System.out.println("-> Kết quả search cũ trả về: " + searchOldStyle.size() + " sản phẩm.");

        // 8. Test getProductsBySupplier()
        System.out.println("\n8. Test getProductsBySupplier(1):");
        List<Product> bySupplier = dao.getProductsBySupplier(1);
        System.out.println("-> Sản phẩm của Supplier 1: " + bySupplier.size());

        // 9. Test delete()
        System.out.println("\n9. Test delete() (Dọn dẹp dữ liệu test):");
        // Xóa SP_TEST_01 (chúng ta biết ID từ insertedId)
        dao.delete(insertedId);
        System.out.println("-> Đã xóa sản phẩm ID: " + insertedId);

        // Tìm và xóa SP_TEST_02 (Vì insert thường không trả về ID, ta tìm qua search rồi xóa)
        List<Product> toDeleteList = dao.getFilteredProducts("SP_TEST_02", null, null, 1, 10);
        for (Product p : toDeleteList) {
            dao.delete(p.getId());
            System.out.println("-> Đã xóa dọn dẹp sản phẩm rác: " + p.getName());
        }

        System.out.println("\n========== KẾT THÚC TEST ==========");
    }
}