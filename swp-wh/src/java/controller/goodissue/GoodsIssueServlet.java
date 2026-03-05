///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//
//package controller.goodissue;
//
//import dal.GoodsIssueDAO;
//import dal.LocationDAO;
//import dal.LocationProductDAO;
//import dal.ProductDetailDAO;
//import dal.SalesOrderDAO;
//import dal.UserDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//import model.GoodsIssue;
//import model.GoodsIssueDetail;
//import model.Location;
//import model.ProductDetail;
//import model.SalesOrder;
//import model.SalesOrderDetail;
//import model.User;
//
///**
// *
// * @author Asus
// */
//@WebServlet(name="GoodsIssueServlet", urlPatterns={"/goods-issue"})
//public class GoodsIssueServlet extends HttpServlet {
//private final GoodsIssueDAO giDAO = new GoodsIssueDAO();
//    private final SalesOrderDAO soDAO = new SalesOrderDAO();
//    private final LocationProductDAO lpDAO = new LocationProductDAO();
//    private final ProductDetailDAO pdDAO = new ProductDetailDAO();
//    /** 
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet GoodsIssueServlet</title>");  
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet GoodsIssueServlet at " + request.getContextPath () + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    } 
//
//@Override
//protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//    try {
//        int soId = Integer.parseInt(request.getParameter("soId"));
//        SalesOrder order = soDAO.getById(soId);
//        List<Location> locations = new LocationDAO().getAll();
//
//        // Mặc định lấy tồn kho tại vị trí đầu tiên trong danh sách để hiển thị ban đầu
//        int defaultLocId = locations.isEmpty() ? 0 : locations.get(0).getId();
//        
//        // Gọi hàm bạn đã viết trong GoodsIssueDAO
//        List<Object[]> uiDetails = giDAO.getDetailsForUI(soId, defaultLocId);
//
//        request.setAttribute("order", order);
//        request.setAttribute("locations", locations);
//        request.setAttribute("uiDetails", uiDetails); // Gửi danh sách kèm tồn kho này sang JSP
//        request.getRequestDispatcher("/view/good-issue/goods-issue-create.jsp").forward(request, response);
//    } catch (Exception e) {
//        response.sendRedirect("sales-order?action=warehouse-list");
//    }
//}
//
//// @Override
////protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
////    try {
////        // Lấy đúng soId từ request
////        String idRaw = request.getParameter("soId"); 
////        if (idRaw == null) {
////            response.sendRedirect("sales-order?action=warehouse-list");
////            return;
////        }
////        
////        int soId = Integer.parseInt(idRaw);
////        SalesOrder order = soDAO.getById(soId); // Sử dụng biến soId thay vì số 1
////        
////        if (order == null || order.getStatus() == 4 || order.getStatus() == 3) { // 3 là Completed
////            response.sendRedirect("sales-order?action=warehouse-list");
////            return;
////        }
////
////        request.setAttribute("order", order);
////        request.setAttribute("locations", new LocationDAO().getAll());
////        request.getRequestDispatcher("/view/good-issue/goods-issue-create.jsp").forward(request, response);
////    } catch (Exception e) {
////        response.sendRedirect("sales-order?action=warehouse-list");
////    }
////}
//
//@Override
//protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//    int soId = Integer.parseInt(request.getParameter("soId"));
//    int locId = Integer.parseInt(request.getParameter("locationId"));
//    String[] pdIds = request.getParameterValues("pdId");
//    String[] shipQtys = request.getParameterValues("shipQty");
//    String note = request.getParameter("note");
//
//    SalesOrder order = soDAO.getById(soId);
//    Map<Integer, SalesOrderDetail> orderMap = new HashMap<>();
//    for (SalesOrderDetail sod : order.getDetails()) {
//        orderMap.put(sod.getProductDetail().getId(), sod);
//    }
//
//    User user = (User) request.getSession().getAttribute("user");
//    if (user == null) user = new UserDAO().getById(1);
//
//    GoodsIssue gi = new GoodsIssue();
//    gi.setIssueCode("GIN-" + System.currentTimeMillis());
//    gi.setSalesOrder(order);
//    gi.setLocation(new Location()); gi.getLocation().setId(locId);
//    gi.setCreateBy(user);
//    gi.setStatus(1); // 1: Đã xuất
//    gi.setNote(note);
//
//    List<GoodsIssueDetail> details = new ArrayList<>();
//    List<String> errors = new ArrayList<>();
//
//    if (pdIds != null) {
//        for (int i = 0; i < pdIds.length; i++) {
//            int pdId = Integer.parseInt(pdIds[i]);
//            int qtyToShip = Integer.parseInt(shipQtys[i]);
//
//            // HÀNH ĐỘNG: Nếu nhập 0 thì coi như không giao đợt này -> Skip
//            if (qtyToShip <= 0) continue; 
//
//            SalesOrderDetail originalDetail = orderMap.get(pdId);
//            if (originalDetail == null) continue;
//
//            int remaining = originalDetail.getQuantity() - originalDetail.getDeliveredQty();
//            
//            // Validate số lượng nợ
//            if (qtyToShip > remaining) {
//                errors.add("Sản phẩm " + originalDetail.getProductDetail().getProduct().getName() 
//                           + ": Giao quá số nợ (" + remaining + ")");
//                continue;
//            }
//
//            // Validate tồn kho
//            int stockAtLoc = lpDAO.getStockAtLocation(locId, pdId);
//            if (qtyToShip > stockAtLoc) {
//                errors.add("Sản phẩm " + originalDetail.getProductDetail().getProduct().getName() 
//                           + ": Kho không đủ (Còn: " + stockAtLoc + ")");
//                continue;
//            }
//
//            GoodsIssueDetail gid = new GoodsIssueDetail();
//            gid.setProductDetail(originalDetail.getProductDetail());
//            gid.setQuantityActual(qtyToShip);
//            gid.setQuantityExpected(remaining);
//            details.add(gid);
//        }
//    }
//
//    // Nếu không có lỗi validate nhưng danh sách details trống -> Người dùng nhập toàn số 0
//    if (errors.isEmpty() && details.isEmpty()) {
//        errors.add("Vui lòng nhập số lượng > 0 cho ít nhất một sản phẩm để tạo phiếu xuất.");
//    }
//
//    if (!errors.isEmpty()) {
//        request.setAttribute("errors", errors);
//        request.setAttribute("order", order);
//        request.setAttribute("locations", new LocationDAO().getAll());
//        request.getRequestDispatcher("/view/good-issue/goods-issue-create.jsp").forward(request, response);
//        return;
//    }
//
//    // --- MỞ KHÓA TRANSACTION ---
//    if (giDAO.confirmIssue(gi, details)) {
//        // Thành công: Về trang xem chi tiết đơn hàng để thấy status đã cập nhật
//        response.sendRedirect("sales-order?action=view&id=" + soId);
//    } else {
//        errors.add("Lỗi hệ thống khi lưu phiếu xuất kho (Kiểm tra Log).");
//        request.setAttribute("errors", errors);
//        request.setAttribute("order", order);
//        request.setAttribute("locations", new LocationDAO().getAll());
//        request.getRequestDispatcher("/view/good-issue/goods-issue-create.jsp").forward(request, response);
//    }
//}
//
//    /** 
//     * Returns a short description of the servlet.
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
package controller.goodissue;

