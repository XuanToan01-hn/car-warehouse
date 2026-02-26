package controller.purchase;

import dal.ProductDAO;
import dal.SupplierDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;

@WebServlet(name = "QuickAddProductServlet", urlPatterns = { "/quick-add-product" })
public class QuickAddProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        ProductDAO productDAO = new ProductDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        try (PrintWriter out = response.getWriter()) {
            String name = request.getParameter("name");
            String code = request.getParameter("code");
            String priceStr = request.getParameter("price");
            String catIdStr = request.getParameter("categoryId");
            String supIdStr = request.getParameter("supplierId");

            if (name == null || name.trim().isEmpty() || code == null || code.trim().isEmpty()) {
                out.print("{\"success\":false,\"message\":\"Tên và mã sản phẩm không được trống\"}");
                return;
            }

            double price = 0;
            try {
                price = Double.parseDouble(priceStr);
            } catch (Exception e) {
                price = 0;
            }

            Product p = new Product();
            p.setName(name.trim());
            p.setCode(code.trim());
            p.setPrice(price);
            p.setDescription("");
            p.setImage("");
            p.setMinStock(0);

            if (catIdStr != null && !catIdStr.isEmpty()) {
                try {
                    Category cat = new Category();
                    cat.setId(Integer.parseInt(catIdStr));
                    p.setCategory(cat);
                } catch (Exception e) {
                    /* bỏ qua */ }
            }

            int newProductId = productDAO.insertAndGetId(p);
            if (newProductId > 0) {
                // Link supplier → product nếu có supplierId
                if (supIdStr != null && !supIdStr.isEmpty()) {
                    try {
                        supplierDAO.updateProductId(Integer.parseInt(supIdStr), newProductId);
                    } catch (Exception e) {
                        /* không bắt buộc */ }
                }
                out.print("{\"success\":true,\"productId\":" + newProductId
                        + ",\"productName\":\"" + escapeJson(name.trim())
                        + "\",\"productCode\":\"" + escapeJson(code.trim()) + "\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Lỗi khi lưu sản phẩm\"}");
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
