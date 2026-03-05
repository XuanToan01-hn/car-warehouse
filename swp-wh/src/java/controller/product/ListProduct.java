package controller.product;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.SupplierDAO;
import dal.UnitDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;

@WebServlet(name = "ListProduct", urlPatterns = { "/list-product" })
public class ListProduct extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        // Xử lý action getDetailJson (trả JSON cho modal edit)
        String action = request.getParameter("action");
        if ("getDetailJson".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    Product p = productDAO.getById(id);
                    if (p != null) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");

                        String nameJson = p.getName() != null ? p.getName().replace("\"", "\\\"") : "";
                        String codeJson = p.getCode() != null ? p.getCode().replace("\"", "\\\"") : "";
                        String descJson = p.getDescription() != null
                                ? p.getDescription().replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "")
                                : "";
                        String imageJson = p.getImage() != null ? p.getImage() : "";
                        int catId = p.getCategory() != null ? p.getCategory().getId() : 0;
                        int unitIdVal = p.getUnit() != null ? p.getUnit().getId() : 0;
                        int supId = p.getSupplier() != null ? p.getSupplier().getId() : 0;
                        String colorJson = p.getColor() != null ? p.getColor() : "";

                        String json = String.format(
                                "{\"id\": %d, \"name\": \"%s\", \"code\": \"%s\", \"description\": \"%s\", \"image\": \"%s\", \"categoryId\": %d, \"unitId\": %d, \"supplierId\": %d, \"color\": \"%s\"}",
                                p.getId(), nameJson, codeJson, descJson, imageJson, catId, unitIdVal, supId, colorJson);
                        response.getWriter().write(json);
                        return;
                    }
                } catch (NumberFormatException ignored) {
                }
            }
        }

        // 1. Lấy các tham số lọc
        String search = request.getParameter("search");
        String categoryId = request.getParameter("categoryId");
        String unitId = request.getParameter("unitId");
        String supplierId = request.getParameter("supplierId");

        // 2. Parse page
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1)
                    page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // 3. Xử lý kích thước trang (PageSize)
        int pageSize = DEFAULT_PAGE_SIZE;
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                pageSize = validatePageSize(pageSize);
            } catch (NumberFormatException e) {
                pageSize = DEFAULT_PAGE_SIZE;
            }
        }

        // 4. Lấy danh sách sản phẩm có lọc + phân trang
        List<Product> productList = productDAO.getFilteredProducts(search, categoryId, unitId, page, pageSize);
        int totalProducts = productDAO.getTotalFilteredProducts(search, categoryId, unitId, supplierId);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        // 5. Tính toán dải phân trang
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);

        // 6. Set attributes
        request.setAttribute("listProduct", productList);
        request.setAttribute("listSupplier", supplierDAO.getAll());
        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("listCategory", categoryDAO.getAll());

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("pageSize", pageSize);

        // Giữ lại các giá trị search để hiển thị lại trên form
        request.setAttribute("search", search);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("unitId", unitId);
        request.setAttribute("supplierId", supplierId);

        request.getRequestDispatcher("view/product/page-list-product.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP POST method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ProductDAO productDAO = new ProductDAO();

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = productDAO.delete(id);
                if (success) {
                    response.sendRedirect("list-product?status=deleteSuccess");
                } else {
                    response.sendRedirect("list-product?status=deleteError&errorDetail=constraint");
                }
                return;
            } catch (Exception e) {
                response.sendRedirect("list-product?status=deleteError");
                return;
            }
        }

        request.setAttribute("showUpdateModal", true);
        request.setAttribute("ePrice", request.getAttribute("errorPrice"));
        request.setAttribute("eName", request.getAttribute("errorName"));
        request.setAttribute("eCode", request.getAttribute("errorCode"));
        request.setAttribute("eDesc", request.getAttribute("errorDesc"));

        UnitDAO unitDAO = new UnitDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        String search = request.getParameter("search");
        String categoryId = request.getParameter("categoryId");
        String unitId = request.getParameter("unitId");
        String supplierId = request.getParameter("supplierId");

        // Parse page with default value
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1)
                    page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Parse pageSize with validation
        int pageSize = DEFAULT_PAGE_SIZE;
        String pageSizeParam = request.getParameter("pageSize");
        if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeParam);
                pageSize = validatePageSize(pageSize);
            } catch (NumberFormatException e) {
                pageSize = DEFAULT_PAGE_SIZE;
            }
        }

        // Get filtered and paginated products
        List<Product> productList = productDAO.getFilteredProducts(search, categoryId, unitId, page, pageSize);
        int totalProducts = productDAO.getTotalFilteredProducts(search, categoryId, unitId, supplierId);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        // Calculate pagination
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        boolean hasPrevious = page > 1;
        boolean hasNext = page < totalPages;

        // Set attributes
        request.setAttribute("listSupplier", supplierDAO.getAll());
        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("listCategory", categoryDAO.getAll());
        request.setAttribute("listProduct", productList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("hasPrevious", hasPrevious);
        request.setAttribute("hasNext", hasNext);
        request.setAttribute("pageSize", pageSize);

        request.setAttribute("uId", request.getAttribute("updateid"));
        request.setAttribute("uName", request.getAttribute("updateName"));
        request.setAttribute("uCode", request.getAttribute("updateCode"));
        request.setAttribute("uImage", request.getAttribute("updateImage"));
        request.setAttribute("uCategory", request.getAttribute("updateCategory"));
        request.setAttribute("uDes", request.getAttribute("updateDes"));
        request.setAttribute("unitS", request.getAttribute("updateUnit"));
        request.getRequestDispatcher("view/product/page-list-product.jsp").forward(request, response);
    }

    private int validatePageSize(int pageSize) {
        int[] validSizes = { 10, 20, 50, 100 };
        for (int size : validSizes) {
            if (pageSize == size)
                return pageSize;
        }
        return DEFAULT_PAGE_SIZE;
    }
}
