/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.locationProduct;

import dal.LocationDAO;
import dal.LocationProductDAO;
import dal.ProductDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Location;
import model.LocationProduct;
import model.ProductDetail;

/**
 *
 * @author Asus
 */
@WebServlet(name="LocationProductServlet", urlPatterns={"/location-product"})
public class LocationProductServlet extends HttpServlet {
   
 private final LocationProductDAO lpDAO = new LocationProductDAO();
    private final LocationDAO locDAO = new LocationDAO();
    private final ProductDetailDAO pdDAO = new ProductDetailDAO();
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LocationProduct</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LocationProduct at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                request.setAttribute("items", lpDAO.getAll());
                request.getRequestDispatcher("/view/location-product/location-product-list.jsp").forward(request, response);
                break;
            case "add":
                request.setAttribute("locations", locDAO.getAll());
                request.setAttribute("details", pdDAO.getAll()); 
                request.getRequestDispatcher("/view/location-product/location-product-form.jsp").forward(request, response);
                break;
            case "delete":
                int locId = Integer.parseInt(request.getParameter("locId"));
                int pdId = Integer.parseInt(request.getParameter("pdId"));
                lpDAO.delete(locId, pdId);
                response.sendRedirect("location-product");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int locId = Integer.parseInt(request.getParameter("locationId"));
        int pdId = Integer.parseInt(request.getParameter("productDetailId"));
        int qty = Integer.parseInt(request.getParameter("quantity"));

        LocationProduct lp = new LocationProduct();
        Location l = new Location(); l.setId(locId);
        ProductDetail pd = pdDAO.getById(pdId); 
        
        lp.setLocation(l);
        lp.setProductDetail(pd);
        lp.setQuantity(qty);

        lpDAO.save(lp);
        response.sendRedirect("location-product");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
