package controller.goodsreceipt;

import dal.GoodsReceiptDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.GoodsReceipt;
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
            if (detailIds != null && qtyActuals != null && detailIds.length > 0) {
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

            // Phiếu chưa có chi tiết (hiển thị fallback từ PO): cố gắng tạo chi tiết từ PO rồi confirm
            if (updatedDetails.isEmpty()) {
                grDAO.createDetailsFromPOIfMissing(receiptId);
                GoodsReceipt gr = grDAO.getById(receiptId);
                if (gr != null && gr.getDetails() != null) {
                    for (GoodsReceiptDetail d : gr.getDetails()) {
                        GoodsReceiptDetail u = new GoodsReceiptDetail();
                        u.setId(d.getId());
                        u.setQuantityActual(d.getQuantityActual());
                        updatedDetails.add(u);
                    }
                }
            }

            // Server-side validation: actual qty must not exceed remaining qty
            if (!updatedDetails.isEmpty()) {
                GoodsReceipt currentGr = grDAO.getById(receiptId);
                if (currentGr != null && currentGr.getDetails() != null) {
                    Map<Integer, Integer> remainingMap = new java.util.HashMap<>();
                    for (GoodsReceiptDetail dd : currentGr.getDetails()) {
                        remainingMap.put(dd.getId(), dd.getRemainingQty());
                    }
                    boolean overLimit = false;
                    for (GoodsReceiptDetail ud : updatedDetails) {
                        int maxAllowed = remainingMap.getOrDefault(ud.getId(), Integer.MAX_VALUE);
                        if (ud.getQuantityActual() > maxAllowed) {
                            overLimit = true;
                            break;
                        }
                    }
                    if (overLimit) {
                        response.sendRedirect(request.getContextPath()
                                + "/detail-goods-receipt?id=" + receiptId + "&error=qty_exceeds_remaining");
                        return;
                    }
                }
            }

            // Cho phép confirm ngay cả khi không có chi tiết (phiếu cũ, chỉ cần chốt trạng thái)
            boolean ok = grDAO.confirmDraft(receiptId, updatedDetails);
            String qs = ok ? "success=confirmed" : "error=confirm_failed";
            response.sendRedirect(request.getContextPath() + "/detail-goods-receipt?id=" + receiptId + "&" + qs);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/detail-goods-receipt?id=" + receiptId + "&error=exception");
        }
    }
}

