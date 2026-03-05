package controller.product;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.UnitDAO;
import dal.SupplierDAO; // Thêm SupplierDAO
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import model.Category;
import model.Unit;
import model.Supplier;

@WebServlet(name = "AddProduct", urlPatterns = {"/add-product"})
public class AddProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();
        SupplierDAO supplierDAO = new SupplierDAO(); // Thêm mới

        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("listCategory", categoryDAO.getAll());
        request.setAttribute("listSupplier", supplierDAO.getAll()); // Đẩy supplier sang view
        request.getRequestDispatcher("view/product/page-add-product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        boolean status = true;
        boolean flag = true;

        // 1. Lấy dữ liệu (ĐÃ BỎ PRICE)
        String name = (request.getParameter("name") != null) ? request.getParameter("name").trim() : "";
        String code = (request.getParameter("code") != null) ? request.getParameter("code").trim() : "";
        String categoryStr = request.getParameter("category");
        String unitStr = request.getParameter("unit");
        String supplierStr = request.getParameter("supplier"); // Thêm mới
        String image = (request.getParameter("image") != null) ? request.getParameter("image").trim() : "";
        String description = (request.getParameter("description") != null) ? request.getParameter("description").trim() : "";

        int categoryId = 0;
        int unitId = 0;
        int supplierId = 0;

        try {
            if (categoryStr != null && !categoryStr.isEmpty()) categoryId = Integer.parseInt(categoryStr);
            if (unitStr != null && !unitStr.isEmpty()) unitId = Integer.parseInt(unitStr);
            if (supplierStr != null && !supplierStr.isEmpty()) supplierId = Integer.parseInt(supplierStr);
        } catch (NumberFormatException e) {
            flag = false;
        }

        // 2. Validation cơ bản
        if (name.isEmpty()) { 
            request.setAttribute("eName", "Name is required"); 
            flag = false; 
        }

        if (!flag) {
            status = false;
            // Sticky Form dữ liệu cũ
            request.setAttribute("uName", name);
            request.setAttribute("uCode", code);
            request.setAttribute("uCategory", categoryId);
            request.setAttribute("uSupplier", supplierId); // Thêm mới
            request.setAttribute("uImage", image);
            request.setAttribute("uDes", description);
            request.setAttribute("unitS", unitId);
        } else {
            // 3. Mapping vào Model và Insert (Không có Price)
            Product product = new Product();
            product.setCode(code);
            product.setName(name);
            product.setDescription(description);
            product.setImage(image);
            
            // Set các object liên quan
            Category c = new Category(); c.setId(categoryId);
            product.setCategory(c);
            
            Unit u = new Unit(); u.setId(unitId);
            product.setUnit(u);
            
            Supplier s = new Supplier(); s.setId(supplierId);
            product.setSupplier(s);

            productDAO.insert(product);
        }

        // Trả lại các list để hiển thị lại form nếu có lỗi hoặc sau khi add
        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("listCategory", categoryDAO.getAll());
        request.setAttribute("listSupplier", supplierDAO.getAll());
        request.setAttribute("showStatus", status);
        request.getRequestDispatcher("view/product/page-add-product.jsp").forward(request, response);
    }
}