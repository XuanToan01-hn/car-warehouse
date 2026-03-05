package controller.purchase;

import dal.PurchaseOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.PurchaseOrder;
import model.User;

@WebServlet(name = "DetailPurchaseOrderServlet", urlPatterns = { "/detail-purchase-order" })
public class DetailPurchaseOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            PurchaseOrder po = poDAO.getById(id);
            if (po == null) {
                response.sendRedirect(request.getContextPath() + "/purchase-orders");
                return;
            }
            request.setAttribute("po", po);
            request.getRequestDispatcher("/view/purchase/page-detail-purchase-order.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/purchase-orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null || currentUser.getRole() == null) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders?error=unauthorized");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int newStatus = Integer.parseInt(request.getParameter("status"));

            PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
            PurchaseOrder po = poDAO.getById(id);

            if (po == null) {
                response.sendRedirect(request.getContextPath() + "/purchase-orders");
                return;
            }

            int currentRole = currentUser.getRole().getId();

            // Authorization logic:
            // - Draft (status 1) -> Confirmed (status 2): Only Manager (role 2) can do Confirm/Cancel
            // - Confirmed (status 2) -> Received (status 3) or Cancelled (status 4): Only Staff (role 3) can do Mark Received/Cancel

            boolean authorized = false;

            if (po.getStatus() == 1) {
                // Draft: only manager can approve or cancel
                authorized = (currentRole == 2);
            } else if (po.getStatus() == 2) {
                // Confirmed: only staff can mark received or cancel
                authorized = (currentRole == 3);
            }

            if (!authorized) {
                response.sendRedirect(request.getContextPath() + "/purchase-orders?error=unauthorized");
                return;
            }

            // Update status
            poDAO.updateStatus(id, newStatus);
            response.sendRedirect(request.getContextPath() + "/detail-purchase-order?id=" + id);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/purchase-orders");
        }
    }
}