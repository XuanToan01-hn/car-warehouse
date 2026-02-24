/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

/**
 *
 * @author Asus
 */
public class ProductDAO {
    
<<<<<<< Updated upstream
}
=======
    public List<Product> getFilteredProducts(String search, String sortPrice, String categoryId, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        CategoryDAO categoryDAO = new CategoryDAO();
        
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
        
        // Sort by price and required ORDER BY for pagination
        sql.append(" ORDER BY ");
        if (sortPrice != null && !sortPrice.isEmpty()) {
            sql.append("Price ").append(sortPrice.equals("asc") ? "ASC" : "DESC");
        } else {
            sql.append("ProductID ASC"); // Default sorting if no price sort specified
        }
        
        // Pagination for SQL Server
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
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    
        public int getTotalFilteredProducts(String search, String categoryId) {
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
    public List<Product> getAll() {

        List<Product> list = new ArrayList<>();

        String sql = "SELECT * FROM Product";

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

                Category c = categoryDAO.getByID(rs.getInt("CategoryID"));
//                Unit u = unitDAO.getUnitById(rs.getInt("UnitID"));

                p.setCategory(c);
//                p.setUnit(u);

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
//                p.setUnit(unitDAO.getUnitById(rs.getInt("UnitID")));

                return p;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ===============================
    // INSERT
    // ===============================
    public void insert(Product p) {

        String sql = """
                     INSERT INTO Product
                     (Code, Name, Price, Description, Image, CategoryID, MinStock)
                     VALUES (?, ?, ?, ?, ?, ?, ?)
                     """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, p.getCode());
            ps.setString(2, p.getName());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getDescription());
            ps.setString(5, p.getImage());
            ps.setInt(6, p.getCategory().getId());
            ps.setInt(7, p.getMinStock());

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
                     SET Code = ?,
                         Name = ?,
                         Price = ?,
                         Description = ?,
                         Image = ?,
                         CategoryID = ?,
                         MinStock = ?
                     WHERE ProductID = ?
                     """;

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, p.getCode());
            ps.setString(2, p.getName());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getDescription());
            ps.setString(5, p.getImage());
            ps.setInt(6, p.getCategory().getId());
            ps.setInt(7, p.getMinStock());
            ps.setInt(8, p.getId());

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
    public List<Product> search(
            String keyword,
            int categoryId,
            int unitId,
            int page,
            int pageSize) {

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

                Product p = new Product();

                p.setId(rs.getInt("ProductID"));
                p.setCode(rs.getString("Code"));
                p.setName(rs.getString("Name"));
                p.setPrice(rs.getDouble("Price"));
                p.setDescription(rs.getString("Description"));
                p.setImage(rs.getString("Image"));
                p.setMinStock(rs.getInt("MinStock"));

                p.setCategory(categoryDAO.getByID(rs.getInt("CategoryID")));
//                p.setUnit(unitDAO.getUnitById(rs.getInt("UnitID")));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
>>>>>>> Stashed changes
