
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
    SupplierDAO supplierDAO = new SupplierDAO();

    public String getNextProductCode() {
        String sql = "SELECT MAX(ProductID) FROM Product";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int nextId = rs.getInt(1) + 1;
                return String.format("PRO-%04d", nextId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "PRO-0001";
    }

//lấy thông tin sản phẩm theo warehouse
    public List<Product> getProductsByWarehouse(int warehouseId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT DISTINCT p.* FROM Product p " +
                     "JOIN Product_Detail pd ON p.ProductID = pd.ProductID " +
                     "JOIN Location_Product lp ON pd.ProductDetailID = lp.ProductDetailID " +
                     "JOIN Location l ON lp.LocationID = l.LocationID " +
                     "WHERE l.WarehouseID = ? AND lp.Quantity > 0 " +
                     "ORDER BY p.Name ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, warehouseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }


  
    // 3. GET BY ID
    
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

    
    public int insertAndGetId(Product p) {
        String sql = "INSERT INTO Product (Code, Name, Description, Image, CategoryID, UnitID, SupplierID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            //lấy ID product vừa insert
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
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    
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

  
    public boolean delete(int id) {
        String sql = "DELETE FROM Product WHERE ProductID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0; // có dòng bị ảnh hương nên true
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


   
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

    // Hàm dùng chung để map ResultSet sang Product object
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
    public int count(String keyword, int categoryId, int supplierId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Product WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Name LIKE ? OR Code LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (categoryId > 0) {
            sql.append(" AND CategoryID = ?");
            params.add(categoryId);
        }
        if (supplierId > 0) {
            sql.append(" AND SupplierID = ?");
            params.add(supplierId);
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<Product> search(String keyword, int categoryId, int supplierId, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Product WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (Name LIKE ? OR Code LIKE ?)");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        if (categoryId > 0) {
            sql.append(" AND CategoryID = ?");
            params.add(categoryId);
        }
        if (supplierId > 0) {
            sql.append(" AND SupplierID = ?");
            params.add(supplierId);
        }
        //Bỏ x dòng đầu Lấy y dòng tiếp theo

        sql.append(" ORDER BY ProductID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToProduct(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean isCodeExists(String code, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Product WHERE Code = ? AND ProductID != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean isNameExists(String name, int excludeId) {
        String sql = "SELECT COUNT(*) FROM Product WHERE Name = ? AND ProductID != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
//Không cần lấy dữ liệu cụ thể
//Chỉ cần kiểm tra có dòng nào tồn tại hay không
    public boolean hasProductDetail(int id) {
        String sql = "SELECT 1 FROM Product_Detail WHERE ProductID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
