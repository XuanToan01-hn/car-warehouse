package controller.purchase;

import dal.GoodsReceiptDAO;
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

            // [WH-FILTER] Check visibility for Inventory Staff (Role 3)
            User userObj = (User) request.getSession().getAttribute("user");
            if (userObj != null && userObj.getRole() != null
                    && (userObj.getRole().getId() == 3 || userObj.getRole().getId() == 5)) {
                int userWhId = (userObj.getWarehouse() != null) ? userObj.getWarehouse().getId() : 0;
                int poWhId = (po.getWarehouse() != null) ? po.getWarehouse().getId() : 0;

                if (userWhId != poWhId && userWhId != 0) {
                    response.sendRedirect(request.getContextPath() + "/purchase-orders?error=denied");
                    return;
                }
            }
            request.setAttribute("po", po);
            request.setAttribute("lockMinutes", PurchaseOrderDAO.LOCK_TIMEOUT / 60000);

            // Check lock status
            if (po.getLockedBy() != null && po.getLockedBy().getId() > 0
                    && po.getLockedBy().getId() != userObj.getId()) {
                request.setAttribute("poLockedByName", po.getLockedBy().getFullName());
            }

            // Check if an existing GRO (Draft or Partial) exists for this PO
            GoodsReceiptDAO grDAO = new GoodsReceiptDAO();
            int existingGroId = grDAO.getReceiptIdByPO(id);
            if (existingGroId > 0) {
                request.setAttribute("existingGroId", existingGroId);
            }

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

            // [WH-FILTER] Check visibility for Inventory Staff (Role 3)
            if (currentUser != null && currentUser.getRole() != null
                    && (currentUser.getRole().getId() == 3 || currentUser.getRole().getId() == 5)) {
                int userWhId = (currentUser.getWarehouse() != null) ? currentUser.getWarehouse().getId() : 0;
                int poWhId = (po.getWarehouse() != null) ? po.getWarehouse().getId() : 0;

                if (userWhId != poWhId && userWhId != 0) {
                    response.sendRedirect(request.getContextPath() + "/purchase-orders?error=denied");
                    return;
                }
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

            if (po.getStatus() == 1) { // Draft
                if (newStatus == 2) {
                    // Confirm (Draft -> Confirmed): only Warehouse Manager
                    authorized = (currentRole == 2);
                } else if (newStatus == 4) {
                    // Cancel from Draft: Manager or Purchasing Staff
                    authorized = (currentRole == 2 || currentRole == 5);
                }
            } else if (po.getStatus() == 2 || po.getStatus() == 3) { // Confirmed or Partial
                if (newStatus == 5) {
                    // Mark Done (Fully Received): only Inventory Staff
                    authorized = (currentRole == 3);
                } else if (newStatus == 4) {
                    // Cancel from Confirmed/Partial: only Manager (PO already approved)
                    authorized = (currentRole == 2);
                } else if (newStatus == 3) {
                    // Mark Partial Receipt: Inventory Staff
                    authorized = (currentRole == 3);
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