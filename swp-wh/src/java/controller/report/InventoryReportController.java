/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.report;

import dal.ReportDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.ProductDetail;

/**
 *
 * @author Asus
 */
@WebServlet(name="InventoryReportController", urlPatterns={"/inventory-report"})
public class InventoryReportController extends HttpServlet {
   
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
            out.println("<title>Servlet InventoryReportController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InventoryReportController at " + request.getContextPath () + "</h1>");
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
    ReportDAO dao = new ReportDAO();
    
    String search = request.getParameter("search");
    int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int size = 5;

    // THAY ĐỔI Ở ĐÂY: Gọi hàm lấy báo cáo phẳng thay vì gộp
    List<ProductDetail> list = dao.getInventoryFlatReport(search, page, size);
    
    int totalRecords = dao.countGlobalStock(search);
    int totalPages = (int) Math.ceil((double) totalRecords / size);

    request.setAttribute("pdList", list);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("currentPage", page);

    request.getRequestDispatcher("/view/report/inventoryReport.jsp").forward(request, response);
}

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
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