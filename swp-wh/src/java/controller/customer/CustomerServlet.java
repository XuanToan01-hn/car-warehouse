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

        CustomerDAO dao = new CustomerDAO();
        String search = request.getParameter("search");

        // Load filtered customers
        List<Customer> allCustomers;
        if (search != null && !search.trim().isEmpty()) {
            allCustomers = dao.search(search.trim());
            request.setAttribute("search", search.trim());
        } else {
            allCustomers = dao.getAll();
        }

        // Pagination Logic
        int pageSize = 5;
        String pageStr = request.getParameter("page");
        int currentPage = (pageStr != null && !pageStr.trim().isEmpty()) ? Integer.parseInt(pageStr.trim()) : 1;

        int totalCustomers = allCustomers.size();
        int totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        int start = (currentPage - 1) * pageSize;
        int end = Math.min(start + pageSize, totalCustomers);

        List<Customer> pagedCustomers = new java.util.ArrayList<>();
        if (start < totalCustomers) {
            pagedCustomers = allCustomers.subList(start, end);
        }

        request.setAttribute("customers", pagedCustomers);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Edit mode: load the customer to be edited
        String mode = request.getParameter("mode");
        if ("edit".equals(mode)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    Customer editing = dao.getById(id);
                    request.setAttribute("editCustomer", editing);
                    request.setAttribute("mode", "edit");
                } catch (NumberFormatException ignored) {}
            }
        } else if ("add".equals(mode)) {
            request.setAttribute("mode", "add");
        }

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
                String customerCode = dao.getNextCustomerCode();
                String name = trimParam(request.getParameter("name"));
                String phone = trimParam(request.getParameter("phone"));
                String email = trimParam(request.getParameter("email"));
                String address = trimParam(request.getParameter("address"));

                if (name.isEmpty() || !isValidName(name)) {
                    request.getSession().setAttribute("error", "Thêm khách hàng không thành công. Tên phải là định dạng chữ!");
                    response.sendRedirect(request.getContextPath() + "/customers");
                    return;
                }
                
                if (!phone.isEmpty() && !isValidPhone(phone)) {
                    request.getSession().setAttribute("error", "Thêm khách hàng không thành công. Số điện thoại phải là 10 số và bắt đầu bằng số 0!");
                    response.sendRedirect(request.getContextPath() + "/customers");
                    return;
                }

                if (!email.isEmpty() && !isValidEmail(email)) {
                    request.getSession().setAttribute("error", "Thêm khách hàng không thành công. Email không đúng định dạng!");
                    response.sendRedirect(request.getContextPath() + "/customers?mode=add");
                    return;
                }

                if (!phone.isEmpty() && dao.isPhoneExists(phone, 0)) {
                    request.getSession().setAttribute("error", "Thêm khách hàng không thành công. Số điện thoại \"" + phone + "\" đã tồn tại!");
                    response.sendRedirect(request.getContextPath() + "/customers?mode=add");
                    return;
                }

                if (!email.isEmpty() && dao.isEmailExists(email, 0)) {
                    request.getSession().setAttribute("error", "Thêm khách hàng không thành công. Email \"" + email + "\" đã tồn tại!");
                    response.sendRedirect(request.getContextPath() + "/customers?mode=add");
                    return;
                }

                Customer c = new Customer();
                c.setCustomerCode(customerCode);
                c.setName(name);
                c.setPhone(phone);
                c.setEmail(email);
                c.setAddress(address);
                dao.insert(c);
                request.getSession().setAttribute("success", "Thêm khách hàng thành công!");
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


                if (name.isEmpty() || !isValidName(name)) {
                    request.getSession().setAttribute("error", "Cập nhật khách hàng không thành công. Tên phải là định dạng chữ!");
                    response.sendRedirect(request.getContextPath() + "/customers");
                    return;
                }
                
                if (!phone.isEmpty() && !isValidPhone(phone)) {
                    request.getSession().setAttribute("error", "Cập nhật khách hàng không thành công. Số điện thoại phải là 10 số và bắt đầu bằng số 0!");
                    response.sendRedirect(request.getContextPath() + "/customers");
                    return;
                }

                if (!email.isEmpty() && !isValidEmail(email)) {
                    request.getSession().setAttribute("error", "Cập nhật khách hàng không thành công. Email không đúng định dạng!");
                    response.sendRedirect(request.getContextPath() + "/customers?mode=edit&id=" + id);
                    return;
                }

                if (!phone.isEmpty() && dao.isPhoneExists(phone, id)) {
                    request.getSession().setAttribute("error", "Cập nhật khách hàng không thành công. Số điện thoại \"" + phone + "\" đã tồn tại!");
                    response.sendRedirect(request.getContextPath() + "/customers?mode=edit&id=" + id);
                    return;
                }

                if (!email.isEmpty() && dao.isEmailExists(email, id)) {
                    request.getSession().setAttribute("error", "Cập nhật khách hàng không thành công. Email \"" + email + "\" đã tồn tại!");
                    response.sendRedirect(request.getContextPath() + "/customers?mode=edit&id=" + id);
                    return;
                }

                if (customerCode.isEmpty()) {
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
                request.getSession().setAttribute("success", "Cập nhật khách hàng thành công!");
                break;
            }
            case "delete": {
                String idStr = request.getParameter("customerId");
                if (idStr != null && !idStr.trim().isEmpty()) {
                    try {
                        int id = Integer.parseInt(idStr.trim());
                        dal.SalesOrderDAO soDAO = new dal.SalesOrderDAO();
                        
                        if (soDAO.hasOrders(id)) {
                             request.getSession().setAttribute("error", "Không thể xóa khách hàng này vì đã có đơn hàng được tạo hoặc đã giao!");
                             response.sendRedirect(request.getContextPath() + "/customers");
                             return;
                        }

                        if (dao.delete(id)) {
                            request.getSession().setAttribute("success", "Xóa khách hàng thành công!");
                        } else {
                            request.getSession().setAttribute("error", "Xóa khách hàng thất bại!");
                        }
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

    private boolean isValidName(String name) {
        // Chỉ bao gồm chữ cái và khoảng trắng
        return name.matches("^[\\p{L}\\s]+$");
    }

    private boolean isValidPhone(String phone) {
        // 10 số bắt đầu là số 0
        return phone.matches("^0\\d{9}$");
    }

    private boolean isValidEmail(String email) {
        return email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }

    private static String trimParam(String s) {
        return s == null ? "" : s.trim();
    }
}
