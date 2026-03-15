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
            // Draft (status 1):
            // - Confirm (-> status 2): Warehouse Manager (role 2) only
            // - Cancel (-> status 4): Warehouse Manager (role 2) OR Purchasing Staff (role
            // 5)
            // Confirmed (status 2):
            // - Mark Received (-> status 3): Inventory Staff (role 3) only
            // - Cancel (-> status 4): Warehouse Manager (role 2) OR Purchasing Staff (role
            // 5)

            boolean authorized = false;

            if (po.getStatus() == 1) {
                if (newStatus == 2) {
                    // Confirm: only Warehouse Manager
                    authorized = (currentRole == 2);
                } else if (newStatus == 4) {
                    // Cancel from Draft: Manager or Purchasing Staff
                    authorized = (currentRole == 2 || currentRole == 5);
                }
            } else if (po.getStatus() == 2) {
                if (newStatus == 3) {
                    // Mark Received: only Inventory Staff
                    authorized = (currentRole == 3);
                } else if (newStatus == 4) {
                    // Cancel from Confirmed: only Manager (PO already approved, Purchasing Staff cannot cancel)
                    authorized = (currentRole == 2);
                }
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