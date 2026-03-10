/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import context.DBContext;
import java.util.ArrayList;
import java.util.List;
import model.LocationProduct;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Location;
import model.Product;
import model.ProductDetail;
import model.Warehouse;
/**
 *
 * @author Asus
 */
public class ReportDAO extends DBContext{
    
    
    public static void main(String[] args) {
    ReportDAO dao = new ReportDAO();
    WarehouseDAO wd = new WarehouseDAO();
    // Lấy trang 1, mỗi trang 5 bản ghi, sắp xếp theo số lượng giảm dần
    List<LocationProduct> report = dao.getCurrentStock("", "", 1, 5, "lp.Quantity", "DESC");
    
    System.out.println("================= BÁO CÁO TỒN KHO HIỆN TẠI =================");
    System.out.printf("%-15s | %-10s | %-20s | %-10s | %-5s\n", 
                      "Warehouse", "Bin/Rack", "Product", "Lot", "Qty");
    System.out.println("------------------------------------------------------------");
   
    for (LocationProduct item : report) {
        Warehouse w = wd.getById(item.getLocation().getWarehouseId());
        System.out.printf("%-15s | %-10s | %-20s | %-10s | %-5d\n",
            w.getWarehouseName(), 
            item.getLocation().getLocationCode(),
            item.getProduct().getName(),
            item.getProductDetail().getLotNumber(),
            item.getQuantity()
        );
    }
}
    
 public List<LocationProduct> getCurrentStock(String productName, String warehouseName,
                                             int page, int size, String sortCol, String sortType) {

    List<LocationProduct> list = new ArrayList<>();

    if (sortCol == null || sortCol.isEmpty()) sortCol = "p.Name";
    if (sortType == null || sortType.isEmpty()) sortType = "ASC";

    String sql =
            "SELECT lp.Quantity, " +
            "l.LocationID, l.LocationCode, l.LocationName, " +
            "w.WarehouseID, w.WarehouseName, " +
            "p.ProductID, p.Code AS ProductCode, p.Name AS ProductName, " +
            "pd.ProductDetailID, pd.LotNumber, pd.SerialNumber " +

            "FROM Location_Product lp " +
            "JOIN Location l ON lp.LocationID = l.LocationID " +
            "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID " +
            "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID " +
            "JOIN Product p ON pd.ProductID = p.ProductID " +

            "WHERE p.Name LIKE ? AND w.WarehouseName LIKE ? " +

            "ORDER BY " + sortCol + " " + sortType + " " +

            "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {

        ps.setString(1, "%" + (productName == null ? "" : productName) + "%");
        ps.setString(2, "%" + (warehouseName == null ? "" : warehouseName) + "%");

        ps.setInt(3, (page - 1) * size);   // OFFSET
        ps.setInt(4, size);                // FETCH NEXT

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            LocationProduct lp = new LocationProduct();
            lp.setQuantity(rs.getInt("Quantity"));

            Location loc = new Location();
            loc.setId(rs.getInt("LocationID"));
            loc.setLocationCode(rs.getString("LocationCode"));
            loc.setLocationName(rs.getString("LocationName"));

            Warehouse wh = new Warehouse();
            wh.setId(rs.getInt("WarehouseID"));
            wh.setWarehouseName(rs.getString("WarehouseName"));

            loc.setWarehouseId(wh.getId());

            lp.setLocation(loc);

            Product pro = new Product();
            pro.setId(rs.getInt("ProductID"));
            pro.setCode(rs.getString("ProductCode"));
            pro.setName(rs.getString("ProductName"));

            lp.setProduct(pro);

            ProductDetail pd = new ProductDetail();
            pd.setId(rs.getInt("ProductDetailID"));
            pd.setLotNumber(rs.getString("LotNumber"));
            pd.setSerialNumber(rs.getString("SerialNumber"));

            lp.setProductDetail(pd);

            list.add(lp);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
//    /**
//     * Báo cáo biến động kho - Dùng Entity InventoryTransaction
//     */
//    public List<InventoryTransaction> getStockMovement(Integer type, String from, String to, int page, int size) {
//        List<InventoryTransaction> list = new ArrayList<>();
//        StringBuilder sql = new StringBuilder(
//            "SELECT it.*, p.Name AS ProductName, l.LocationCode " +
//            "FROM Inventory_Transaction it " +
//            "JOIN Product p ON it.ProductID = p.ProductID " +
//            "JOIN Location l ON it.LocationID = l.LocationID WHERE 1=1 "
//        );
//
//        if (type != null) sql.append("AND it.TransactionType = ? ");
//        if (from != null && !from.isEmpty()) sql.append("AND it.TransactionDate >= ? ");
//        if (to != null && !to.isEmpty()) sql.append("AND it.TransactionDate <= ? ");
//        
//        sql.append("ORDER BY it.TransactionDate DESC LIMIT ? OFFSET ?");
//
//        try (Connection conn = getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
//            int idx = 1;
//            if (type != null) ps.setInt(idx++, type);
//            if (from != null && !from.isEmpty()) ps.setString(idx++, from + " 00:00:00");
//            if (to != null && !to.isEmpty()) ps.setString(idx++, to + " 23:59:59");
//            ps.setInt(idx++, size);
//            ps.setInt(idx++, (page - 1) * size);
//
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                InventoryTransaction it = new InventoryTransaction();
//                it.setTransactionDate(rs.getTimestamp("TransactionDate"));
//                it.setProductName(rs.getString("ProductName"));
//                it.setTransactionType(rs.getInt("TransactionType"));
//                it.setQuantity(rs.getInt("Quantity"));
//                it.setLocationCode(rs.getString("LocationCode"));
//                it.setReferenceCode(rs.getString("ReferenceCode"));
//                list.add(it);
//            }
//        } catch (Exception e) { e.printStackTrace(); }
//        return list;
//    }
//    
    
}
