package controller.goodsreceipt;

import dal.GoodsReceiptDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GoodsReceipt;

@WebServlet(name = "DetailGoodsReceiptServlet", urlPatterns = { "/detail-goods-receipt" })
public class DetailGoodsReceiptServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GoodsReceiptDAO dao = new GoodsReceiptDAO();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            GoodsReceipt gr = dao.getById(id);
            if (gr == null) {
                response.sendRedirect(request.getContextPath() + "/goods-receipt");
                return;
            }
            request.setAttribute("gr", gr);
            request.getRequestDispatcher("/view/goods-receipt/page-detail-goods-receipt.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/goods-receipt");
        }
    }
}
