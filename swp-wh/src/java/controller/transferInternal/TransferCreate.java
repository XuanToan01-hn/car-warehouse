///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//
//package controller.transferInternal;
//
//import dal.LocationDAO;
//import dal.LocationProductDAO;
//import dal.ProductDetailDAO;
//import dal.TransferDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.List;
//import model.LocationProduct;
//import model.ProductDetail;
//import model.TransferOrder;
//import model.TransferOrderDetail;
///**
// *
// * @author Asus
// */
//@WebServlet(name="TransferCreate", urlPatterns={"/transfer-create"})
//public class TransferCreate extends HttpServlet {
//    private final LocationDAO locDao = new LocationDAO();
//    private final ProductDetailDAO pdDao = new ProductDetailDAO();
//    private final TransferDAO transDao = new TransferDAO();
//    private final LocationProductDAO lpDao = new LocationProductDAO();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        String action = request.getParameter("action");
//        
//        // 1. XỬ LÝ AJAX LẤY HÀNG (Giữ nguyên logic cũ)
//        if ("get-stock".equals(action)) {
//            int locId = Integer.parseInt(request.getParameter("locId"));
//            List<LocationProduct> list = lpDao.getByLocationId(locId);
//            request.setAttribute("stockList", list);
//            request.getRequestDispatcher("view/internal/stock-fragment.jsp").forward(request, response);
//            return;
//        }
//
//        // 2. LẤY LỖI HOẶC THÔNG BÁO TỪ SESSION (NẾU CÓ)
//        Object errors = session.getAttribute("inventoryErrors");
//        if (errors != null) {
//            request.setAttribute("inventoryErrors", errors);
//            session.removeAttribute("inventoryErrors"); // Lấy xong xóa luôn cho sạch
//        }
//
//        Object successMsg = session.getAttribute("successMsg");
//        if (successMsg != null) {
//            request.setAttribute("successMsg", successMsg);
//            session.removeAttribute("successMsg");
//        }
//
//        // 3. LOAD TRANG
//        request.setAttribute("locations", locDao.getAll());
//        request.getRequestDispatcher("view/internal/transfer-create.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        List<String> inventoryErrors = new ArrayList<>();
//        
//        try {
//            int fromLoc = Integer.parseInt(request.getParameter("fromLocationId"));
//            int toLoc = Integer.parseInt(request.getParameter("toLocationId"));
//            String[] pdIds = request.getParameterValues("productDetailId");
//            String[] qtys = request.getParameterValues("quantity");
//
//            // VALIDATE MẠNH
//            if (fromLoc == toLoc) inventoryErrors.add("Kho xuất và nhập không được trùng nhau.");
//            
//            if (pdIds == null || pdIds.length == 0) {
//                inventoryErrors.add("Chưa chọn sản phẩm nào.");
//            } else {
//                for (int i = 0; i < pdIds.length; i++) {
//                    int pdId = Integer.parseInt(pdIds[i]);
//                    int reqQty = Integer.parseInt(qtys[i]);
//                    int stock = lpDao.getStockAtLocation(fromLoc, pdId);
//                    
//                    if (reqQty > stock) {
//                        ProductDetail pd = pdDao.getById(pdId);
//                        inventoryErrors.add("Sản phẩm [" + pd.getProduct().getName() + "] không đủ hàng. (Kho: " + stock + ")");
//                    }
//                }
//            }
//
//            // XỬ LÝ TRUYỀN ĐI QUA SESSION
//            if (!inventoryErrors.isEmpty()) {
//                session.setAttribute("inventoryErrors", inventoryErrors);
//                response.sendRedirect("transfer-create"); // Redirect để URL sạch
//            } else {
//                boolean success = transDao.executeTransfer(fromLoc, toLoc, 1, pdIds, qtys);
//                if (success) {
//                    session.setAttribute("successMsg", "Chuyển kho thành công!");
//                } else {
//                    inventoryErrors.add("Lỗi hệ thống khi thực hiện DB Transaction.");
//                    session.setAttribute("inventoryErrors", inventoryErrors);
//                }
//                response.sendRedirect("transfer-create");
//            }
//        } catch (Exception e) {
//            session.setAttribute("inventoryErrors", Arrays.asList("Lỗi không xác định: " + e.getMessage()));
//            response.sendRedirect("transfer-create");
//        }
//    }
//}
