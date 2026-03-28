package controller.goodsreceipt;

import dal.GoodsReceiptDAO;
import dal.LocationDAO;
import dal.PurchaseOrderDAO;
import dal.UserDAO;
import dal.WarehouseDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || (user.getRole().getId() != 3)) {
            response.sendError(403, "Access Denied");
            return;
        }

        GoodsReceiptDAO grDAO = new GoodsReceiptDAO();
        LocationDAO locationDAO = new LocationDAO();
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
        WarehouseDAO whDAO = new WarehouseDAO();

        // 1. Load list of warehouses
        List<Warehouse> warehouses = whDAO.getAll();
        request.setAttribute("warehouses", warehouses);

        // 2. Handle selected warehouse: Force user's warehouse if assigned
        int selectedWhId = 0;
        boolean isWhLocked = false;

        if (user != null && user.getWarehouse() != null && user.getWarehouse().getId() > 0) {
            selectedWhId = user.getWarehouse().getId();
            isWhLocked = true;
        } else {
            // Admin or unassigned staff can choose
            String whIdStr = request.getParameter("warehouseId");
            if (whIdStr != null && !whIdStr.isEmpty()) {
                selectedWhId = Integer.parseInt(whIdStr);
            } else if (!warehouses.isEmpty()) {
                selectedWhId = warehouses.get(0).getId();
            }
        }
        request.setAttribute("selectedWhId", selectedWhId);
        request.setAttribute("isWhLocked", isWhLocked);

        // 3. Load locations for the selected warehouse
        List<Location> locations = locationDAO.getByWarehouseId(selectedWhId);
        request.setAttribute("locations", locations);

        // 4. Handle selected location
        String locIdStr = request.getParameter("locationId");
        int selectedLocId = 0;
        if (locIdStr != null && !locIdStr.isEmpty()) {
            selectedLocId = Integer.parseInt(locIdStr);
        } else if (!locations.isEmpty()) {
            selectedLocId = locations.get(0).getId();
        }
        request.setAttribute("selectedLocId", selectedLocId);

        // 5. Handle PO and items
        String poIdStr = request.getParameter("poId");
        if (poIdStr != null && !poIdStr.isEmpty()) {
            try {
                int poId = Integer.parseInt(poIdStr);
                PurchaseOrder po = poDAO.getById(poId);
                if (po != null) {
                    request.setAttribute("order", po);

                    // Fetch delivered totals and stock at location
                    Map<Integer, Integer> deliveredMap = grDAO.getDeliveredQtyByPO(poId);

                    List<Integer> pdIds = new ArrayList<>();
                    if (po.getDetails() != null) {
                        for (PurchaseOrderDetail pod : po.getDetails()) {
                            if (pod.getProductDetail() != null)
                                pdIds.add(pod.getProductDetail().getId());
                        }
                    }
                    Map<Integer, Integer> stockMap = grDAO.getStockAtLocation(selectedLocId, pdIds);

                    // Prepare UI details: [name, variantLabel, orderedQty, deliveredQty,
                    // remainingQty, stockAtLoc, pdId, color, productId]
                    List<Object[]> uiDetails = new ArrayList<>();
                    if (po.getDetails() != null) {
                        for (PurchaseOrderDetail pod : po.getDetails()) {
                            ProductDetail pd = pod.getProductDetail();
                            int pdId = (pd != null) ? pd.getId() : 0;
                            int productId = (pod.getProduct() != null) ? pod.getProduct().getId() : 0;

                            String name = (pod.getProduct() != null) ? pod.getProduct().getName() : "Unknown";
                            String variant = (pd != null) ? (pd.getLotNumber() != null
                                    ? "Lot: " + pd.getLotNumber() + " | Ser: " + pd.getSerialNumber()
                                    : pd.getSerialNumber()) : "-";
                            int ordered = pod.getQuantity();
                            int delivered = deliveredMap.getOrDefault(pdId, 0);
                            int remaining = ordered - delivered;
                            int stockAtLoc = stockMap.getOrDefault(pdId, 0);
                            String color = (pd != null) ? pd.getColor() : "-";

                            uiDetails.add(new Object[] {
                                    name, variant, ordered, delivered, remaining, stockAtLoc, pdId, color, productId
                            });
                        }
                    }
                    request.setAttribute("uiDetails", uiDetails);
                }
            } catch (NumberFormatException ignored) {
            }
        } else {
            // No PO selected, fetch list of POs that can be received (Status CONFIRMED(2)
            // or RECEIVED(3))
            List<PurchaseOrder> pendingPOs = new ArrayList<>();
            List<PurchaseOrder> allPOs = poDAO.getAll();
            for (PurchaseOrder po : allPOs) {
                if (po.getStatus() == 2 || po.getStatus() == 3) {
                    pendingPOs.add(po);
                }
            }
            request.setAttribute("pendingPOs", pendingPOs);
        }

        request.getRequestDispatcher("/view/goods-receipt/page-create-goods-receipt.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || (user.getRole().getId() != 3)) {
            response.sendError(403, "Access Denied");
            return;
        }

        GoodsReceiptDAO grDAO = new GoodsReceiptDAO();
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
        LocationDAO locationDAO = new LocationDAO();
        User currentUser = user;
        // No need to fallback to getById(1) if we have the session user

        int poId = 0;
        try {
            poId = Integer.parseInt(request.getParameter("poId"));
            int locationId = Integer.parseInt(request.getParameter("locationId"));
            String note = request.getParameter("note");

            String[] productDetailIds = request.getParameterValues("productDetailId[]");
            String[] productIds = request.getParameterValues("productId[]");
            String[] qtyExpected = request.getParameterValues("qtyExpected[]");
            String[] qtyActual = request.getParameterValues("qtyActual[]");

            if (productDetailIds == null || productDetailIds.length == 0) {
                request.getSession().setAttribute("error", "Product list is empty.");
                response.sendRedirect(request.getContextPath() + "/create-goods-receipt?poId=" + poId);
                return;
            }

            // 1. CAPACITY VALIDATION
            Location loc = locationDAO.getById(locationId);
            if (loc == null) {
                request.getSession().setAttribute("error", "Location does not exist.");
                response.sendRedirect(request.getContextPath() + "/create-goods-receipt?poId=" + poId);
                return;
            }

            int totalIncoming = 0;
            List<GoodsReceiptDetail> details = new java.util.ArrayList<>();
            for (int i = 0; i < productDetailIds.length; i++) {
                int actual = Integer.parseInt(qtyActual[i]);
                if (actual <= 0)
                    continue;
                totalIncoming += actual;

                GoodsReceiptDetail d = new GoodsReceiptDetail();
                Product p = new Product();
                p.setId((productIds != null && productIds.length > i) ? Integer.parseInt(productIds[i]) : 0);
                d.setProduct(p);

                ProductDetail pd = new ProductDetail();
                pd.setId(Integer.parseInt(productDetailIds[i]));
                d.setProductDetail(pd);

                d.setQuantityExpected(Integer.parseInt(qtyExpected[i]));
                d.setQuantityActual(actual);
                details.add(d);
            }

            if (details.isEmpty()) {
                request.getSession().setAttribute("error",
                        "Please input actual received quantity > 0 for at least one item.");
                response.sendRedirect(request.getContextPath() + "/create-goods-receipt?poId=" + poId);
                return;
            }

            if (loc.getMaxCapacity() != null && loc.getMaxCapacity() > 0) {
                if (loc.getCurrentStock() + totalIncoming > loc.getMaxCapacity()) {
                    request.getSession().setAttribute("error",
                            "Error: Location " + loc.getLocationName() + " does not have enough capacity. (Current: "
                                    + loc.getCurrentStock() + "/" + loc.getMaxCapacity() + ", Incoming: "
                                    + totalIncoming + ")");
                    response.sendRedirect(request.getContextPath() + "/create-goods-receipt?poId=" + poId
                            + "&locationId=" + locationId);
                    return;
                }
            }

            // 2. STATUS LOGIC: Determine if this receipt is the final one for the PO
            Map<Integer, Integer> deliveredMap = grDAO.getDeliveredQtyByPO(poId);
            PurchaseOrder poObj = poDAO.getById(poId);
            int totalOrderRemaining = 0;
            if (poObj != null && poObj.getDetails() != null) {
                for (PurchaseOrderDetail pod : poObj.getDetails()) {
                    int pdId = (pod.getProductDetail() != null) ? pod.getProductDetail().getId() : 0;
                    totalOrderRemaining += (pod.getQuantity() - deliveredMap.getOrDefault(pdId, 0));
                }
            }

            // If incoming qty < total remaining qty of PO, set GRO status to 4 (Partial)
            int finalGROStatus = (totalIncoming >= totalOrderRemaining) ? 2 : 4;

            // Build GoodsReceipt header
            GoodsReceipt gr = new GoodsReceipt();
            gr.setReceiptCode(grDAO.generateReceiptCode());
            PurchaseOrder poRef = new PurchaseOrder();
            poRef.setId(poId);
            gr.setPurchaseOrder(poRef);
            gr.setLocation(loc);
            gr.setNote(note);
            gr.setCreateBy(currentUser);
            gr.setStatus(finalGROStatus);

            int receiptId = grDAO.createAndConfirmReceipt(gr, details);

            if (receiptId > 0) {
                request.getSession().setAttribute("success", "Goods Receipt created successfully!");
                response.sendRedirect(request.getContextPath() + "/detail-goods-receipt?id=" + receiptId);
            } else {
                request.getSession().setAttribute("error",
                        "An error occurred while creating the Goods Receipt. Please try again.");
                response.sendRedirect(request.getContextPath() + "/create-goods-receipt?poId=" + poId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Invalid data: " + e.getMessage());
            response.sendRedirect(
                    request.getContextPath() + "/create-goods-receipt" + (poId > 0 ? "?poId=" + poId : ""));
        }
    }
}
