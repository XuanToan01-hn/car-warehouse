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
import java.util.List;
import model.TransferOrder;

/**
 *
 * @author Asus
 */
@WebServlet(name="TransferController", urlPatterns={"/internal-transfer"})
public class TransferController extends HttpServlet {
   
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
            out.println("<title>Servlet TransferController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TransferController at " + request.getContextPath () + "</h1>");
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
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "view";

        LocationDAO locDAO = new LocationDAO();
        ProductDetailDAO pdDAO = new ProductDetailDAO();
        TransferDAO transDAO = new TransferDAO();

        if (action.equals("form")) {
            // Đổ dữ liệu vào Form tạo mới
            request.setAttribute("locations", locDAO.getAll());
            request.setAttribute("productDetails", pdDAO.getAll());
            request.getRequestDispatcher("/view/create-transfer.jsp").forward(request, response);
        } else {
            // Hiển thị danh sách yêu cầu chờ duyệt
            request.setAttribute("pendingList", transDAO.getPendingTransfers());
            request.getRequestDispatcher("/view/transfer-list.jsp").forward(request, response);
        }
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        TransferDAO dao = new TransferDAO();

        if ("create".equals(action)) {
            // Bước: Create stock transfer request
            TransferOrder o = new TransferOrder();
            o.setFromLocationId(Integer.parseInt(request.getParameter("fromLoc")));
            o.setToLocationId(Integer.parseInt(request.getParameter("toLoc")));
            o.setProductDetailId(Integer.parseInt(request.getParameter("pdId")));
            o.setQuantity(Integer.parseInt(request.getParameter("qty")));
            o.setCreateBy(1); 

            if(dao.createTransferRequest(o)) {
                request.getSession().setAttribute("msg", "Gửi yêu cầu thành công!");
                response.sendRedirect("internal-transfer?action=view");
            }
        } else if ("approve".equals(action)) {
            // Bước: Record stock transfer
            int id = Integer.parseInt(request.getParameter("transferId"));
            if(dao.executeTransfer(id)) {
                request.getSession().setAttribute("msg", "Đã thực hiện chuyển kho thực tế!");
            }
            response.sendRedirect("internal-transfer?action=view");
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
