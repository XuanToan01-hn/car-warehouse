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
import model.TransferOrderDetail;
import model.Warehouse;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

@WebServlet(name = "WarehouseTransferServlet", urlPatterns = { "/warehouse-transfer" })
public class WarehouseTransferServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                TransferDAO transferDAO = new TransferDAO();
                List<TransferOrder> orders = transferDAO.getTransfersById(id);
                if (!orders.isEmpty()) {
                    dal.ProductDetailDAO pdDAO = new dal.ProductDetailDAO();
                    List<Map<String, Object>> productDetailsList = new ArrayList<>();
                    int totalQty = 0;
                    for (TransferOrder to : orders) {
                        model.ProductDetail pd = pdDAO.getById(to.getProductDetailId());
                        String pName = (pd != null && pd.getProduct() != null)
                                ? "[" + pd.getSerialNumber() + "] " + pd.getProduct().getName() + " - " + pd.getColor()
                                : "Unknown Product #" + to.getProductDetailId();

                        Map<String, Object> map = new HashMap<>();
                        map.put("name", pName);
                        map.put("qty", to.getQuantity());
                        productDetailsList.add(map);
                        totalQty += to.getQuantity();
                    }

                    request.setAttribute("t", orders.get(0));
                    request.setAttribute("productList", productDetailsList);
                    request.setAttribute("totalQuantity", totalQty);
                    request.getRequestDispatcher("/view/internal/transfer-detail.jsp").forward(request, response);
                    return;
                }
            }
        }

        String code = request.getParameter("code");
        String statusStr = request.getParameter("status");
        String warehouseIdStr = request.getParameter("warehouseId");
        String type = request.getParameter("type");
        String pageStr = request.getParameter("page");

        Integer status = (statusStr != null && !statusStr.isEmpty()) ? Integer.parseInt(statusStr) : null;
        Integer warehouseId = (warehouseIdStr != null && !warehouseIdStr.isEmpty()) ? Integer.parseInt(warehouseIdStr)
                : null;
        int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;
        int pageSize = 5;

        TransferDAO transferDAO = new TransferDAO();
        dal.WarehouseDAO warehouseDAO = new dal.WarehouseDAO();

        List<TransferOrder> transfers = transferDAO.getTransfersPaged(code, status, warehouseId, type, null, null, null,
                page, pageSize);
        int totalTransfers = transferDAO.getTransfersCount(code, status, warehouseId, type, null, null, null);
        int totalPages = (int) Math.ceil((double) totalTransfers / pageSize);
        List<model.Warehouse> warehouses = warehouseDAO.getAll();

        request.setAttribute("transfers", transfers);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedWarehouse", warehouseId);
        request.setAttribute("searchCode", code);
        request.setAttribute("selectedType", type);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Construct base filter URL for pagination links
        StringBuilder baseUrl = new StringBuilder("warehouse-transfer?");
        if (code != null)
            baseUrl.append("code=").append(code).append("&");
        if (statusStr != null)
            baseUrl.append("status=").append(statusStr).append("&");
        if (warehouseIdStr != null)
            baseUrl.append("warehouseId=").append(warehouseIdStr).append("&");
        if (type != null)
            baseUrl.append("type=").append(type).append("&");
        request.setAttribute("baseUrl", baseUrl.toString());

        request.getRequestDispatcher("/view/internal/warehouse-transfer-list.jsp").forward(request, response);
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
        if (code != null)
            redirectUrl.append("code=").append(code).append("&");
        if (status != null)
            redirectUrl.append("status=").append(status).append("&");
        if (warehouseId != null)
            redirectUrl.append("warehouseId=").append(warehouseId);

        response.sendRedirect(redirectUrl.toString());
    }
}