import dal.*;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.*;

@WebServlet(name = "GoodsIssueServlet", urlPatterns = {"/goods-issue"})
public class GoodsIssueServlet extends HttpServlet {

    private final GoodsIssueDAO giDAO = new GoodsIssueDAO();
    private final SalesOrderDAO soDAO = new SalesOrderDAO();
    private final LocationProductDAO lpDAO = new LocationProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idRaw = request.getParameter("soId");
            if (idRaw == null) {
                response.sendRedirect("sales-order?action=warehouse-list");
                return;
            }
            int soId = Integer.parseInt(idRaw);

            SalesOrder order = soDAO.getById(soId);
            // Kiểm tra trạng thái: Không cho xuất nếu đơn đã hoàn thành (3) hoặc đã hủy (4)
            if (order == null || order.getStatus() == 4 || order.getStatus() == 3) {
                response.sendRedirect("sales-order?action=warehouse-list");
                return;
            }

            List<Location> locations = new LocationDAO().getAll();
            String locIdParam = request.getParameter("locationId");
            int selectedLocId = (locIdParam != null) ? Integer.parseInt(locIdParam)
                    : (locations.isEmpty() ? 0 : locations.get(0).getId());

            // Lấy dữ liệu UI bao gồm tồn kho tại kho đã chọn
            List<Object[]> uiDetails = giDAO.getDetailsForUI(soId, selectedLocId);

