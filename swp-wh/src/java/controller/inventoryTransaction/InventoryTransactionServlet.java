/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.inventoryTransaction;

import dal.InventoryTransactionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.InventoryTransaction;

/**
 *
 * @author Asus
 */
@WebServlet(name="InventoryTransactionServlet", urlPatterns={"/inventory-log"})
public class InventoryTransactionServlet extends HttpServlet {
   
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
            out.println("<title>Servlet InventoryTransactionServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InventoryTransactionServlet at " + request.getContextPath () + "</h1>");
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
 private final InventoryTransactionDAO transDAO = new InventoryTransactionDAO();

  @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    int page = 1;
    int pageSize = 5; 
    try {
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) page = Integer.parseInt(pageStr);
    } catch (NumberFormatException e) { page = 1; }

    String typeRaw = request.getParameter("type");
    Integer type = (typeRaw != null && !typeRaw.isEmpty()) ? Integer.parseInt(typeRaw) : 0;
    
    String search = request.getParameter("search");
    if (search == null) search = "";

    // LẤY THÊM THÔNG TIN NGÀY
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");

    // Gọi DAO với tham số mới
    List<InventoryTransaction> list = transDAO.getTransactions(page, pageSize, type, search, fromDate, toDate);
    int totalRecords = transDAO.getTotalTransactions(type, search, fromDate, toDate);
    int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

    request.setAttribute("transactions", list);
    request.setAttribute("currentPage", page);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("selectedType", type);
    request.setAttribute("search", search);
    request.setAttribute("fromDate", fromDate); // Đẩy lại lên JSP để giữ giá trị trong ô input
    request.setAttribute("toDate", toDate);

    request.getRequestDispatcher("/view/inventory-transaction/log-list.jsp").forward(request, response);
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
