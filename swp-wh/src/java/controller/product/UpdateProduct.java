/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.product;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.UnitDAO;
import dal.SupplierDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import model.Category;
import model.Product;
import model.Unit;
import model.Supplier;

/**
 *
 * @author Asus
 */
@WebServlet(name = "UpdateProduct", urlPatterns = { "/update-product" })
public class UpdateProduct extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     * 
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateProduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateProduct at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     * 
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        try {
            int id = Integer.parseInt(idStr);
            Product product = productDAO.getById(id);
            if (product != null) {
                // Đẩy dữ liệu vào request để JSP hiển thị
                request.setAttribute("p", product);
                request.setAttribute("listCategory", categoryDAO.getAll());
                request.setAttribute("listUnit", unitDAO.getAll());
                request.setAttribute("listSupplier", supplierDAO.getAll());
                request.getRequestDispatcher("view/product/page-update-product.jsp").forward(request, response);
            } else {
                response.sendRedirect("list-product");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("list-product");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * 
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        // 1. Lấy dữ liệu từ form
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect("list-product?error=missingId");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("list-product?error=invalidId");
            return;
        }

        String name = request.getParameter("name");
        String code = request.getParameter("code");
        String categoryId = request.getParameter("category");
        String unitId = request.getParameter("unit");
        String supplierId = request.getParameter("supplier");
        String image = request.getParameter("image");
        String description = request.getParameter("description");

        // 2. Validation (Ví dụ cơ bản)
        boolean hasError = false;
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("eName", "Name is required");
            hasError = true;
        }
        if (code == null || code.trim().isEmpty()) {
            request.setAttribute("eCode", "Code is required");
            hasError = true;
        }

        if (hasError) {
            // Nếu có lỗi, load lại trang kèm thông báo
            request.setAttribute("listCategory", categoryDAO.getAll());
            request.setAttribute("listUnit", unitDAO.getAll());
            request.setAttribute("listSupplier", supplierDAO.getAll());
            // Tạo một object product giả để giữ lại các giá trị user vừa nhập
            Product p = new Product();
            p.setId(id);
            p.setName(name);
            p.setCode(code);
            p.setImage(image);
            p.setDescription(description);
            // Bạn có thể set thêm category và unit tương tự
            request.setAttribute("p", p);
            request.getRequestDispatcher("view/product/page-update-product.jsp").forward(request, response);
        } else {
            // 3. Thực hiện Update
            Product p = new Product();
            p.setId(id);
            p.setName(name);
            p.setCode(code);
            p.setImage(image);
            p.setDescription(description);

            Category c = new Category();
            if (categoryId != null && !categoryId.isEmpty()) {
                c.setId(Integer.parseInt(categoryId));
                p.setCategory(c);
            }

            Unit u = new Unit();
            if (unitId != null && !unitId.isEmpty()) {
                u.setId(Integer.parseInt(unitId));
                p.setUnit(u);
            }

            if (supplierId != null && !supplierId.isEmpty()) {
                Supplier s = new Supplier();
                s.setId(Integer.parseInt(supplierId));
                p.setSupplier(s);
            }

            productDAO.update(p);

            // Chuyển hướng về trang danh sách với thông báo thành công
            response.sendRedirect("list-product?status=updateSuccess");
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
