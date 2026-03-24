package controller.purchase;

import dal.CategoryDAO;
import dal.ProductDAO;
import dal.ProductDetailDAO;
import dal.PurchaseOrderDAO;
import dal.SupplierDAO;
import dal.TaxDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Category;
import model.Product;
import model.ProductDetail;
import model.PurchaseOrder;
import model.PurchaseOrderDetail;
import model.Supplier;
import model.Tax;
import model.User;
import model.dto.ProductDetailOption;
import model.dto.PurchaseLineDraft;
import model.dto.PurchaseOrderFormDraft;

@WebServlet(name = "AddPurchaseOrderServlet", urlPatterns = { "/add-purchase-order" })
public class AddPurchaseOrderServlet extends HttpServlet {

    private static final String DRAFT_KEY = "purchaseOrderFormDraft";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);

        if ("1".equals(request.getParameter("reset"))) {
            session.removeAttribute(DRAFT_KEY);
        }

        PurchaseOrderFormDraft draft = getOrCreateDraft(session);

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

        if (draft.getOrderCode() == null || draft.getOrderCode().isEmpty()) {
            draft.setOrderCode(generateOrderCode());
        }

        if (draft.getSupplierId() > 0 && draft.getLines().isEmpty()) {
            draft.resetLinesOneEmpty();
        }

        mapInfoFlash(request);
        mapQueryError(request);

        prepareFormView(request, draft);
        request.getRequestDispatcher("/view/purchase/page-add-purchase-order.jsp")
                .forward(request, response);
    }

    private void mapQueryError(HttpServletRequest request) {
        if (request.getAttribute("error") != null) {
            return;
        }
        String err = request.getParameter("error");
        if (err == null || err.isEmpty()) {
            return;
        }
        if ("noSupplier".equals(err)) {
            request.setAttribute("error", "Please select a supplier.");
        } else if ("supplierName".equals(err)) {
            request.setAttribute("error", "Supplier name is required.");
        } else if ("supplierSave".equals(err)) {
            request.setAttribute("error", "Failed to save supplier.");
        } else if ("supplierException".equals(err)) {
            request.setAttribute("error", "Error creating supplier.");
        } else if ("productFields".equals(err)) {
            request.setAttribute("error", "Product name and code are required.");
        } else if ("productSupplier".equals(err)) {
            request.setAttribute("error", "Please select a supplier before creating a product.");
        } else if ("productSave".equals(err)) {
            request.setAttribute("error", "Failed to save product.");
        } else if ("productException".equals(err)) {
            request.setAttribute("error", "Error creating product.");
        }
    }

    private void mapInfoFlash(HttpServletRequest request) {
        String info = request.getParameter("info");
        if (info == null || info.isEmpty()) {
            return;
        }
        if ("supplierCreated".equals(info)) {
            request.setAttribute("infoMessage", "New supplier has been created.");
        } else if ("productCreated".equals(info)) {
            request.setAttribute("infoMessage", "New product has been created.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);
        PurchaseOrderFormDraft draft = getOrCreateDraft(session);
        String ctx = request.getContextPath();

        try {
            if (request.getParameter("setSupplier") != null) {
                syncDraftFromRequest(request, draft);
                int sid = Integer.parseInt(request.getParameter("supplierId"));
                if (sid <= 0) {
                    response.sendRedirect(ctx + "/add-purchase-order?error=noSupplier");
                    return;
                }
                draft.setSupplierId(sid);
                draft.resetLinesOneEmpty();
                if (draft.getOrderCode() == null || draft.getOrderCode().isEmpty()) {
                    draft.setOrderCode(generateOrderCode());
                }
                response.sendRedirect(ctx + "/add-purchase-order");
                return;
            }

            if (request.getParameter("addLine") != null) {
                syncDraftFromRequest(request, draft);
                draft.addLine(new PurchaseLineDraft());
                response.sendRedirect(ctx + "/add-purchase-order");
                return;
            }

            if (request.getParameter("removeLine") != null) {
                syncDraftFromRequest(request, draft);
                int idx = Integer.parseInt(request.getParameter("removeLine"));
                draft.removeLine(idx);
                response.sendRedirect(ctx + "/add-purchase-order");
                return;
            }

            if (request.getParameter("createPO") != null) {
                syncDraftFromRequest(request, draft);
                createPurchaseOrder(request, response, session, draft);
                return;
            }

            response.sendRedirect(ctx + "/add-purchase-order");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-add-purchase-order.jsp")
                    .forward(request, response);
        }
    }

    private void createPurchaseOrder(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, PurchaseOrderFormDraft draft)
            throws ServletException, IOException {

        User loginUser = (User) session.getAttribute("user");
        ProductDetailDAO productDetailDAO = new ProductDetailDAO();
        TaxDAO taxDAO = new TaxDAO();
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();

        if (draft.getSupplierId() <= 0) {
            request.setAttribute("error", "Please select a supplier.");
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-add-purchase-order.jsp")
                    .forward(request, response);
            return;
        }

        String orderCode = draft.getOrderCode();
        if (orderCode == null || orderCode.trim().isEmpty()) {
            request.setAttribute("error", "Order code is required.");
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-add-purchase-order.jsp")
                    .forward(request, response);
            return;
        }

        List<PurchaseLineDraft> lines = draft.getLines();
        if (lines.isEmpty()) {
            request.setAttribute("error", "At least 1 product line is required.");
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-add-purchase-order.jsp")
                    .forward(request, response);
            return;
        }

        for (PurchaseLineDraft line : lines) {
            if (line.getProductDetailId() == null || line.getProductDetailId() <= 0) {
                request.setAttribute("error", "Each line must have a selected variant (product detail).");
                prepareFormView(request, draft);
                request.getRequestDispatcher("/view/purchase/page-add-purchase-order.jsp")
                        .forward(request, response);
                return;
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
                if (line.getPrice() == null || line.getPrice() <= 0) {
                    throw new Exception("Price for each line must be greater than 0.");
                }
                double price = line.getPrice();
                int qty = line.getQuantity();
                if (qty <= 0) {
                    throw new Exception("Quantity must be greater than 0.");
                }
                double rate = 0;
                if (line.getTaxId() != null && line.getTaxId() > 0) {
                    Tax t = taxDAO.getById(line.getTaxId());
                    if (t != null) {
                        rate = t.getTaxRate();
                    }
                }
                double sub = qty * price * (1 + rate / 100);
                subTotals.add(sub);
                prices.add(price);
                detailRows.add(pd);
                totalAmount += sub;
            }

            PurchaseOrder po = new PurchaseOrder();
            po.setOrderCode(orderCode.trim());
            Supplier s = new Supplier();
            s.setId(draft.getSupplierId());
            po.setSupplier(s);
            po.setStatus(1);
            po.setTotalAmount(totalAmount);
            if (loginUser != null) {
                po.setCreateBy(loginUser);
            }

            int newPoId = poDAO.insert(po);
            if (newPoId <= 0) {
                throw new Exception("Failed to create PO");
            }

            for (int i = 0; i < lines.size(); i++) {
                PurchaseLineDraft line = lines.get(i);
                ProductDetail pd = detailRows.get(i);

                PurchaseOrderDetail pod = new PurchaseOrderDetail();
                pod.setPurchaseOrderId(newPoId);

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

                if (line.getTaxId() != null && line.getTaxId() > 0) {
                    Tax t = new Tax();
                    t.setId(line.getTaxId());
                    pod.setTax(t);
                }

                poDAO.insertDetail(pod);
            }

            session.removeAttribute(DRAFT_KEY);
            request.setAttribute("success", "created");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            prepareFormView(request, draft);
            request.getRequestDispatcher("/view/purchase/page-add-purchase-order.jsp")
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
        String[] taxes = request.getParameterValues("taxId");
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
                try {
                    line.setQuantity(Integer.parseInt(qtys[i].trim()));
                } catch (NumberFormatException e) {
                    line.setQuantity(1);
                }
            }
            if (taxes != null && i < taxes.length && taxes[i] != null && !taxes[i].isEmpty()) {
                try {
                    line.setTaxId(Integer.parseInt(taxes[i]));
                } catch (NumberFormatException e) {
                    line.setTaxId(null);
                }
            } else {
                line.setTaxId(null);
            }
            if (prices != null && i < prices.length && prices[i] != null && !prices[i].isEmpty()) {
                try {
                    line.setPrice(Double.parseDouble(prices[i].trim()));
                } catch (NumberFormatException e) {
                    line.setPrice(null);
                }
            } else {
                line.setPrice(null);
            }
        }
    }

    private void prepareFormView(HttpServletRequest request, PurchaseOrderFormDraft draft) {
        SupplierDAO supplierDAO = new SupplierDAO();
        TaxDAO taxDAO = new TaxDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        ProductDAO productDAO = new ProductDAO();
        ProductDetailDAO productDetailDAO = new ProductDetailDAO();

        request.setAttribute("draft", draft);
        request.setAttribute("supplierList", supplierDAO.getAll());
        request.setAttribute("taxList", taxDAO.getAll());
        request.setAttribute("categoryList", categoryDAO.getAll());

        if (draft.getSupplierId() > 0) {
            List<ProductDetailOption> detailOptions = buildDetailOptions(
                    productDAO, productDetailDAO, draft.getSupplierId());
            request.setAttribute("detailOptions", detailOptions);
            request.setAttribute("grandTotal", computeGrandTotal(draft, productDetailDAO, taxDAO));
        } else {
            request.setAttribute("detailOptions", new ArrayList<ProductDetailOption>());
            request.setAttribute("grandTotal", 0.0);
        }
    }

    private double computeGrandTotal(PurchaseOrderFormDraft draft,
            ProductDetailDAO productDetailDAO, TaxDAO taxDAO) {
        double total = 0;
        for (PurchaseLineDraft line : draft.getLines()) {
            if (line.getProductDetailId() == null || line.getProductDetailId() <= 0) {
                continue;
            }
            if (line.getPrice() == null || line.getPrice() <= 0) {
                continue;
            }
            double price = line.getPrice();
            int qty = line.getQuantity();
            double rate = 0;
            if (line.getTaxId() != null && line.getTaxId() > 0) {
                Tax t = taxDAO.getById(line.getTaxId());
                if (t != null) {
                    rate = t.getTaxRate();
                }
            }
            total += qty * price * (1 + rate / 100);
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
                if (color == null || color.isEmpty()) {
                    color = "";
                }
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
        if (color == null || color.isEmpty()) {
            color = "No Color";
        }
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

    private PurchaseOrderFormDraft getOrCreateDraft(HttpSession session) {
        PurchaseOrderFormDraft d = (PurchaseOrderFormDraft) session.getAttribute(DRAFT_KEY);
        if (d == null) {
            d = new PurchaseOrderFormDraft();
            session.setAttribute(DRAFT_KEY, d);
        }
        return d;
    }

    private String generateOrderCode() {
        return "PO-" + new SimpleDateFormat("yyyyMMdd").format(new Date())
                + "-" + (int) (Math.random() * 9000 + 1000);
    }
}
