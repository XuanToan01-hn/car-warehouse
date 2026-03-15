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
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    ReportDAO rd = new ReportDAO();
    dal.WarehouseDAO wd = new dal.WarehouseDAO();
    dal.LocationDAO ld = new dal.LocationDAO(); // Cần có DAO này để lấy list Location

    String pName = request.getParameter("productName");
    String wName = request.getParameter("warehouseName");
    String locIdStr = request.getParameter("locationId");
    String pageStr = request.getParameter("page");
    
    Integer locationId = (locIdStr == null || locIdStr.isEmpty()) ? 0 : Integer.parseInt(locIdStr);
    int page = (pageStr == null || pageStr.isEmpty()) ? 1 : Integer.parseInt(pageStr);
    int pageSize = 10;

    // Truyền thêm locationId vào DAO
    List<model.LocationProduct> list = rd.getCurrentStock(pName, wName, locationId, page, pageSize, "lp.Quantity", "DESC");
    int totalRecords = rd.countCurrentStock(pName, wName, locationId);
    int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

    request.setAttribute("stockList", list);
    request.setAttribute("warehouses", wd.getAll()); 
    request.setAttribute("locations", ld.getAll()); // Đẩy danh sách location sang JSP
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
