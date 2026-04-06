package controller.purchase;

import dal.ProductDAO;
import dal.ProductDetailDAO;
import dal.PurchaseOrderDAO;
import dal.SupplierDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.Product;
import model.ProductDetail;
import model.PurchaseOrder;
import model.PurchaseOrderDetail;
import model.Supplier;
import model.User;
import model.dto.ProductDetailOption;
import model.dto.PurchaseLineDraft;
import model.dto.PurchaseOrderFormDraft;
import utils.PurchaseValidator;

@WebServlet(name = "EditPurchaseOrderServlet", urlPatterns = { "/edit-purchase-order" })
public class EditPurchaseOrderServlet extends HttpServlet {

    private static final String EDIT_DRAFT_KEY = "editPurchaseOrderDraft";
    private static final String EDIT_PO_ID_KEY = "editPurchaseOrderId";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        User currentUser = (User) session.getAttribute("user");

        // Only Purchasing Staff (role 5) can edit
        if (currentUser == null || currentUser.getRole() == null || currentUser.getRole().getId() != 5) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders?error=unauthorized");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders");
            return;
        }

        try {
            int poId = Integer.parseInt(idParam);
            PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
            PurchaseOrder po = poDAO.getById(poId);

            if (po == null) {
                response.sendRedirect(request.getContextPath() + "/purchase-orders");
                return;
            }

            // Only Draft (status 1) can be edited
            if (po.getStatus() != 1) {
                response.sendRedirect(request.getContextPath() + "/detail-purchase-order?id=" + poId);
                return;
            }

            // Check if we need to initialize the edit draft (first load or different PO)
            Integer storedPoId = (Integer) session.getAttribute(EDIT_PO_ID_KEY);
            PurchaseOrderFormDraft draft = (PurchaseOrderFormDraft) session.getAttribute(EDIT_DRAFT_KEY);

            if (draft == null || storedPoId == null || storedPoId != poId
                    || "1".equals(request.getParameter("reload"))) {
                // Initialize draft from existing PO
                draft = new PurchaseOrderFormDraft();
                draft.setOrderCode(po.getOrderCode());
                draft.setSupplierId(po.getSupplier().getId());

                // Load existing lines
                draft.getLines().clear();
                if (po.getDetails() != null) {
                    for (PurchaseOrderDetail d : po.getDetails()) {
                        PurchaseLineDraft line = new PurchaseLineDraft();
                        if (d.getProductDetail() != null) {
                            line.setProductDetailId(d.getProductDetail().getId());
                        }
                        line.setQuantity(d.getQuantity());
                        line.setPrice(d.getPrice());
                        draft.addLine(line);
                    }
                }
                if (draft.getLines().isEmpty()) {
                    draft.resetLinesOneEmpty();
                }
                session.setAttribute(EDIT_DRAFT_KEY, draft);
                session.setAttribute(EDIT_PO_ID_KEY, poId);
            }

            // Handle supplier change via GET param
            String sidParam = request.getParameter("supplierId");
            if (sidParam != null && !sidParam.isEmpty()) {
                try {
                    int sid = Integer.parseInt(sidParam);
                    if (sid > 0 && draft.getSupplierId() != sid) {
                        draft.setSupplierId(sid);
                        draft.resetLinesOneEmpty();
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            request.setAttribute("poId", poId);
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || currentUser.getRole() == null || currentUser.getRole().getId() != 5) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders?error=unauthorized");
            return;
        }

        PurchaseOrderFormDraft draft = (PurchaseOrderFormDraft) session.getAttribute(EDIT_DRAFT_KEY);
        Integer poId = (Integer) session.getAttribute(EDIT_PO_ID_KEY);
        String ctx = request.getContextPath();

        if (draft == null || poId == null) {
            response.sendRedirect(ctx + "/purchase-orders");
            return;
        }

        try {
            if (request.getParameter("setSupplier") != null) {
                syncDraftFromRequest(request, draft);
                int sid = Integer.parseInt(request.getParameter("supplierId"));
                if (sid > 0) {
                    draft.setSupplierId(sid);
                    draft.resetLinesOneEmpty();
                }
                response.sendRedirect(ctx + "/edit-purchase-order?id=" + poId);
                return;
            }

            if (request.getParameter("addLine") != null) {
                syncDraftFromRequest(request, draft);
                draft.addLine(new PurchaseLineDraft());
                response.sendRedirect(ctx + "/edit-purchase-order?id=" + poId);
                return;
            }

            if (request.getParameter("removeLine") != null) {
                syncDraftFromRequest(request, draft);
                int idx = Integer.parseInt(request.getParameter("removeLine"));
                draft.removeLine(idx);
                response.sendRedirect(ctx + "/edit-purchase-order?id=" + poId);
                return;
            }

            if (request.getParameter("savePO") != null) {
                syncDraftFromRequest(request, draft);
                savePurchaseOrder(request, response, session, draft, poId);
                return;
            }

            response.sendRedirect(ctx + "/edit-purchase-order?id=" + poId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.setAttribute("poId", poId);
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                    .forward(request, response);
        }
    }

    private void savePurchaseOrder(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, PurchaseOrderFormDraft draft, int poId)
            throws ServletException, IOException {

        ProductDetailDAO productDetailDAO = new ProductDetailDAO();
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();

        // Verify PO still exists and is Draft
        PurchaseOrder existingPo = poDAO.getById(poId);
        if (existingPo == null || existingPo.getStatus() != 1) {
            response.sendRedirect(request.getContextPath() + "/purchase-orders");
            return;
        }

        if (draft.getSupplierId() <= 0) {
            request.setAttribute("error", "Please select a supplier.");
            request.setAttribute("poId", poId);
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                    .forward(request, response);
            return;
        }

        String orderCode = draft.getOrderCode();
        if (!PurchaseValidator.isValidOrderCode(orderCode)) {
            request.setAttribute("error", "Order code format is invalid.");
            request.setAttribute("poId", poId);
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                    .forward(request, response);
            return;
        }

        if (!PurchaseValidator.isOrderCodeUnique(orderCode, poId)) {
            request.setAttribute("error", "Order code already exists.");
            request.setAttribute("poId", poId);
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                    .forward(request, response);
            return;
        }

        List<PurchaseLineDraft> lines = draft.getLines();
        if (lines.isEmpty()) {
            request.setAttribute("error", "At least 1 product line is required.");
            request.setAttribute("poId", poId);
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                    .forward(request, response);
            return;
        }

        for (PurchaseLineDraft line : lines) {
            if (line.getProductDetailId() == null || line.getProductDetailId() <= 0) {
                request.setAttribute("error", "Each line must have a selected variant.");
                request.setAttribute("poId", poId);
                prepareFormView(request, draft);
                request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                        .forward(request, response);
                return;
            }
            if (line.getPrice() == null || line.getPrice() <= 0) {
                request.setAttribute("error", "Unit price must be greater than 0.");
                request.setAttribute("poId", poId);
                prepareFormView(request, draft);
                request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                        .forward(request, response);
                return;
            }
            if (line.getQuantity() < 1) {
                request.setAttribute("error", "Quantity must be at least 1.");
                request.setAttribute("poId", poId);
                prepareFormView(request, draft);
                request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                        .forward(request, response);
                return;
            }
        }

        // Validate duplicates
        Set<Integer> seenPdIds = new HashSet<>();
        for (PurchaseLineDraft line : lines) {
            if (line.getProductDetailId() != null) {
                if (seenPdIds.contains(line.getProductDetailId())) {
                    request.setAttribute("error",
                            "Duplicate product variant detected. Please merge quantities or remove the duplicate line.");
                    request.setAttribute("poId", poId);
                    prepareFormView(request, draft);
                    request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                            .forward(request, response);
                    return;
                }
                seenPdIds.add(line.getProductDetailId());
            }
        }

        try {
            double totalAmount = 0;
            List<Double> subTotals = new ArrayList<>();
            List<Double> prices = new ArrayList<>();
            List<ProductDetail> detailRows = new ArrayList<>();

            for (PurchaseLineDraft line : lines) {
                ProductDetail pd = productDetailDAO.getById(line.getProductDetailId());
                if (pd == null) {
                    throw new Exception("Product detail not found.");
                }
                double price = line.getPrice();
                int qty = line.getQuantity();
                double sub = qty * price;
                subTotals.add(sub);
                prices.add(price);
                detailRows.add(pd);
                totalAmount += sub;
            }

            // Update PO header
            PurchaseOrder po = new PurchaseOrder();
            po.setId(poId);
            po.setOrderCode(orderCode.trim());
            Supplier s = new Supplier();
            s.setId(draft.getSupplierId());
            po.setSupplier(s);
            po.setTotalAmount(totalAmount);

            boolean updated = poDAO.update(po);
            if (!updated) {
                throw new Exception("Failed to update PO.");
            }

            // Delete old details and re-insert
            poDAO.deleteDetailsByOrderId(poId);

            for (int i = 0; i < lines.size(); i++) {
                PurchaseLineDraft line = lines.get(i);
                ProductDetail pd = detailRows.get(i);

                PurchaseOrderDetail pod = new PurchaseOrderDetail();
                pod.setPurchaseOrderId(poId);

                Product p = new Product();
                if (pd.getProduct() == null) {
                    throw new Exception("Missing product info for variant #" + pd.getId());
                }
                p.setId(pd.getProduct().getId());
                pod.setProduct(p);
                pod.setQuantity(line.getQuantity());
                pod.setPrice(prices.get(i));
                pod.setSubTotal(subTotals.get(i));
                pod.setProductDetail(pd);

                poDAO.insertDetail(pod);
            }

            // Clear edit draft
            session.removeAttribute(EDIT_DRAFT_KEY);
            session.removeAttribute(EDIT_PO_ID_KEY);

            response.sendRedirect(request.getContextPath() + "/detail-purchase-order?id=" + poId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.setAttribute("poId", poId);
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-edit-purchase-order.jsp")
                    .forward(request, response);
        }
    }

    private void syncDraftFromRequest(HttpServletRequest request, PurchaseOrderFormDraft draft) {
        String oc = request.getParameter("orderCode");
        if (oc != null) {
            draft.setOrderCode(oc.trim());
        }

        String[] pds = request.getParameterValues("productDetailId");
        String[] qtys = request.getParameterValues("quantity");
        String[] prices = request.getParameterValues("price");

        List<PurchaseLineDraft> lines = draft.getLines();
        for (int i = 0; i < lines.size(); i++) {
            PurchaseLineDraft line = lines.get(i);
            if (pds != null && i < pds.length && pds[i] != null && !pds[i].isEmpty()) {
                try {
                    line.setProductDetailId(Integer.parseInt(pds[i]));
                } catch (NumberFormatException e) {
                    line.setProductDetailId(null);
                }
            } else {
                line.setProductDetailId(null);
            }
            if (qtys != null && i < qtys.length && qtys[i] != null && !qtys[i].isEmpty()) {
                if (PurchaseValidator.isValidQuantity(qtys[i])) {
                    line.setQuantity(Integer.parseInt(qtys[i].trim()));
                } else {
                    line.setQuantity(1);
                }
            }
            if (prices != null && i < prices.length && prices[i] != null && !prices[i].isEmpty()) {
                if (PurchaseValidator.isValidUnitPrice(prices[i])) {
                    line.setPrice(Double.parseDouble(prices[i].trim()));
                } else {
                    line.setPrice(null);
                }
            } else {
                line.setPrice(null);
            }
        }
    }

    private void prepareFormView(HttpServletRequest request, PurchaseOrderFormDraft draft) {
        SupplierDAO supplierDAO = new SupplierDAO();
        ProductDAO productDAO = new ProductDAO();
        ProductDetailDAO productDetailDAO = new ProductDetailDAO();

        request.setAttribute("draft", draft);
        request.setAttribute("supplierList", supplierDAO.getAll());

        if (draft.getSupplierId() > 0) {
            List<ProductDetailOption> detailOptions = buildDetailOptions(
                    productDAO, productDetailDAO, draft.getSupplierId());
            request.setAttribute("detailOptions", detailOptions);
            request.setAttribute("grandTotal", computeGrandTotal(draft));
        } else {
            request.setAttribute("detailOptions", new ArrayList<ProductDetailOption>());
            request.setAttribute("grandTotal", 0.0);
        }
    }

    private double computeGrandTotal(PurchaseOrderFormDraft draft) {
        double total = 0;
        for (PurchaseLineDraft line : draft.getLines()) {
            if (line.getProductDetailId() == null || line.getProductDetailId() <= 0)
                continue;
            if (line.getPrice() == null || line.getPrice() <= 0)
                continue;
            total += line.getQuantity() * line.getPrice();
        }
        return total;
    }

    private List<ProductDetailOption> buildDetailOptions(ProductDAO productDAO,
            ProductDetailDAO productDetailDAO, int supplierId) {
        List<ProductDetailOption> options = new ArrayList<>();
        List<Product> products = productDAO.getProductsBySupplier(supplierId);
        for (Product p : products) {
            List<ProductDetail> details = productDetailDAO.getAllDetailsByProductId(p.getId());
            for (ProductDetail pd : details) {
                String color = pd.getColor();
                if (color == null || color.isEmpty())
                    color = "";
                options.add(new ProductDetailOption(
                        pd.getId(),
                        buildVariantLabel(p, pd),
                        pd.getPrice(),
                        p.getId(),
                        color));
            }
        }
        return options;
    }

    private String buildVariantLabel(Product p, ProductDetail pd) {
        StringBuilder sb = new StringBuilder();
        sb.append(p.getName()).append(" [").append(p.getCode()).append("] — ");
        String color = pd.getColor();
        if (color == null || color.isEmpty())
            color = "No Color";
        sb.append(color);
        List<String> extra = new ArrayList<>();
        if (pd.getLotNumber() != null && !pd.getLotNumber().isEmpty() && !"N/A".equalsIgnoreCase(pd.getLotNumber())) {
            extra.add("Lot: " + pd.getLotNumber());
        }
        if (pd.getSerialNumber() != null && !pd.getSerialNumber().isEmpty()
                && !"N/A".equalsIgnoreCase(pd.getSerialNumber())) {
            extra.add("Ser: " + pd.getSerialNumber());
        }
        if (!extra.isEmpty()) {
            sb.append(" (").append(String.join(", ", extra)).append(")");
        }
        return sb.toString();
    }
}
