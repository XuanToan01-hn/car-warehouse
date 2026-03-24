package controller.purchase;

import dal.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Category;
import model.Product;
import model.Supplier;

@WebServlet(name = "QuickAddProductServlet", urlPatterns = { "/quick-add-product" })
public class QuickAddProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        ProductDAO productDAO = new ProductDAO();
        String ctx = request.getContextPath();

        try {
            String name = request.getParameter("name");
            String code = request.getParameter("code");
            String catIdStr = request.getParameter("categoryId");
            String supIdStr = request.getParameter("supplierId");

            if (name == null || name.trim().isEmpty() || code == null || code.trim().isEmpty()) {
                response.sendRedirect(ctx + "/add-purchase-order?error=productFields");
                return;
            }

            if (supIdStr == null || supIdStr.isEmpty()) {
                response.sendRedirect(ctx + "/add-purchase-order?error=productSupplier");
                return;
            }

            int supplierId = Integer.parseInt(supIdStr);

            Product p = new Product();
            p.setName(name.trim());
            p.setCode(code.trim());
            p.setDescription("");
            p.setImage("");

            if (catIdStr != null && !catIdStr.isEmpty()) {
                try {
                    Category cat = new Category();
                    cat.setId(Integer.parseInt(catIdStr));
                    p.setCategory(cat);
                } catch (Exception ignored) {
                }
            }

            Supplier sup = new Supplier();
            sup.setId(supplierId);
            p.setSupplier(sup);

            int newProductId = productDAO.insertAndGetId(p);

            if (newProductId > 0) {
                response.sendRedirect(ctx + "/add-purchase-order?supplierId=" + supplierId + "&info=productCreated");
            } else {
                response.sendRedirect(ctx + "/add-purchase-order?supplierId=" + supplierId + "&error=productSave");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(ctx + "/add-purchase-order?error=productException");
        }
    }
}
