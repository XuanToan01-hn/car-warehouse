package controller.product;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.SupplierDAO;
import dal.UnitDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.UUID;
import model.Category;
import model.Product;
import model.Supplier;
import model.Unit;

@WebServlet(name = "ProductServlet", urlPatterns = {"/list-product"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UnitDAO unitDAO = new UnitDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        String categoryIdStr = request.getParameter("categoryId");
        String supplierIdStr = request.getParameter("supplierId");
        
        int categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : 0;
        int supplierId = (supplierIdStr != null && !supplierIdStr.isEmpty()) ? Integer.parseInt(supplierIdStr) : 0;

        // Load filtered products
        List<Product> allProducts = productDAO.search(search, categoryId, supplierId, 1, 1000); // For now, simple list

        // Pagination Logic
        int pageSize = 5;
        String pageStr = request.getParameter("page");
        int currentPage = (pageStr != null && !pageStr.trim().isEmpty()) ? Integer.parseInt(pageStr.trim()) : 1;

        int totalProducts = productDAO.count(search, categoryId, supplierId);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        List<Product> pagedProducts = productDAO.search(search, categoryId, supplierId, currentPage, pageSize);

        request.setAttribute("products", pagedProducts);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("supplierId", supplierId);
        
        // Load dropdown data
        request.setAttribute("categories", categoryDAO.getAll());
        request.setAttribute("units", unitDAO.getAll());
        request.setAttribute("suppliers", supplierDAO.getAll());

        // Mode handling for Add/Edit
        String mode = request.getParameter("mode");
        if ("edit".equals(mode)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Product editing = productDAO.getById(id);
                request.setAttribute("editProduct", editing);
                request.setAttribute("mode", "edit");
            }
        } else if ("add".equals(mode)) {
            request.setAttribute("mode", "add");
            request.setAttribute("nextCode", productDAO.getNextProductCode());
        }

        request.getRequestDispatcher("/view/product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add": {
                // Tự động tạo mã sản phẩm
                String code = productDAO.getNextProductCode();
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                int catId = Integer.parseInt(request.getParameter("categoryId"));
                int unitId = Integer.parseInt(request.getParameter("unitId"));
                int supId = Integer.parseInt(request.getParameter("supplierId"));

                // (Bỏ qua kiểm tra mã trùng lặp vì đây là mã tự sinh)

                // Handle Image Upload
                String imageFileName = uploadFile(request);

                Product p = new Product();
                p.setCode(code);
                p.setName(name);
                p.setDescription(description);
                p.setCategory(categoryDAO.getByID(catId));
                p.setUnit(unitDAO.getUnitById(unitId));
                p.setSupplier(supplierDAO.getById(supId));
                p.setImage(imageFileName != null ? imageFileName : "no-image.png");

                productDAO.insert(p);
                request.getSession().setAttribute("success", "Thêm sản phẩm thành công!");
                break;
            }
            case "update": {
                int id = Integer.parseInt(request.getParameter("id"));
                String code = request.getParameter("code");
                String name = request.getParameter("name");
                String description = request.getParameter("description");
                int catId = Integer.parseInt(request.getParameter("categoryId"));
                int unitId = Integer.parseInt(request.getParameter("unitId"));
                int supId = Integer.parseInt(request.getParameter("supplierId"));

                if (productDAO.isCodeExists(code, id)) {
                    request.getSession().setAttribute("error", "Mã sản phẩm đã tồn tại!");
                    response.sendRedirect("list-product?mode=edit&id=" + id);
                    return;
                }

                // Handle Image Update
                String imageFileName = uploadFile(request);
                Product oldP = productDAO.getById(id);

                Product p = new Product();
                p.setId(id);
                p.setCode(code);
                p.setName(name);
                p.setDescription(description);
                p.setCategory(categoryDAO.getByID(catId));
                p.setUnit(unitDAO.getUnitById(unitId));
                p.setSupplier(supplierDAO.getById(supId));
                
                // Keep old image if no new one is uploaded
                if (imageFileName != null && !imageFileName.isEmpty()) {
                    p.setImage(imageFileName);
                } else if (oldP != null) {
                    p.setImage(oldP.getImage());
                } else {
                    p.setImage("no-image.png");
                }

                productDAO.update(p);
                request.getSession().setAttribute("success", "Cập nhật sản phẩm thành công!");
                break;
            }
            case "delete": {
                int id = Integer.parseInt(request.getParameter("id"));
                // Check if product has details (simple safeguard)
                if (productDAO.hasProductDetail(id)) {
                    request.getSession().setAttribute("error", "Không thể xóa sản phẩm vì đã có biến thể chi tiết hoặc đang được sử dụng!");
                } else {
                    if (productDAO.delete(id)) {
                        request.getSession().setAttribute("success", "Xóa sản phẩm thành công!");
                    } else {
                        request.getSession().setAttribute("error", "Xóa sản phẩm thất bại!");
                    }
                }
                break;
            }
        }
        response.sendRedirect("list-product");
    }

    private String uploadFile(HttpServletRequest request) {
        try {
            Part part = request.getPart("image");
            if (part == null || part.getSize() <= 0) {
                return null;
            }

            String originalFileName = part.getSubmittedFileName();
            if (originalFileName == null || originalFileName.isEmpty()) {
                return null;
            }

            // Generate unique filename
            String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;

            String uploadPath = getServletContext().getRealPath("/") + "assets/images/product/";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File file = new File(uploadPath + uniqueFileName);
            try (InputStream input = part.getInputStream();
                 OutputStream output = new FileOutputStream(file)) {
                byte[] buffer = new byte[1024];
                int length;
                while ((length = input.read(buffer)) > 0) {
                    output.write(buffer, 0, length);
                }
            }
            return uniqueFileName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
