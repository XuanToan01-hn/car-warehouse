/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

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
import java.net.URLEncoder;
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
 * @author LEGION
 */
@WebServlet(name = "EditUserServlet", urlPatterns = {"/update-user"})
public class UpdateUserServlet extends HttpServlet {

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
            out.println("<title>Servlet EditUserServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditUserServlet at " + request.getContextPath() + "</h1>");
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
//        RoleDAO roleService = new RoleDAO();
//        UserDAO userService = new UserDAO();
//        List<Role> listR = roleService.getAllRole();
//        String userId = request.getParameter("userId");
//        User user = userService.getUserByUserId(Integer.parseInt(userId));
//        request.setAttribute("listR", listR);
//        request.setAttribute("user", user);
//        request.getRequestDispatcher("view/system-edit-user.jsp").forward(request, response);
        processRequest(request, response);
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
        String page = request.getParameter("page");
        String keyword = request.getParameter("keyword");

        try {
            String idStr = request.getParameter("userId");
            String fullName = request.getParameter("fullName");
            String userCode = request.getParameter("userCode");
            String userName = request.getParameter("userName");
            String maleStr = request.getParameter("male");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String roleIdStr = request.getParameter("roleId");
            String warehouseIdStr = request.getParameter("warehouseId");

            // Validate ID
            if (InputValidator.isEmpty(idStr)) {
                session.setAttribute("error", "Invalid user ID!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            int userId = Integer.parseInt(idStr);

            // Validate inputs
            if (InputValidator.isEmpty(fullName) || !InputValidator.isValid(fullName, InputValidator.NAME_USER)) {
                session.setAttribute("error", "Invalid full name!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            if (InputValidator.isEmpty(userCode) || !InputValidator.isValid(userCode, InputValidator.USER_CODE)) {
                session.setAttribute("error", "Invalid user code!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            if (InputValidator.isEmpty(userName) || !InputValidator.isValid(userName, InputValidator.USERNAME)) {
                session.setAttribute("error", "Invalid username!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            if (InputValidator.isEmpty(email) || !InputValidator.isValid(email, InputValidator.EMAIL_REGEX)) {
                session.setAttribute("error", "Invalid email!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            if (InputValidator.isEmpty(phone) || !InputValidator.isValid(phone, InputValidator.PHONE_NUMBER)) {
                session.setAttribute("error", "Invalid phone number!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            int male = Integer.parseInt(maleStr);
            if (male != 0 && male != 1) {
                session.setAttribute("error", "Invalid gender value!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            LocalDate dob = LocalDate.parse(dateOfBirthStr);
            if (!InputValidator.isOver18(dob)) {
                session.setAttribute("error", "User must be at least 18 years old!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            int roleId = Integer.parseInt(roleIdStr);

            UserDAO userService = new UserDAO();
            User existing = userService.getById(userId);

            if (existing == null) {
                session.setAttribute("error", "User not found!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            // Check duplicates if changed
            if (!userCode.equals(existing.getUserCode()) && userService.isUserCodeExist(userCode)) {
                session.setAttribute("error", "User code already exists!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            if (!email.equals(existing.getEmail()) && userService.isEmailExist(email)) {
                session.setAttribute("error", "Email already exists!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            if (!phone.equals(existing.getPhone()) && userService.isPhoneExist(phone)) {
                session.setAttribute("error", "Phone number already exists!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }
            Integer warehouseId = null;
            if (roleId == 3 || roleId == 4 || roleId == 5) {
                if (InputValidator.isEmpty(warehouseIdStr)) {
                    session.setAttribute("error", "Warehouse is required for Sales Warehouse Staff and Purchasing staff!");
                    response.sendRedirect("userlist?page=" + page);
                    return;
                }
                try {
                    warehouseId = Integer.parseInt(warehouseIdStr);
                } catch (NumberFormatException e) {
                    session.setAttribute("error", "Invalid warehouse ID!");
                    response.sendRedirect("userlist?page=" + page);
                    return;
                }
            }
            // Update user info
            existing.setFullName(fullName);
            existing.setUserCode(userCode);
            existing.setUsername(userName);
            existing.setMale(male);
            existing.setDateOfBirth(dob.toString());
            existing.setEmail(email);
            existing.setPhone(phone);
            existing.setRole(new Role(roleId));
            existing.setRole(new Role(roleId));
            if (warehouseId != null) {
                existing.setWarehouse(new Warehouse(warehouseId));
            } else {
                existing.setWarehouse(null);
            }
            boolean updated = userService.update(existing);

            if (updated) {
                session.setAttribute("success", "User updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update user!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Invalid data or system error!");
        }

        response.sendRedirect("userlist?page=" + page + "&keyword=" + URLEncoder.encode(keyword == null ? "" : keyword, "UTF-8"));
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
