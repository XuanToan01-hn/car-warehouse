package controller.sales;

import dal.*;
import model.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SalesOrderServlet", urlPatterns = {"/sales-order"})
public class SalesOrderServlet extends HttpServlet {

    private final SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ProductDetailDAO productDetailDAO = new ProductDetailDAO();
    private final WarehouseDAO warehouseDAO = new WarehouseDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listOrders(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "warehouse-list":
                List<SalesOrder> warehouseOrders = salesOrderDAO.getAll(); // Hàm getAll của bạn đã có OrderedQty/DeliveredQty
                request.setAttribute("orders", warehouseOrders);
                request.getRequestDispatcher("/view/good-issue/sales-order-staff-list.jsp").forward(request, response);
                break;
            case "view":
                viewOrder(request, response);
                break;
            case "ajax-get-products":
                ajaxGetProducts(request, response);
                break;
            case "ajax-get-details":
                ajaxGetDetails(request, response);
                break;
            default:
                listOrders(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createOrder(request, response);
        } else if ("cancel".equals(action)) {
            cancelOrder(request, response);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusStr = request.getParameter("status");
        Integer status = null;
        if (statusStr != null && !statusStr.trim().isEmpty()) {
            try {
                status = Integer.parseInt(statusStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<SalesOrder> allOrders;
        if (status != null) {
            allOrders = salesOrderDAO.getByStatus(status);
        } else {
            allOrders = salesOrderDAO.getAll();
        }

        // Pagination Logic
        int pageSize = 5;
        String pageStr = request.getParameter("page");
        int currentPage = (pageStr != null && !pageStr.trim().isEmpty()) ? Integer.parseInt(pageStr.trim()) : 1;

        int totalOrders = allOrders.size();
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalOrders);

        List<SalesOrder> pagedOrders = new java.util.ArrayList<>();
        if (start < totalOrders) {
            pagedOrders = allOrders.subList(start, end);
        }

        request.setAttribute("orders", pagedOrders);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentStatus", status);

        request.getRequestDispatcher("/view/sales-order-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("customers", customerDAO.getAll());
        request.setAttribute("warehouses", warehouseDAO.getAll());
        request.getRequestDispatcher("/view/sales-order-create.jsp").forward(request, response);
    }

    private void ajaxGetProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
        List<Product> products = productDAO.getProductsByWarehouse(warehouseId);
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write("<option value=''>-- Select Product --</option>");
        for (Product p : products) {
            response.getWriter().write("<option value='" + p.getId() + "'>" + p.getName() + "</option>");
        }
    }

    private void ajaxGetDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
        List<ProductDetail> details = productDetailDAO.getByProductIdAndWarehouse(productId, warehouseId);
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write("<option value=''>-- Select Variant --</option>");
        for (ProductDetail pd : details) {
            response.getWriter().write("<option value='" + pd.getId() + "' data-price='" + pd.getPrice() + "'>" +
                "Lot: " + pd.getLotNumber() + " | SN: " + pd.getSerialNumber() + " | Color: " + pd.getColor() + "</option>");
        }
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        SalesOrder order = salesOrderDAO.getById(id);
        request.setAttribute("order", order);
        request.getRequestDispatcher("/view/sales-order-view.jsp").forward(request, response);
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            user = new UserDAO().getById(1); // Mock user nếu chưa login
        }
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        String orderCode = "SO-" + System.currentTimeMillis();

        String[] productDetailIds = request.getParameterValues("productDetailId");
        String[] quantities = request.getParameterValues("quantity");
        String[] prices = request.getParameterValues("price");

        List<SalesOrderDetail> details = new ArrayList<>();
        List<String> inventoryErrors = new ArrayList<>(); // Danh sách chứa lỗi tồn kho
        double totalAmount = 0;

        LocationProductDAO lpDAO = new LocationProductDAO();
        ProductDetailDAO pdDAO = new ProductDetailDAO();

        if (productDetailIds != null) {
            for (int i = 0; i < productDetailIds.length; i++) {
                int pdId = Integer.parseInt(productDetailIds[i]);
                int reqQty = Integer.parseInt(quantities[i]);
                double price = Double.parseDouble(prices[i]);

                // Create and add detail regardless of stock availability
                SalesOrderDetail detail = new SalesOrderDetail();
                detail.setProductDetail(pdDAO.getById(pdId));
                detail.setQuantity(reqQty);
                detail.setPrice(price);
                detail.setSubTotal(reqQty * price);
                totalAmount += detail.getSubTotal();
                details.add(detail);
            }
        }

        // --- XỬ LÝ KẾT QUẢ ---
        // Proceed to save order without blocking on inventoryErrors
        SalesOrder order = new SalesOrder();
        order.setOrderCode(orderCode);
        order.setCustomer(customerDAO.getById(customerId));
        order.setWarehouse(warehouseDAO.getById(warehouseId));
        order.setStatus(1); // Trạng thái: Draft/Created
        order.setNote(note);
        order.setCreateBy(user);
        order.setTotalAmount(totalAmount);

        salesOrderDAO.insert(order, details);
        response.sendRedirect(request.getContextPath() + "/sales-order?action=list");
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        // 1. Lấy thông tin đơn hàng lên để kiểm tra
        SalesOrder order = salesOrderDAO.getById(id);

        if (order != null) {
            // 2. Kiểm tra nếu đã có hàng được giao (DeliveredQty > 0)
            if (order.getDeliveredQty() > 0) {
                // Không cho hủy, gửi thông báo lỗi về trang list hoặc view
                request.getSession().setAttribute("error", "Không thể hủy đơn hàng đã phát sinh giao dịch xuất kho!");
                response.sendRedirect(request.getContextPath() + "/sales-order?action=view&id=" + id);
                return;
            }

            // 3. Nếu chưa giao hàng (DeliveredQty == 0), tiến hành hủy (Status = 4)
            salesOrderDAO.updateStatus(id, 4);
            request.getSession().setAttribute("message", "Đã hủy đơn hàng thành công.");
        }

        response.sendRedirect(request.getContextPath() + "/sales-order?action=list");
    }

    // Hàm mới để chuyển đến trang danh sách của kho
    private void listOrdersForWarehouse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SalesOrder> list = salesOrderDAO.getAll();
        request.setAttribute("orders", list);
        // Forward sang trang JSP dành riêng cho Warehouse
        request.getRequestDispatcher("/view/good-issue/sales-order-staff-list.jsp").forward(request, response);
    }
    
    
}
