package controller.purchase;

import dal.SupplierDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Supplier;

@WebServlet(name = "QuickAddSupplierServlet", urlPatterns = { "/quick-add-supplier" })
public class QuickAddSupplierServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        SupplierDAO supplierDAO = new SupplierDAO();

        try (PrintWriter out = response.getWriter()) {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            if (name == null || name.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Tên supplier không được trống\"}");
                return;
            }

            Supplier s = new Supplier();
            s.setName(name.trim());
            s.setPhone(phone != null ? phone.trim() : "");
            s.setEmail(email != null ? email.trim() : "");
            s.setAddress(address != null ? address.trim() : "");

            int newId = supplierDAO.insert(s);
            if (newId > 0) {
                out.print("{\"success\":true,\"supplierId\":" + newId + ",\"supplierName\":\"" + escapeJson(name.trim())
                        + "\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Lỗi khi lưu supplier\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            try (PrintWriter out = response.getWriter()) {
                out.print("{\"success\":false,\"message\":\"" + escapeJson(e.getMessage()) + "\"}");
            }
        }
    }

    private String escapeJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}