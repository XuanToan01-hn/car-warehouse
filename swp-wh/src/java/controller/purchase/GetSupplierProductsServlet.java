package controller.purchase;

import dal.ProductDetailDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ProductDetail;

@WebServlet(name = "GetSupplierProductsServlet", urlPatterns = { "/get-supplier-products" })
public class GetSupplierProductsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));

            ProductDetailDAO pdDAO = new ProductDetailDAO();
            List<ProductDetail> details = pdDAO.getDetailsBySupplier(supplierId);

            // Build JSON response manually
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < details.size(); i++) {
                ProductDetail pd = details.get(i);

                // Xử lý màu: nếu null hoặc rỗng thì để mặc định
                String colorStr = (pd.getColor() != null && !pd.getColor().trim().isEmpty()) ? pd.getColor()
                        : "Chưa có màu";

                if (i > 0)
                    json.append(",");
                json.append("{");
                json.append("\"id\":").append(pd.getProduct().getId()).append(","); // Use ProductID for the main
                                                                                    // selection
                json.append("\"detailId\":").append(pd.getId()).append(",");
                json.append("\"name\":\"").append(escapeJson(pd.getProduct().getName())).append("\",");
                json.append("\"code\":\"").append(escapeJson(pd.getProduct().getCode())).append("\",");
                json.append("\"price\":").append(pd.getPrice()).append(",");
                json.append("\"color\":\"").append(escapeJson(colorStr)).append("\"");
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
        if (str == null)
            return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
