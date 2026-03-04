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
import model.Category;
import model.Product;
import model.Unit;
import model.Supplier;

@WebServlet(name="UpdateProduct", urlPatterns={"/update-product"})
public class UpdateProduct extends HttpServlet {
   
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        // 1. Lấy dữ liệu (ĐÃ BỎ PRICE)
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String code = request.getParameter("code");
        String categoryId = request.getParameter("category");
        String unitId = request.getParameter("unit");
        String supplierId = request.getParameter("supplier");
        String image = request.getParameter("image");
        String description = request.getParameter("description");

        // 2. Validation
        boolean hasError = false;
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("eName", "Name is required");
            hasError = true;
        }

        if (hasError) {
            request.setAttribute("listCategory", categoryDAO.getAll());
            request.setAttribute("listUnit", unitDAO.getAll());
            request.setAttribute("listSupplier", supplierDAO.getAll());
            
            // Giữ lại dữ liệu cũ để người dùng sửa
            Product p = new Product();
            p.setId(Integer.parseInt(idStr));
            p.setName(name);
            p.setCode(code);
            p.setImage(image);
            p.setDescription(description);
            // Có thể set thêm ID cho Category/Unit/Supplier nếu cần logic hiển thị lại selection
            
            request.setAttribute("p", p);
            request.getRequestDispatcher("view/product/page-update-product.jsp").forward(request, response);
        } else {
            // 3. Thực hiện Update (Đã bỏ Price)
            Product p = new Product();
            p.setId(Integer.parseInt(idStr));
            p.setName(name);
            p.setCode(code);
            p.setImage(image);
            p.setDescription(description);
            
            Category c = new Category(); 
            c.setId(Integer.parseInt(categoryId));
            p.setCategory(c);
            
            Unit u = new Unit(); 
            u.setId(Integer.parseInt(unitId));
            p.setUnit(u);

            Supplier s = new Supplier();
            s.setId(Integer.parseInt(supplierId));
            p.setSupplier(s);

            productDAO.update(p);
            
            response.sendRedirect("list-product?status=updateSuccess");
        }
    }
}