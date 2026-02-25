package controller.purchase;

import dal.CategoryDAO;
import dal.PurchaseOrderDAO;
import dal.SupplierDAO;
import dal.TaxDAO;
import dal.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Product;
import model.PurchaseOrder;
import model.PurchaseOrderDetail;
import model.Supplier;
import model.Tax;
import model.User;

@WebServlet(name = "AddPurchaseOrderServlet", urlPatterns = { "/add-purchase-order" })
public class AddPurchaseOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạo DAO mới mỗi request
        SupplierDAO supplierDAO = new SupplierDAO();
        ProductDAO productDAO = new ProductDAO();
        TaxDAO taxDAO = new TaxDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Tự động sinh mã đơn hàng: PO-yyyyMMdd-xxxx
        String autoCode = "PO-" + new SimpleDateFormat("yyyyMMdd").format(new Date())
                + "-" + (int) (Math.random() * 9000 + 1000);

        request.setAttribute("autoCode", autoCode);
        request.setAttribute("supplierList", supplierDAO.getAll());
        request.setAttribute("productList", productDAO.getAll());
        request.setAttribute("taxList", taxDAO.getAll());
        request.setAttribute("categoryList", categoryDAO.getAll());

        request.getRequestDispatcher("/view/purchase/page-add-purchase-order.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User loginUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            PurchaseOrderDAO poDAO = new PurchaseOrderDAO();

            // --- HEADER ---
            String orderCode = request.getParameter("orderCode");
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            int status = 1; // Draft mặc định

            // --- DETAILS ---
            String[] productIds = request.getParameterValues("productId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] prices = request.getParameterValues("price[]");
            String[] taxIds = request.getParameterValues("taxId[]");
            String[] subTotals = request.getParameterValues("subTotal[]");

            if (productIds == null || productIds.length == 0) {
                request.setAttribute("error", "Cần thêm ít nhất 1 sản phẩm!");
                doGet(request, response);
                return;
            }

            // Tính totalAmount
            double totalAmount = 0;
            for (String st : subTotals) {
                try {
                    totalAmount += Double.parseDouble(st);
                } catch (Exception e) {
                    /* bỏ qua */ }
            }

            // Insert PurchaseOrder
            PurchaseOrder po = new PurchaseOrder();
            po.setOrderCode(orderCode);
            Supplier s = new Supplier();
            s.setId(supplierId);
            po.setSupplier(s);
            po.setStatus(status);
            po.setTotalAmount(totalAmount);
            po.setCreateBy(loginUser);

            int newPoId = poDAO.insert(po);
            if (newPoId <= 0)
                throw new Exception("Tạo PO thất bại");

            // Insert từng dòng chi tiết
            for (int i = 0; i < productIds.length; i++) {
                PurchaseOrderDetail pod = new PurchaseOrderDetail();
                pod.setPurchaseOrderId(newPoId);

                Product p = new Product();
                p.setId(Integer.parseInt(productIds[i]));
                pod.setProduct(p);
                pod.setQuantity(Integer.parseInt(quantities[i]));
                pod.setPrice(Double.parseDouble(prices[i]));
                pod.setSubTotal(Double.parseDouble(subTotals[i]));

                if (taxIds != null && taxIds[i] != null && !taxIds[i].isEmpty() && !taxIds[i].equals("0")) {
                    Tax t = new Tax();
                    t.setId(Integer.parseInt(taxIds[i]));
                    pod.setTax(t);
                }

                poDAO.insertDetail(pod);
            }

            response.sendRedirect(request.getContextPath() + "/purchase-orders?success=created");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }
}
