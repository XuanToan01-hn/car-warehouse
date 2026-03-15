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
import model.InventoryTransaction;
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

    System.out.println("=== CASE 1: TẤT CẢ BIẾN ĐỘNG TRONG THÁNG 10/2024 (Trang 1) ===");
    List<InventoryTransaction> list1 = dao.getStockMovement(0, "2024-10-01", "2026-10-31", "", 1, 10);
    printReport(list1);

    System.out.println("\n=== CASE 2: CHỈ LỌC PHIẾU XUẤT (Type=2) VÀ TÌM KIẾM 'IPHONE' ===");
    // Giả sử Type 2 = ISSUE
    List<InventoryTransaction> list2 = dao.getStockMovement(2, null, null, "Iphone", 1, 5);
    printReport(list2);

    System.out.println("\n=== CASE 3: KIỂM TRA PHÂN TRANG (Trang 2, mỗi trang 2 bản ghi) ===");
    List<InventoryTransaction> list3 = dao.getStockMovement(0, null, null, null, 2, 2);
    printReport(list3);
}

// Hàm hỗ trợ in kết quả đẹp mắt
private static void printReport(List<InventoryTransaction> list) {
    if (list.isEmpty()) {
        System.out.println("Không có dữ liệu.");
        return;
    }
    WarehouseDAO wd = new WarehouseDAO();
    System.out.printf("%-20s | %-10s | %-15s | %-8s | %-10s | %-12s\n", 
                      "Ngày Giao Dịch", "Loại", "Sản Phẩm", "SL", "Kho/Vị Trí", "Mã Tham Chiếu");
    System.out.println("---------------------------------------------------------------------------------------------");
    for (InventoryTransaction it : list) {
               Warehouse w = wd.getById(it.getLocation().getWarehouseId());

        String typeStr = (it.getTransactionType() == 1) ? "Import" : (it.getTransactionType() == 2 ? "Export" : "KHÁC");
        
        System.out.printf("%-20s | %-10s | %-15s | %-8d | %-10s | %-12s\n",
            it.getTransactionDate(),
            typeStr,
            it.getProduct().getName(),
            it.getQuantity(),
            w.getWarehouseName() + "/" + it.getLocation().getLocationCode(),
            it.getReferenceCode()
        );
    }
}
    
//    public static void main(String[] args) {
//    ReportDAO dao = new ReportDAO();
//    WarehouseDAO wd = new WarehouseDAO();
//    // Lấy trang 1, mỗi trang 5 bản ghi, sắp xếp theo số lượng giảm dần
//    List<LocationProduct> report = dao.getCurrentStock("", "", 1, 5, "lp.Quantity", "DESC");
//    
//    System.out.println("================= BÁO CÁO TỒN KHO HIỆN TẠI =================");
//    System.out.printf("%-15s | %-10s | %-20s | %-10s | %-5s\n", 
//                      "Warehouse", "Bin/Rack", "Product", "Lot", "Qty");
//    System.out.println("------------------------------------------------------------");
//   
//    for (LocationProduct item : report) {
//        Warehouse w = wd.getById(item.getLocation().getWarehouseId());
//        System.out.printf("%-15s | %-10s | %-20s | %-10s | %-5d\n",
//            w.getWarehouseName(), 
//            item.getLocation().getLocationCode(),
//            item.getProduct().getName(),
//            item.getProductDetail().getLotNumber(),
//            item.getQuantity()
//        );
//    }
//}
    
// Sửa phương thức lấy danh sách
public List<LocationProduct> getCurrentStock(String productName, String warehouseName, Integer locationId,
                                             int page, int size, String sortCol, String sortType) {
    List<LocationProduct> list = new ArrayList<>();
    if (sortCol == null || sortCol.isEmpty()) sortCol = "p.Name";
    if (sortType == null || sortType.isEmpty()) sortType = "ASC";

    // Thêm điều kiện lọc LocationID vào SQL
    String sql = "SELECT lp.Quantity, l.LocationID, l.LocationCode, l.LocationName, " +
                 "w.WarehouseID, w.WarehouseName, p.ProductID, p.Code AS ProductCode, p.Name AS ProductName, " +
                 "pd.ProductDetailID, pd.LotNumber, pd.SerialNumber " +
                 "FROM Location_Product lp " +
                 "JOIN Location l ON lp.LocationID = l.LocationID " +
                 "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID " +
                 "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID " +
                 "JOIN Product p ON pd.ProductID = p.ProductID " +
                 "WHERE p.Name LIKE ? AND w.WarehouseName LIKE ? " +
                 (locationId != null && locationId > 0 ? "AND l.LocationID = ? " : "") + // Thêm dòng này
                 "ORDER BY " + sortCol + " " + sortType + " " +
                 "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        int idx = 1;
        ps.setString(idx++, "%" + (productName == null ? "" : productName) + "%");
        ps.setString(idx++, "%" + (warehouseName == null ? "" : warehouseName) + "%");
        
        if (locationId != null && locationId > 0) {
            ps.setInt(idx++, locationId);
        }
        
        ps.setInt(idx++, (page - 1) * size);
        ps.setInt(idx++, size);
        
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            // ... (giữ nguyên phần mapping object như code cũ của bạn)
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
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}

