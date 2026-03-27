package controller.warehouse;

import dal.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Warehouse;

@WebServlet(name = "WarehouseServlet", urlPatterns = {"/warehouses"})
public class WarehouseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        WarehouseDAO dao = new WarehouseDAO();

        // Server-side search
        String search = request.getParameter("search");
        List<Warehouse> warehouses;
        if (search != null && !search.trim().isEmpty()) {
            warehouses = dao.search(search.trim());
            request.setAttribute("search", search.trim());
        } else {
            warehouses = dao.getAll();
        }
        request.setAttribute("warehouses", warehouses);

        // Edit mode: load the warehouse to be edited
        String mode = request.getParameter("mode");
        if ("edit".equals(mode)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    Warehouse editing = dao.getById(id);
                    request.setAttribute("editWarehouse", editing);
                    request.setAttribute("mode", "edit");
                } catch (NumberFormatException ignored) {}
            }
        } else if ("add".equals(mode)) {
            request.setAttribute("mode", "add");
        }

        request.getRequestDispatcher("/view/warehouse.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        WarehouseDAO dao = new WarehouseDAO();

        switch (action) {
            case "add": {
                String code = dao.getNextWarehouseCode();
                String name = trimParam(request.getParameter("warehouseName"));
                String address = trimParam(request.getParameter("address"));
                String description = trimParam(request.getParameter("description"));

                if (name.isEmpty() || !isValidName(name)) {
                    request.getSession().setAttribute("error", "Thêm kho không thành công. Tên kho phải là định dạng chữ hoặc số!");
                    response.sendRedirect(request.getContextPath() + "/warehouses");
                    return;
                }

                Warehouse w = new Warehouse();
                w.setWarehouseCode(code);
                w.setWarehouseName(name);
                w.setAddress(address);
                w.setDescription(description);
                dao.insert(w);
                request.getSession().setAttribute("success", "Thêm kho mới thành công!");
                break;
            }
            case "update": {
                String idRaw = request.getParameter("id");
                if (idRaw == null || idRaw.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/warehouses");
                    return;
                }
                int id;
                try {
                    id = Integer.parseInt(idRaw.trim());
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/warehouses");
                    return;
                }

                String code = trimParam(request.getParameter("warehouseCode"));
                String name = trimParam(request.getParameter("warehouseName"));
                String address = trimParam(request.getParameter("address"));
                String description = trimParam(request.getParameter("description"));

                if (name.isEmpty() || !isValidName(name)) {
                    request.getSession().setAttribute("error", "Cập nhật kho không thành công. Tên kho phải là định dạng chữ hoặc số!");
                    response.sendRedirect(request.getContextPath() + "/warehouses");
                    return;
                }

                if (code.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/warehouses");
                    return;
                }

                Warehouse w = new Warehouse();
                w.setId(id);
                w.setWarehouseCode(code);
                w.setWarehouseName(name);
                w.setAddress(address);
                w.setDescription(description);
                dao.update(w);
                request.getSession().setAttribute("success", "Cập nhật thông tin kho thành công!");
                break;
            }
            case "delete": {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.trim().isEmpty()) {
                    try {
                        int id = Integer.parseInt(idStr.trim());
                        
                        // Safeguard: Check if warehouse has locations
                        dal.LocationDAO locationDAO = new dal.LocationDAO();
                        List<model.Location> locations = locationDAO.getByWarehouseId(id);
                        
                        if (!locations.isEmpty()) {
                            request.getSession().setAttribute("error", "Không thể xóa kho vì vẫn còn vị trí bên trong!");
                        } else {
                            if (dao.delete(id)) {
                                request.getSession().setAttribute("success", "Xóa kho thành công!");
                            } else {
                                request.getSession().setAttribute("error", "Xóa kho thất bại. Vui lòng thử lại!");
                            }
                        }
                    } catch (NumberFormatException ignored) {
                    }
                }
                break;
            }
            default:
                break;
        }

        response.sendRedirect(request.getContextPath() + "/warehouses");
    }

    private boolean isValidName(String name) {
        // Only letters and spaces, including Vietnamese characters
        return name.matches("^[\\p{L}\\s\\d]+$"); // Warehouses might have numbers
    }

    private static String trimParam(String s) {
        return s == null ? "" : s.trim();
    }
}
