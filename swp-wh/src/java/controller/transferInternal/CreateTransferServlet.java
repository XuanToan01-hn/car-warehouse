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
import jakarta.servlet.http.HttpSession;
import model.TransferOrder;
import model.TransferOrderDetail;
import model.User;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Asus
 */
@WebServlet(name = "CreateTransferServlet", urlPatterns = { "/create-transfer" })
public class CreateTransferServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateTransferServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateTransferServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load dữ liệu cho các ô Select
        LocationDAO locDAO = new LocationDAO();
        ProductDetailDAO pdDAO = new ProductDetailDAO();
        TransferDAO transDAO = new TransferDAO();

        request.setAttribute("locations", locDAO.getAll());
        request.setAttribute("productDetails", pdDAO.getAll());
        request.setAttribute("pendingList", transDAO.getPendingTransfers());

        request.getRequestDispatcher("/view/internal/create-transfer.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        TransferDAO dao = new TransferDAO();

        if ("create".equals(action)) {
            TransferOrder o = new TransferOrder();
            o.setFromLocationId(Integer.parseInt(request.getParameter("fromLoc")));
            o.setToLocationId(Integer.parseInt(request.getParameter("toLoc")));
            int pdId = Integer.parseInt(request.getParameter("pdId"));
            int qty = Integer.parseInt(request.getParameter("qty"));

            TransferOrderDetail d = new TransferOrderDetail();
            d.setProductDetailId(pdId);
            d.setQuantity(qty);

            List<TransferOrderDetail> details = new ArrayList<>();
            details.add(d);
            o.setCreateBy(1);

            if (dao.createTransferRequest(o, details))
                request.getSession().setAttribute("msg", "Inventory transfer request created successfully!");
            else
                request.getSession().setAttribute("err", "Failed to create inventory transfer request!");

        } else if ("approve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("transferId"));
            if (dao.executeTransfer(id))
                request.getSession().setAttribute("msg", "Inventory has been approved and updated!");
            else
                request.getSession().setAttribute("err", "Failed! Check inventory again.");
        }
        response.sendRedirect("internal-transfer");
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
