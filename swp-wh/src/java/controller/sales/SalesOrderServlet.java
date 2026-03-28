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
                List<SalesOrder> warehouseOrders = salesOrderDAO.getAll();
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
//load danh sách sản phẩm theo kho
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
            user = new UserDAO().getById(1); // 
        }
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
        String note = request.getParameter("note");
        //Trả về thời gian hiện tại tính bằng mili giây kể từ 01/01/1970
        String orderCode = "SO-" + System.currentTimeMillis();

        String[] productDetailIds = request.getParameterValues("productDetailId");
        String[] quantities = request.getParameterValues("quantity");
        String[] prices = request.getParameterValues("price");

        
        // Dùng HashSet để kiểm tra vì Set không cho phép chứa phần tử trùng.
        if (productDetailIds != null) {
            java.util.Set<String> idSet = new java.util.HashSet<>();
            for (String id : productDetailIds) {
                if (id != null && !id.trim().isEmpty()) {
                    // Nếu id đã tồn tại trong Set, hàm .add() sẽ trả về FALSE
                    if (!idSet.add(id)) {
                        // Phát hiện trùng lặp -> Báo lỗi và quay lại trang tạo đơn
                        session.setAttribute("error", "Lỗi: Một xe (VIN/Số khung) không được xuất hiện 2 lần trong cùng một đơn hàng!");
                        response.sendRedirect(request.getContextPath() + "/sales-order?action=create");
                        return;
                    }
                }
            }
        }

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

                // tạo đơn ko qtam đến số luong kho
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
        order.setStatus(1); // Created
        order.setNote(note);
        order.setCreateBy(user);
        order.setTotalAmount(totalAmount);

        salesOrderDAO.insert(order, details);
        response.sendRedirect(request.getContextPath() + "/sales-order?action=list");
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));


        SalesOrder order = salesOrderDAO.getById(id);

        if (order != null) {
            // kiểm tra nếu đã có hàng được giao (DeliveredQty > 0)
            if (order.getDeliveredQty() > 0) {
                
                request.getSession().setAttribute("error", "Không thể hủy đơn hàng đã phát sinh giao dịch xuất kho!");
                response.sendRedirect(request.getContextPath() + "/sales-order?action=view&id=" + id);
                return;
            }

            // 3. Nếu chưa giao hàng tiến hành hủy (Status = 4)
            salesOrderDAO.updateStatus(id, 4);
            request.getSession().setAttribute("message", "Đã hủy đơn hàng thành công.");
        }

        response.sendRedirect(request.getContextPath() + "/sales-order?action=list");
    }

    // 
    private void listOrdersForWarehouse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SalesOrder> list = salesOrderDAO.getAll();
        request.setAttribute("orders", list);
        // 
        request.getRequestDispatcher("/view/good-issue/sales-order-staff-list.jsp").forward(request, response);
    }
    
    
}
