/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ProductDetail;
import model.Product;

public class ProductDetailDAO extends DBContext {

    ProductDAO productDAO = new ProductDAO();

    // Lọc và phân trang ProductDetail
    public List<ProductDetail> getFilteredProductDetails(String search, String productId, int page, int pageSize) {
        List<ProductDetail> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT pd.* FROM ProductDetail pd 
            JOIN Product p ON pd.ProductID = p.ProductID 
            WHERE 1=1
            """);
        List<Object> params = new ArrayList<>();

        // Lọc theo Lot hoặc Serial
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (pd.LotNumber LIKE ? OR pd.SerialNumber LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        // Lọc theo Product gốc
        if (productId != null && !productId.isEmpty() && !productId.equals("0")) {
            sql.append(" AND pd.ProductID = ?");
            params.add(Integer.parseInt(productId));
        }

        sql.append(" ORDER BY pd.ProductDetailID ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
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

    public int getTotalFiltered(String search, String productId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM ProductDetail WHERE 1=1");
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
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void insert(ProductDetail pd) {
        String sql = "INSERT INTO ProductDetail (ProductID, LotNumber, SerialNumber, ManufactureDate) VALUES (?,?,?,?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, pd.getProduct().getId());
            ps.setString(2, pd.getLotNumber());
            ps.setString(3, pd.getSerialNumber());
            ps.setDate(4, new java.sql.Date(pd.getManufactureDate().getTime()));
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    public void delete(int id) {
        String sql = "DELETE FROM ProductDetail WHERE ProductDetailID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}