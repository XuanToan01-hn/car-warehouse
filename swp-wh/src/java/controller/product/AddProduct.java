package controller.product;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.UnitDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import utils.InputValidator;

@WebServlet(name = "AddProduct", urlPatterns = {"/add-product"})
// ĐÃ XÓA @MultipartConfig
public class AddProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();
        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("listCategory", categoryDAO.getAll());
        request.getRequestDispatcher("view/product/page-add-product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Tránh lỗi tiếng Việt
        request.setCharacterEncoding("UTF-8");

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();

        boolean status = true;
        boolean flag = true;

        // Lấy dữ liệu dạng String thông thường
        String name = (request.getParameter("name") != null) ? request.getParameter("name").trim() : "";
        String code = (request.getParameter("code") != null) ? request.getParameter("code").trim() : "";
        String priceStr = request.getParameter("price");
        String categoryStr = request.getParameter("category");
        String unitStr = request.getParameter("unit");
        String image = (request.getParameter("image") != null) ? request.getParameter("image").trim() : "";
        String description = (request.getParameter("description") != null) ? request.getParameter("description").trim() : "";

        long price = 0;
        int categoryId = 0;
        int unitId = 0;

        try {
            if (priceStr != null) price = Long.parseLong(priceStr);
            if (categoryStr != null) categoryId = Integer.parseInt(categoryStr);
            if (unitStr != null) unitId = Integer.parseInt(unitStr);
        } catch (NumberFormatException e) {
            flag = false;
        }

        // Validation cơ bản
        if (name.isEmpty()) { request.setAttribute("eName", "Name is required"); flag = false; }
        if (price <= 0) { request.setAttribute("ePrice", "Price > 0"); flag = false; }

        if (!flag) {
            status = false;
            // Sticky Form dữ liệu cũ
            request.setAttribute("uName", name);
            request.setAttribute("uCode", code);
            request.setAttribute("uPrice", price);
            request.setAttribute("uCategory", categoryId);
            request.setAttribute("uImage", image);
            request.setAttribute("uDes", description);
            request.setAttribute("unitS", unitId);
        } else {
            // FIX: Sử dụng setter thay vì constructor để tránh lỗi khi Model thay đổi
            Product product = new Product();
            product.setCode(code);
            product.setName(name);
            product.setPrice((double) price);
            product.setDescription(description);
            product.setImage(image);
            product.setUnit(unitDAO.getUnitById(unitId));
            product.setCategory(categoryDAO.getByID(categoryId));
            product.setMinStock(0); // Set mặc định
            // Nếu có Supplier thì thêm: product.setSupplier(supplierDAO.getById(supplierId));

            productDAO.insert(product);
        }

        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("listCategory", categoryDAO.getAll());
        request.setAttribute("showStatus", status);
        request.getRequestDispatcher("view/product/page-add-product.jsp").forward(request, response);
    }
}