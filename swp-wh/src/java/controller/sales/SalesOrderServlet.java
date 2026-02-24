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
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listOrders(request, response);
                break;
            case "create":
                showCreateForm(request, response);
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
        request.setAttribute("customers", customerDAO.getAll());
        // For simplicity, listing some product details to select from
        request.setAttribute("productDetails", productDetailDAO.getFiltered(null, null, 1, 100));
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
            // Mocking a user if not logged in for testing, though in production should redirect to login
            user = new UserDAO().getById(1); 
        }

        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String note = request.getParameter("note");
        String orderCode = "SO-" + System.currentTimeMillis();

        SalesOrder order = new SalesOrder();
        order.setOrderCode(orderCode);
        order.setCustomer(customerDAO.getById(customerId));
        order.setStatus(1); // Created
        order.setNote(note);
        order.setCreateBy(user);

        String[] productDetailIds = request.getParameterValues("productDetailId");
        String[] quantities = request.getParameterValues("quantity");
        String[] prices = request.getParameterValues("price");

        List<SalesOrderDetail> details = new ArrayList<>();
        double totalAmount = 0;

        if (productDetailIds != null) {
            for (int i = 0; i < productDetailIds.length; i++) {
                SalesOrderDetail detail = new SalesOrderDetail();
                ProductDetail pd = new ProductDetail();
                pd.setId(Integer.parseInt(productDetailIds[i]));
                detail.setProductDetail(pd);
                int qty = Integer.parseInt(quantities[i]);
                double price = Double.parseDouble(prices[i]);
                detail.setQuantity(qty);
                detail.setPrice(price);
                detail.setSubTotal(qty * price);
                totalAmount += detail.getSubTotal();
                details.add(detail);
            }
        }
        order.setTotalAmount(totalAmount);

        salesOrderDAO.insert(order, details);
        response.sendRedirect(request.getContextPath() + "/sales-order?action=list");
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        salesOrderDAO.updateStatus(id, 4); // Cancelled
        response.sendRedirect(request.getContextPath() + "/sales-order?action=list");
    }
}
