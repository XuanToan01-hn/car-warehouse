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
import java.util.List;
import model.Location;
import model.Role;
import model.User;
import dal.WarehouseDAO;
import model.Warehouse;
/**
 *
 * @author LEGION
 */
@WebServlet(name = "UserListServlet", urlPatterns = {"/userlist"})
public class UserListServlet extends HttpServlet {

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
            out.println("<title>Servlet UserListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserListServlet at " + request.getContextPath() + "</h1>");
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

        // Lấy keyword và trang hiện tại
        String keyword = request.getParameter("keyword");
        String roleIdParam = request.getParameter("roleId");
        Integer roleId = null;
        if (roleIdParam != null && !roleIdParam.isEmpty()) {
            try {
                roleId = Integer.parseInt(roleIdParam.trim());
            } catch (Exception e) {
                roleId = null;
            }
        }

        int page = 1;
        int pageSize = 10;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        UserDAO userService = new UserDAO();
        RoleDAO roleService = new RoleDAO();
        WarehouseDAO wd = new WarehouseDAO();
        List<Warehouse> wh = wd.getAll();
        List<Role> roles = roleService.getAll();
        List<User> listU;
        int totalUsers;

        // Trường hợp có từ khóa tìm kiếm
        if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();

            if (roleId != null) {
                listU = userService.searchUsersWithRole(keyword, roleId, (page - 1) * pageSize, pageSize);
                totalUsers = userService.countSearchUsersWithRole(keyword, roleId);
            } else {
                listU = userService.searchUsers(keyword, (page - 1) * pageSize, pageSize);
                totalUsers = userService.countSearchUsers(keyword);
            }

            if (listU.isEmpty()) {
                request.setAttribute("errorS", "Không tìm thấy người dùng nào phù hợp.");
            }

        } else {
            // Không có từ khóa tìm kiếm
            if (roleId != null) {
                listU = userService.getUserByRole(roleId, (page - 1) * pageSize, pageSize);
                totalUsers = userService.countUsersByRole(roleId);
            } else {
//                listU = userService.getUserByPage(page, pageSize);
//                totalUsers = userService.getTotalUserCount();
            }
        }

//        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        request.setAttribute("keyword", keyword);
        request.setAttribute("roleId", roleId); // giữ lại role đã chọn trên form
        request.setAttribute("currentPage", page);
//        request.setAttribute("totalPages", totalPages);
//        request.setAttribute("listUser", listU);
        request.setAttribute("roles", roles);
        request.setAttribute("listWarehouse", wh);
        request.getRequestDispatcher("view/page-list-users.jsp").forward(request, response);
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
        processRequest(request, response);
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
