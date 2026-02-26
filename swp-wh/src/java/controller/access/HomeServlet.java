/*
 * Home page servlet
 */
package controller.access;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Servlet for home page after login
 * @author System
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user from session
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            // Not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Set user data for the view
        request.setAttribute("user", user);
        if (user.getFullName() != null) {
            request.setAttribute("fullName", user.getFullName());
        } else {
            request.setAttribute("fullName", user.getUsername());
        }
        if (user.getRole() != null) {
            request.setAttribute("roleName", user.getRole().getRoleName());
            request.setAttribute("roleId", user.getRole().getId());
        } else {
            request.setAttribute("roleName", "");
            request.setAttribute("roleId", 0);
        }

        // Forward to index.jsp
        request.getRequestDispatcher("view/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Home page servlet";
    }
}
