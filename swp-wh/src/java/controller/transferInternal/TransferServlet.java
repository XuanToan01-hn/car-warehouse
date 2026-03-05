/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.transferInternal;

import dal.LocationDAO;
import dal.ProductDetailDAO;
import dal.TransferDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.TransferOrder;
import model.TransferOrderDetail;

/**
 *
 * @author Asus
 */
@WebServlet(name = "TransferServlet", urlPatterns = {"/transfer"})
public class TransferServlet extends HttpServlet {

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
            out.println("<title>Servlet TransferServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TransferServlet at " + request.getContextPath() + "</h1>");
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
    private final LocationDAO locDao = new LocationDAO();
    private final ProductDetailDAO pdDao = new ProductDetailDAO();
    private final TransferDAO transDao = new TransferDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Gửi danh sách Location và ProductDetail sang JSP
        request.setAttribute("locations", locDao.getAll());
        request.setAttribute("productDetails", pdDao.getAll());
        request.getRequestDispatcher("view/internal/transfer-list.jsp").forward(request, response);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int fromLoc = Integer.parseInt(request.getParameter("fromLocation"));
        int toLoc = Integer.parseInt(request.getParameter("toLocation"));
        
        // Nhận mảng ID và Quantity từ các input trùng tên trong bảng
        String[] pdIds = request.getParameterValues("pdId");
        String[] qtys = request.getParameterValues("qty");
        
        // Mặc định UserID = 1 (Thay bằng session của bạn)
        int userId = 1; 

        boolean result = transDao.executeTransfer(fromLoc, toLoc, userId, pdIds, qtys);
        
        if (result) {
            response.sendRedirect("transfer-internal?msg=success");
        } else {
            response.sendRedirect("transfer-internal?msg=error");
        }
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

}
