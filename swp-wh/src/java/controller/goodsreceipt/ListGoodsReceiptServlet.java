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

    private static final int PAGE_SIZE = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GoodsReceiptDAO grDAO = new GoodsReceiptDAO();
        dal.PurchaseOrderDAO poDAO = new dal.PurchaseOrderDAO();

        String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword").trim() : "";
        int statusFilter = 0;
        try {
            statusFilter = Integer.parseInt(request.getParameter("status"));
        } catch (Exception ignored) {
        }

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception ignored) {
        }
        if (page < 1)
            page = 1;

        // 0. Get user info
        model.User user = (model.User) request.getSession().getAttribute("user");
        int warehouseId = 0; // 0 = all (Show all if Admin/Manager)
        if (user != null && user.getRole() != null && user.getRole().getId() == 3) {
            if (user.getWarehouse() != null) {
                warehouseId = user.getWarehouse().getId();
            }
        }

        // 1. Fetch relevant data (Pending POs and GRO History)
        java.util.List<Object> combinedList = new java.util.ArrayList<>();

        // Show pending POs if no specific GRO status filter is active
        if (statusFilter == 0) {
            List<model.PurchaseOrder> pendingPOs = poDAO.getPendingPOs(warehouseId);
            for (model.PurchaseOrder po : pendingPOs) {
                boolean matchesKeyword = keyword.isEmpty() ||
                        po.getOrderCode().toLowerCase().contains(keyword.toLowerCase()) ||
                        (po.getSupplier() != null
                                && po.getSupplier().getName().toLowerCase().contains(keyword.toLowerCase()));

                if (matchesKeyword) {
                    combinedList.add(po);
                }
            }
        }

        // 2. Fetch GRO History
        List<GoodsReceipt> grHistory = grDAO.searchAndPaginate(keyword, statusFilter, 0, 1000, warehouseId);
        combinedList.addAll(grHistory);

        // 3. Sort: Pending POs always at the top, then sort by date descending
        combinedList.sort((a, b) -> {
            boolean isAPO = (a instanceof model.PurchaseOrder);
            boolean isBPO = (b instanceof model.PurchaseOrder);

            if (isAPO && !isBPO)
                return -1; // PO comes before GRO
            if (!isAPO && isBPO)
                return 1; // GRO comes after PO

            // Same type: sort by date descending
            java.util.Date dateA = (isAPO) ? ((model.PurchaseOrder) a).getCreatedDate()
                    : ((GoodsReceipt) a).getReceiptDate();
            java.util.Date dateB = (isBPO) ? ((model.PurchaseOrder) b).getCreatedDate()
                    : ((GoodsReceipt) b).getReceiptDate();
            if (dateA == null)
                return 1;
            if (dateB == null)
                return -1;
            return dateB.compareTo(dateA);
        });

        // 4. Pagination
        int totalItems = combinedList.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        if (page > totalPages && totalPages > 0)
            page = totalPages;

        int start = (page - 1) * PAGE_SIZE;
        int end = Math.min(start + PAGE_SIZE, totalItems);

        List<Object> paginatedList = (start < totalItems) ? combinedList.subList(start, end)
                : new java.util.ArrayList<>();

        request.setAttribute("unifiedList", paginatedList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", statusFilter);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", totalItems);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/view/goods-receipt/page-list-goods-receipt.jsp").forward(request, response);
    }
}
