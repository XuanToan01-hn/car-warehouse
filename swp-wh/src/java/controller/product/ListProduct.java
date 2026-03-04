/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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

@WebServlet(name = "ListProduct", urlPatterns = {"/list-product"})
public class ListProduct extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        UnitDAO unitDAO = new UnitDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        // 1. Lấy các tham số lọc
        String search = request.getParameter("search");
        String categoryId = request.getParameter("categoryId");
        String unitId = request.getParameter("unitId");

        // 2. Xử lý phân trang (Page)
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
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

        // 4. Gọi DAO lấy dữ liệu (Đã bỏ sortPrice theo logic DAO mới)
        List<Product> productList = productDAO.getFilteredProducts(search, categoryId, unitId, page, pageSize);
        int totalProducts = productDAO.getTotalFilteredProducts(search, categoryId, unitId);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        // 5. Tính toán dải phân trang (ví dụ hiển thị: 1 2 [3] 4 5)
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);

        // 6. Đẩy dữ liệu sang JSP
        request.setAttribute("listProduct", productList);
        request.setAttribute("listCategory", categoryDAO.getAll());
        request.setAttribute("listUnit", unitDAO.getAll());
        request.setAttribute("listSupplier", supplierDAO.getAll());

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("pageSize", pageSize);
        
        // Giữ lại các giá trị search để hiển thị lại trên form
        request.setAttribute("search", search);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("unitId", unitId);

        request.getRequestDispatcher("view/product/page-list-product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Post thường dùng để nhận dữ liệu từ các Modal (Add/Update) có lỗi 
        // hoặc xử lý các thao tác yêu cầu bảo mật.
        // Ở đây mình chuyển hướng về doGet để hiển thị lại danh sách.
        doGet(request, response);
    }

    private int validatePageSize(int pageSize) {
        int[] validSizes = {10, 20, 50, 100};
        for (int size : validSizes) {
            if (pageSize == size) return pageSize;
        }
        return DEFAULT_PAGE_SIZE;
    }
}
