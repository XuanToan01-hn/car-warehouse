package controller.transferInternal;

import dal.TransferDAO;
import dal.WarehouseDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TransferOrder;
import model.Warehouse;

@WebServlet(name = "WarehouseTransferServlet", urlPatterns = {"/warehouse-transfer"})
public class WarehouseTransferServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String statusStr = request.getParameter("status");
        String warehouseIdStr = request.getParameter("warehouseId");

        Integer status = (statusStr != null && !statusStr.isEmpty()) ? Integer.parseInt(statusStr) : null;
        Integer warehouseId = (warehouseIdStr != null && !warehouseIdStr.isEmpty()) ? Integer.parseInt(warehouseIdStr) : null;

        TransferDAO transferDAO = new TransferDAO();
        WarehouseDAO warehouseDAO = new WarehouseDAO();

        List<TransferOrder> transfers = transferDAO.getTransfers(code, status, warehouseId);
        List<Warehouse> warehouses = warehouseDAO.getAll();

        request.setAttribute("transfers", transfers);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedWarehouse", warehouseId);
        request.setAttribute("searchCode", code);

        request.getRequestDispatcher("/view/warehouse-transfer-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idStr = request.getParameter("transferId");

        if (idStr != null && !idStr.isEmpty()) {
            int transferId = Integer.parseInt(idStr);
            TransferDAO dao = new TransferDAO();
            boolean success = false;

            if ("transferOut".equals(action)) {
                success = dao.transferOut(transferId);
                if (success) {
                    request.getSession().setAttribute("msg", "Transfer Out successful!");
                } else {
                    request.getSession().setAttribute("err", "Transfer Out failed!");
                }
            } else if ("transferIn".equals(action)) {
                success = dao.transferIn(transferId);
                if (success) {
                    request.getSession().setAttribute("msg", "Transfer In successful!");
                } else {
                    request.getSession().setAttribute("err", "Transfer In failed!");
                }
            }
        }

        // Redirect back with current filters
        String code = request.getParameter("code");
        String status = request.getParameter("status");
        String warehouseId = request.getParameter("warehouseId");
        
        StringBuilder redirectUrl = new StringBuilder("warehouse-transfer?");
        if (code != null) redirectUrl.append("code=").append(code).append("&");
        if (status != null) redirectUrl.append("status=").append(status).append("&");
        if (warehouseId != null) redirectUrl.append("warehouseId=").append(warehouseId);
        response.sendRedirect(redirectUrl.toString());
    }
}
