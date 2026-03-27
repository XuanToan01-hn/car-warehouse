
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
public class ReportDAO extends DBContext {
//    public static void main(String[] args) {
//    ReportDAO dao = new ReportDAO();
//
//    System.out.println("=== CASE 1: TẤT CẢ BIẾN ĐỘNG TRONG THÁNG 10/2024 (Trang 1) ===");
//    List<InventoryTransaction> list1 = dao.getStockMovement(0, "2024-10-01", "2026-10-31", "", 1, 10);
//    printReport(list1);
//
//    System.out.println("\n=== CASE 2: CHỈ LỌC PHIẾU XUẤT (Type=2) VÀ TÌM KIẾM 'IPHONE' ===");
//    // Giả sử Type 2 = ISSUE
//    List<InventoryTransaction> list2 = dao.getStockMovement(2, null, null, "Iphone", 1, 5);
//    printReport(list2);
//
//    System.out.println("\n=== CASE 3: KIỂM TRA PHÂN TRANG (Trang 2, mỗi trang 2 bản ghi) ===");
//    List<InventoryTransaction> list3 = dao.getStockMovement(0, null, null, null, 2, 2);
//    printReport(list3);
//}

    public static void main(String[] args) {
        ReportDAO dao = new ReportDAO();

        // --- TEST CẤP ĐỘ 1: TỔNG HỢP TOÀN HỆ THỐNG ---
        System.out.println("=== LEVEL 1: ALL PRODUCT DETAILS (GLOBAL QTY) ===");
        List<ProductDetail> allDetails = dao.getAllProductDetailsWithGlobalQty();

        if (allDetails.isEmpty()) {
            System.out.println("No data found in Product_Detail or Location_Product.");
        } else {
            System.out.printf("%-5s | %-20s | %-15s | %-10s\n", "ID", "Product Name", "Lot Number", "Total Qty");
            System.out.println("------------------------------------------------------------");
            for (ProductDetail pd : allDetails) {
                System.out.printf("%-5d | %-20s | %-15s | %-10d\n",
                        pd.getId(),
                        pd.getProduct().getName(),
                        pd.getLotNumber(),
                        pd.getQuantity());
            }

            // --- TEST CẤP ĐỘ 2: LẤY THEO NHÀ KHO (Lấy ID đầu tiên từ Level 1 để test) ---
            int testPdId = allDetails.get(0).getId();
            System.out.println("\n=== LEVEL 2: WAREHOUSES FOR PRODUCT DETAIL ID: " + testPdId + " ===");
            List<Warehouse> warehouses = dao.getWarehousesByProductDetail(testPdId);

            if (warehouses.isEmpty()) {
                System.out.println("This product detail is not stored in any warehouse.");
            } else {
                System.out.printf("%-5s | %-20s | %-10s\n", "W_ID", "Warehouse Name", "Qty in Wh");
                System.out.println("---------------------------------------------------");
                for (Warehouse w : warehouses) {
                    System.out.printf("%-5d | %-20s | %-10s\n",
                            w.getId(),
                            w.getWarehouseName(),
                            w.getDescription()); // Số lượng được tạm lưu ở description trong DAO trước đó
                }

                // --- TEST CẤP ĐỘ 3: LẤY THEO VỊ TRÍ (Lấy Warehouse ID đầu tiên từ Level 2 để test) ---
                int testWId = warehouses.get(0).getId();
                System.out.println("\n=== LEVEL 3: LOCATIONS IN WAREHOUSE " + testWId + " FOR DETAIL " + testPdId + " ===");
                List<Location> locations = dao.getLocationsByDetailInWarehouse(testPdId, testWId);

                if (locations.isEmpty()) {
                    System.out.println("No specific locations found.");
                } else {
                    System.out.printf("%-5s | %-15s | %-15s | %-10s\n", "L_ID", "Code", "Name", "Qty");
                    System.out.println("------------------------------------------------------------");
                    for (Location loc : locations) {
                        System.out.printf("%-5d | %-15s | %-15s | %-10d\n",
                                loc.getId(),
                                loc.getLocationCode(),
                                loc.getLocationName(),
                                loc.getCurrentStock());
                    }
                }
            }
        }
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

// CẤP ĐỘ 1: Lấy toàn bộ Product Detail và TỔNG số lượng của nó trong toàn hệ thống
    public List<ProductDetail> getAllProductDetailsWithGlobalQty() {
        List<ProductDetail> list = new ArrayList<>();
        String sql = "SELECT pd.ProductDetailID, pd.LotNumber, pd.SerialNumber, p.ProductID, p.Name, p.Code, "
                + "SUM(lp.Quantity) as GlobalQty "
                + "FROM Product_Detail pd "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "LEFT JOIN Location_Product lp ON pd.ProductDetailID = lp.ProductDetailID "
                + "GROUP BY pd.ProductDetailID, pd.LotNumber, pd.SerialNumber, p.ProductID, p.Name, p.Code";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setName(rs.getString("Name"));
                p.setCode(rs.getString("Code"));

                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setLotNumber(rs.getString("LotNumber"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                pd.setProduct(p);
                pd.setQuantity(rs.getInt("GlobalQty")); // Tổng lượng toàn hệ thống

                list.add(pd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 1. Báo cáo hàng sắp hết (Dùng Entity ProductDetail)
    public List<ProductDetail> getLowStockReport(int threshold) {
        List<ProductDetail> list = new ArrayList<>();
        String sql = "SELECT pd.ProductDetailID, pd.LotNumber, p.Name, p.Code, SUM(lp.Quantity) as Total "
                + "FROM Product_Detail pd "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "LEFT JOIN Location_Product lp ON pd.ProductDetailID = lp.ProductDetailID "
                + "GROUP BY pd.ProductDetailID, pd.LotNumber, p.Name, p.Code "
                + "HAVING SUM(lp.Quantity) < ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, threshold);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setName(rs.getString("Name"));
                p.setCode(rs.getString("Code"));

                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setLotNumber(rs.getString("LotNumber"));
                pd.setProduct(p);
                pd.setQuantity(rs.getInt("Total")); // Tận dụng field quantity có sẵn
                list.add(pd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// 2. Báo cáo Nhập/Xuất (Dùng Entity InventoryTransaction)
// Vì không dùng DTO, ta sẽ trả về list giao dịch đã được GROUP BY
    public List<InventoryTransaction> getSummaryMovement(int type, String from, String to) {
        List<InventoryTransaction> list = new ArrayList<>();
        String sql = "SELECT p.ProductID, p.Name, SUM(it.Quantity) as SubTotal "
                + "FROM Inventory_Transaction it "
                + "JOIN Product p ON it.ProductID = p.ProductID "
                + "WHERE it.TransactionType = ? AND it.TransactionDate BETWEEN ? AND ? "
                + "GROUP BY p.ProductID, p.Name";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, type);
            ps.setString(2, from + " 00:00:00");
            ps.setString(3, to + " 23:59:59");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setName(rs.getString("Name"));

                InventoryTransaction it = new InventoryTransaction();
                it.setProduct(p);
                it.setQuantity(rs.getInt("SubTotal")); // Chứa tổng số lượng nhập hoặc xuất
                it.setTransactionType(type);
                list.add(it);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // CẤP ĐỘ 2: Click vào Product Detail -> Lấy danh sách các Nhà kho chứa nó và số lượng tại mỗi kho
    public List<Warehouse> getWarehousesByProductDetail(int productDetailId) {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT w.WarehouseID, w.WarehouseName, w.WarehouseCode, SUM(lp.Quantity) as QtyInWarehouse "
                + "FROM Location_Product lp "
                + "JOIN Location l ON lp.LocationID = l.LocationID "
                + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
                + "WHERE lp.ProductDetailID = ? "
                + "GROUP BY w.WarehouseID, w.WarehouseName, w.WarehouseCode "
                + "HAVING SUM(lp.Quantity) > 0";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productDetailId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setId(rs.getInt("WarehouseID"));
                w.setWarehouseName(rs.getString("WarehouseName"));
                w.setWarehouseCode(rs.getString("WarehouseCode"));
                // Vì class Warehouse không có field quantity, bạn có thể cân nhắc dùng 
                // Description hoặc tạo một Wrapper class. Ở đây tôi dùng tạm Description để chứa Qty nếu bạn lười tạo class mới.
                w.setDescription(String.valueOf(rs.getInt("QtyInWarehouse")));
                list.add(w);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // CẤP ĐỘ 3: Click vào Nhà kho -> Lấy danh sách các Location (vị trí) cụ thể và số lượng trong đó
    public List<Location> getLocationsByDetailInWarehouse(int productDetailId, int warehouseId) {
        List<Location> list = new ArrayList<>();
        String sql = "SELECT l.LocationID, l.LocationCode, l.LocationName, lp.Quantity "
                + "FROM Location_Product lp "
                + "JOIN Location l ON lp.LocationID = l.LocationID "
                + "WHERE lp.ProductDetailID = ? AND l.WarehouseID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productDetailId);
            ps.setInt(2, warehouseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Location loc = new Location();
                loc.setId(rs.getInt("LocationID"));
                loc.setLocationCode(rs.getString("LocationCode"));
                loc.setLocationName(rs.getString("LocationName"));
                loc.setCurrentStock(rs.getInt("Quantity")); // Số lượng tại vị trí này
                list.add(loc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<LocationProduct> getProductStockDetails(int productId) {
        List<LocationProduct> list = new ArrayList<>();
        String sql = "SELECT lp.Quantity, l.LocationCode, l.LocationName, w.WarehouseName, "
                + "p.Name AS ProductName, p.Code AS ProductCode, pd.LotNumber "
                + "FROM Location_Product lp "
                + "JOIN Location l ON lp.LocationID = l.LocationID "
                + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
                + "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "WHERE p.ProductID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                LocationProduct lp = new LocationProduct();
                lp.setQuantity(rs.getInt("Quantity"));

                Location loc = new Location();
                loc.setLocationCode(rs.getString("LocationCode"));
                loc.setLocationName(rs.getString("LocationName"));
                loc.setWarehouseName(rs.getString("WarehouseName")); // Đảm bảo model Location có field này
                lp.setLocation(loc);

                Product p = new Product();
                p.setName(rs.getString("ProductName"));
                p.setCode(rs.getString("ProductCode"));
                lp.setProduct(p);

                ProductDetail pd = new ProductDetail();
                pd.setLotNumber(rs.getString("LotNumber"));
                lp.setProductDetail(pd);

                list.add(lp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// Sửa phương thức lấy danh sách
    public List<LocationProduct> getCurrentStock(String productName, String warehouseName, Integer locationId,
            int page, int size, String sortCol, String sortType) {
        List<LocationProduct> list = new ArrayList<>();
        if (sortCol == null || sortCol.isEmpty()) {
            sortCol = "p.Name";
        }
        if (sortType == null || sortType.isEmpty()) {
            sortType = "ASC";
        }

        // Thêm điều kiện lọc LocationID vào SQL
        String sql = "SELECT lp.Quantity, l.LocationID, l.LocationCode, l.LocationName, "
                + "w.WarehouseID, w.WarehouseName, p.ProductID, p.Code AS ProductCode, p.Name AS ProductName, "
                + "pd.ProductDetailID, pd.LotNumber, pd.SerialNumber "
                + "FROM Location_Product lp "
                + "JOIN Location l ON lp.LocationID = l.LocationID "
                + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
                + "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "WHERE p.Name LIKE ? AND w.WarehouseName LIKE ? "
                + (locationId != null && locationId > 0 ? "AND l.LocationID = ? " : "")
                + // Thêm dòng này
                "ORDER BY " + sortCol + " " + sortType + " "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// Sửa phương thức đếm tổng số bản ghi (phục vụ phân trang)
    public int countCurrentStock(String productName, String warehouseName, Integer locationId) {
        String sql = "SELECT COUNT(*) FROM Location_Product lp "
                + "JOIN Location l ON lp.LocationID = l.LocationID "
                + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
                + "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "WHERE p.Name LIKE ? AND w.WarehouseName LIKE ? "
                + (locationId != null && locationId > 0 ? "AND l.LocationID = ? " : "");
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + (productName == null ? "" : productName) + "%");
            ps.setString(2, "%" + (warehouseName == null ? "" : warehouseName) + "%");
            if (locationId != null && locationId > 0) {
                ps.setInt(3, locationId);
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

    /**
     * Báo cáo biến động kho - Dùng Entity InventoryTransaction
     */
    public List<InventoryTransaction> getStockMovement(Integer type, String fromDate, String toDate,
            String txtSearch, int page, int size) {

        List<InventoryTransaction> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT it.TransactionID, it.TransactionType, it.Quantity, it.ReferenceCode, it.TransactionDate, "
                + "p.ProductID, p.Name AS ProductName, p.Code AS ProductCode, "
                + "pd.ProductDetailID, pd.LotNumber, pd.SerialNumber, "
                + "l.LocationID, l.LocationCode, "
                + "w.WarehouseID, w.WarehouseName "
                + "FROM Inventory_Transaction it "
                + "JOIN Product p ON it.ProductID = p.ProductID "
                + "JOIN Product_Detail pd ON it.ProductDetailID = pd.ProductDetailID "
                + "JOIN Location l ON it.LocationID = l.LocationID "
                + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
                + "WHERE 1=1 "
        );

        if (type != null && type > 0) {
            sql.append("AND it.TransactionType = ? ");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND it.TransactionDate >= ? ");
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND it.TransactionDate <= ? ");
        }

        if (txtSearch != null && !txtSearch.isEmpty()) {
            sql.append("AND (p.Name LIKE ? OR it.ReferenceCode LIKE ?) ");
        }

        sql.append("ORDER BY it.TransactionDate DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            int idx = 1;

            if (type != null && type > 0) {
                ps.setInt(idx++, type);
            }

            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(idx++, fromDate + " 00:00:00");
            }

            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(idx++, toDate + " 23:59:59");
            }

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
        String sql = "SELECT COUNT(*) FROM Location_Product lp "
                + "JOIN Location l ON lp.LocationID = l.LocationID "
                + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
                + "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "WHERE p.Name LIKE ? AND w.WarehouseName LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + (productName == null ? "" : productName) + "%");
            ps.setString(2, "%" + (warehouseName == null ? "" : warehouseName) + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countStockMovement(Integer type, String fromDate, String toDate, String txtSearch) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Inventory_Transaction it "
                + "JOIN Product p ON it.ProductID = p.ProductID WHERE 1=1 ");
        if (type != null && type > 0) {
            sql.append("AND it.TransactionType = ? ");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append("AND it.TransactionDate >= ? ");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append("AND it.TransactionDate <= ? ");
        }
        if (txtSearch != null && !txtSearch.isEmpty()) {
            sql.append("AND (p.Name LIKE ? OR it.ReferenceCode LIKE ?) ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (type != null && type > 0) {
                ps.setInt(idx++, type);
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(idx++, fromDate + " 00:00:00");
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(idx++, toDate + " 23:59:59");
            }
            if (txtSearch != null && !txtSearch.isEmpty()) {
                ps.setString(idx++, "%" + txtSearch + "%");
                ps.setString(idx++, "%" + txtSearch + "%");
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
    // CẤP ĐỘ 1: Lấy danh sách Product Detail có Search và Phân trang (OFFSET/FETCH)

    public List<ProductDetail> getGlobalStockPaged(String txtSearch, int page, int size) {
        List<ProductDetail> list = new ArrayList<>();
        // Sử dụng LEFT JOIN để hiện cả SP chưa có trong kho nếu cần, 
        // hoặc JOIN nếu chỉ muốn hiện SP đang có hàng.
        String sql = "SELECT pd.ProductDetailID, pd.LotNumber, pd.SerialNumber, p.ProductID, p.Name, p.Code, "
                + "SUM(ISNULL(lp.Quantity, 0)) as GlobalQty "
                + "FROM Product_Detail pd "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "LEFT JOIN Location_Product lp ON pd.ProductDetailID = lp.ProductDetailID "
                + "WHERE p.Name LIKE ? OR p.Code LIKE ? OR pd.LotNumber LIKE ? "
                + "GROUP BY pd.ProductDetailID, pd.LotNumber, pd.SerialNumber, p.ProductID, p.Name, p.Code "
                + "ORDER BY p.Name ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String search = "%" + (txtSearch == null ? "" : txtSearch) + "%";
            ps.setString(1, search);
            ps.setString(2, search);
            ps.setString(3, search);
            ps.setInt(4, (page - 1) * size);
            ps.setInt(5, size);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setName(rs.getString("Name"));
                p.setCode(rs.getString("Code"));

                ProductDetail pd = new ProductDetail();
                pd.setId(rs.getInt("ProductDetailID"));
                pd.setLotNumber(rs.getString("LotNumber"));
                pd.setSerialNumber(rs.getString("SerialNumber"));
                pd.setProduct(p);
                pd.setQuantity(rs.getInt("GlobalQty"));
                list.add(pd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// Đếm tổng số bản ghi ProductDetail để chia trang
    public int countGlobalStock(String txtSearch) {
        String sql = "SELECT COUNT(DISTINCT pd.ProductDetailID) FROM Product_Detail pd "
                + "JOIN Product p ON pd.ProductID = p.ProductID "
                + "WHERE p.Name LIKE ? OR p.Code LIKE ? OR pd.LotNumber LIKE ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String search = "%" + (txtSearch == null ? "" : txtSearch) + "%";
            ps.setString(1, search);
            ps.setString(2, search);
            ps.setString(3, search);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
public List<ProductDetail> getInventoryFlatReport(String txtSearch, int page, int size) {
    List<ProductDetail> list = new ArrayList<>();

    String sql = "SELECT p.Name, p.Code, "
               + "pd.ProductDetailID, pd.LotNumber, pd.Color, "
               + "w.WarehouseName, l.LocationCode, "
               + "lp.Quantity "
               + "FROM Location_Product lp "
               + "JOIN Product_Detail pd ON lp.ProductDetailID = pd.ProductDetailID "
               + "JOIN Product p ON pd.ProductID = p.ProductID "
               + "JOIN Location l ON lp.LocationID = l.LocationID "
               + "JOIN Warehouse w ON l.WarehouseID = w.WarehouseID "
               + "WHERE p.Name LIKE ? OR p.Code LIKE ? OR pd.LotNumber LIKE ? "
               + "ORDER BY p.Name ASC "
               + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        String search = "%" + (txtSearch == null ? "" : txtSearch) + "%";
        ps.setString(1, search);
        ps.setString(2, search);
        ps.setString(3, search);
        ps.setInt(4, (page - 1) * size);
        ps.setInt(5, size);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Product p = new Product();
            p.setName(rs.getString("Name"));
            p.setCode(rs.getString("Code"));

            Location loc = new Location();
            loc.setWarehouseName(rs.getString("WarehouseName"));
            loc.setLocationCode(rs.getString("LocationCode"));

            ProductDetail pd = new ProductDetail();
            pd.setId(rs.getInt("ProductDetailID"));
            pd.setLotNumber(rs.getString("LotNumber"));
            pd.setColor(rs.getString("Color"));    // <-- từ Product_Detail
            pd.setQuantity(rs.getInt("Quantity")); // <-- từ Location_Product
            pd.setProduct(p);
            pd.setLocation(loc);

            list.add(pd);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

}
