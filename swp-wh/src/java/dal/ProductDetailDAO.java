package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ProductDetail;
import model.Product;
import java.sql.SQLException;
public class ProductDetailDAO extends DBContext {


    // Cần ProductDAO để lấy thông tin Product cha cho ProductDetail
    private final ProductDAO productDAO = new ProductDAO();

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
            pd.setQuantity(rs.getInt("Quantity"));

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
            pd.setManufactureDate(rs.getTimestamp("ManufactureDate"));

            // ĐỪNG QUÊN 2 DÒNG NÀY:
            pd.setColor(rs.getString("Color"));
            pd.setQuantity(rs.getInt("Quantity"));

            pd.setProduct(productDAO.getById(rs.getInt("ProductID")));
            return pd;
        }
    } catch (SQLException e) { e.printStackTrace(); }
    return null;
}



    // Lọc danh sách ProductDetail theo ProductID và Tìm kiếm (Lot/Serial)
    public List<ProductDetail> getFiltered(String search, String productId, int page, int pageSize) {
        List<ProductDetail> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("select * from Product_Detail WHERE 1=1");
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

        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
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
                pd.setProduct(productDAO.getById(rs.getInt("ProductID")));
                list.add(pd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số bản ghi sau khi lọc để phân trang
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

    public static void main(String[] args) {
        ProductDetailDAO dao = new ProductDetailDAO();

        System.out.println("--- KIỂM TRA KẾT NỐI VÀ DỮ LIỆU ---");

        // 1. Kiểm tra hàm getTotal
        int total = dao.getTotal(null, null);
        System.out.println("Tổng số bản ghi tìm thấy: " + total);

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
