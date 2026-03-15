package controller.supplier;

import dal.SupplierDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Supplier;

@WebServlet(name = "ManageSupplierServlet", urlPatterns = {"/manage-suppliers"})
public class ManageSupplierServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    /**
     * GET  /manage-suppliers             → list page
     * GET  /manage-suppliers?action=edit&id=X → pre-fill edit form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // ── Delete via GET (simple link) ──────────────────────────────────────
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            try {
                int id = Integer.parseInt(idStr);
                SupplierDAO dao = new SupplierDAO();
                boolean ok = dao.delete(id);
                if (ok) {
                    response.sendRedirect(request.getContextPath()
                            + "/manage-suppliers?success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath()
                            + "/manage-suppliers?error=delete_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/manage-suppliers?error=invalid_id");
            }
            return;
        }

        // ── List (with optional search & pagination) ──────────────────────────
        loadList(request, response);
    }

    /**
     * POST /manage-suppliers?action=add    → insert new supplier
     * POST /manage-suppliers?action=update → update existing supplier
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        SupplierDAO dao = new SupplierDAO();

        String name    = trim(request.getParameter("name"));
        String phone   = trim(request.getParameter("phone"));
        String email   = trim(request.getParameter("email"));
        String address = trim(request.getParameter("address"));

        if (name.isEmpty()) {
            // Re-show list with validation error
            request.setAttribute("error", "Supplier name is required.");
            request.setAttribute("formName",    name);
            request.setAttribute("formPhone",   phone);
            request.setAttribute("formEmail",   email);
            request.setAttribute("formAddress", address);
            loadList(request, response);
            return;
        }

        if ("update".equals(action)) {
            int id = parseId(request.getParameter("id"));
            Supplier s = new Supplier();
            s.setId(id);
            s.setName(name);
            s.setPhone(phone);
            s.setEmail(email);
            s.setAddress(address);
            boolean ok = dao.update(s);
            response.sendRedirect(request.getContextPath()
                    + "/manage-suppliers?success=" + (ok ? "updated" : "update_failed"));

        } else { // add
            Supplier s = new Supplier();
            s.setName(name);
            s.setPhone(phone);
            s.setEmail(email);
            s.setAddress(address);
            int newId = dao.insert(s);
            response.sendRedirect(request.getContextPath()
                    + "/manage-suppliers?success=" + (newId > 0 ? "added" : "add_failed"));
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private void loadList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SupplierDAO dao  = new SupplierDAO();
        String keyword   = request.getParameter("keyword") != null
                           ? request.getParameter("keyword").trim() : "";
        int page         = parseId(request.getParameter("page"));
        if (page < 1) page = 1;
        int offset       = (page - 1) * PAGE_SIZE;

        List<Supplier> supplierList = dao.searchAndPaginate(keyword, offset, PAGE_SIZE);
        int total        = dao.count(keyword);
        int totalPages   = (int) Math.ceil((double) total / PAGE_SIZE);

        // If edit mode, fetch supplier to populate the edit form
        String idParam = request.getParameter("id");
        if ("edit".equals(request.getParameter("action")) && idParam != null) {
            Supplier editing = dao.getById(parseId(idParam));
            request.setAttribute("editingSupplier", editing);
        }

        request.setAttribute("supplierList", supplierList);
        request.setAttribute("keyword",      keyword);
        request.setAttribute("page",         page);
        request.setAttribute("totalPages",   totalPages);
        request.setAttribute("total",        total);
        request.setAttribute("pageSize",     PAGE_SIZE);

        request.getRequestDispatcher("/view/supplier/page-list-supplier.jsp")
               .forward(request, response);
    }

    private String trim(String val) {
        return val == null ? "" : val.trim();
    }

    private int parseId(String val) {
        try { return Integer.parseInt(val); } catch (Exception e) { return 0; }
    }
}
