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

    CategoryDAO categoryDAO = new CategoryDAO();
    UnitDAO unitDAO = new UnitDAO();
    SupplierDAO supplierDAO = new SupplierDAO(); // Thêm SupplierDAO để map object

    // ===============================
    // GET FILTERED PRODUCTS
    // ===============================
    public List<Product> getFilteredProducts(String search, String sortPrice, String categoryId, String unitId, int page, int pageSize) {
        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM Product WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Search filter
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
        
        // Sort by price
        sql.append(" ORDER BY ");
        if (sortPrice != null && !sortPrice.isEmpty()) {
            sql.append("Price ").append(sortPrice.equals("asc") ? "ASC" : "DESC");
        } else {
            sql.append("ProductID ASC"); // Default sorting
        }
        
        // Pagination (MySQL format)
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
                p.setPrice(rs.getDouble("Price"));
                p.setDescription(rs.getString("Description"));
                p.setImage(rs.getString("Image"));
                p.setMinStock(rs.getInt("MinStock"));

                p.setCategory(categoryDAO.getByID(rs.getInt("CategoryID")));
                p.setUnit(unitDAO.getUnitById(rs.getInt("UnitID")));

                int supId = rs.getInt("SupplierID");
                if (!rs.wasNull()) {
                    p.setSupplier(supplierDAO.getById(supId));
                }

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // ===============================
    // GET TOTAL FILTERED PRODUCTS
    // ===============================
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
    // GET ALL
    // ===============================
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        // CẬP NHẬT LỆNH SQL: Lấy thêm màu từ Product_Detail
        String sql = "SELECT p.*, (SELECT TOP 1 Color FROM Product_Detail pd WHERE pd.ProductID = p.ProductID AND pd.Color IS NOT NULL) AS Color FROM Product p";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setCode(rs.getString("Code"));
                p.setName(rs.getString("Name"));
                p.setPrice(rs.getDouble("Price"));
                p.setDescription(rs.getString("Description"));
                p.setImage(rs.getString("Image"));
                p.setMinStock(rs.getInt("MinStock"));

                // Set color lấy từ câu query
                p.setColor(rs.getString("Color"));

                p.setCategory(categoryDAO.getByID(rs.getInt("CategoryID")));
                p.setUnit(unitDAO.getUnitById(rs.getInt("UnitID")));

                int supId = rs.getInt("SupplierID");
                if (!rs.wasNull()) {
                    p.setSupplier(supplierDAO.getById(supId));
                }

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // GET BY ID
    // ===============================
    public Product getById(int id) {
        String sql = "SELECT * FROM Product WHERE ProductID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setCode(rs.getString("Code"));
                p.setName(rs.getString("Name"));
                p.setPrice(rs.getDouble("Price"));
                p.setDescription(rs.getString("Description"));
                p.setImage(rs.getString("Image"));
                p.setMinStock(rs.getInt("MinStock"));

                p.setCategory(categoryDAO.getByID(rs.getInt("CategoryID")));
                p.setUnit(unitDAO.getUnitById(rs.getInt("UnitID")));

                int supId = rs.getInt("SupplierID");
                if (!rs.wasNull()) {
                    p.setSupplier(supplierDAO.getById(supId));
                }

                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===============================
    // INSERT (RETURN ID)
    // ===============================
    public int insertAndGetId(Product p) {
        String sql = """
                     INSERT INTO Product
                     (Code, Name, Price, Description, Image, CategoryID, UnitID, MinStock, SupplierID)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, p.getCode());
            ps.setString(2, p.getName());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getDescription());
            ps.setString(5, p.getImage());

            if (p.getCategory() != null) ps.setInt(6, p.getCategory().getId());
            else ps.setNull(6, java.sql.Types.INTEGER);

            if (p.getUnit() != null) ps.setInt(7, p.getUnit().getId());
            else ps.setNull(7, java.sql.Types.INTEGER);

            ps.setInt(8, p.getMinStock());

            if (p.getSupplier() != null) ps.setInt(9, p.getSupplier().getId());
            else ps.setNull(9, java.sql.Types.INTEGER);

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ===============================
    // INSERT
    // ===============================
    public void insert(Product p) {
        String sql = """
                     INSERT INTO Product
                     (Code, Name, Price, Description, Image, CategoryID, UnitID, MinStock, SupplierID)
                     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getCode());
            ps.setString(2, p.getName());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getDescription());
            ps.setString(5, p.getImage());

            if (p.getCategory() != null) ps.setInt(6, p.getCategory().getId());
            else ps.setNull(6, java.sql.Types.INTEGER);

            if (p.getUnit() != null) ps.setInt(7, p.getUnit().getId());
            else ps.setNull(7, java.sql.Types.INTEGER);

            ps.setInt(8, p.getMinStock());

            if (p.getSupplier() != null) ps.setInt(9, p.getSupplier().getId());
            else ps.setNull(9, java.sql.Types.INTEGER);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // UPDATE
    // ===============================
    public void update(Product p) {
        String sql = """
                     UPDATE Product
                     SET Code = ?, Name = ?, Price = ?, Description = ?, Image = ?,
                         CategoryID = ?, UnitID = ?, MinStock = ?, SupplierID = ?
                     WHERE ProductID = ?
                     """;
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getCode());
            ps.setString(2, p.getName());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getDescription());
            ps.setString(5, p.getImage());

            if (p.getCategory() != null) ps.setInt(6, p.getCategory().getId());
            else ps.setNull(6, java.sql.Types.INTEGER);

            if (p.getUnit() != null) ps.setInt(7, p.getUnit().getId());
            else ps.setNull(7, java.sql.Types.INTEGER);

            ps.setInt(8, p.getMinStock());

            if (p.getSupplier() != null) ps.setInt(9, p.getSupplier().getId());
            else ps.setNull(9, java.sql.Types.INTEGER);

            ps.setInt(10, p.getId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // DELETE
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
    // SEARCH + PAGINATION
    // ===============================
    public List<Product> search(String keyword, int categoryId, int unitId, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        // Thay đổi sang cú pháp LIMIT cho đồng bộ
       String sql = """
    SELECT * FROM Product
    WHERE (Name LIKE ? OR Code LIKE ?)
    AND (? = 0 OR CategoryID = ?)
    AND (? = 0 OR UnitID = ?)
    ORDER BY ProductID
    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
""";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String search = "%" + keyword + "%";

            ps.setString(1, search);
            ps.setString(2, search);

            ps.setInt(3, categoryId);
            ps.setInt(4, categoryId);

            ps.setInt(5, unitId);
            ps.setInt(6, unitId);

            ps.setInt(7, (page - 1) * pageSize);
            ps.setInt(8, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setCode(rs.getString("Code"));
                p.setName(rs.getString("Name"));
                p.setPrice(rs.getDouble("Price"));
                p.setDescription(rs.getString("Description"));
                p.setImage(rs.getString("Image"));
                p.setMinStock(rs.getInt("MinStock"));

                p.setCategory(categoryDAO.getByID(rs.getInt("CategoryID")));
                p.setUnit(unitDAO.getUnitById(rs.getInt("UnitID")));

                int supId = rs.getInt("SupplierID");
                if (!rs.wasNull()) {
                    p.setSupplier(supplierDAO.getById(supId));
                }

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // GET PRODUCTS BY SUPPLIER
    // ===============================
    public List<Product> getProductsBySupplier(int supplierId) {
        List<Product> list = new ArrayList<>();
        // CẬP NHẬT LỆNH SQL
        String sql = "SELECT p.*, (SELECT TOP 1 Color FROM Product_Detail pd WHERE pd.ProductID = p.ProductID AND pd.Color IS NOT NULL) AS Color FROM Product p WHERE p.SupplierID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();

            Supplier supplier = supplierDAO.getById(supplierId);

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setCode(rs.getString("Code"));
                p.setName(rs.getString("Name"));
                p.setPrice(rs.getDouble("Price"));
                p.setDescription(rs.getString("Description"));
                p.setImage(rs.getString("Image"));
                p.setMinStock(rs.getInt("MinStock"));

                // Set color
                p.setColor(rs.getString("Color"));

                p.setCategory(categoryDAO.getByID(rs.getInt("CategoryID")));
                p.setUnit(unitDAO.getUnitById(rs.getInt("UnitID")));
                p.setSupplier(supplier);

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();

        System.out.println("===== TEST GET ALL =====");
        List<Product> allProducts = dao.getAll();
        for (Product p : allProducts) {
            System.out.println(p.getId() + " - " + p.getName() + " - " + p.getPrice());
        }

        System.out.println("\n===== TEST GET BY ID =====");
        Product product = dao.getById(1);
        if (product != null) {
            System.out.println(product.getId() + " - " + product.getName());
        } else {
            System.out.println("Product not found");
        }

        System.out.println("\n===== TEST INSERT & GET ID =====");
        Product newProduct = new Product();
        newProduct.setCode("TEST001");
        newProduct.setName("Test Product");
        newProduct.setPrice(100.0);
        newProduct.setDescription("Test insert");
        newProduct.setImage("test.jpg");
        newProduct.setMinStock(10);

        // Giả sử đã có CategoryID=1, UnitID=1, SupplierID=1 trong DB
        Category c = new Category();
        c.setId(1);
        newProduct.setCategory(c);

        Unit u = new Unit();
        u.setId(1);
        newProduct.setUnit(u);

        Supplier s = new Supplier();
        s.setId(1);
        newProduct.setSupplier(s);

        int newId = dao.insertAndGetId(newProduct);
        System.out.println("Inserted Product ID: " + newId);

        System.out.println("\n===== TEST UPDATE =====");
        Product updateProduct = dao.getById(newId);
        if (updateProduct != null) {
            updateProduct.setName("Updated Product");
            updateProduct.setPrice(150.0);
            dao.update(updateProduct);
            System.out.println("Updated Product ID: " + newId);
        }

        System.out.println("\n===== TEST SEARCH + PAGINATION =====");
        List<Product> searchList = dao.search("Test", 0, 0, 1, 5);
        for (Product p : searchList) {
            System.out.println(p.getId() + " - " + p.getName());
        }

        System.out.println("\n===== TEST FILTERED PRODUCTS =====");
        List<Product> filtered = dao.getFilteredProducts(
                "Test",   // search
                "asc",    // sort price
                "",       // category
                "",       // unit
                1,        // page
                5         // pageSize
        );
        for (Product p : filtered) {
            System.out.println(p.getId() + " - " + p.getName() + " - " + p.getPrice());
        }

        System.out.println("\n===== TEST TOTAL FILTERED =====");
        int total = dao.getTotalFilteredProducts("Test", "", "");
        System.out.println("Total filtered: " + total);

        System.out.println("\n===== TEST GET BY SUPPLIER =====");
        List<Product> supplierProducts = dao.getProductsBySupplier(1);
        for (Product p : supplierProducts) {
            System.out.println(p.getId() + " - " + p.getName());
        }

        System.out.println("\n===== TEST DELETE =====");
        if (newId > 0) {
            dao.delete(newId);
            System.out.println("Deleted Product ID: " + newId);
        }

        System.out.println("\n===== TEST COMPLETED =====");
    }
}