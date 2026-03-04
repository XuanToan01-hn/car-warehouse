package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ProductDetail;

public class ProductDetailDAO extends DBContext {

    private final ProductDAO productDAO = new ProductDAO();

    // Trong ProductDetailDAO.java
public List<ProductDetail> getByProductId(int productId) {
    List<ProductDetail> list = new ArrayList<>();
    String sql = "SELECT * FROM Product_Detail WHERE ProductID = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, productId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    public List<ProductDetail> getAll() {
        List<ProductDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM Product_Detail ORDER BY ProductDetailID ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToEntity(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ProductDetail getById(int id) {
        String sql = "SELECT * FROM Product_Detail WHERE ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEntity(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ProductDetail> getFiltered(String search, String productId, int page, int pageSize) {
        List<ProductDetail> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Product_Detail WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (LotNumber LIKE ? OR SerialNumber LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        if (productId != null && !productId.isEmpty() && !productId.equals("0")) {
            sql.append(" AND ProductID = ?");
            params.add(Integer.parseInt(productId));
        }

        sql.append(" ORDER BY ProductDetailID ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToEntity(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotal(String search, String productId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Product_Detail WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (LotNumber LIKE ? OR SerialNumber LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        if (productId != null && !productId.isEmpty() && !productId.equals("0")) {
            sql.append(" AND ProductID = ?");
            params.add(Integer.parseInt(productId));
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private ProductDetail mapResultSetToEntity(ResultSet rs) throws SQLException {
        ProductDetail pd = new ProductDetail();
        pd.setId(rs.getInt("ProductDetailID"));
        pd.setLotNumber(rs.getString("LotNumber"));
        pd.setSerialNumber(rs.getString("SerialNumber"));
        pd.setManufactureDate(rs.getTimestamp("ManufactureDate"));
        pd.setColor(rs.getString("Color"));
        pd.setPrice(rs.getDouble("Price")); 
        pd.setQuantity(rs.getInt("Quantity"));
        
        pd.setProduct(productDAO.getById(rs.getInt("ProductID")));
        
        try {
            pd.setColor(rs.getString("Color"));
        } catch (SQLException ignored) {}
        
        return pd;
    }
    
    public void insert(ProductDetail pd) {
    String sql = "INSERT INTO [Product_Detail] ([ProductID], [LotNumber], [SerialNumber], "
               + "[ManufactureDate], [Price], [Quantity], [Color]) "
               + "VALUES (?, ?, ?, ?, ?, ?, ?)";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, pd.getProduct().getId());
        ps.setString(2, pd.getLotNumber());
        ps.setString(3, pd.getSerialNumber());
        ps.setDate(4, new java.sql.Date(pd.getManufactureDate().getTime()));
        ps.setDouble(5, pd.getPrice());
        ps.setInt(6, pd.getQuantity());
        ps.setString(7, pd.getColor());
        
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
    
    // --- CÁC HÀM THAY ĐỔI DỮ LIỆU ---

public void update(ProductDetail pd) {
    String sql = "UPDATE [Product_Detail] SET [ProductID] = ?, [LotNumber] = ?, "
               + "[SerialNumber] = ?, [ManufactureDate] = ?, [Price] = ?, "
               + "[Quantity] = ?, [Color] = ? WHERE [ProductDetailID] = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, pd.getProduct().getId());
        ps.setString(2, pd.getLotNumber());
        ps.setString(3, pd.getSerialNumber());
        ps.setDate(4, new java.sql.Date(pd.getManufactureDate().getTime()));
        ps.setDouble(5, pd.getPrice());
        ps.setInt(6, pd.getQuantity());
        ps.setString(7, pd.getColor());
        ps.setInt(8, pd.getId());
        
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

public void delete(int id) {
    String sql = "DELETE FROM [Product_Detail] WHERE [ProductDetailID] = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, id);
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}


    public static void main(String[] args) {
        ProductDetailDAO dao = new ProductDetailDAO();
        System.out.println("--- KIỂM TRA DỮ LIỆU ---");

        int total = dao.getTotal(null, null);
        System.out.println("Tổng số bản ghi: " + total);

        List<ProductDetail> list = dao.getFiltered(null, null, 1, 10);
        if (list != null && !list.isEmpty()) {
            for (ProductDetail pd : list) {
                System.out.print("ID: " + pd.getId());
                System.out.print(" | Serial: " + pd.getSerialNumber());
                System.out.print(" | Giá: " + pd.getPrice()); // Test Price ở đây
                System.out.print(" | SL: " + pd.getQuantity());
                
                if (pd.getProduct() != null) {
                    System.out.println(" | Sản phẩm: " + pd.getProduct().getName());
                } else {
                    System.out.println(" | Lỗi: Không tìm thấy Product ID tương ứng");
                }
                System.out.println("--------------------------------------------------");
            }
        } else {
            System.out.println("Không có dữ liệu hoặc lỗi kết nối.");
        }
    }
}