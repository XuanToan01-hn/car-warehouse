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
import model.Role;
import model.User;
import dal.WarehouseDAO;
import model.Warehouse;

/**
 *
 */
@WebServlet(name = "UserListServlet", urlPatterns = {"/userlist"})
public class UserListServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
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

        // Lấy keyword
        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }

        // FIX: Lấy roleId dưới dạng String để truyền sang JSP so sánh an toàn
        String roleIdParam = request.getParameter("roleId");
        Integer roleId = null;
        String selectedRoleId = ""; // String rỗng = "All Roles"

        if (roleIdParam != null && !roleIdParam.trim().isEmpty()) {
            try {
                roleId = Integer.parseInt(roleIdParam.trim());
                selectedRoleId = String.valueOf(roleId); // chỉ set nếu parse thành công
            } catch (NumberFormatException e) {
                roleId = null;
                selectedRoleId = "";
            }
        }

        // Phân trang
        int page = 1;
        int pageSize = 10;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
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

        if (keyword != null && !keyword.isEmpty()) {
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
            if (roleId != null) {
                listU = userService.getUserByRole(roleId, (page - 1) * pageSize, pageSize);
                totalUsers = userService.countUsersByRole(roleId);
            } else {
                listU = userService.getUserByPage(page, pageSize);
                totalUsers = userService.getTotalUserCount();
            }
        }

        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (totalPages < 1) totalPages = 1;

        // FIX: set selectedRoleId là String để JSP so sánh bằng .toString() không bị lỗi type
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("selectedRoleId", selectedRoleId); // String, dùng trong JSP
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("listUser", listU);
        request.setAttribute("roles", roles);
        request.setAttribute("listWarehouse", wh);

        request.getRequestDispatcher("view/user/page-list-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
