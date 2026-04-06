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

        request.getRequestDispatcher("/view/product/product.jsp").forward(request, response);
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

                // --- XỬ LÝ ẢNH (BƯỚC 1: UPLOAD) ---
                // Gọi hàm uploadFile để xử lý file từ request. 
                // Hàm này sẽ trả về tên file duy nhất (UUID) nếu người dùng có chọn ảnh mới, ngược lại trả về null.
                String imageFileName = uploadFile(request);

                // Lấy thông tin sản phẩm hiện tại từ Database để có thể giữ lại ảnh cũ nếu người dùng không chọn ảnh mới.
                Product oldP = productDAO.getById(id);

                Product p = new Product();
                p.setId(id);
                p.setCode(code);
                p.setName(name);
                p.setDescription(description);
                p.setCategory(categoryDAO.getByID(catId));
                p.setUnit(unitDAO.getUnitById(unitId));
                p.setSupplier(supplierDAO.getById(supId));
                
                // --- XỬ LÝ ẢNH (BƯỚC 2: CẬP NHẬT TÊN FILE VÀO ĐỐI TƯỢNG) ---
                // Trường hợp 1: Nếu người dùng có chọn ảnh mới (uploadFile thành công trả về tên file)
                if (imageFileName != null && !imageFileName.isEmpty()) {
                    p.setImage(imageFileName); // Lưu tên file mới vào đối tượng Product
                } 
                // Trường hợp 2: Nếu không chọn ảnh mới nhưng sản phẩm hiện tại đã có ảnh cũ
                else if (oldP != null && oldP.getImage() != null) {
                    p.setImage(oldP.getImage()); // Giữ nguyên tên file cũ
                } 
                // Trường hợp 3: Nếu là sản phẩm mới hoàn toàn hoặc chưa có ảnh
                else {
                    p.setImage("no-image.png"); // Gán ảnh mặc định
                }

                // Thực hiện lưu tất cả thông tin (bao gồm cả tên file ảnh mới/cũ) vào Database
                productDAO.update(p);
                request.getSession().setAttribute("success", "Cập nhật sản phẩm thành công!");
                break;
            }
            case "delete": {
                // Bước 1: Lấy ID của sản phẩm cần xóa từ request
                int id = Integer.parseInt(request.getParameter("id"));
                
                // Bước 2: KIỂM TRA RÀNG BUỘC (Safeguard)
                // - Kiểm tra xem sản phẩm này đã được tạo các biến thể chi tiết (Product Detail) chưa. 
                // - Ví dụ: iPhone 15 đã có IMEI, màu sắc cụ thể... thì không thể xóa được để tránh lỗi Database.
                if (productDAO.hasProductDetail(id)) {
                    // Nếu đã có dữ liệu ràng buộc -> Gán thông báo lỗi vào Session và chặn xóa
                    request.getSession().setAttribute("error", "Không thể xóa sản phẩm vì đã có biến thể chi tiết hoặc đang được sử dụng!");
                } else {
                    // Bước 3: THỰC HIỆN XÓA (nếu là sản phẩm "sạch", chưa có dữ liệu giao dịch)
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

    /**
     * Hàm hỗ trợ xử lý upload file ảnh từ form multipart/form-data.
     * @param request HttpServletRequest chứa dữ liệu form
     * @return Tên file duy nhất đã được lưu trên server, hoặc null nếu không có file/lỗi
     */
    private String uploadFile(HttpServletRequest request) {
        try {
            // Bước 1: Trích xuất phần dữ liệu file từ input có attribute name="image"
            Part part = request.getPart("image");
            
            // Kiểm tra nếu người dùng không chọn file hoặc file rỗng
            if (part == null || part.getSize() <= 0) {
                return null; // Trả về null để Servlet biết không cần cập nhật ảnh mới
            }

            // Lấy tên file gốc (ví dụ: "xe-hoi.jpg")
            String originalFileName = part.getSubmittedFileName();
            if (originalFileName == null || originalFileName.isEmpty()) {
                return null;
            }

            // Bước 2: Tạo tên file duy nhất để tránh trùng lặp trên server (ví dụ: "550e8400-e29b...jpg")
            // Lấy phần mở rộng của file (.jpg, .png, ...)
            String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            // Sử dụng UUID để tạo chuỗi ngẫu nhiên không bao giờ trùng lặp
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            
            // Bước 3: Xác định thư mục vật lý trên server để chứa ảnh (trong thư mục cài đặt của Tomcat)
            String uploadPath = getServletContext().getRealPath("/") + "assets/images/product/";
            
            // Tạo thư mục nếu nó chưa tồn tại trên ổ đĩa
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Bước 4: Lưu dữ liệu byte từ bộ nhớ (Stream) vào file vật lý đã tạo trên ổ đĩa
            File file = new File(uploadPath + uniqueFileName);
            try (InputStream input = part.getInputStream();
                 OutputStream output = new FileOutputStream(file)) {
                byte[] buffer = new byte[1024]; // Bộ đệm 1KB để đọc/ghi dữ liệu
                int length;
                // Đọc từng khối dữ liệu từ input stream và ghi vào output stream cho đến hết file
                while ((length = input.read(buffer)) > 0) {
                    output.write(buffer, 0, length);
                }
            }
            // Trả về tên file UUID để lưu vào cột Image trong bảng Product của Database
            return uniqueFileName;
        } catch (Exception e) {
            // In lỗi ra console nếu quá trình upload gặp sự cố (ví dụ: hết dung lượng đĩa, sai quyền ghi...)
            e.printStackTrace();
            return null;
        }
    }
}
