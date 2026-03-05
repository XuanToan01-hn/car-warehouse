package controller.productDetail;

import dal.ProductDAO;
import dal.ProductDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
        dal.ProductDetailDAO dao = new dal.ProductDetailDAO();
        dal.ProductDAO pDao = new dal.ProductDAO();

        request.setAttribute("pd", dao.getById(id));
        request.setAttribute("products", pDao.getAll());
        request.getRequestDispatcher("view/product-detail/edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            String lotNumber = request.getParameter("lotNumber");
            String serialNumber = request.getParameter("serialNumber");
            String manufactureDateStr = request.getParameter("manufactureDate");
            double price = Double.parseDouble(request.getParameter("price"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String color = request.getParameter("color");
            ProductDetail pd = new ProductDetail();
            pd.setId(Integer.parseInt(request.getParameter("id")));
            pd.setLotNumber(request.getParameter("lotNumber"));
            pd.setSerialNumber(request.getParameter("serialNumber"));
            pd.setManufactureDate(java.sql.Date.valueOf(request.getParameter("mfdDate")));
            pd.setColor(request.getParameter("color"));
            pd.setPrice(Double.parseDouble(request.getParameter("price")));

            model.ProductDetail pd = new model.ProductDetail();
            pd.setId(id);
            model.Product p = new model.Product();
            p.setId(productId);
            Product p = new Product();
            p.setId(Integer.parseInt(request.getParameter("productId")));
            pd.setProduct(p);
            pd.setLotNumber(lotNumber);
            pd.setSerialNumber(serialNumber);
            pd.setPrice(price);
            pd.setQuantity(quantity);
            pd.setColor(color);
            pd.setManufactureDate(java.sql.Date.valueOf(manufactureDateStr));

            new dal.ProductDetailDAO().update(pd);
            response.sendRedirect("list-product-detail");
        } catch (Exception e) {
            response.sendRedirect("list-product-detail?error=update_failed");
        }
    }
}
