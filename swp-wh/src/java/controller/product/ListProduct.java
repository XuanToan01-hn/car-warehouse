/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.product;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.UnitDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;

/**
 *
 * @author Nhat
 */
@WebServlet(name = "ListProduct", urlPatterns = {"/list-product"})
public class ListProduct extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet ListProduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListProduct at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();

        // Get parameters with null checks
        String search = request.getParameter("search");
        String sortPrice = request.getParameter("sortPrice");
        String categoryId = request.getParameter("categoryId");
        String unitId = request.getParameter("unitId");

        // Parse page with default value
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1; // Ensure page is positive
            } catch (NumberFormatException e) {
                page = 1; // Fallback to page 1 if parsing fails
            }
        }

        // Parse pageSize with validation
        int pageSize = DEFAULT_PAGE_SIZE;
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                pageSize = validatePageSize(pageSize);
            } catch (NumberFormatException e) {
                pageSize = DEFAULT_PAGE_SIZE; // Fallback to default if parsing fails
            }
        }

        // Get filtered and paginated products
        List<Product> productList = productDAO.getFilteredProducts(search, sortPrice, categoryId, unitId, page, pageSize);
        int totalProducts = productDAO.getTotalFilteredProducts(search, categoryId, unitId);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        // Calculate pagination
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        boolean hasPrevious = page > 1;
        boolean hasNext = page < totalPages;

        // Set attributes
        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("listCategory", categoryDAO.getAll());
        request.setAttribute("listProduct", productList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("hasPrevious", hasPrevious);
        request.setAttribute("hasNext", hasNext);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("view/page-list-product.jsp").forward(request, response);


    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("showUpdateModal", true);
        request.setAttribute("ePrice", request.getAttribute("errorPrice"));
        request.setAttribute("eName", request.getAttribute("errorName"));
        request.setAttribute("eCode", request.getAttribute("errorCode"));
        request.setAttribute("eDesc", request.getAttribute("errorDesc"));
        
        ProductDAO productDAO = new ProductDAO();
        UnitDAO unitDAO = new UnitDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        String search = request.getParameter("search");
        String sortPrice = request.getParameter("sortPrice");
        String categoryId = request.getParameter("categoryId");
        String unitId = request.getParameter("unitId");

        // Parse page with default value
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1; // Ensure page is positive
            } catch (NumberFormatException e) {
                page = 1; // Fallback to page 1 if parsing fails
            }
        }

        // Parse pageSize with validation
        int pageSize = DEFAULT_PAGE_SIZE;
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                pageSize = validatePageSize(pageSize);
            } catch (NumberFormatException e) {
                pageSize = DEFAULT_PAGE_SIZE; // Fallback to default if parsing fails
            }
        }

        // Get filtered and paginated products
        List<Product> productList = productDAO.getFilteredProducts(search, sortPrice, categoryId, unitId, page, pageSize);
        int totalProducts = productDAO.getTotalFilteredProducts(search, categoryId, unitId);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        // Calculate pagination
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        boolean hasPrevious = page > 1;
        boolean hasNext = page < totalPages;

        // Set attributes
        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("listCategory", categoryDAO.getAll());
        request.setAttribute("listProduct", productList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("hasPrevious", hasPrevious);
        request.setAttribute("hasNext", hasNext);
        request.setAttribute("pageSize", pageSize);
        
        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("uId", request.getAttribute("updateid"));
        request.setAttribute("uName", request.getAttribute("updateName"));
        request.setAttribute("uCode", request.getAttribute("updateCode"));
        request.setAttribute("uPrice", request.getAttribute("updatePrice"));
        request.setAttribute("uImage", request.getAttribute("updateImage"));
        request.setAttribute("uCategory", request.getAttribute("updateCategory"));
        request.setAttribute("uDes", request.getAttribute("updateDes"));
        request.setAttribute("unitS", request.getAttribute("updateUnit"));
        request.getRequestDispatcher("view/page-list-product.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    private int validatePageSize(int pageSize) {
        int[] validSizes = {10, 20, 50, 100};
        for (int size : validSizes) {
            if (pageSize == size) {
                return pageSize;
            }
        }
        return DEFAULT_PAGE_SIZE;
    }
}
