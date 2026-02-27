package controller.goodsreceipt;

import dal.GoodsReceiptDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GoodsReceipt;

@WebServlet(name = "ListGoodsReceiptServlet", urlPatterns = { "/goods-receipt" })
public class ListGoodsReceiptServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GoodsReceiptDAO dao = new GoodsReceiptDAO();

        String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword").trim() : "";
        int status = 0;
        try {
            status = Integer.parseInt(request.getParameter("status"));
        } catch (Exception ignored) {
        }
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }
        if (page < 1)
            page = 1;

        int total = dao.count(keyword, status);
        int offset = (page - 1) * PAGE_SIZE;
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        List<GoodsReceipt> list = dao.searchAndPaginate(keyword, status, offset, PAGE_SIZE);

        request.setAttribute("grList", list);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/view/goods-receipt/page-list-goods-receipt.jsp")
                .forward(request, response);
    }
}
