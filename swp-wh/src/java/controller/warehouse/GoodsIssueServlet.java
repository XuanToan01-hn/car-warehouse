package controller.warehouse;

import dal.*;
import model.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "GoodsIssueServlet", urlPatterns = {"/goods-issue"})
public class GoodsIssueServlet extends HttpServlet {

    private final GoodsIssueDAO goodsIssueDAO = new GoodsIssueDAO();
    private final SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
    private final LocationDAO locationDAO = new LocationDAO();
    private final ProductDetailDAO productDetailDAO = new ProductDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listOrders(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            default:
                listOrders(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("confirm".equals(action)) {
            processConfirm(request, response);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SalesOrder> orders = goodsIssueDAO.getOrdersForIssue();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/view/goods-issue-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int soId = Integer.parseInt(request.getParameter("soId"));
            int locationId = 0;
            if (request.getParameter("locationId") != null) {
                locationId = Integer.parseInt(request.getParameter("locationId"));
            }

            SalesOrder so = salesOrderDAO.getById(soId);
            List<Location> locations = locationDAO.getAll();

            request.setAttribute("order", so);
            request.setAttribute("locations", locations);
            request.setAttribute("selectedLocationId", locationId);

            // Always fetch details for display in Order Info step
            request.setAttribute("details", goodsIssueDAO.getDetailsForUI(soId, locationId));

            request.getRequestDispatcher("/view/goods-issue-create.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("goods-issue?action=list");
        }
    }

    private void processConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        // Fallback for dev if session is empty (should ideally redirect to login)
        if (user == null) user = new UserDAO().getById(1);

        try {
            int soId = Integer.parseInt(request.getParameter("soId"));
            int locationId = Integer.parseInt(request.getParameter("locationId"));
            String note = request.getParameter("note");
            String issueCode = "GI-" + System.currentTimeMillis();

            GoodsIssue gi = new GoodsIssue();
            gi.setIssueCode(issueCode);
            gi.setSalesOrder(salesOrderDAO.getById(soId));
            gi.setLocation(locationDAO.getById(locationId));
            gi.setStatus(1); // Confirmed
            gi.setNote(note);
            gi.setCreateBy(user);

            String[] pdIds = request.getParameterValues("productDetailId");
            String[] qtyActuals = request.getParameterValues("qtyActual");
            String[] remainingQtys = request.getParameterValues("remainingQty");

            List<GoodsIssueDetail> details = new ArrayList<>();
            for (int i = 0; i < pdIds.length; i++) {
                int qtyActual = Integer.parseInt(qtyActuals[i]);
                if (qtyActual > 0) {
                    GoodsIssueDetail gid = new GoodsIssueDetail();
                    gid.setProductDetail(productDetailDAO.getById(Integer.parseInt(pdIds[i])));
                    gid.setQuantityExpected(Integer.parseInt(remainingQtys[i]));
                    gid.setQuantityActual(qtyActual);
                    details.add(gid);
                }
            }

            if (!details.isEmpty() && goodsIssueDAO.confirmIssue(gi, details)) {
                response.sendRedirect("goods-issue?action=list&msg=success");
            } else {
                response.sendRedirect("goods-issue?action=create&soId=" + soId + "&locationId=" + locationId + "&msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("goods-issue?action=list&msg=error");
        }
    }
}
