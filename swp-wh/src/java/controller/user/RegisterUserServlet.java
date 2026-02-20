/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dal.LocationDAO;
import dal.RoleDAO;
import dal.UserDAO;
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
        LocationDAO locationDAO = new LocationDAO();
        List<Location> listL = locationDAO.getAll();
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
        HttpSession session = request.getSession();
        
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
        String locationIdStr = request.getParameter("warehouseId");
        // Reload role list for JSP
        LocationDAO locationDAO = new LocationDAO();
        RoleDAO roleService = new RoleDAO();
        List<Role> listR = roleService.getAll();
        List<Location> listL = locationDAO.getAll();
        request.setAttribute("listWarehouse", listL);
        request.setAttribute("listR", listR);
        request.setAttribute("warehouseId", locationIdStr);
        boolean hasError = false;

        // --- Validation ---
        if (InputValidator.isEmpty(name) || !InputValidator.isValid(name, InputValidator.NAME_USER)) {
            request.setAttribute("error_name", "Invalid full name!");
            hasError = true;
        }
        
        if (InputValidator.isEmpty(phone) || !InputValidator.isValid(phone, InputValidator.PHONE_NUMBER)) {
            request.setAttribute("error_phone", "Invalid phone number!");
            hasError = true;
        }
        
        if (InputValidator.isEmpty(userCode) || !InputValidator.isValid(userCode, InputValidator.USER_CODE)) {
            request.setAttribute("error_userCode", "Invalid employee code!");
            hasError = true;
        }
        
        if (InputValidator.isEmpty(email) || !InputValidator.isValid(email, InputValidator.EMAIL_REGEX)) {
            request.setAttribute("error_email", "Invalid email address!");
            hasError = true;
        }
        
        if (InputValidator.isEmpty(username) || !InputValidator.isValid(username, InputValidator.USERNAME)) {
            request.setAttribute("error_username", "Invalid username!");
            hasError = true;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error_confirmPassword", "Password confirmation does not match!");
            hasError = true;
        }
        
        if (!InputValidator.isValid(password, InputValidator.PASSWORD)) {
            request.setAttribute("error_password", "Password must be at least 8 characters and include uppercase, lowercase, digits, and special characters.");
            hasError = true;
        }
        
        LocalDate dateOfBirth = null;
        try {
            dateOfBirth = LocalDate.parse(dateOfBirthStr);
            if (!InputValidator.isOver18(dateOfBirth)) {
                request.setAttribute("error_dateOfBirth", "User must be at least 18 years old!");
                hasError = true;
            }
        } catch (Exception e) {
            request.setAttribute("error_dateOfBirth", "Invalid date of birth!");
            hasError = true;
        }
        
        UserDAO userService = new UserDAO();
        
        if (userService.isUserCodeExist(userCode)) {
            
            request.setAttribute("error_userCode", "Employee code already exists!");
            hasError = true;
        }
        
        if (userService.isPhoneExist(phone)) {
            request.setAttribute("error_phone", "Phone number already exists!");
            hasError = true;
        }
        
        if (userService.isEmailExist(email)) {
            request.setAttribute("error_email", "Email address already exists!");
            hasError = true;
        }
        
        if (hasError) {
            // Preserve user input on error
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("userCode", userCode);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.setAttribute("dateOfBirth", dateOfBirthStr);
            request.setAttribute("role", roleStr);
            request.setAttribute("male", maleStr);
            request.getRequestDispatcher("view/user/page-add-users.jsp").forward(request, response);
            return;
        }
        
        try {
            int roleId = Integer.parseInt(roleStr);
            int male = Integer.parseInt(maleStr);
            int locationId = 0;
            if (locationIdStr != null && !locationIdStr.isEmpty()) {
                locationId = Integer.parseInt(locationIdStr);
            }
            
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
            user.setDateOfBirth(dateOfBirth.toString());
            user.setWarehouse(new Warehouse(locationId));
            boolean success = userService.insert(user);
            
            if (success) {
                session.setAttribute("success", "User added successfully!");
                System.out.println("add thành công");
            } else {
                session.setAttribute("error", "An error occurred while adding the user.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing data!");
        }
        
        response.sendRedirect("registeruser");
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
