package controller.externalTransfer;

import dal.LocationDAO;
import dal.ProductDetailDAO;
import dal.TransferDAO;
import dal.WarehouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Location;
import model.TransferOrder;
import model.TransferOrderDetail;
import model.User;
import model.Warehouse;

@WebServlet(name = "ExternalWarehouseTransferServlet", urlPatterns = { "/external-transfer" })
public class WarehouseTransferServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        LocationDAO locDAO = new LocationDAO();
        ProductDetailDAO pdDAO = new ProductDetailDAO();
        TransferDAO transDAO = new TransferDAO();
        WarehouseDAO warehouseDAO = new WarehouseDAO();

        if (action.equals("detail")) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);
                List<TransferOrder> orders = transDAO.getTransfersById(id);
                if (!orders.isEmpty()) {
                    List<Map<String, Object>> productDetailsList = new ArrayList<>();
                    int totalQty = 0;
                    for (TransferOrder to : orders) {
                        model.ProductDetail pd = pdDAO.getById(to.getProductDetailId());
                        String pName = (pd != null && pd.getProduct() != null)
                                ? "[" + pd.getSerialNumber() + "] " + pd.getProduct().getName() + " - " + pd.getColor()
                                : "Unknown Product #" + to.getProductDetailId();

                        Map<String, Object> map = new HashMap<>();
                        map.put("name", pName);
                        map.put("qty", to.getQuantity());
                        productDetailsList.add(map);
                        totalQty += to.getQuantity();
                    }

                    request.setAttribute("t", orders.get(0));
                    request.setAttribute("productList", productDetailsList);
                    request.setAttribute("totalQuantity", totalQty);
                    request.setAttribute("isExternal", true);
                    request.getRequestDispatcher("/view/transfer-detail.jsp").forward(request, response);
                    return;
                }
            }
        } else if (action.equals("form")) {
            request.setAttribute("warehouses", warehouseDAO.getAll());
            // Pass user's warehouse info to lock source warehouse
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null && user.getWarehouse() != null) {
                request.setAttribute("userWarehouseId", user.getWarehouse().getId());
                request.setAttribute("userWarehouseName", user.getWarehouse().getWarehouseName());
            }
            request.getRequestDispatcher("/view/create-external-transfer.jsp").forward(request, response);

        } else if (action.equals("getWarehousesByProduct")) {
            String pdIdStr = request.getParameter("pdId");
            if (pdIdStr == null || pdIdStr.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().print("[]");
                return;
            }
            int pdId = Integer.parseInt(pdIdStr);
            List<Location> locs = locDAO.getLocationsByProductDetail(pdId);

            // Map to unique warehouses
            Map<Integer, Warehouse> whMap = new HashMap<>();
            for (Location l : locs) {
                int reserved = transDAO.getReservedQuantity(l.getId(), pdId);
                int available = Math.max(0, l.getCurrentStock() - reserved);
                if (available > 0) {
                    if (!whMap.containsKey(l.getWarehouseId())) {
                        Warehouse w = new Warehouse();
                        w.setId(l.getWarehouseId());
                        w.setWarehouseName(l.getWarehouseName());
                        whMap.put(l.getWarehouseId(), w);
                    }
                }
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            StringBuilder json = new StringBuilder("[");
            int count = 0;
            for (Warehouse w : whMap.values()) {
                json.append("{");
                json.append("\"id\":").append(w.getId()).append(",");
                json.append("\"name\":\"")
                        .append(w.getWarehouseName() != null ? w.getWarehouseName().replace("\"", "\\\"") : "Unknown")
                        .append("\"");
                json.append("}");
                if (++count < whMap.size())
                    json.append(",");
            }
            json.append("]");
            out.print(json.toString());
            out.flush();
            return;

        } else if (action.equals("getLocationsByWarehouseAndProduct")) {
            String pdIdStr = request.getParameter("pdId");
            String whIdStr = request.getParameter("whId");
            if (pdIdStr == null || whIdStr == null) {
                response.setContentType("application/json");
                response.getWriter().print("[]");
                return;
            }
            int pdId = Integer.parseInt(pdIdStr);
            int whId = Integer.parseInt(whIdStr);

            List<Location> locs = locDAO.getLocationsByProductDetail(pdId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Location l : locs) {
                if (l.getWarehouseId() == whId) {
                    int reserved = transDAO.getReservedQuantity(l.getId(), pdId);
                    int available = Math.max(0, l.getCurrentStock() - reserved);
                    if (available > 0) {
                        if (!first)
                            json.append(",");
                        json.append("{");
                        json.append("\"id\":").append(l.getId()).append(",");
                        json.append("\"name\":\"").append(l.getLocationName().replace("\"", "\\\"")).append("\",");
                        json.append("\"available\":").append(available).append(",");
                        json.append("\"max\":").append(l.getMaxCapacity());
                        json.append("}");
                        first = false;
                    }
                }
            }
            json.append("]");
            out.print(json.toString());
            out.flush();
            return;

        } else if (action.equals("getLocationsByWarehouse")) {
            String whIdStr = request.getParameter("whId");
            if (whIdStr == null) {
                response.setContentType("application/json");
                response.getWriter().print("[]");
                return;
            }
            int whId = Integer.parseInt(whIdStr);
            List<Location> locs = locDAO.getByWarehouseId(whId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            StringBuilder json = new StringBuilder("[");
            boolean first = true;
            for (Location l : locs) {
                // Get full location detail with current stock
                Location fullLoc = locDAO.getById(l.getId());
                if (!first)
                    json.append(",");
                json.append("{");
                json.append("\"id\":").append(fullLoc.getId()).append(",");
                json.append("\"name\":\"").append(fullLoc.getLocationName().replace("\"", "\\\"")).append("\",");
                json.append("\"current\":").append(fullLoc.getCurrentStock()).append(",");
                json.append("\"max\":").append(fullLoc.getMaxCapacity() == null ? 0 : fullLoc.getMaxCapacity());
                json.append("}");
                first = false;
            }
            json.append("]");
            out.print(json.toString());
            out.flush();
            return;

        } else if (action.equals("getProductsByLocation")) {
            String locIdStr = request.getParameter("locId");
            if (locIdStr == null || locIdStr.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().print("[]");
                return;
            }
            int locId = Integer.parseInt(locIdStr);
            java.util.List<model.LocationProduct> products = locDAO.getProductsByLocation(locId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out2 = response.getWriter();
            StringBuilder json2 = new StringBuilder("[");
            for (int i = 0; i < products.size(); i++) {
                model.LocationProduct lp = products.get(i);
                int reserved2 = transDAO.getReservedQuantity(locId, lp.getProductDetail().getId());
                int available2 = Math.max(0, lp.getQuantity() - reserved2);
                if (available2 <= 0)
                    continue;

                if (json2.length() > 1)
                    json2.append(",");
                json2.append("{");
                json2.append("\"pdId\":").append(lp.getProductDetail().getId()).append(",");
                json2.append("\"productName\":\"").append(lp.getProduct().getName().replace("\"", "\\\""))
                        .append("\",");
                json2.append("\"serialNumber\":\"")
                        .append(lp.getProductDetail().getSerialNumber().replace("\"", "\\\"")).append("\",");
                json2.append("\"color\":\"")
                        .append(lp.getProductDetail().getColor() != null
                                ? lp.getProductDetail().getColor().replace("\"", "\\\"")
                                : "")
                        .append("\",");
                json2.append("\"available\":").append(available2);
                json2.append("}");
            }
            json2.append("]");
            out2.print(json2.toString());
            out2.flush();
            return;

        } else {
            // view all external transfers
            List<TransferOrder> allPending = transDAO.getPendingTransfers();
            List<TransferOrder> externalPending = new ArrayList<>();
            for (TransferOrder t : allPending) {
                if (t.getFromWarehouseId() != t.getToWarehouseId()) {
                    externalPending.add(t);
                }
            }
            request.setAttribute("pendingList", externalPending);
            request.setAttribute("isExternal", true);
            request.getRequestDispatcher("/view/transfer-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        TransferDAO dao = new TransferDAO();

        if ("create".equals(action)) {
            try {
                int fromLocId = Integer.parseInt(request.getParameter("fromLoc"));
                int toLocId = Integer.parseInt(request.getParameter("toLoc"));
                String note = "[EXTERNAL] " + request.getParameter("note");
                String[] selectedProducts = request.getParameterValues("selectedProducts");

                if (selectedProducts == null || selectedProducts.length == 0) {
                    request.getSession().setAttribute("err", "Please select at least one product!");
                    response.sendRedirect("external-transfer?action=form");
                    return;
                }

                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                int userId = (user != null) ? user.getId() : 1;

                TransferOrder o = new TransferOrder();
                o.setFromLocationId(fromLocId);
                o.setToLocationId(toLocId);
                o.setNote(note);
                o.setCreateBy(userId);

                List<TransferOrderDetail> details = new ArrayList<>();
                for (String pdIdStr : selectedProducts) {
                    int pdId = Integer.parseInt(pdIdStr);
                    String qtyStr = request.getParameter("qty_" + pdId);
                    int qty = (qtyStr != null) ? Integer.parseInt(qtyStr) : 1;

                    int physical = dao.getPhysicalQuantity(fromLocId, pdId);
                    int reserved = dao.getReservedQuantity(fromLocId, pdId);
                    if (qty > (physical - reserved)) {
                        request.getSession().setAttribute("err",
                                "Quantity for product #" + pdId + " exceeds available stock!");
                        response.sendRedirect("external-transfer?action=form");
                        return;
                    }

                    TransferOrderDetail d = new TransferOrderDetail();
                    d.setProductDetailId(pdId);
                    d.setQuantity(qty);
                    details.add(d);
                }

                if (dao.createTransferRequest(o, details)) {
                    request.getSession().setAttribute("msg", "External transfer request created successfully!");
                } else {
                    request.getSession().setAttribute("err", "Failed to create transfer request!");
                }
                response.sendRedirect("external-transfer?action=view");
            } catch (Exception e) {
                request.getSession().setAttribute("err", "Invalid input parameters.");
                response.sendRedirect("external-transfer?action=form");
            }
        } else if ("approve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("transferId"));
            if (dao.approveRequest(id)) {
                request.getSession().setAttribute("msg",
                        "External transfer request approved! Internal stock ticket created.");
            } else {
                request.getSession().setAttribute("err", "Failed to approve request!");
            }
            response.sendRedirect("external-transfer?action=view");
        } else if ("cancel".equals(action)) {
            int id = Integer.parseInt(request.getParameter("transferId"));
            if (dao.cancelRequest(id)) {
                request.getSession().setAttribute("msg", "External transfer request cancelled!");
            } else {
                request.getSession().setAttribute("err", "Failed to cancel request!");
            }
            response.sendRedirect("external-transfer?action=view");
        }
    }
}
