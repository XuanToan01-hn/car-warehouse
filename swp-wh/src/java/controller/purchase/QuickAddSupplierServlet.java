package controller.purchase;

import dal.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Supplier;

@WebServlet(name = "QuickAddSupplierServlet", urlPatterns = { "/quick-add-supplier" })
public class QuickAddSupplierServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        SupplierDAO supplierDAO = new SupplierDAO();
        String ctx = request.getContextPath();

        try {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            if (name == null || name.trim().isEmpty()) {
                response.sendRedirect(ctx + "/add-purchase-order?error=supplierName");
                return;
            }

            Supplier s = new Supplier();
            s.setName(name.trim());
            s.setPhone(phone != null ? phone.trim() : "");
            s.setEmail(email != null ? email.trim() : "");
            s.setAddress(address != null ? address.trim() : "");

            int newId = supplierDAO.insert(s);
            if (newId > 0) {
                response.sendRedirect(ctx + "/add-purchase-order?supplierId=" + newId + "&info=supplierCreated");
            } else {
                response.sendRedirect(ctx + "/add-purchase-order?error=supplierSave");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(ctx + "/add-purchase-order?error=supplierException");
        }
    }
}
