package controller.purchase;

import dal.ProductDAO;
import dal.ProductDetailDAO; // Nhập thêm DAO chi tiết
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import model.ProductDetail; // Nhập thêm Model chi tiết

@WebServlet(name = "GetSupplierProductsServlet", urlPatterns = {"/get-supplier-products"})
public class GetSupplierProductsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));

            ProductDAO productDAO = new ProductDAO();
            ProductDetailDAO productDetailDAO = new ProductDetailDAO(); // Khởi tạo
            List<Product> products = productDAO.getProductsBySupplier(supplierId);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < products.size(); i++) {
                Product p = products.get(i);

                // Fetch Product_Detail liên quan đến Product này
                // Lấy toàn bộ chi tiết để đổ ra dropdown màu sắc bất kể tồn kho
                List<ProductDetail> details = productDetailDAO.getAllDetailsByProductId(p.getId());

                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"id\":").append(p.getId()).append(",");
                json.append("\"name\":\"").append(escapeJson(p.getName())).append("\",");
                json.append("\"code\":\"").append(escapeJson(p.getCode())).append("\",");

                // Đưa mảng chi tiết vào trong JSON
                json.append("\"details\":[");
                for (int j = 0; j < details.size(); j++) {
                    ProductDetail pd = details.get(j);
                    if (j > 0) json.append(",");
                    json.append("{");
                    json.append("\"id\":").append(pd.getId()).append(",");
                    json.append("\"color\":\"").append(escapeJson(pd.getColor())).append("\",");
                    json.append("\"price\":").append(pd.getPrice());
                    json.append("}");
                }
                json.append("]");
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
        return str.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}