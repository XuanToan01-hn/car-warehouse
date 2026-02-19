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
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    LocationDAO locationDAO = new LocationDAO();
                    locationDAO.delete(id);
                } catch (NumberFormatException e) {
                }
            }
            response.sendRedirect(request.getContextPath() + "/locations");
            return;
        }

        LocationDAO locationDAO = new LocationDAO();
        WarehouseDAO warehouseDAO = new WarehouseDAO();

        List<Location> locations = locationDAO.getAll();
        List<Warehouse> warehouses = warehouseDAO.getAll();

        request.setAttribute("locations", locations);
        request.setAttribute("warehouses", warehouses);

        request.getRequestDispatcher("/view/location.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String warehouseIdRaw = request.getParameter("warehouseId");
        String locationCode = request.getParameter("locationCode");
        String locationName = request.getParameter("locationName");
        String parentLocationIdRaw = request.getParameter("parentLocationId");
        String locationType = request.getParameter("locationType");
        String maxCapacityRaw = request.getParameter("maxCapacity");

        Location location = new Location();
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
        locationDAO.insert(location);

        response.sendRedirect(request.getContextPath() + "/locations");
    }
}

