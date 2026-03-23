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
        if (action == null) {
            action = "";
        }

        LocationDAO locationDAO = new LocationDAO();
        WarehouseDAO warehouseDAO = new WarehouseDAO();

        switch (action) {
            case "delete":
                handleDelete(request, response, locationDAO);
                break;
            case "viewDetail":
            case "getDetail":
                handleViewDetail(request, response, locationDAO);
                break;
            default:
                List<Location> locations = locationDAO.getAll();
                List<Warehouse> warehouses = warehouseDAO.getAll();
                request.setAttribute("locations", locations);
                request.setAttribute("warehouses", warehouses);
                request.getRequestDispatcher("/view/location.jsp").forward(request, response);
                break;
        }
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

            // Grouping logic
            Map<Integer, Map<String, Object>> groupedMap = new LinkedHashMap<>();
            int totalQty = 0;
            for (LocationProduct lp : rawProducts) {
                totalQty += lp.getQuantity();
                int pid = lp.getProduct().getId();
                if (!groupedMap.containsKey(pid)) {
                    Map<String, Object> group = new HashMap<>();
                    group.put("product", lp.getProduct());
                    group.put("totalQty", 0);
                    group.put("serials", new ArrayList<Map<String, Object>>());
                    groupedMap.put(pid, group);
                }
                Map<String, Object> group = groupedMap.get(pid);
                group.put("totalQty", (int) group.get("totalQty") + lp.getQuantity());
                
                if (lp.getProductDetail() != null && lp.getProductDetail().getSerialNumber() != null) {
                    Map<String, Object> serialInfo = new HashMap<>();
                    serialInfo.put("serial", lp.getProductDetail().getSerialNumber());
                    serialInfo.put("qty", lp.getQuantity());
                    serialInfo.put("color", lp.getProductDetail().getColor() != null ? lp.getProductDetail().getColor() : "");
                    ((List<Map<String, Object>>) group.get("serials")).add(serialInfo);
                }
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
            request.getSession().setAttribute("error", "Tên vị trí phải là định dạng chữ và số!");
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
