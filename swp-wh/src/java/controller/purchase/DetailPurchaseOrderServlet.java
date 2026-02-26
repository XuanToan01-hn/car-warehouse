package controller.purchase;

import dal.PurchaseOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.PurchaseOrder;

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
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int status = Integer.parseInt(request.getParameter("status"));
            poDAO.updateStatus(id, status);
            response.sendRedirect(request.getContextPath() + "/detail-purchase-order?id=" + id);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/purchase-orders");
        }
    }
}