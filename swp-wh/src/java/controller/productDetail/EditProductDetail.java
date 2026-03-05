package controller.productDetail;

import dal.ProductDAO;
import dal.ProductDetailDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import model.ProductDetail;

@WebServlet(name = "EditProductDetail", urlPatterns = { "/edit-product-detail" })
public class EditProductDetail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        ProductDetailDAO dao = new ProductDetailDAO();
        ProductDAO pDao = new ProductDAO();

        request.setAttribute("pd", dao.getById(id));
        request.setAttribute("listProduct", pDao.getAll());
        request.getRequestDispatcher("view/product-detail/page-update-product-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            String lotNumber = request.getParameter("lotNumber");
            String serialNumber = request.getParameter("serialNumber");
            String manufactureDateStr = request.getParameter("mfdDate");
            double price = Double.parseDouble(request.getParameter("price"));
            String color = request.getParameter("color");

            ProductDetail pd = new ProductDetail();
            pd.setId(id);
            pd.setLotNumber(lotNumber);
            pd.setSerialNumber(serialNumber);
            if (manufactureDateStr == null || manufactureDateStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Manufacture date is required.");
            }
            pd.setManufactureDate(java.sql.Date.valueOf(manufactureDateStr.trim()));
            pd.setColor(color);
            pd.setPrice(price);

            Product p = new Product();
            p.setId(productId);
            pd.setProduct(p);

            new ProductDetailDAO().update(pd);
            response.sendRedirect("list-product-detail");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("list-product-detail?error=update_failed");
        }
    }
}
