package controller.purchase;

import dal.PurchaseOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.PurchaseOrder;

@WebServlet(name = "ListPurchaseOrderServlet", urlPatterns = { "/purchase-orders" })
public class ListPurchaseOrderServlet extends HttpServlet {

    private static final int PAGE_SIZE = 8;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Create new DAO per request to avoid null connection from field-level caching
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();

        String keyword = request.getParameter("search");
        if (keyword == null)
            keyword = "";

        String statusParam = request.getParameter("status");
        int status = 0; // 0 = all
        try {
            if (statusParam != null)
                status = Integer.parseInt(statusParam);
        } catch (NumberFormatException e) {
            status = 0;
        }

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
            page = 1;
        }
        if (page < 1)
            page = 1;

        // Get logged in user to check role and warehouse
        model.User user = (model.User) request.getSession().getAttribute("user");
        int warehouseId = 0; // 0 = all (Admin/Manager)
        if (user != null && user.getRole() != null && (user.getRole().getId() == 3 || user.getRole().getId() == 5)) {
            if (user.getWarehouse() != null) {
                warehouseId = user.getWarehouse().getId();
            }
        }

        int offset = (page - 1) * PAGE_SIZE;
        List<PurchaseOrder> list = poDAO.searchAndPaginate(keyword, status, offset, PAGE_SIZE, warehouseId);
        int total = poDAO.count(keyword, status, warehouseId);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        request.setAttribute("poList", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", keyword);
        request.setAttribute("statusFilter", status);

        request.getRequestDispatcher("/view/purchase/page-list-purchase-order.jsp")
                .forward(request, response);
    }
}