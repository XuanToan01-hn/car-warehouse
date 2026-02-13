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

/**
 * Screen quản lý Warehouse (kho).
 * - GET: hiển thị form + danh sách warehouse
 * - POST: tạo warehouse mới đơn giản.
 */
@WebServlet(name = "WarehouseServlet", urlPatterns = {"/warehouses"})
public class WarehouseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra nếu có action=delete
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    WarehouseDAO warehouseDAO = new WarehouseDAO();
                    warehouseDAO.delete(id);
                } catch (NumberFormatException e) {
                    // ignore
                }
            }
            response.sendRedirect(request.getContextPath() + "/warehouses");
            return;
        }

        WarehouseDAO warehouseDAO = new WarehouseDAO();
        List<Warehouse> warehouses = warehouseDAO.getAll();

        request.setAttribute("warehouses", warehouses);
        request.getRequestDispatcher("/view/warehouse.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("warehouseCode");
        String name = request.getParameter("warehouseName");
        String address = request.getParameter("address");
        String description = request.getParameter("description");

        Warehouse w = new Warehouse();
        w.setWarehouseCode(code);
        w.setWarehouseName(name);
        w.setAddress(address);
        w.setDescription(description);
        // createdAt để DB tự set GETDATE()

        WarehouseDAO warehouseDAO = new WarehouseDAO();
        warehouseDAO.insert(w);

        response.sendRedirect(request.getContextPath() + "/warehouses");
    }
}

