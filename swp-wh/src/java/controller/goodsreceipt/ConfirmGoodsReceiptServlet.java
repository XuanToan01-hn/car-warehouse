package controller.goodsreceipt;

import dal.GoodsReceiptDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GoodsReceiptDetail;
import model.Product;

@WebServlet(name = "ConfirmGoodsReceiptServlet", urlPatterns = {"/confirm-goods-receipt"})
public class ConfirmGoodsReceiptServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        GoodsReceiptDAO grDAO = new GoodsReceiptDAO();

        String action = request.getParameter("action");
        int receiptId = Integer.parseInt(request.getParameter("receiptId"));

        try {
            if ("cancel".equalsIgnoreCase(action)) {
                boolean ok = grDAO.cancelReceipt(receiptId);
                String qs = ok ? "success=cancelled" : "error=cancel_failed";
                response.sendRedirect(request.getContextPath() + "/detail-goods-receipt?id=" + receiptId + "&" + qs);
                return;
            }

            // Confirm draft
            String[] detailIds = request.getParameterValues("detailId[]");
            String[] qtyActuals = request.getParameterValues("qtyActual[]");

            List<GoodsReceiptDetail> updatedDetails = new ArrayList<>();
            if (detailIds != null && qtyActuals != null) {
                for (int i = 0; i < detailIds.length; i++) {
                    GoodsReceiptDetail d = new GoodsReceiptDetail();
                    d.setId(Integer.parseInt(detailIds[i]));
                    int qty = 0;
                    try {
                        qty = Integer.parseInt(qtyActuals[i]);
                    } catch (NumberFormatException ignored) {
                    }
                    if (qty < 0) qty = 0;
                    d.setQuantityActual(qty);
                    updatedDetails.add(d);
                }
            }

            boolean ok = grDAO.confirmDraft(receiptId, updatedDetails);
            String qs = ok ? "success=confirmed" : "error=confirm_failed";
            response.sendRedirect(request.getContextPath() + "/detail-goods-receipt?id=" + receiptId + "&" + qs);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/detail-goods-receipt?id=" + receiptId + "&error=exception");
        }
    }
}

