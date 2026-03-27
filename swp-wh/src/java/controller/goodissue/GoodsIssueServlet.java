
package controller.goodissue;

import dal.*;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.*;

@WebServlet(name = "GoodsIssueServlet", urlPatterns = {"/goods-issue"})
public class GoodsIssueServlet extends HttpServlet {

    private final GoodsIssueDAO giDAO = new GoodsIssueDAO();
    private final SalesOrderDAO soDAO = new SalesOrderDAO();
    private final LocationProductDAO lpDAO = new LocationProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listWarehouseOrders(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            default:
                listWarehouseOrders(request, response);
                break;
        }
    }

    private void listWarehouseOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SalesOrder> warehouseOrders = soDAO.getAll();
        request.setAttribute("orders", warehouseOrders);
        request.getRequestDispatcher("/view/good-issue/sales-order-staff-list.jsp").forward(request, response);
    }

private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        String idRaw = request.getParameter("soId");
        if (idRaw == null) {
            response.sendRedirect("goods-issue?action=list");
            return;
        }
        int soId = Integer.parseInt(idRaw);
        SalesOrder order = soDAO.getById(soId);

        if (order == null || order.getStatus() == 4 || order.getStatus() == 3) {
            response.sendRedirect("goods-issue?action=list");
            return;
        }

        // 2. Lấy Warehouse từ Sales Order (KHÔNG cho chọn thủ công nữa)
        int selectedWhId = (order.getWarehouse() != null) ? order.getWarehouse().getId() : 0;
        
        // Nếu là đơn hàng cũ không có Warehouse, lấy mặc định từ list (nếu cần)
        if (selectedWhId == 0) {
            List<Warehouse> allWhs = new WarehouseDAO().getAll();
            if (!allWhs.isEmpty()) selectedWhId = allWhs.get(0).getId();
        }

        // 3. Lấy danh sách Location thuộc Warehouse đó
        List<Location> locations = new LocationDAO().getByWarehouseId(selectedWhId);
        
        // 4. Xác định Location đang được chọn
        String locIdParam = request.getParameter("locationId");
        int selectedLocId = (locIdParam != null) ? Integer.parseInt(locIdParam)
                            : (locations.isEmpty() ? 0 : locations.get(0).getId());

        // 5. Lấy dữ liệu tồn kho theo Location đã chọn
        List<Object[]> uiDetails = giDAO.getDetailsForUI(soId, selectedLocId);

        request.setAttribute("order", order);
        request.setAttribute("selectedWhId", selectedWhId);
        request.setAttribute("locations", locations);
        request.setAttribute("selectedLocId", selectedLocId);
        request.setAttribute("uiDetails", uiDetails);
        
        request.getRequestDispatcher("/view/good-issue/goods-issue-create.jsp").forward(request, response);
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("goods-issue?action=list");
    }
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int soId = Integer.parseInt(request.getParameter("soId"));
        int locId = Integer.parseInt(request.getParameter("locationId"));
        String[] pdIds = request.getParameterValues("pdId");
        String[] shipQtys = request.getParameterValues("shipQty");

        SalesOrder order = soDAO.getById(soId);
        Map<Integer, SalesOrderDetail> orderMap = new HashMap<>();
        if (order.getDetails() != null) {
            for (SalesOrderDetail sod : order.getDetails()) {
                orderMap.put(sod.getProductDetail().getId(), sod);
            }
        }

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) user = new UserDAO().getById(1); // Fallback nếu session hết hạn

        GoodsIssue gi = new GoodsIssue();
        gi.setIssueCode("GIN-" + System.currentTimeMillis());
        gi.setSalesOrder(order);
        gi.setLocation(new Location());
        gi.getLocation().setId(locId);
        gi.setCreateBy(user);
        gi.setStatus(1); // Đã xuất

        List<GoodsIssueDetail> details = new ArrayList<>();
        List<String> errors = new ArrayList<>();

        if (pdIds != null && shipQtys != null) {
            for (int i = 0; i < pdIds.length; i++) {
                try {
                    int pdId = Integer.parseInt(pdIds[i]);
                    int qtyToShip = (shipQtys[i] == null || shipQtys[i].isEmpty()) ? 0 : Integer.parseInt(shipQtys[i]);

                    if (qtyToShip <= 0) continue;

                    SalesOrderDetail originalDetail = orderMap.get(pdId);
                    if (originalDetail == null) continue;

                    int remaining = originalDetail.getQuantity() - originalDetail.getDeliveredQty();
                    int stockAtLoc = lpDAO.getStockAtLocation(locId, pdId);

                    // Validation tập trung
                    if (qtyToShip > remaining) {
                        errors.add(originalDetail.getProductDetail().getProduct().getName() + ": Xuất quá số lượng nợ (" + remaining + ")");
                    }
                    if (qtyToShip > stockAtLoc) {
                        errors.add(originalDetail.getProductDetail().getProduct().getName() + ": Kho không đủ tồn (" + stockAtLoc + ")");
                    }

                    GoodsIssueDetail gid = new GoodsIssueDetail();
                    gid.setProductDetail(originalDetail.getProductDetail());
                    gid.setQuantityActual(qtyToShip);
                    gid.setQuantityExpected(remaining);
                    details.add(gid);
                } catch (NumberFormatException e) {
                    // Bỏ qua dòng nếu số lượng nhập sai định dạng
                }
            }
        }

        if (errors.isEmpty() && details.isEmpty()) {
            errors.add("Vui lòng nhập số lượng xuất cho ít nhất một sản phẩm.");
        }

        if (!errors.isEmpty()) {
            handleError(request, response, soId, locId, order, errors);
            return;
        }

        if (giDAO.confirmIssue(gi, details)) {
            response.sendRedirect("sales-order?action=warehouse-list");
        } else {
            errors.add("Lỗi hệ thống: Không thể lưu phiếu xuất. Vui lòng kiểm tra lại tồn kho hoặc nhật ký giao dịch.");
            handleError(request, response, soId, locId, order, errors);
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, int soId, int locId, SalesOrder order, List<String> errors) 
            throws ServletException, IOException {
        request.setAttribute("errors", errors);
        request.setAttribute("order", order);
        int whId = (order.getWarehouse() != null) ? order.getWarehouse().getId() : 0;
        request.setAttribute("locations", new LocationDAO().getByWarehouseId(whId));
        request.setAttribute("selectedLocId", locId);
        request.setAttribute("uiDetails", giDAO.getDetailsForUI(soId, locId));
        request.getRequestDispatcher("/view/good-issue/goods-issue-create.jsp").forward(request, response);
    }
}