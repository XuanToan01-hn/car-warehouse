package controller.goodsreceipt;

import dal.GoodsReceiptDAO;
import dal.LocationDAO;
import dal.PurchaseOrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;

@WebServlet(name = "CreateGoodsReceiptServlet", urlPatterns = { "/create-goods-receipt" })
public class CreateGoodsReceiptServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GoodsReceiptDAO grDAO = new GoodsReceiptDAO();
        LocationDAO locationDAO = new LocationDAO();
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();

        // Danh sách PO đã Confirmed để dropdown chọn
        List<PurchaseOrder> confirmedPOs = grDAO.getConfirmedPOs();
        request.setAttribute("confirmedPOs", confirmedPOs);

        // Danh sách Location để chọn nơi nhập
        List<Location> locations = locationDAO.getAll();
        request.setAttribute("locations", locations);

        // Nếu có poId → tự load PO đó và sản phẩm
        String poIdStr = request.getParameter("poId");
        if (poIdStr != null && !poIdStr.isEmpty()) {
            try {
                int poId = Integer.parseInt(poIdStr);
                PurchaseOrder selectedPO = poDAO.getById(poId);
                request.setAttribute("selectedPO", selectedPO);
            } catch (NumberFormatException ignored) {
            }
        }

        request.getRequestDispatcher("/view/goods-receipt/page-create-goods-receipt.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        GoodsReceiptDAO grDAO = new GoodsReceiptDAO();
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
        User currentUser = (User) request.getSession().getAttribute("user");
        // DEV fallback: nếu chưa đăng nhập, dùng mock user ID=1
        if (currentUser == null) {
            currentUser = new User();
            currentUser.setId(1);
        }

        try {
            int poId = Integer.parseInt(request.getParameter("poId"));
            int locationId = Integer.parseInt(request.getParameter("locationId"));
            String note = request.getParameter("note");

            // Build GoodsReceipt header
            GoodsReceipt gr = new GoodsReceipt();
            gr.setReceiptCode(grDAO.generateReceiptCode());
            PurchaseOrder po = new PurchaseOrder();
            po.setId(poId);
            gr.setPurchaseOrder(po);
            Location loc = new Location();
            loc.setId(locationId);
            gr.setLocation(loc);
            gr.setStatus(1); // Draft
            gr.setNote(note);
            gr.setCreateBy(currentUser);

            // Build detail list từ form
            String[] productIds = request.getParameterValues("productId[]");
            String[] qtyExpected = request.getParameterValues("qtyExpected[]");
            // qtActual không cần thiết khi tạo draft, lấy mảng về chỉ đễ phòng hờ
            String[] qtyActual = request.getParameterValues("qtyActual[]");

            List<GoodsReceiptDetail> details = new java.util.ArrayList<>();
            if (productIds == null || productIds.length == 0) {
                request.setAttribute("error", "Vui lòng chọn Purchase Order và nhập số lượng thực tế nhận trước khi lưu.");
                doGet(request, response);
                return;
            }
            if (productIds != null) {
                for (int i = 0; i < productIds.length; i++) {
                    GoodsReceiptDetail d = new GoodsReceiptDetail();
                    Product p = new Product();
                    p.setId(Integer.parseInt(productIds[i]));
                    d.setProduct(p);
                    int expected = Integer.parseInt(qtyExpected[i]);
                    d.setQuantityExpected(expected);

                    // Lấy actual từ form nếu có, nếu không thì bằng expected
                    if (qtyActual != null && qtyActual.length > i && qtyActual[i] != null && !qtyActual[i].isEmpty()) {
                        d.setQuantityActual(Integer.parseInt(qtyActual[i]));
                    } else {
                        d.setQuantityActual(expected);
                    }

                    details.add(d);
                }
            }

            int receiptId = grDAO.createDraft(gr, details);

            if (receiptId > 0) {
                response.sendRedirect(request.getContextPath() + "/detail-goods-receipt?id=" + receiptId);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo Goods Receipt. Vui lòng thử lại.");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            doGet(request, response);
        }
    }
}
