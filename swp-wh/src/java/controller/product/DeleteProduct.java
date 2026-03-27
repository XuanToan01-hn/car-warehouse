package controller.product;

import dal.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DeleteProduct", urlPatterns = {"/delete-product"})
public class DeleteProduct extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        ProductDAO dao = new ProductDAO();

        try {
            int id = Integer.parseInt(idStr);

            boolean deleted = dao.delete(id);

            if (deleted) {
                request.getSession().setAttribute("success", "Delete product successfully!");
            } else {
                request.getSession().setAttribute("error", "Delete failed!");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid product ID!");
        }

        response.sendRedirect("list-product");
    }
}