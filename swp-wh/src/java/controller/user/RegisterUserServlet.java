
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

    UserDAO userService = new UserDAO();
    RoleDAO roleService = new RoleDAO();
    WarehouseDAO warehouseDAO = new WarehouseDAO();

    HttpSession session = request.getSession();
    boolean hasError = false;

    // Get parameters
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

    // ===== VALIDATION =====

    // Full Name
    if (InputValidator.isEmpty(name)) {
        request.setAttribute("error_name", "Full name is required!");
        hasError = true;
    }

    // Phone
    if (InputValidator.isEmpty(phone)) {
        request.setAttribute("error_phone", "Phone number is required!");
        hasError = true;
    } else if (userService.isPhoneExist(phone)) {
        request.setAttribute("error_phone", "Phone number already exists!");
        hasError = true;
    }

    // User Code
    if (InputValidator.isEmpty(userCode)) {
        request.setAttribute("error_userCode", "Employee code is required!");
        hasError = true;
    } else if (userService.isUserCodeExist(userCode)) {
        request.setAttribute("error_userCode", "Employee code already exists!");
        hasError = true;
    }

    // Username
    if (InputValidator.isEmpty(username)) {
        request.setAttribute("error_username", "Username is required!");
        hasError = true;
    } else if (userService.isUsernameExist(username)) {
        request.setAttribute("error_username", "Username already exists!");
        hasError = true;
    }

    // Email
    if (InputValidator.isEmpty(email)) {
        request.setAttribute("error_email", "Email is required!");
        hasError = true;
    } else if (userService.isEmailExist(email)) {
        request.setAttribute("error_email", "Email already exists!");
        hasError = true;
    }

    // Password
    if (InputValidator.isEmpty(password)) {
        request.setAttribute("error_password", "Password is required!");
        hasError = true;
    }

    // Confirm Password
    if (!password.equals(confirmPassword)) {
        request.setAttribute("error_confirmPassword", "Passwords do not match!");
        hasError = true;
    }

    // Date of Birth
    if (InputValidator.isEmpty(dateOfBirthStr)) {
        request.setAttribute("error_dateOfBirth", "Date of birth is required!");
        hasError = true;
    } else {
        try {
            LocalDate dob = LocalDate.parse(dateOfBirthStr);
            if (!dob.isBefore(LocalDate.now())) {
                request.setAttribute("error_dateOfBirth", "Date of birth must be in the past!");
                hasError = true;
            }
        } catch (Exception e) {
            request.setAttribute("error_dateOfBirth", "Invalid date format!");
            hasError = true;
        }
    }

    if (roleStr != null) {
        int roleId = Integer.parseInt(roleStr);

        if ((roleId == 3 || roleId == 4 || roleId == 5)) {

            request.setAttribute("error_warehouse", "Warehouse is required for this role!");
            hasError = true;
        }
    }

    if (hasError) {
        request.setAttribute("listR", roleService.getAll());
        request.setAttribute("listWarehouse", warehouseDAO.getAll());

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
        return;
    }

    // ===== INSERT =====
    try {
        int roleId = Integer.parseInt(roleStr);
        int male = Integer.parseInt(maleStr);
        int warehouseId = (warehouseIdStr != null && !warehouseIdStr.isEmpty())
                ? Integer.parseInt(warehouseIdStr) : 0;

        String encodedPassword = EndCode.toSHA1(password);

        User user = new User();
        user.setFullName(name);
        user.setPhone(phone);
        user.setUserCode(userCode);
        user.setEmail(email);
        user.setUsername(username);
        user.setPassword(encodedPassword);
        user.setRole(new Role(roleId));
        user.setMale(male);
        user.setDateOfBirth(dateOfBirthStr);
        user.setWarehouse(new Warehouse(warehouseId));

        boolean success = userService.insert(user);

        if (success) {
            session.setAttribute("success", "User created successfully!");
            response.sendRedirect("registeruser");
        } else {
            throw new Exception("Insert operation failed!");
        }

    } catch (Exception e) {
        e.printStackTrace();

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
