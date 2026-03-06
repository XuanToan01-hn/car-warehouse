package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ProductDetail;
import model.Product;

public class ProductDetailDAO extends DBContext {

    // Cần ProductDAO để lấy thông tin Product cha cho ProductDetail
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    /**
     * Lấy toàn bộ danh sách ProductDetail
     */
    public List<ProductDetail> getAll() {
        List<ProductDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM Product_Detail ORDER BY ProductDetailID ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setLotNumber(rs.getString("LotNumber"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                pd.setManufactureDate(rs.getTimestamp("ManufactureDate"));

                // nếu bảng có các field này
                pd.setColor(rs.getString("Color"));
                pd.setPrice(rs.getDouble("Price"));

                // lấy Product cha
                pd.setProduct(productDAO.getById(rs.getInt("ProductID")));

                list.add(pd);
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
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setLotNumber(rs.getString("LotNumber"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                pd.setManufactureDate(rs.getDate("ManufactureDate"));

                // Các field mở rộng nếu có
                try {
                    pd.setColor(rs.getString("Color"));
                    pd.setPrice(rs.getDouble("Price"));
                } catch (SQLException ignored) {
                }

                pd.setProduct(productDAO.getById(rs.getInt("ProductID")));
                return pd;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lọc danh sách ProductDetail theo ProductID và Tìm kiếm (Lot/Serial)
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
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setLotNumber(rs.getString("LotNumber"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                pd.setManufactureDate(rs.getDate("ManufactureDate"));
                pd.setColor(rs.getString("Color"));
                pd.setPrice(rs.getDouble("Price"));
                pd.setProduct(productDAO.getById(rs.getInt("ProductID")));
                list.add(pd);
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
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<ProductDetail> getDetailsBySupplier(int supplierId) {
        List<ProductDetail> list = new ArrayList<>();
        String sql = "SELECT pd.* FROM Product_Detail pd " +
                "JOIN Product p ON pd.ProductID = p.ProductID " +
                "WHERE p.SupplierID = ? " +
                "ORDER BY p.Name ASC, pd.Color ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setLotNumber(rs.getString("LotNumber"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                pd.setManufactureDate(rs.getTimestamp("ManufactureDate"));
                pd.setColor(rs.getString("Color"));
                pd.setPrice(rs.getDouble("Price"));
                pd.setProduct(productDAO.getById(rs.getInt("ProductID")));
                list.add(pd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(ProductDetail pd) {
        String sql = "INSERT INTO Product_Detail (LotNumber, SerialNumber, ManufactureDate, ProductID, Color, Price) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, pd.getLotNumber());
            ps.setString(2, pd.getSerialNumber());
            ps.setDate(3, new java.sql.Date(pd.getManufactureDate().getTime()));
            ps.setInt(4, pd.getProduct().getId());
            ps.setString(5, pd.getColor());
            ps.setDouble(6, pd.getPrice());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(ProductDetail pd) {
        String sql = "UPDATE Product_Detail SET LotNumber = ?, SerialNumber = ?, ManufactureDate = ?, ProductID = ?, Color = ?, Price = ? WHERE ProductDetailID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, pd.getLotNumber());
            ps.setString(2, pd.getSerialNumber());
            ps.setDate(3, new java.sql.Date(pd.getManufactureDate().getTime()));
            ps.setInt(4, pd.getProduct().getId());
            ps.setString(5, pd.getColor());
            ps.setDouble(6, pd.getPrice());
            ps.setInt(7, pd.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy danh sách ProductDetail theo ProductID,
     * kèm số lượng tồn kho thực tế (SUM từ Location_Product).
     * Chỉ lấy những detail có tồn kho > 0.
     */
    public List<ProductDetail> getByProductId(int productId) {
        List<ProductDetail> list = new ArrayList<>();
        // Đã sửa: Liệt kê rõ các cột thay vì dùng pd.*
        String sql = "SELECT pd.ProductDetailID, pd.LotNumber, pd.SerialNumber, " +
                "       pd.ManufactureDate, pd.ProductID, pd.Color, pd.Price, " +
                "       ISNULL(SUM(lp.Quantity), 0) AS StockQty " +
                "FROM Product_Detail pd " +
                "LEFT JOIN Location_Product lp ON pd.ProductDetailID = lp.ProductDetailID " +
                "WHERE pd.ProductID = ? " +
                "GROUP BY pd.ProductDetailID, pd.LotNumber, pd.SerialNumber, " +
                "         pd.ManufactureDate, pd.ProductID, pd.Color, pd.Price " +
                "HAVING ISNULL(SUM(lp.Quantity), 0) > 0 " +
                "ORDER BY pd.ProductDetailID ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setLotNumber(rs.getString("LotNumber"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                pd.setManufactureDate(rs.getDate("ManufactureDate"));
                pd.setColor(rs.getString("Color"));
                pd.setPrice(rs.getDouble("Price"));
                pd.setProduct(productDAO.getById(productId));

                // Lưu ý: Bạn đã tính StockQty trong SQL nhưng chưa set vào Object.
                // Nếu model ProductDetail có thuộc tính này, hãy uncomment dòng dưới:
                // pd.setStockQty(rs.getInt("StockQty"));

                list.add(pd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    /**
     * Lấy toàn bộ danh sách ProductDetail theo ProductID không quan tâm tồn kho (Dùng cho nhập hàng/PO).
     */
    public List<ProductDetail> getAllDetailsByProductId(int productId) {
        List<ProductDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM Product_Detail WHERE ProductID = ? ORDER BY ProductDetailID ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setLotNumber(rs.getString("LotNumber"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                pd.setManufactureDate(rs.getDate("ManufactureDate"));

                // Bắt exception nếu bảng chưa chuẩn hóa cột này
                try {
                    pd.setColor(rs.getString("Color"));
                    pd.setPrice(rs.getDouble("Price"));
                } catch (SQLException ignored) {}

                list.add(pd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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

        if (total == 0) {
            System.out.println("LỖI: Database không có dữ liệu hoặc câu lệnh COUNT bị sai.");
        }

        // 2. Kiểm tra hàm getFiltered (Trang 1, mỗi trang 10 cái)
        System.out.println("\n--- DANH SÁCH CHI TIẾT SẢN PHẨM ---");
        List<ProductDetail> list = dao.getFiltered(null, null, 1, 10);

        if (list == null) {
            System.out.println("LỖI: Danh sách trả về bị NULL (Kiểm tra try-catch trong DAO).");
        } else if (list.isEmpty()) {
            System.out.println("LỖI: Danh sách rỗng. Có thể do lỗi OFFSET/FETCH hoặc dữ liệu trống.");
        } else {
            for (ProductDetail pd : list) {
                System.out.print("ID Detail: " + pd.getId());
                System.out.print(" | Lot: " + pd.getLotNumber());
                System.out.print(" | Serial: " + pd.getSerialNumber());

                // Kiểm tra xem Product có bị null không (Lỗi Join/Mapping)
                if (pd.getProduct() != null) {
                    System.out.println(" | Sản phẩm: " + pd.getProduct().getName());
                } else {
                    System.out.println(" | LỖI: Product bị NULL (Kiểm tra ProductDAO.getById)");
                }
                System.out.println("--------------------------------------------------");
            }
        }
    }
}