package controller.purchase;

import dal.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet(name = "GetSupplierProductsServlet", urlPatterns = {"/get-supplier-products"})
public class GetSupplierProductsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));

            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.getProductsBySupplier(supplierId);

            // Build JSON response manually
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < products.size(); i++) {
                Product p = products.get(i);

                // Xử lý màu: nếu null hoặc rỗng thì để mặc định
                String colorStr = (p.getColor() != null && !p.getColor().trim().isEmpty()) ? p.getColor() : "Chưa có màu";

                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"id\":").append(p.getId()).append(",");
                json.append("\"name\":\"").append(escapeJson(p.getName())).append("\",");
                json.append("\"code\":\"").append(escapeJson(p.getCode())).append("\",");
                json.append("\"price\":").append(p.getPrice()).append(","); // Thêm dấu phẩy ở đây
                json.append("\"color\":\"").append(escapeJson(colorStr)).append("\""); // Thêm trường color
                json.append("}");
            }
            json.append("]");

            response.getWriter().print(json.toString());

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().print("{\"error\":\"Invalid supplier ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"error\":\"Server error\"}");
        }
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r");
    }
}


