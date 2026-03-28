/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.security;

import dal.PermissionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.PermissionGroup;
import model.Role;
import model.RolePermission;

/**
 *
 * @author admin
 */
@WebServlet(name = "UpdatePermissionServlet", urlPatterns = {"/update-permission"})
public class UpdatePermissionServlet extends HttpServlet {

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
            out.println("<title>Servlet UpdatePermissionServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdatePermissionServlet at " + request.getContextPath() + "</h1>");
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
        PermissionDAO permissionDAO = new PermissionDAO();
        HttpSession session = request.getSession();
        try {
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            request.setAttribute("selectedRoleId", roleId);
            String[] permissionId_Raw = request.getParameterValues("permissionId");
            if (permissionId_Raw != null) {
                permissionDAO.deletePermission(roleId);
                for (String pId : permissionId_Raw) {
                    int permissionId = Integer.parseInt(pId);
                    permissionDAO.addPermission(roleId, permissionId);
                }
                session.setAttribute("toast", true);
                session.setAttribute("message", "Update success!");
            }

            List<Role> listRole = permissionDAO.getListRole();
            request.setAttribute("listRole", listRole);
            List<PermissionGroup> listPermissionGroup = permissionDAO.getListPermissionGroup();
            request.setAttribute("listPermissionGroup", listPermissionGroup);
            List<RolePermission> listRolePermission = permissionDAO.getListRolePermissionByRoleId(roleId);
            Set<Integer> rolePermissionIds = new HashSet<>();
            for (RolePermission rp : listRolePermission) {
                rolePermissionIds.add(rp.getPermission().getId());
            }
            request.setAttribute("rolePermissionIds", rolePermissionIds);
            request.getRequestDispatcher("view/security/page-permissions.jsp").forward(request, response);
        } catch (NumberFormatException nfe) {
            System.out.println(nfe.getMessage());
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
    }// </editor-fold>a

}