// Sửa phương thức đếm tổng số bản ghi (phục vụ phân trang)
public int countCurrentStock(String productName, String warehouseName, Integer locationId) {
    String sql = "SELECT COUNT(*) FROM Location_Product lp " +
                 "JOIN Location l ON lp.LocationID = l.LocationID " +
                 "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID " +
                 "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID " +
                 "JOIN Product p ON pd.ProductID = p.ProductID " +
                 "WHERE p.Name LIKE ? AND w.WarehouseName LIKE ? " +
                 (locationId != null && locationId > 0 ? "AND l.LocationID = ? " : "");
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, "%" + (productName == null ? "" : productName) + "%");
        ps.setString(2, "%" + (warehouseName == null ? "" : warehouseName) + "%");
        if (locationId != null && locationId > 0) ps.setInt(3, locationId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) { e.printStackTrace(); }
    return 0;
}
    /**
     * Báo cáo biến động kho - Dùng Entity InventoryTransaction
     */
public List<InventoryTransaction> getStockMovement(Integer type, String fromDate, String toDate,
                                                   String txtSearch, int page, int size) {

    List<InventoryTransaction> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder(
        "SELECT it.TransactionID, it.TransactionType, it.Quantity, it.ReferenceCode, it.TransactionDate, " +
        "p.ProductID, p.Name AS ProductName, p.Code AS ProductCode, " +
        "pd.ProductDetailID, pd.LotNumber, pd.SerialNumber, " +
        "l.LocationID, l.LocationCode, " +
        "w.WarehouseID, w.WarehouseName " +
        "FROM Inventory_Transaction it " +
        "JOIN Product p ON it.ProductID = p.ProductID " +
        "JOIN Product_Detail pd ON it.ProductDetailID = pd.ProductDetailID " +
        "JOIN Location l ON it.LocationID = l.LocationID " +
        "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID " +
        "WHERE 1=1 "
    );

    if (type != null && type > 0)
        sql.append("AND it.TransactionType = ? ");

    if (fromDate != null && !fromDate.isEmpty())
        sql.append("AND it.TransactionDate >= ? ");

    if (toDate != null && !toDate.isEmpty())
        sql.append("AND it.TransactionDate <= ? ");

    if (txtSearch != null && !txtSearch.isEmpty())
        sql.append("AND (p.Name LIKE ? OR it.ReferenceCode LIKE ?) ");

    sql.append("ORDER BY it.TransactionDate DESC ");
    sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

        int idx = 1;

        if (type != null && type > 0)
            ps.setInt(idx++, type);

        if (fromDate != null && !fromDate.isEmpty())
            ps.setString(idx++, fromDate + " 00:00:00");

        if (toDate != null && !toDate.isEmpty())
            ps.setString(idx++, toDate + " 23:59:59");

        if (txtSearch != null && !txtSearch.isEmpty()) {
            String search = "%" + txtSearch + "%";
            ps.setString(idx++, search);
            ps.setString(idx++, search);
        }

        ps.setInt(idx++, (page - 1) * size); // OFFSET
        ps.setInt(idx++, size);              // FETCH

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            InventoryTransaction it = new InventoryTransaction();

            it.setId(rs.getInt("TransactionID"));
            it.setTransactionType(rs.getInt("TransactionType"));
            it.setQuantity(rs.getInt("Quantity"));
            it.setReferenceCode(rs.getString("ReferenceCode"));
            it.setTransactionDate(rs.getTimestamp("TransactionDate"));

            Product p = new Product();
            p.setId(rs.getInt("ProductID"));
            p.setName(rs.getString("ProductName"));
            p.setCode(rs.getString("ProductCode"));
            it.setProduct(p);

            ProductDetail pd = new ProductDetail();
            pd.setId(rs.getInt("ProductDetailID"));
            pd.setLotNumber(rs.getString("LotNumber"));
            pd.setSerialNumber(rs.getString("SerialNumber"));
            it.setProductDetail(pd);

            Location loc = new Location();
            loc.setId(rs.getInt("LocationID"));
            loc.setLocationCode(rs.getString("LocationCode"));
            loc.setWarehouseId(rs.getInt("WarehouseID")); // FIX BUG

            it.setLocation(loc);

            list.add(it);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}

public int countCurrentStock(String productName, String warehouseName) {
    String sql = "SELECT COUNT(*) FROM Location_Product lp " +
                 "JOIN Location l ON lp.LocationID = l.LocationID " +
                 "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID " +
                 "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID " +
                 "JOIN Product p ON pd.ProductID = p.ProductID " +
                 "WHERE p.Name LIKE ? AND w.WarehouseName LIKE ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, "%" + (productName == null ? "" : productName) + "%");
        ps.setString(2, "%" + (warehouseName == null ? "" : warehouseName) + "%");
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) { e.printStackTrace(); }
    return 0;
}

public int countStockMovement(Integer type, String fromDate, String toDate, String txtSearch) {
    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Inventory_Transaction it " +
                                           "JOIN Product p ON it.ProductID = p.ProductID WHERE 1=1 ");
    if (type != null && type > 0) sql.append("AND it.TransactionType = ? ");
    if (fromDate != null && !fromDate.isEmpty()) sql.append("AND it.TransactionDate >= ? ");
    if (toDate != null && !toDate.isEmpty()) sql.append("AND it.TransactionDate <= ? ");
    if (txtSearch != null && !txtSearch.isEmpty()) sql.append("AND (p.Name LIKE ? OR it.ReferenceCode LIKE ?) ");

    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
        int idx = 1;
        if (type != null && type > 0) ps.setInt(idx++, type);
        if (fromDate != null && !fromDate.isEmpty()) ps.setString(idx++, fromDate + " 00:00:00");
        if (toDate != null && !toDate.isEmpty()) ps.setString(idx++, toDate + " 23:59:59");
        if (txtSearch != null && !txtSearch.isEmpty()) {
            ps.setString(idx++, "%" + txtSearch + "%");
            ps.setString(idx++, "%" + txtSearch + "%");
        }
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) { e.printStackTrace(); }
    return 0;
}
    
}
