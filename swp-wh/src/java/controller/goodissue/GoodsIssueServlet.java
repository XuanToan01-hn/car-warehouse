/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.goodissue;

import dal.GoodsIssueDAO;
import dal.LocationDAO;
import dal.LocationProductDAO;
import dal.ProductDetailDAO;
import dal.SalesOrderDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.GoodsIssue;
import model.GoodsIssueDetail;
import model.Location;
import model.ProductDetail;
import model.SalesOrder;
import model.SalesOrderDetail;
import model.User;

/**
 *
 * @author Asus
 */
@WebServlet(name="GoodsIssueServlet", urlPatterns={"/goods-issue"})
public class GoodsIssueServlet extends HttpServlet {
private final GoodsIssueDAO giDAO = new GoodsIssueDAO();
    private final SalesOrderDAO soDAO = new SalesOrderDAO();
    private final LocationProductDAO lpDAO = new LocationProductDAO();
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
            out.println("<title>Servlet GoodsIssueServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GoodsIssueServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 



    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int soId = Integer.parseInt(request.getParameter("1"));
            // SalesOrderDAO.getById phải lấy được cả SalesOrderDetail (kèm DeliveredQty từng dòng)
            SalesOrder order = soDAO.getById(1); 
            
            if (order == null || order.getStatus() == 4 || order.getStatus() == 5) {
                response.sendRedirect("sales-order?action=list");
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("locations", new LocationDAO().getAll());
            request.getRequestDispatcher("/view/goods-issue/goods-issue-create.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect("sales-order?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int soId = Integer.parseInt(request.getParameter("soId"));
        int locId = Integer.parseInt(request.getParameter("locationId"));
        String[] pdIds = request.getParameterValues("pdId");
        String[] shipQtys = request.getParameterValues("shipQty");

        // Lấy lại thông tin đơn hàng để so khớp số lượng nợ
        SalesOrder order = soDAO.getById(soId);
        Map<Integer, SalesOrderDetail> orderMap = new HashMap<>();
        for (SalesOrderDetail sod : order.getDetails()) {
            orderMap.put(sod.getProductDetail().getId(), sod);
        }

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) user = new UserDAO().getById(1);

        GoodsIssue gi = new GoodsIssue();
        gi.setIssueCode("GIN-" + System.currentTimeMillis());
        gi.setSalesOrder(order);
        gi.setLocation(new Location()); gi.getLocation().setId(locId);
        gi.setCreateBy(user);

        List<GoodsIssueDetail> details = new ArrayList<>();
        List<String> errors = new ArrayList<>();

        if (pdIds != null) {
            for (int i = 0; i < pdIds.length; i++) {
                int pdId = Integer.parseInt(pdIds[i]);
                int qtyToShip = Integer.parseInt(shipQtys[i]);

                if (qtyToShip <= 0) continue;

                SalesOrderDetail originalDetail = orderMap.get(pdId);
                if (originalDetail == null) continue;

                // 1. Logic Validate: Không giao quá số lượng khách nợ
                int remaining = originalDetail.getQuantity() - originalDetail.getDeliveredQty();
                if (qtyToShip > remaining) {
                    errors.add("Sản phẩm " + originalDetail.getProductDetail().getProduct().getName() 
                               + ": Giao quá số lượng nợ (Nợ: " + remaining + ", Nhập: " + qtyToShip + ")");
                    continue;
                }

                // 2. Logic Validate: Không giao quá tồn kho tại vị trí đã chọn
                int stockAtLoc = lpDAO.getStockAtLocation(locId, pdId);
                if (qtyToShip > stockAtLoc) {
                    errors.add("Sản phẩm " + originalDetail.getProductDetail().getProduct().getName() 
                               + ": Không đủ tồn kho tại vị trí này (Có: " + stockAtLoc + ")");
                    continue;
                }

                // Nếu mọi thứ OK
                GoodsIssueDetail gid = new GoodsIssueDetail();
                gid.setProductDetail(originalDetail.getProductDetail());
                gid.setQuantityActual(qtyToShip);
                gid.setQuantityExpected(remaining); // Kỳ vọng giao hết số còn nợ
                details.add(gid);
            }
        }

        if (details.isEmpty() && errors.isEmpty()) {
            errors.add("Vui lòng nhập số lượng giao cho ít nhất một sản phẩm.");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("order", order);
            request.setAttribute("locations", new LocationDAO().getAll());
            request.getRequestDispatcher("/view/goods-issue/goods-issue-create.jsp").forward(request, response);
            return;
        }

        // Thực thi Transaction trong DAO
        if (giDAO.createGoodsIssue(gi, details)) {
            response.sendRedirect("sales-order?action=view&id=" + soId);
        } else {
            errors.add("Lỗi hệ thống khi lưu phiếu xuất kho.");
            request.setAttribute("errors", errors);
            request.setAttribute("order", order);
            request.setAttribute("locations", new LocationDAO().getAll());
            request.getRequestDispatcher("/view/goods-issue/goods-issue-create.jsp").forward(request, response);
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
