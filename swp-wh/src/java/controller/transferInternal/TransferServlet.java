/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.transferInternal;

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
@WebServlet(name="TransferServlet", urlPatterns={"/transfer"})
public class TransferServlet extends HttpServlet {
   
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
            out.println("<title>Servlet TransferServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TransferServlet at " + request.getContextPath () + "</h1>");
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
    private final TransferDAO dao = new TransferDAO();

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String action = request.getParameter("action");
    
    // Nếu action = create -> Load danh sách Location để người dùng chọn trong Form
    if ("create".equals(action)) {
        dal.LocationDAO locDAO = new dal.LocationDAO();
        request.setAttribute("locations", locDAO.getAll()); // Lấy list kho để đổ vào Select box
        request.getRequestDispatcher("/view/internal/create-transfer.jsp").forward(request, response);
    } 
    // Nếu action = record -> Thực hiện cập nhật kho thực tế
    else if ("record".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        int userId = 1; // Giả sử lấy từ session
        boolean success = dao.recordTransfer(id, userId);
        response.sendRedirect("transfer?msg=" + (success ? "success" : "fail"));
    } 
    // Mặc định -> Load danh sách phiếu chuyển
    else {
        request.setAttribute("transfers", dao.getAllTransfers());
        request.getRequestDispatcher("/view/internal/transfer-list.jsp").forward(request, response);
    }
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
    // 1. Lấy thông tin cơ bản từ form
    int fromLocId = Integer.parseInt(request.getParameter("fromLocationId"));
    int toLocId = Integer.parseInt(request.getParameter("toLocationId"));
    int userId = 1; // Giả sử lấy từ session: ((User)request.getSession().getAttribute("user")).getId();
    
    // Tự sinh mã code: TRF + timestamp
    String transferCode = "TRF" + System.currentTimeMillis();

    // 2. Lấy danh sách sản phẩm (Giả sử bạn gửi mảng id và quantity từ giao diện)
    String[] productDetailIds = request.getParameterValues("productDetailId");
    String[] quantities = request.getParameterValues("quantity");

    List<TransferOrderDetail> details = new ArrayList<>();
    if (productDetailIds != null) {
        for (int i = 0; i < productDetailIds.length; i++) {
            TransferOrderDetail d = new TransferOrderDetail();
            d.setProductDetailId(Integer.parseInt(productDetailIds[i]));
            d.setQuantity(Integer.parseInt(quantities[i]));
            details.add(d);
        }
    }

    // 3. Đóng gói vào Object
    TransferOrder order = new TransferOrder();
    order.setTransferCode(transferCode);
    order.setFromLocationId(fromLocId);
    order.setToLocationId(toLocId);
    order.setCreateBy(userId);

    // 4. Lưu vào Database thông qua DAO
    int result = dao.createTransferRequest(order, details);

    if (result > 0) {
        response.sendRedirect("transfer?msg=created");
    } else {
        request.setAttribute("error", "Could not create transfer request.");
        request.getRequestDispatcher("/view/internal/create-transfer.jsp").forward(request, response);
    }
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
