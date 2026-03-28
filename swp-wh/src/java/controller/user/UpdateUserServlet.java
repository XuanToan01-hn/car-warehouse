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
        String maleStr = request.getParameter("male");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleIdStr = request.getParameter("roleId");
        String warehouseIdStr = request.getParameter("warehouseId");

        if (InputValidator.isEmpty(idStr)) {
            session.setAttribute("error", "User ID not found!");
            response.sendRedirect("userlist?page=" + page);
            return;
        }
        int userId = Integer.parseInt(idStr);

        UserDAO userService = new UserDAO();
        User existing = userService.getById(userId);

        if (existing == null) {
            session.setAttribute("error", "User does not exist!");
            response.sendRedirect("userlist?page=" + page);
            return;
        }

        // Validate fullName
        if (InputValidator.isEmpty(fullName) || !InputValidator.isValid(fullName, InputValidator.NAME_USER)) {
            session.setAttribute("error", "Invalid Full Name!");
            redirectBack(response, page, keyword);
            return;
        }

        // Validate email
        if (InputValidator.isEmpty(email) || !InputValidator.isValid(email, InputValidator.EMAIL_REGEX)) {
            session.setAttribute("error", "Invalid Email Address!");
            redirectBack(response, page, keyword);
            return;
        }

        // Validate phone
        if (InputValidator.isEmpty(phone) || !InputValidator.isValid(phone, InputValidator.PHONE_NUMBER)) {
            session.setAttribute("error", "Invalid Phone Number!");
            redirectBack(response, page, keyword);
            return;
        }

        // Validate Date of Birth
        if (InputValidator.isEmpty(dateOfBirthStr)) {
            session.setAttribute("error", "Date of Birth cannot be empty!");
            redirectBack(response, page, keyword);
            return;
        }
        LocalDate dob = LocalDate.parse(dateOfBirthStr);
        if (!dob.isBefore(LocalDate.now())) {
            session.setAttribute("error", "Date of Birth cannot be today or in the future!");
            redirectBack(response, page, keyword);
            return;
        }
//        if (!InputValidator.isOver18(dob)) {
//            session.setAttribute("error", "User must be at least 18 years old!");
//            redirectBack(response, page, keyword);
//            return;
//        }

        // Check duplicate email
        if (!email.equalsIgnoreCase(existing.getEmail()) && userService.isEmailExist(email)) {
            session.setAttribute("error", "Email already exists in the system!");
            redirectBack(response, page, keyword);
            return;
        }

        // Check duplicate phone
        if (!phone.equals(existing.getPhone()) && userService.isPhoneExist(phone)) {
            session.setAttribute("error", "Phone number already exists!");
            redirectBack(response, page, keyword);
            return;
        }

        // Validate warehouse by role
        int roleId = Integer.parseInt(roleIdStr);
        Integer warehouseId = null;
        if (roleId == 3 || roleId == 4 || roleId == 5) {
            if (InputValidator.isEmpty(warehouseIdStr) || "0".equals(warehouseIdStr)) {
                session.setAttribute("error", "Please assign a Warehouse for this role!");
                redirectBack(response, page, keyword);
                return;
            }
            warehouseId = Integer.parseInt(warehouseIdStr);
        }

        existing.setFullName(fullName);
        existing.setMale(Integer.parseInt(maleStr));
        existing.setDateOfBirth(dateOfBirthStr);
        existing.setEmail(email);
        existing.setPhone(phone);
        existing.setRole(new Role(roleId));
        existing.setWarehouse(warehouseId != null && warehouseId > 0 ? new Warehouse(warehouseId) : null);

        boolean updated = userService.update(existing);

        if (updated) {
            session.setAttribute("success", "User updated successfully!");
        } else {
            session.setAttribute("error", "Update failed due to a system error!");
        }

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "System error: " + e.getMessage());
    }

    response.sendRedirect("userlist?page=" + page + "&keyword=" + URLEncoder.encode(keyword == null ? "" : keyword, "UTF-8"));
}
private void redirectBack(HttpServletResponse response, String page, String keyword) throws IOException {
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
