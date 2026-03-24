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
        List<SalesOrder> list = salesOrderDAO.getAll();
        request.setAttribute("orders", list);
        request.getRequestDispatcher("/view/sales-order-list.jsp").forward(request, response);
    }

 private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    // 1. Load danh sách khách hàng
    request.setAttribute("customers", customerDAO.getAll());
    
    // 2. Load danh sách Product (Bảng cha - để chọn tên SP)
    ProductDAO pDAO = new ProductDAO();
    request.setAttribute("productList", pDAO.getAll());
    
    // 3. Load TOÀN BỘ ProductDetail (Bảng con - chứa Lot, Serial, Price...)
    ProductDetailDAO pdDAO = new ProductDetailDAO();
    request.setAttribute("allDetails", pdDAO.getAll());
    
    request.getRequestDispatcher("/view/sales-order-create.jsp").forward(request, response);
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
