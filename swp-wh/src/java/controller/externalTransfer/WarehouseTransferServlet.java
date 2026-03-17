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
import model.User;
import model.Warehouse;

@WebServlet(name = "ExternalWarehouseTransferServlet", urlPatterns = {"/external-transfer"})
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

        if (action.equals("form")) {
            request.setAttribute("productDetails", pdDAO.getAll());
            request.setAttribute("warehouses", warehouseDAO.getAll());
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
                json.append("\"name\":\"").append(w.getWarehouseName() != null ? w.getWarehouseName().replace("\"", "\\\"") : "Unknown").append("\"");
                json.append("}");
                if (++count < whMap.size()) json.append(",");
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
                        if (!first) json.append(",");
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
                if (!first) json.append(",");
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
            // We use the same transfer-list.jsp but maybe add an indicator or distinct URL
            request.setAttribute("isExternal", true); // To distinguish logic in JSP if needed
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
                int pdId = Integer.parseInt(request.getParameter("pdId"));
                int fromLocId = Integer.parseInt(request.getParameter("fromLoc"));
                int qty = Integer.parseInt(request.getParameter("qty"));

                int physical = dao.getPhysicalQuantity(fromLocId, pdId);
                int reserved = dao.getReservedQuantity(fromLocId, pdId);
                if (qty > (physical - reserved)) {
                    request.getSession().setAttribute("err", "Requested quantity (" + qty + ") exceeds available stock (" + (physical - reserved) + ")!");
                    response.sendRedirect("external-transfer?action=form");
                    return;
                }

                TransferOrder o = new TransferOrder();
                o.setFromLocationId(fromLocId);
                o.setToLocationId(Integer.parseInt(request.getParameter("toLoc"))); // Note: The validation that the warehouses are different is done in frontend
                o.setProductDetailId(pdId);
                o.setQuantity(qty);
                o.setNote("[EXTERNAL] " + request.getParameter("note")); 
                
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                o.setCreateBy(user != null ? user.getId() : 1);

                if (dao.createTransferRequest(o)) {
                    request.getSession().setAttribute("msg", "External transfer request dispatched successfully! Awaiting manager approval.");
                    response.sendRedirect("external-transfer?action=view");
                } else {
                    request.getSession().setAttribute("err", "Failed to create external transfer request.");
                    response.sendRedirect("external-transfer?action=form");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("err", "Invalid input parameters.");
                response.sendRedirect("external-transfer?action=form");
            }
        } else if ("approve".equals(action)) {
            int id = Integer.parseInt(request.getParameter("transferId"));
            if (dao.approveRequest(id)) {
                request.getSession().setAttribute("msg", "External transfer request approved! Internal stock ticket created.");
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
