/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.access;

import java.io.IOException;
import java.io.PrintWriter;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.EndCode;
import utils.InputValidator;

/**
 *
 * @author LEGION
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

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
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("view/auth-sign-in.jsp").forward(request, response);
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
        String emailStr = request.getParameter("email");
        String passwordStr = request.getParameter("password");
        String remember = request.getParameter("remember");

        if (InputValidator.isEmpty(emailStr) || InputValidator.isEmpty(passwordStr)) {
            request.setAttribute("error", "Email and password must not be empty.");
            request.getRequestDispatcher("view/auth-sign-in.jsp").forward(request, response);
            return;
        }

        if (!InputValidator.isValid(emailStr, InputValidator.EMAIL_REGEX)) {
            request.setAttribute("error", "Invalid email format.");
            request.getRequestDispatcher("view/auth-sign-in.jsp").forward(request, response);
            return;
        }

        UserDAO userService = new UserDAO();
        String passwordEncode = EndCode.toSHA1(passwordStr);
        User user = userService.loginAuth(emailStr, passwordStr);
        if (user != null) {
            // Login successful -> Save to session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Handle Remember Me
            if ("on".equals(remember)) {
                // Save email and password to cookies for 7 days
                Cookie emailCookie = new Cookie("email", emailStr);
                Cookie passwordCookie = new Cookie("password", passwordStr);
                Cookie rememberCookie = new Cookie("remember", "on");

                int expiry = 7 * 24 * 60 * 60; // 7 days in seconds

                emailCookie.setMaxAge(expiry);
                passwordCookie.setMaxAge(expiry);
                rememberCookie.setMaxAge(expiry);

                response.addCookie(emailCookie);
                response.addCookie(passwordCookie);
                response.addCookie(rememberCookie);

            } else {
                // Not remembered -> delete cookies if they exist
                Cookie emailCookie = new Cookie("email", "");
                Cookie passwordCookie = new Cookie("password", "");
                Cookie rememberCookie = new Cookie("remember", "");

                emailCookie.setMaxAge(0);
                passwordCookie.setMaxAge(0);
                rememberCookie.setMaxAge(0);

                response.addCookie(emailCookie);
                response.addCookie(passwordCookie);
                response.addCookie(rememberCookie);
            }
            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Incorrect email or password.");
            request.getRequestDispatcher("view/auth-sign-in.jsp").forward(request, response);
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
