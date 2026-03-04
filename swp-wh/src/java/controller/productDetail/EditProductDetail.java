/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.productDetail;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Asus
 */
@WebServlet(name="EditProductDetail", urlPatterns={"/edit-product-detail"})
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

            model.ProductDetail pd = new model.ProductDetail();
            pd.setId(id);
            model.Product p = new model.Product();
            p.setId(productId);
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
