package controller.location;

import dal.LocationDAO;
import dal.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;
import model.Location;
import model.Warehouse;
import model.LocationProduct;

@WebServlet(name = "LocationServlet", urlPatterns = {"/locations"})
public class LocationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        LocationDAO locationDAO = new LocationDAO();
        WarehouseDAO warehouseDAO = new WarehouseDAO();

        switch (action) {
            case "viewDetail":
            case "getDetail":
                handleViewDetail(request, response, locationDAO);
                return;
            default:
                break;
        }

        // Load warehouses for filter dropdown
        List<Warehouse> warehouses = warehouseDAO.getAll();
        request.setAttribute("warehouses", warehouses);

        // Resolve warehouseId filter
        String whIdStr = request.getParameter("warehouseId");
        int warehouseId = 0;
        if (whIdStr != null && !whIdStr.trim().isEmpty()) {
            try { warehouseId = Integer.parseInt(whIdStr.trim()); } catch (NumberFormatException ignored) {}
        }
        // Default to first warehouse if none selected
        if (warehouseId == 0 && !warehouses.isEmpty()) {
            warehouseId = warehouses.get(0).getId();
        }
        request.setAttribute("selectedWarehouseId", warehouseId);

        // Search keyword
        String search = request.getParameter("search");
        String keyword = (search != null) ? search.trim() : "";
        request.setAttribute("search", keyword);

        // Load filtered locations
        List<Location> locations = locationDAO.search(warehouseId, keyword);
        request.setAttribute("locations", locations);

        // Edit mode
        String mode = request.getParameter("mode");
        if ("edit".equals(mode)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    Location editing = locationDAO.getById(id);
                    request.setAttribute("editLocation", editing);
                    request.setAttribute("mode", "edit");
                } catch (NumberFormatException ignored) {}
            }
        } else if ("add".equals(mode)) {
            request.setAttribute("mode", "add");
        }

        request.getRequestDispatcher("/view/location.jsp").forward(request, response);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, LocationDAO dao)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                dao.delete(id);
                request.getSession().setAttribute("success", "Xóa vị trí thành công!");
            } catch (NumberFormatException ignored) {
            }
        }
        response.sendRedirect(request.getContextPath() + "/locations");
    }

    private void handleViewDetail(HttpServletRequest request, HttpServletResponse response, LocationDAO dao)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/locations");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            Location loc = dao.getById(id);
            if (loc == null) {
                response.sendRedirect(request.getContextPath() + "/locations");
                return;
            }

            List<LocationProduct> rawProducts = dao.getProductsByLocation(id);

            // Grouping logic (Simplified: Model + Color)
            Map<String, Map<String, Object>> groupedMap = new LinkedHashMap<>();
            int totalQty = 0;
            for (LocationProduct lp : rawProducts) {
                totalQty += lp.getQuantity();
                int pid = lp.getProduct().getId();
                String color = (lp.getProductDetail() != null && lp.getProductDetail().getColor() != null) 
                               ? lp.getProductDetail().getColor() : "N/A";
                
                String key = pid + "_" + color;
                
                if (!groupedMap.containsKey(key)) {
                    Map<String, Object> group = new HashMap<>();
                    group.put("product", lp.getProduct());
                    group.put("color", color);
                    group.put("totalQty", 0);
                    groupedMap.put(key, group);
                }
                Map<String, Object> group = groupedMap.get(key);
                group.put("totalQty", (int) group.get("totalQty") + lp.getQuantity());
            }

            List<Map<String, Object>> allGroupedProducts = new ArrayList<>(groupedMap.values());

            // Pagination Logic
            int pageSize = 5;
            String pageStr = request.getParameter("page");
            int currentPage = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
            int totalProducts = allGroupedProducts.size();
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            int start = (currentPage - 1) * pageSize;
            int end = Math.min(start + pageSize, totalProducts);

            List<Map<String, Object>> pagedProducts = new ArrayList<>();
            if (start < totalProducts) {
                pagedProducts = allGroupedProducts.subList(start, end);
            }

            request.setAttribute("loc", loc);
            request.setAttribute("totalQty", totalQty);
            request.setAttribute("pagedProducts", pagedProducts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/view/location-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/locations");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        LocationDAO dao = new LocationDAO();

        switch (action) {
            case "add":
            case "update":
                handleUpsert(request, response, dao, action);
                break;
            case "delete":
                handleDelete(request, response, dao);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/locations");
                break;
        }
    }

    private void handleUpsert(HttpServletRequest request, HttpServletResponse response, LocationDAO dao, String action)
            throws IOException {
        String idRaw = request.getParameter("id");
        String warehouseIdRaw = request.getParameter("warehouseId");
        String locationCode = trimParam(request.getParameter("locationCode"));
        String locationName = trimParam(request.getParameter("locationName"));
        String maxCapacityRaw = request.getParameter("maxCapacity");

        if (locationName.isEmpty() || !isValidName(locationName)) {
            String prefix = "add".equals(action) ? "Thêm vị trí" : "Cập nhật vị trí";
            request.getSession().setAttribute("error", prefix + " không thành công. Tên vị trí phải là định dạng chữ và số!");
            response.sendRedirect(request.getContextPath() + "/locations");
            return;
        }

        Location location = new Location();
        if (idRaw != null && !idRaw.trim().isEmpty()) {
            try {
                location.setId(Integer.parseInt(idRaw.trim()));
            } catch (NumberFormatException ignored) {}
        }

        try {
            location.setWarehouseId(Integer.parseInt(warehouseIdRaw));
        } catch (NumberFormatException e) {
            location.setWarehouseId(0);
        }

        location.setLocationCode(locationCode);
        location.setLocationName(locationName);

        if (maxCapacityRaw != null && !maxCapacityRaw.trim().isEmpty()) {
            try {
                location.setMaxCapacity(Integer.parseInt(maxCapacityRaw.trim()));
            } catch (NumberFormatException e) {
                location.setMaxCapacity(null);
            }
        }

        if ("update".equals(action)) {
            dao.update(location);
            request.getSession().setAttribute("success", "Cập nhật vị trí thành công!");
        } else {
            dao.insert(location);
            request.getSession().setAttribute("success", "Thêm vị trí mới thành công!");
        }

        response.sendRedirect(request.getContextPath() + "/locations");
    }

    private boolean isValidName(String name) {
        return name.matches("^[\\p{L}\\s\\d\\-]+$");
    }

    private static String trimParam(String s) {
        return s == null ? "" : s.trim();
    }
}
