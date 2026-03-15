package controller.goodsreceipt;

import dal.PurchaseOrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
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

            // Build JSON manually (no Gson dependency needed)
            dal.ProductDetailDAO pdDAO = new dal.ProductDetailDAO();
            StringBuilder sb = new StringBuilder();
            sb.append("{");
            sb.append("\"id\":").append(po.getId()).append(",");
            sb.append("\"code\":\"").append(escapeJson(po.getOrderCode())).append("\",");
            sb.append("\"supplier\":\"").append(po.getSupplier() != null ? escapeJson(po.getSupplier().getName()) : "")
                    .append("\",");
            sb.append("\"details\":[");

            List<PurchaseOrderDetail> details = po.getDetails();
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

                    if (d.getProductDetail() != null) {
                        sb.append("\"pdId\":").append(d.getProductDetail().getId()).append(",");
                        String label = d.getProductDetail().getSerialNumber();
                        if (d.getProductDetail().getLotNumber() != null
                                && !d.getProductDetail().getLotNumber().isEmpty()) {
                            label = "Lot: " + d.getProductDetail().getLotNumber() + " | Ser: " + label;
                        }
                        if (d.getProductDetail().getColor() != null && !d.getProductDetail().getColor().isEmpty()) {
                            label += " (" + d.getProductDetail().getColor() + ")";
                        }
                        sb.append("\"variantLabel\":\"").append(escapeJson(label)).append("\"");
                    } else {
                        sb.append("\"pdId\":0,");
                        sb.append("\"variantLabel\":\"-\"");
                    }
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
