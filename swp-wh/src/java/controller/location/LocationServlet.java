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
                Location loc = locationDAO.getByIdWithFullContext(id);
                List<model.LocationProduct> products = locationDAO.getProductsByLocation(id);
                
                request.setAttribute("loc", loc);
                request.setAttribute("products", products);
                request.getRequestDispatcher("/view/location-detail-fragment.jsp").forward(request, response);
                return;
            }
        } else if ("getParents".equals(action)) {
            String whIdStr = request.getParameter("whId");
            String type = request.getParameter("type");
            if (whIdStr != null && type != null) {
                int whId = Integer.parseInt(whIdStr);
                List<Location> parents = locationDAO.getPotentialParents(whId, type);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                StringBuilder msg = new StringBuilder("[");
                for (int i = 0; i < parents.size(); i++) {
                    Location p = parents.get(i);
                    String code = p.getLocationCode() != null ? p.getLocationCode().replace("\"", "\\\"") : "";
                    String name = p.getLocationName() != null ? p.getLocationName().replace("\"", "\\\"") : "";
                    msg.append(String.format("{\"id\": %d, \"code\": \"%s\", \"name\": \"%s\"}", 
                        p.getId(), code, name));
                    if (i < parents.size() - 1) msg.append(",");
                }
                msg.append("]");
                response.getWriter().write(msg.toString());
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
                    String typeJson = l.getLocationType() != null ? l.getLocationType().trim().split(" ")[0].toUpperCase() : "UNKNOWN";
                    String codeJson = l.getLocationCode() != null ? l.getLocationCode().replace("\"", "\\\"") : "";
                    String nameJson = l.getLocationName() != null ? l.getLocationName().replace("\"", "\\\"") : "";
                    String pIdJson = (l.getParentLocationId() == null ? "null" : l.getParentLocationId().toString());
                    int capJson = l.getMaxCapacity() != null ? l.getMaxCapacity() : 0;

                    String json = String.format("{\"id\": %d, \"whId\": %d, \"type\": \"%s\", \"code\": \"%s\", \"name\": \"%s\", \"parentId\": %s, \"capacity\": %d}",
                        l.getId(), l.getWarehouseId(), typeJson, codeJson, nameJson, pIdJson, capJson);
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
        String parentLocationIdRaw = request.getParameter("parentLocationId");
        String locationType = request.getParameter("locationType");
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

        if (parentLocationIdRaw != null && !parentLocationIdRaw.trim().isEmpty()) {
            try {
                location.setParentLocationId(Integer.parseInt(parentLocationIdRaw));
            } catch (NumberFormatException e) {
                location.setParentLocationId(null);
            }
        }

        location.setLocationType(locationType);

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

