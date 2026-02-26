/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.category;

import dal.CategoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Category;

/**
 *
 * @author Nhat
 */
@WebServlet(name = "ListCategory", urlPatterns = {"/list-category"})
public class ListCategory extends HttpServlet {

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
            out.println("<title>Servlet ListCategory</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListCategory at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        if ("getDetailJson".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    CategoryDAO dao = new CategoryDAO();
                    Category c = dao.getByID(id);
                    if (c != null) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        String nameJson = c.getName() != null ? c.getName().replace("\"", "\\\"") : "";
                        String descJson = c.getDescription() != null ? c.getDescription().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") : "";
                        String json = String.format("{\"id\": %d, \"name\": \"%s\", \"description\": \"%s\"}",
                                c.getId(), nameJson, descJson);
                        response.getWriter().write(json);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    CategoryDAO dao = new CategoryDAO();
                    dao.delete(id);
                } catch (NumberFormatException ignored) {}
            }
            response.sendRedirect("list-category");
            return;
        }

        final int PAGE_SIZE = 10;
        String keyword = request.getParameter("search");
        if (keyword == null) {
            keyword = "";
        }

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * PAGE_SIZE;

        CategoryDAO dao = new CategoryDAO();
        List<Category> categoryList = dao.searchAndPaginate(keyword, offset, PAGE_SIZE);
        int totalRecords = dao.count(keyword);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("categoryList", categoryList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", keyword);

        request.getRequestDispatcher("/view/category/page-list-category.jsp").forward(request, response);
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
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String idStr = request.getParameter("id");

        CategoryDAO dao = new CategoryDAO();
        if ("add".equals(action)) {
            dao.insert(new Category(0, name, description));
        } else if ("update".equals(action)) {
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    dao.update(new Category(id, name, description));
                } catch (NumberFormatException ignored) {}
            }
        }
        response.sendRedirect("list-category");
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
