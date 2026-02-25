/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dal.LocationDAO;
import dal.RoleDAO;
import dal.UserDAO;
import dal.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.List;
import model.Location;
import model.Role;
import model.User;
import model.Warehouse;
import utils.EndCode;
import utils.InputValidator;

/**
 *
 *
 */
@WebServlet(name = "RegisterUserServlet", urlPatterns = {"/registeruser"})
public class RegisterUserServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RegisterUserServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterUserServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Hiển thị và xóa thông báo
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }

        RoleDAO roleService = new RoleDAO();
        List<Role> listR = roleService.getAll();

        WarehouseDAO w = new WarehouseDAO();
        List<Warehouse> listL = w.getAll();
        request.setAttribute("listWarehouse", listL);
        request.setAttribute("listR", listR);
        request.getRequestDispatcher("view/user/page-add-users.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Khởi tạo các DAO cần thiết
        UserDAO userService = new UserDAO();
        RoleDAO roleService = new RoleDAO();
        WarehouseDAO warehouseDAO = new WarehouseDAO(); // Dùng thống nhất WarehouseDAO

        HttpSession session = request.getSession();
        boolean hasError = false;

        // 2. Lấy dữ liệu từ Form
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String userCode = request.getParameter("userCode");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String roleStr = request.getParameter("role");
        String maleStr = request.getParameter("male");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String warehouseIdStr = request.getParameter("warehouseId");

        // 3. Validation logic
        if (utils.InputValidator.isEmpty(name)) {
            request.setAttribute("error_name", "Full name is required!");
            hasError = true;
        }
        if (utils.InputValidator.isEmpty(phone) || userService.isPhoneExist(phone)) {
            request.setAttribute("error_phone", "Phone invalid or already exists!");
            hasError = true;
        }
        if (userService.isUserCodeExist(userCode)) {
            request.setAttribute("error_userCode", "Employee code already exists!");
            hasError = true;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error_confirmPassword", "Passwords do not match!");
            hasError = true;
        }

        // 4. Xử lý khi có lỗi nhập liệu (Validation Fail)
        if (hasError) {
            // Load lại dữ liệu cho các dropdown
            request.setAttribute("listR", roleService.getAll());
            request.setAttribute("listWarehouse", warehouseDAO.getAll());

            // Giữ lại các giá trị user đã nhập (trừ password)
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("userCode", userCode);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.setAttribute("dateOfBirth", dateOfBirthStr);
            request.setAttribute("role", roleStr);
            request.setAttribute("male", maleStr);
            request.setAttribute("warehouseId", warehouseIdStr);

            request.getRequestDispatcher("view/user/page-add-users.jsp").forward(request, response);
            return; // Dừng tại đây, không chạy xuống dưới
        }

        // 5. Thực hiện Insert vào Database
        try {
            int roleId = Integer.parseInt(roleStr);
            int male = Integer.parseInt(maleStr);
            int warehouseId = (warehouseIdStr != null && !warehouseIdStr.isEmpty()) ? Integer.parseInt(warehouseIdStr) : 0;

            String encodedPassword = utils.EndCode.toSHA1(password);

            model.User user = new model.User();
            user.setFullName(name);
            user.setPhone(phone);
            user.setUserCode(userCode);
            user.setEmail(email);
            user.setUsername(username);
            user.setPassword(encodedPassword);
            user.setRole(new model.Role(roleId));
            user.setMale(male);
            user.setDateOfBirth(dateOfBirthStr);
            user.setWarehouse(new model.Warehouse(warehouseId));

            boolean success = userService.insert(user);

            if (success) {
                session.setAttribute("success", "User added successfully!");
                response.sendRedirect("registeruser"); // Thành công thì Redirect để tránh trùng lặp dữ liệu khi F5
            } else {
                throw new Exception("Database insert returned false.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Khi crash (Exception), vẫn phải forward về trang cũ và báo lỗi
            request.setAttribute("error", "System error: " + e.getMessage());
            request.setAttribute("listR", roleService.getAll());
            request.setAttribute("listWarehouse", warehouseDAO.getAll());
            request.getRequestDispatcher("view/user/page-add-users.jsp").forward(request, response);
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
