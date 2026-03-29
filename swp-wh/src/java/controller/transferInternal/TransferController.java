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
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import model.TransferOrder;
import model.TransferOrderDetail;

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
            // Only show locations from the user's assigned warehouse
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null && user.getWarehouse() != null) {
                int userWhId = user.getWarehouse().getId();
                request.setAttribute("locations", locDAO.getByWarehouseId(userWhId));
                request.setAttribute("userWarehouseName", user.getWarehouse().getWarehouseName());
                request.setAttribute("userWarehouseId", userWhId);
            } else {
                request.setAttribute("locations", locDAO.getAll());
                request.setAttribute("userWarehouseName", "Unknown");
            }
            request.getRequestDispatcher("/view/create-transfer.jsp").forward(request, response);
        } else if (action.equals("detail")) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                List<TransferOrder> orders = transDAO.getTransfersById(id);
                if (!orders.isEmpty()) {
                    List<Map<String, Object>> productDetailsList = new ArrayList<>();
                    int totalQty = 0;
                    for (TransferOrder to : orders) {
                        model.ProductDetail pd = pdDAO.getById(to.getProductDetailId());
                        String pName = (pd != null && pd.getProduct() != null)
                                ? "[" + pd.getSerialNumber() + "] " + pd.getProduct().getName() + " - " + pd.getColor()
                                : "Unknown Product #" + to.getProductDetailId();

                        Map<String, Object> map = new HashMap<>();
                        map.put("name", pName);
                        map.put("qty", to.getQuantity());
                        productDetailsList.add(map);
                        totalQty += to.getQuantity();
                    }

                    request.setAttribute("t", orders.get(0));
                    request.setAttribute("productList", productDetailsList);
                    request.setAttribute("totalQuantity", totalQty);
                    request.getRequestDispatcher("/view/transfer-detail.jsp").forward(request, response);
                    return;
                }
            }
        } else if (action.equals("getProductsByLocation")) {
            String locIdStr = request.getParameter("locId");
            if (locIdStr == null || locIdStr.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().print("[]");
                return;
            }
            int locId = Integer.parseInt(locIdStr);
            List<model.LocationProduct> products = locDAO.getProductsByLocation(locId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            java.io.PrintWriter out = response.getWriter();
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < products.size(); i++) {
                model.LocationProduct lp = products.get(i);
                int reserved = transDAO.getReservedQuantity(locId, lp.getProductDetail().getId());
                int available = Math.max(0, lp.getQuantity() - reserved);
                if (available <= 0)
                    continue;

                if (json.length() > 1)
                    json.append(",");
                json.append("{");
                json.append("\"pdId\":").append(lp.getProductDetail().getId()).append(",");
                json.append("\"productName\":\"").append(lp.getProduct().getName().replace("\"", "\\\"")).append("\",");
                json.append("\"serialNumber\":\"").append(lp.getProductDetail().getSerialNumber().replace("\"", "\\\""))
                        .append("\",");
                json.append("\"color\":\"")
                        .append(lp.getProductDetail().getColor() != null
                                ? lp.getProductDetail().getColor().replace("\"", "\\\"")
                                : "")
                        .append("\",");
                json.append("\"available\":").append(available);
                json.append("}");
            }
            json.append("]");
            out.print(json.toString());
            out.flush();
            return;
        } else if (action.equals("getDetail")) {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty())
                return;

            int id = Integer.parseInt(idStr);
            TransferOrder t = transDAO.getById(id);
            if (t == null)
                return;

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
            json.append("\"from\":\"").append(t.getFromLocationName()).append(" (").append(t.getFromWarehouseName())
                    .append(")\",");
            json.append("\"to\":\"").append(t.getToLocationName()).append(" (").append(t.getToWarehouseName())
                    .append(")\",");
            json.append("\"product\":\"").append(productName.replace("\"", "\\\"")).append("\",");
            json.append("\"qty\":").append(t.getQuantity()).append(",");
            json.append("\"note\":\"").append(t.getNote() != null ? t.getNote().replace("\"", "\\\"") : "")
                    .append("\",");
            json.append("\"status\":").append(t.getStatus());
            json.append("}");
            out.print(json.toString());
            out.flush();
            return;
        } else {
            // Filter Parameters
            String code = request.getParameter("code");
            String statusStr = request.getParameter("status");
            Integer status = (statusStr != null && !statusStr.isEmpty()) ? Integer.parseInt(statusStr) : null;
            String fromLoc = request.getParameter("fromLoc");
            String toLoc = request.getParameter("toLoc");
            String productName = request.getParameter("productName");

            // Pagination Logic
            HttpSession session = request.getSession();
            model.User user = (model.User) session.getAttribute("user");
            Integer warehouseId = (user != null && user.getWarehouse() != null) ? user.getWarehouse().getId() : null;

            int pageSize = 5;
            String pageStr = request.getParameter("page");
            int currentPage = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;

            int totalItems = transDAO.getTransfersCount(code, status, warehouseId, "internal", fromLoc, toLoc, productName);
            int totalPages = (int) Math.ceil((double) totalItems / pageSize);
            if (currentPage > totalPages && totalPages > 0)
                currentPage = totalPages;

            List<TransferOrder> internalHistory = transDAO.getTransfersPaged(code, status, warehouseId, "internal",
                    fromLoc, toLoc, productName, currentPage, pageSize);

            request.setAttribute("pendingList", internalHistory);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            
            // Re-set filter values to request for form persistence
            request.setAttribute("code", code);
            request.setAttribute("status", status);
            request.setAttribute("fromLoc", fromLoc);
            request.setAttribute("toLoc", toLoc);
            request.setAttribute("productName", productName);

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
            int fromLocId = Integer.parseInt(request.getParameter("fromLoc"));
            int toLocId = Integer.parseInt(request.getParameter("toLoc"));
            String note = request.getParameter("note");
            String[] selectedProducts = request.getParameterValues("selectedProducts");

            if (selectedProducts == null || selectedProducts.length == 0) {
                request.getSession().setAttribute("err", "Please select at least one product!");
                response.sendRedirect("internal-transfer?action=form");
                return;
            }

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int userId = (user != null) ? user.getId() : 1;

            TransferOrder o = new TransferOrder();
            o.setFromLocationId(fromLocId);
            o.setToLocationId(toLocId);
            o.setNote(note);
            o.setCreateBy(userId);

            List<TransferOrderDetail> details = new ArrayList<>();
            for (String pdIdStr : selectedProducts) {
                int pdId = Integer.parseInt(pdIdStr);
                String qtyStr = request.getParameter("qty_" + pdId);
                int qty = (qtyStr != null) ? Integer.parseInt(qtyStr) : 1;

                int physical = dao.getPhysicalQuantity(fromLocId, pdId);
                int reserved = dao.getReservedQuantity(fromLocId, pdId);
                if (qty > (physical - reserved)) {
                    request.getSession().setAttribute("err",
                            "Quantity for product #" + pdId + " exceeds available stock!");
                    response.sendRedirect("internal-transfer?action=form");
                    return;
                }

                TransferOrderDetail d = new TransferOrderDetail();
                d.setProductDetailId(pdId);
                d.setQuantity(qty);
                details.add(d);
            }

            if (dao.createAndExecuteInternalTransfer(o, details)) {
                request.getSession().setAttribute("msg", "Internal transfer executed and stock updated successfully!");
            } else {
                request.getSession().setAttribute("err",
                        "Failed to execute transfer! Please check stock availability.");
            }
            response.sendRedirect("internal-transfer?action=view");
        } else if ("approve".equals(action)) {
            // Bước 2: Phê duyệt -> Tạo phiếu chuyển kho nội bộ (Approved)
            int id = Integer.parseInt(request.getParameter("transferId"));
            if (dao.approveRequest(id)) {
                request.getSession().setAttribute("msg", "Approved transfer request!");
            } else {
                request.getSession().setAttribute("err", "Failed to approve transfer request!");
            }
            response.sendRedirect("internal-transfer?action=view");
        } else if ("cancel".equals(action)) {
            int id = Integer.parseInt(request.getParameter("transferId"));
            if (dao.cancelRequest(id)) {
                request.getSession().setAttribute("msg", "Cancelled transfer request!");
            } else {
                request.getSession().setAttribute("err", "Failed to cancel transfer request!");
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
