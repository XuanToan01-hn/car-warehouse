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
import model.User;
import java.util.List;
import model.TransferOrder;

/**
 *
 * @author Asus
 */
@WebServlet(name = "TransferController", urlPatterns = { "/internal-transfer" })
public class TransferController extends HttpServlet {

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
            out.println("<title>Servlet TransferController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TransferController at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null)
            action = "view";

        LocationDAO locDAO = new LocationDAO();
        ProductDetailDAO pdDAO = new ProductDetailDAO();
        TransferDAO transDAO = new TransferDAO();

        if (action.equals("form")) {
            // Đổ danh sách Xe (ProductDetail) có trong kho
            request.setAttribute("productDetails", pdDAO.getAll()); // Hoặc viết thêm hàm chỉ lấy xe đang có hàng
            request.setAttribute("locations", locDAO.getAll()); // Cho To Location
            request.getRequestDispatcher("/view/create-transfer.jsp").forward(request, response);
        } else if (action.equals("getLocationsByProduct")) {
            String pdIdStr = request.getParameter("pdId");
            if (pdIdStr == null || pdIdStr.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().print("[]");
                return;
            }
            int pdId = Integer.parseInt(pdIdStr);
            System.out.println("[DEBUG] TransferController: Fetching locations for pdId=" + pdId);
            List<model.Location> locs = locDAO.getLocationsByProductDetail(pdId);
            System.out.println("[DEBUG] TransferController: Found " + locs.size() + " locations for pdId=" + pdId);
            
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            java.io.PrintWriter out = response.getWriter();
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < locs.size(); i++) {
                model.Location l = locs.get(i);
                int reserved = transDAO.getReservedQuantity(l.getId(), pdId);
                // Đảm bảo available không âm
                int available = Math.max(0, l.getCurrentStock() - reserved);
                
                json.append("{");
                json.append("\"id\":").append(l.getId()).append(",");
                json.append("\"name\":\"").append(l.getLocationName().replace("\"", "\\\"")).append(" (").append(l.getWarehouseName().replace("\"", "\\\"")).append(")\",");
                json.append("\"available\":").append(available).append(",");
                json.append("\"max\":").append(l.getMaxCapacity());
                json.append("}");
                if (i < locs.size() - 1) json.append(",");
            }
            json.append("]");
            System.out.println("[DEBUG] TransferController JSON: " + json.toString());
            out.print(json.toString());
            out.flush();
            return;
        } else if (action.equals("getDetail")) {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) return;
            
            int id = Integer.parseInt(idStr);
            TransferOrder t = transDAO.getById(id);
            if (t == null) return;

            // Lấy thêm tên sản phẩm
            String productName = "Unknown";
            model.ProductDetail pd = pdDAO.getById(t.getProductDetailId());
            if (pd != null && pd.getProduct() != null) {
                productName = "[" + pd.getSerialNumber() + "] " + pd.getProduct().getName() + " - " + pd.getColor();
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            StringBuilder json = new StringBuilder("{");
            json.append("\"id\":").append(t.getId()).append(",");
            json.append("\"code\":\"").append(t.getTransferCode()).append("\",");
            json.append("\"from\":\"").append(t.getFromLocationName()).append(" (").append(t.getFromWarehouseName()).append(")\",");
            json.append("\"to\":\"").append(t.getToLocationName()).append(" (").append(t.getToWarehouseName()).append(")\",");
            json.append("\"product\":\"").append(productName.replace("\"", "\\\"")).append("\",");
            json.append("\"qty\":").append(t.getQuantity()).append(",");
            json.append("\"note\":\"").append(t.getNote() != null ? t.getNote().replace("\"", "\\\"") : "").append("\",");
            json.append("\"status\":").append(t.getStatus());
            json.append("}");
            out.print(json.toString());
            out.flush();
            return;
        } else {
            // Hiển thị danh sách yêu cầu chờ duyệt nội bộ
            List<TransferOrder> allPending = transDAO.getPendingTransfers();
            List<TransferOrder> internalPending = new java.util.ArrayList<>();
            for (TransferOrder t : allPending) {
                if (t.getFromWarehouseId() == t.getToWarehouseId()) {
                    internalPending.add(t);
                }
            }
            request.setAttribute("pendingList", internalPending);
            // Default `isExternal` is implicitly false/null
            request.getRequestDispatcher("/view/transfer-list.jsp").forward(request, response);
        }
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
            // Lấy thông tin từ form theo kiểu cũ
            int pdId = Integer.parseInt(request.getParameter("pdId"));
            int fromLocId = Integer.parseInt(request.getParameter("fromLoc"));
            int qty = Integer.parseInt(request.getParameter("qty"));

            // Kiểm tra tồn kho khả dụng (Physical - Reserved)
            int physical = dao.getPhysicalQuantity(fromLocId, pdId);
            int reserved = dao.getReservedQuantity(fromLocId, pdId);
            if (qty > (physical - reserved)) {
                request.getSession().setAttribute("err", "Số lượng yêu cầu (" + qty + ") vượt quá tồn kho khả dụng (" + (physical - reserved) + ")!");
                response.sendRedirect("internal-transfer?action=form");
                return;
            }

            TransferOrder o = new TransferOrder();
            o.setFromLocationId(fromLocId);
            o.setToLocationId(Integer.parseInt(request.getParameter("toLoc")));
            o.setProductDetailId(pdId);
            o.setQuantity(qty);
            o.setNote(request.getParameter("note")); // Lý do chuyển kho
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                o.setCreateBy(user.getId());
            } else {
                o.setCreateBy(1); // Default to admin for now if no session
            }

            if (dao.createTransferRequest(o)) {
                request.getSession().setAttribute("msg", "Gửi yêu cầu chuyển kho thành công! Chờ quản lý duyệt.");
                response.sendRedirect("internal-transfer?action=view");
            }
        } else if ("approve".equals(action)) {
            // Bước 2: Phê duyệt -> Tạo phiếu chuyển kho nội bộ (Approved)
            int id = Integer.parseInt(request.getParameter("transferId"));
            if (dao.approveRequest(id)) {
                request.getSession().setAttribute("msg", "Đã phê duyệt và tạo phiếu chuyển kho nội bộ!");
            } else {
                request.getSession().setAttribute("err", "Phê duyệt thất bại!");
            }
            response.sendRedirect("internal-transfer?action=view");
        } else if ("cancel".equals(action)) {
            int id = Integer.parseInt(request.getParameter("transferId"));
            if (dao.cancelRequest(id)) {
                request.getSession().setAttribute("msg", "Đã hủy yêu cầu chuyển kho!");
            } else {
                request.getSession().setAttribute("err", "Hủy yêu cầu thất bại!");
            }
            response.sendRedirect("internal-transfer?action=view");
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
