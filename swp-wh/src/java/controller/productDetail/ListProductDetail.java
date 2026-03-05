package controller.productDetail;

import dal.ProductDAO;
import dal.ProductDetailDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.ProductDetail;

@WebServlet(name = "ListProductDetail", urlPatterns = {"/list-product-detail"})
public class ListProductDetail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ProductDetailDAO detailDAO = new ProductDetailDAO();
        ProductDAO productDAO = new ProductDAO();

        String search = request.getParameter("search");
        String productId = request.getParameter("productId");
        
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }
        int pageSize = 10;

        List<ProductDetail> list = detailDAO.getFiltered(search, productId, page, pageSize);
        int total = detailDAO.getTotal(search, productId);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        // Gửi dữ liệu sang JSP
        request.setAttribute("listDetail", list);
        request.setAttribute("listProduct", productDAO.getAll());
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", Math.max(1, page - 2));
        request.setAttribute("endPage", Math.min(totalPages, page + 2));
        
        request.getRequestDispatcher("view/product-detail/page-list-product-detail.jsp").forward(request, response);
    }
}