            request.setAttribute("order", order);
            request.setAttribute("locations", locations);
            request.setAttribute("uiDetails", uiDetails);
            request.getRequestDispatcher("/view/good-issue/goods-issue-create.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("sales-order?action=warehouse-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int soId = Integer.parseInt(request.getParameter("soId"));
        int locId = Integer.parseInt(request.getParameter("locationId"));
        String[] pdIds = request.getParameterValues("pdId");
        String[] shipQtys = request.getParameterValues("shipQty");

        SalesOrder order = soDAO.getById(soId);
        Map<Integer, SalesOrderDetail> orderMap = new HashMap<>();
        if (order.getDetails() != null) {
            for (SalesOrderDetail sod : order.getDetails()) {
                orderMap.put(sod.getProductDetail().getId(), sod);
            }
        }

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) user = new UserDAO().getById(1); // Fallback nếu session hết hạn

        GoodsIssue gi = new GoodsIssue();
        gi.setIssueCode("GIN-" + System.currentTimeMillis());
        gi.setSalesOrder(order);
        gi.setLocation(new Location());
        gi.getLocation().setId(locId);
        gi.setCreateBy(user);
        gi.setStatus(1); // Đã xuất

        List<GoodsIssueDetail> details = new ArrayList<>();
        List<String> errors = new ArrayList<>();

        if (pdIds != null && shipQtys != null) {
            for (int i = 0; i < pdIds.length; i++) {
                try {
                    int pdId = Integer.parseInt(pdIds[i]);
                    int qtyToShip = (shipQtys[i] == null || shipQtys[i].isEmpty()) ? 0 : Integer.parseInt(shipQtys[i]);

                    if (qtyToShip <= 0) continue;

                    SalesOrderDetail originalDetail = orderMap.get(pdId);
                    if (originalDetail == null) continue;

                    int remaining = originalDetail.getQuantity() - originalDetail.getDeliveredQty();
                    int stockAtLoc = lpDAO.getStockAtLocation(locId, pdId);

                    // Validation tập trung
                    if (qtyToShip > remaining) {
                        errors.add(originalDetail.getProductDetail().getProduct().getName() + ": Xuất quá số lượng nợ (" + remaining + ")");
                    }
                    if (qtyToShip > stockAtLoc) {
                        errors.add(originalDetail.getProductDetail().getProduct().getName() + ": Kho không đủ tồn (" + stockAtLoc + ")");
                    }

                    GoodsIssueDetail gid = new GoodsIssueDetail();
                    gid.setProductDetail(originalDetail.getProductDetail());
                    gid.setQuantityActual(qtyToShip);
                    gid.setQuantityExpected(remaining);
                    details.add(gid);
                } catch (NumberFormatException e) {
                    // Bỏ qua dòng nếu số lượng nhập sai định dạng
                }
            }
        }

        if (errors.isEmpty() && details.isEmpty()) {
            errors.add("Vui lòng nhập số lượng xuất cho ít nhất một sản phẩm.");
        }

        if (!errors.isEmpty()) {
            handleError(request, response, soId, locId, order, errors);
            return;
        }

        // Thực hiện lưu vào DB
        if (giDAO.confirmIssue(gi, details)) {
            response.sendRedirect("sales-order?action=warehouse-list");
        } else {
            errors.add("Lỗi hệ thống: Không thể lưu phiếu xuất. Vui lòng kiểm tra lại tồn kho hoặc nhật ký giao dịch.");
            handleError(request, response, soId, locId, order, errors);
        }
    }

    // Hàm bổ trợ để nạp lại dữ liệu khi có lỗi, tránh lặp code
    private void handleError(HttpServletRequest request, HttpServletResponse response, int soId, int locId, SalesOrder order, List<String> errors) 
            throws ServletException, IOException {
        request.setAttribute("errors", errors);
        request.setAttribute("order", order);
        request.setAttribute("locations", new LocationDAO().getAll());
        request.setAttribute("uiDetails", giDAO.getDetailsForUI(soId, locId));
        request.getRequestDispatcher("/view/good-issue/goods-issue-create.jsp").forward(request, response);
    }
}
