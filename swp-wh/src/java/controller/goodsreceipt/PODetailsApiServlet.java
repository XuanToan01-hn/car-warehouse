package controller.goodsreceipt;

import dal.GoodsReceiptDAO;
import dal.PurchaseOrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.PurchaseOrder;
import model.PurchaseOrderDetail;

/**
 * AJAX endpoint: Returns PO details (products) as JSON for a given PO ID.
 * Used by the Create GRO form to dynamically load products.
 *
 * Optional param: locationId – when present, also returns currentStock per product.
 */
@WebServlet(name = "PODetailsApiServlet", urlPatterns = { "/api/po-details" })
public class PODetailsApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        PrintWriter out = response.getWriter();

        try {
            int poId = Integer.parseInt(request.getParameter("poId"));
            PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
            PurchaseOrder po = poDAO.getById(poId);

            if (po == null) {
                out.print("{\"error\":\"PO not found\"}");
                return;
            }

            // Optional locationId for stock lookup
            int locationId = 0;
            String locIdStr = request.getParameter("locationId");
            if (locIdStr != null && !locIdStr.isEmpty()) {
                try { locationId = Integer.parseInt(locIdStr); } catch (NumberFormatException ignored) {}
            }

            GoodsReceiptDAO grDAO = new GoodsReceiptDAO();

            // Already delivered by other confirmed/partial GROs for this PO
            Map<Integer, Integer> deliveredMap = grDAO.getDeliveredQtyByPO(poId);

            // Collect ProductDetailIDs for stock lookup
            List<Integer> pdIds = new ArrayList<>();
            List<PurchaseOrderDetail> details = po.getDetails();
            if (details != null) {
                for (PurchaseOrderDetail d : details) {
                    if (d.getProductDetail() != null && d.getProductDetail().getId() > 0) {
                        pdIds.add(d.getProductDetail().getId());
                    }
                }
            }

            // Stock at selected location
            Map<Integer, Integer> stockMap = grDAO.getStockAtLocation(locationId, pdIds);

            // Build JSON manually (no Gson dependency needed)
            dal.ProductDetailDAO pdDAO = new dal.ProductDetailDAO();
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"id\":").append(po.getId()).append(",");
            sb.append("\"code\":\"").append(escapeJson(po.getOrderCode())).append("\",");
            sb.append("\"supplier\":\"").append(po.getSupplier() != null ? escapeJson(po.getSupplier().getName()) : "")
                    .append("\",");
            sb.append("\"details\":[");

            if (details != null) {
                for (int i = 0; i < details.size(); i++) {
                    PurchaseOrderDetail d = details.get(i);
                    if (i > 0)
                        sb.append(",");
                    sb.append("{");
                    sb.append("\"productId\":").append(d.getProduct().getId()).append(",");
                    sb.append("\"code\":\"").append(escapeJson(d.getProduct().getCode())).append("\",");
                    sb.append("\"name\":\"").append(escapeJson(d.getProduct().getName())).append("\",");
                    sb.append("\"quantity\":").append(d.getQuantity()).append(",");

                    int pdId = 0;
                    if (d.getProductDetail() != null) {
                        pdId = d.getProductDetail().getId();
                        sb.append("\"pdId\":").append(pdId).append(",");
                        String label = d.getProductDetail().getSerialNumber();
                        if (d.getProductDetail().getLotNumber() != null
                                && !d.getProductDetail().getLotNumber().isEmpty()) {
                            label = "Lot: " + d.getProductDetail().getLotNumber() + " | Ser: " + label;
                        }
                        if (d.getProductDetail().getColor() != null && !d.getProductDetail().getColor().isEmpty()) {
                            label += " (" + d.getProductDetail().getColor() + ")";
                        }
                        sb.append("\"variantLabel\":\"").append(escapeJson(label)).append("\",");
                    } else {
                        sb.append("\"pdId\":0,");
                        sb.append("\"variantLabel\":\"-\",");
                    }

                    // Remaining qty = PO qty - already delivered by other GROs
                    int delivered = deliveredMap.getOrDefault(pdId, 0);
                    int remaining = d.getQuantity() - delivered;
                    if (remaining < 0) remaining = 0;
                    sb.append("\"remainingQty\":").append(remaining).append(",");

                    // Current stock at location
                    int stock = stockMap.getOrDefault(pdId, 0);
                    sb.append("\"currentStock\":").append(stock);

                    sb.append("}");
                }
            }
            sb.append("]}");
            out.print(sb.toString());

        } catch (NumberFormatException e) {
            out.print("{\"error\":\"Invalid PO ID\"}");
        }
    }

    private String escapeJson(String s) {
        if (s == null)
            return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
