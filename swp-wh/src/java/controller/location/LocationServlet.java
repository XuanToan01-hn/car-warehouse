package controller.location;

import dal.LocationDAO;
import dal.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Location;
import model.Warehouse;
@WebServlet(name = "LocationServlet", urlPatterns = {"/locations"})
public class LocationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("[DEBUG] LocationServlet action: " + action);
        LocationDAO locationDAO = new LocationDAO();
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        try {

        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    locationDAO.delete(id);
                } catch (NumberFormatException e) {
                }
            }
            response.sendRedirect(request.getContextPath() + "/locations");
            return;
        } else if ("getDetail".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                model.Location loc = locationDAO.getById(id);
                List<model.LocationProduct> rawProducts = locationDAO.getProductsByLocation(id);
                
                // Grouping logic for UI
                java.util.Map<Integer, java.util.Map<String, Object>> groupedMap = new java.util.LinkedHashMap<>();
                for (model.LocationProduct lp : rawProducts) {
                    int pid = lp.getProduct().getId();
                    if (!groupedMap.containsKey(pid)) {
                        java.util.Map<String, Object> group = new java.util.HashMap<>();
                        group.put("product", lp.getProduct());
                        group.put("totalQty", 0);
                        group.put("serials", new java.util.ArrayList<java.util.Map<String, Object>>());
                        groupedMap.put(pid, group);
                    }
                    java.util.Map<String, Object> group = groupedMap.get(pid);
                    group.put("totalQty", (int)group.get("totalQty") + lp.getQuantity());
                    if (lp.getProductDetail() != null && lp.getProductDetail().getSerialNumber() != null) {
                        java.util.Map<String, Object> serialInfo = new java.util.HashMap<>();
                        serialInfo.put("serial", lp.getProductDetail().getSerialNumber());
                        serialInfo.put("qty", lp.getQuantity());
                        serialInfo.put("color", lp.getProductDetail().getColor() != null ? lp.getProductDetail().getColor() : "");
                        ((java.util.List<java.util.Map<String, Object>>)group.get("serials")).add(serialInfo);
                    }
                }
                
                request.setAttribute("loc", loc);
                request.setAttribute("groupedProducts", groupedMap.values());
                request.getRequestDispatcher("/view/location-detail-fragment.jsp").forward(request, response);
                return;
            }
        } else if ("getDetailJson".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Location l = locationDAO.getById(id);
                if (l != null) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    String codeJson = l.getLocationCode() != null ? l.getLocationCode().replace("\"", "\\\"") : "";
                    String nameJson = l.getLocationName() != null ? l.getLocationName().replace("\"", "\\\"") : "";
                    int capJson = l.getMaxCapacity() != null ? l.getMaxCapacity() : 0;

                    String json = String.format("{\"id\": %d, \"whId\": %d, \"code\": \"%s\", \"name\": \"%s\", \"capacity\": %d}",
                        l.getId(), l.getWarehouseId(), codeJson, nameJson, capJson);
                    response.getWriter().write(json);
                    return;
                }
            }
        }

        List<Location> locations = locationDAO.getAll();
        List<Warehouse> warehouses = warehouseDAO.getAll();

        request.setAttribute("locations", locations);
        request.setAttribute("warehouses", warehouses);

        request.getRequestDispatcher("/view/location.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[CRITICAL] LocationServlet Error: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String warehouseIdRaw = request.getParameter("warehouseId");
        String locationCode = request.getParameter("locationCode");
        String locationName = request.getParameter("locationName");
        String maxCapacityRaw = request.getParameter("maxCapacity");
        String idRaw = request.getParameter("id");

        Location location = new Location();
        if (idRaw != null && !idRaw.isEmpty()) {
            location.setId(Integer.parseInt(idRaw));
        }

        try {
            int warehouseId = Integer.parseInt(warehouseIdRaw);
            location.setWarehouseId(warehouseId);
        } catch (NumberFormatException e) {
            location.setWarehouseId(0);
        }

        location.setLocationCode(locationCode);
        location.setLocationName(locationName);

        if (maxCapacityRaw != null && !maxCapacityRaw.trim().isEmpty()) {
            try {
                location.setMaxCapacity(Integer.parseInt(maxCapacityRaw));
            } catch (NumberFormatException e) {
                location.setMaxCapacity(null);
            }
        }

        LocationDAO locationDAO = new LocationDAO();
        if ("update".equals(action)) {
            locationDAO.update(location);
        } else {
            locationDAO.insert(location);
        }

        response.sendRedirect(request.getContextPath() + "/locations");
    }
}

