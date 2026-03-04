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
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("list-product-detail");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            ProductDetailDAO dao = new ProductDetailDAO();
            ProductDetail pd = dao.getById(id);
            if (pd != null) {
                request.setAttribute("pd", pd);
                request.setAttribute("listProduct", new ProductDAO().getAll());
                request.getRequestDispatcher("view/product-detail/page-update-product-detail.jsp").forward(request,
                        response);
            } else {
                response.sendRedirect("list-product-detail");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("list-product-detail");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ProductDetail pd = new ProductDetail();
            pd.setId(Integer.parseInt(request.getParameter("id")));
            pd.setLotNumber(request.getParameter("lotNumber"));
            pd.setSerialNumber(request.getParameter("serialNumber"));
            pd.setManufactureDate(java.sql.Date.valueOf(request.getParameter("mfdDate")));
            pd.setColor(request.getParameter("color"));
            pd.setPrice(Double.parseDouble(request.getParameter("price")));

            Product p = new Product();
            p.setId(Integer.parseInt(request.getParameter("productId")));
            pd.setProduct(p);

            new ProductDetailDAO().update(pd);
            response.sendRedirect("list-product-detail?status=updateSuccess");
        } catch (Exception e) {
            response.sendRedirect("edit-product-detail?id=" + request.getParameter("id") + "&status=error");
        }
    }
}
