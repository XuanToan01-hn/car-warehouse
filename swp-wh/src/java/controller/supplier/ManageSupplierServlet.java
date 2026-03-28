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

@WebServlet(name = "ManageSupplierServlet", urlPatterns = { "/manage-suppliers" })
public class ManageSupplierServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    /**
     * GET /manage-suppliers → list page
     * GET /manage-suppliers?action=edit&id=X → pre-fill edit form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        SupplierDAO dao = new SupplierDAO();

        // ── ROUTING ──
        if ("add".equals(action)) {
            request.getRequestDispatcher("/view/supplier/page-add-supplier.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            int id = parseId(request.getParameter("id"));
            Supplier editing = dao.getById(id);
            if (editing != null) {
                request.setAttribute("supplier", editing);
                request.getRequestDispatcher("/view/supplier/page-edit-supplier.jsp").forward(request, response);
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/manage-suppliers?error=not_found");
                return;
            }
        }

        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            try {
                int id = Integer.parseInt(idStr);
                boolean ok = dao.delete(id);
                response.sendRedirect(request.getContextPath() + "/manage-suppliers?success=" + (ok ? "deleted" : "delete_failed"));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/manage-suppliers?error=invalid_id");
            }
            return;
        }

        // Default: List
        loadList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        SupplierDAO dao = new SupplierDAO();

        String name = trim(request.getParameter("name"));
        String phone = trim(request.getParameter("phone"));
        String email = trim(request.getParameter("email"));
        String address = trim(request.getParameter("address"));

        // ── SERVER-SIDE VALIDATION ──
        int excludeId = "update".equals(action) ? parseId(request.getParameter("id")) : 0;
        
        if (name.isEmpty()) {
            sendValidationError(request, response, "Supplier name is required.", action, excludeId, name, phone, email, address);
            return;
        }

        if (!phone.replaceAll("\\s+", "").matches("\\d{10,11}")) {
            sendValidationError(request, response, "Invalid phone number. Please enter 10 to 11 digits.", action, excludeId, name, phone, email, address);
            return;
        }

        if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            sendValidationError(request, response, "Invalid email format (e.g., supplier@example.com).", action, excludeId, name, phone, email, address);
            return;
        }

        // ── UNIQUENESS CHECKS ──
        if (dao.isNameExists(name, excludeId)) {
            sendValidationError(request, response, "Supplier name '" + name + "' already exists.", action, excludeId, name, phone, email, address);
            return;
        }
        if (dao.isPhoneExists(phone, excludeId)) {
            sendValidationError(request, response, "Phone number '" + phone + "' is already registered.", action, excludeId, name, phone, email, address);
            return;
        }
        if (dao.isEmailExists(email, excludeId)) {
            sendValidationError(request, response, "Email '" + email + "' is already registered.", action, excludeId, name, phone, email, address);
            return;
        }

        if ("update".equals(action)) {
            Supplier s = new Supplier();
            s.setId(excludeId);
            s.setName(name);
            s.setPhone(phone);
            s.setEmail(email);
            s.setAddress(address);
            boolean ok = dao.update(s);
            response.sendRedirect(request.getContextPath() + "/manage-suppliers?success=" + (ok ? "updated" : "update_failed"));
        } else { // add
            Supplier s = new Supplier();
            s.setName(name);
            s.setPhone(phone);
            s.setEmail(email);
            s.setAddress(address);
            int newId = dao.insert(s);
            response.sendRedirect(request.getContextPath() + "/manage-suppliers?success=" + (newId > 0 ? "added" : "add_failed"));
        }
    }

    private void sendValidationError(HttpServletRequest request, HttpServletResponse response, String error,
            String action, int id, String name, String phone, String email, String address)
            throws ServletException, IOException {
        
        request.setAttribute("error", error);
        
        // Re-construct the object for the form
        Supplier s = new Supplier();
        s.setId(id);
        s.setName(name);
        s.setPhone(phone);
        s.setEmail(email);
        s.setAddress(address);
        request.setAttribute("supplier", s);

        String target = "update".equals(action) ? "/view/supplier/page-edit-supplier.jsp" : "/view/supplier/page-add-supplier.jsp";
        request.getRequestDispatcher(target).forward(request, response);
    }

    private void loadList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SupplierDAO dao = new SupplierDAO();
        String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword").trim() : "";
        int page = parseId(request.getParameter("page"));
        if (page < 1) page = 1;
        int offset = (page - 1) * PAGE_SIZE;

        List<Supplier> supplierList = dao.searchAndPaginate(keyword, offset, PAGE_SIZE);
        int total = dao.count(keyword);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        request.setAttribute("supplierList", supplierList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("pageSize", PAGE_SIZE);

        request.getRequestDispatcher("/view/supplier/page-list-supplier.jsp").forward(request, response);
    }

    private String trim(String val) {
        return val == null ? "" : val.trim();
    }

    private int parseId(String val) {
        try { return Integer.parseInt(val); } catch (Exception e) { return 0; }
    }
}
