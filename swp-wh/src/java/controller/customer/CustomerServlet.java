package controller.customer;

import dal.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customers"})
public class CustomerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    CustomerDAO dao = new CustomerDAO();
                    dao.delete(id);
                } catch (NumberFormatException ignored) {
                }
            }
            response.sendRedirect(request.getContextPath() + "/customers");
            return;
        }

        CustomerDAO dao = new CustomerDAO();
        List<Customer> customers = dao.getAll();
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("/view/customer.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        CustomerDAO dao = new CustomerDAO();

        switch (action) {
            case "add": {
                String customerCode = trimParam(request.getParameter("customerCode"));
                String name = trimParam(request.getParameter("name"));
                String phone = trimParam(request.getParameter("phone"));
                String email = trimParam(request.getParameter("email"));
                String address = trimParam(request.getParameter("address"));

                if (customerCode.isEmpty() || name.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/customers");
                    return;
                }
                Customer c = new Customer();
                c.setCustomerCode(customerCode);
                c.setName(name);
                c.setPhone(phone);
                c.setEmail(email);
                c.setAddress(address);
                dao.insert(c);
                break;
            }
            case "update": {
                String idStr = request.getParameter("customerId");
                if (idStr == null || idStr.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/customers");
                    return;
                }
                int id;
                try {
                    id = Integer.parseInt(idStr.trim());
                } catch (NumberFormatException e) {
                    response.sendRedirect(request.getContextPath() + "/customers");
                    return;
                }
                String customerCode = trimParam(request.getParameter("customerCode"));
                String name = trimParam(request.getParameter("name"));
                String phone = trimParam(request.getParameter("phone"));
                String email = trimParam(request.getParameter("email"));
                String address = trimParam(request.getParameter("address"));

                if (customerCode.isEmpty() || name.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/customers");
                    return;
                }
                Customer c = new Customer();
                c.setId(id);
                c.setCustomerCode(customerCode);
                c.setName(name);
                c.setPhone(phone);
                c.setEmail(email);
                c.setAddress(address);
                dao.update(c);
                break;
            }
            case "delete": {
                String idStr = request.getParameter("customerId");
                if (idStr != null && !idStr.trim().isEmpty()) {
                    try {
                        int id = Integer.parseInt(idStr.trim());
                        dao.delete(id);
                    } catch (NumberFormatException ignored) {
                    }
                }
                break;
            }
            default:
                break;
        }

        response.sendRedirect(request.getContextPath() + "/customers");
    }

    private static String trimParam(String s) {
        return s == null ? "" : s.trim();
    }
}
