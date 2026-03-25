package controller.tax;

import dal.TaxDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Tax;

@WebServlet(name = "TaxServlet", urlPatterns = {"/taxes"})
public class TaxServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        TaxDAO dao = new TaxDAO();

        // Server-side search
        String search = request.getParameter("search");
        List<Tax> taxes;
        if (search != null && !search.trim().isEmpty()) {
            taxes = dao.search(search.trim());
            request.setAttribute("search", search.trim());
        } else {
            taxes = dao.getAll();
        }
        request.setAttribute("taxes", taxes);

        // Edit mode: load the tax to be edited
        String mode = request.getParameter("mode");
        if ("edit".equals(mode)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    Tax editing = dao.getById(id);
                    request.setAttribute("editTax", editing);
                    request.setAttribute("mode", "edit");
                } catch (NumberFormatException ignored) {}
            }
        } else if ("add".equals(mode)) {
            request.setAttribute("mode", "add");
        }

        request.getRequestDispatcher("/view/tax.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        TaxDAO dao = new TaxDAO();

        switch (action) {
            case "add":
            case "update":
                handleUpsert(request, response, dao, action);
                break;
            case "delete":
                handleDelete(request, response, dao);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/taxes");
                break;
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, TaxDAO dao)
            throws IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                dao.delete(id);
                request.getSession().setAttribute("success", "Xóa thuế thành công!");
            } catch (NumberFormatException ignored) {}
        }
        response.sendRedirect(request.getContextPath() + "/taxes");
    }

    private void handleUpsert(HttpServletRequest request, HttpServletResponse response, TaxDAO dao, String action)
            throws IOException {
        String idRaw = trimParam(request.getParameter("taxId"));
        String taxName = trimParam(request.getParameter("taxName"));
        String taxRateRaw = trimParam(request.getParameter("taxRate"));
        String effectiveFromRaw = trimParam(request.getParameter("effectiveFrom"));
        String expiredDateRaw = trimParam(request.getParameter("expiredDate"));

        if (taxName.isEmpty()) {
            String prefix = "add".equals(action) ? "Thêm thuế" : "Cập nhật thuế";
            request.getSession().setAttribute("error", prefix + " không thành công. Tên thuế không được để trống!");
            response.sendRedirect(request.getContextPath() + "/taxes");
            return;
        }

        double taxRate;
        try {
            taxRate = Double.parseDouble(taxRateRaw);
            if (taxRate < 0 || taxRate > 100) {
                String prefix = "add".equals(action) ? "Thêm thuế" : "Cập nhật thuế";
                request.getSession().setAttribute("error", prefix + " không thành công. Thuế suất phải từ 0% đến 100%!");
                response.sendRedirect(request.getContextPath() + "/taxes");
                return;
            }
        } catch (NumberFormatException e) {
            String prefix = "add".equals(action) ? "Thêm thuế" : "Cập nhật thuế";
            request.getSession().setAttribute("error", prefix + " không thành công. Thuế suất không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/taxes");
            return;
        }

        java.sql.Date effective = null;
        java.sql.Date expired = null;
        try {
            if (!effectiveFromRaw.isEmpty()) {
                effective = java.sql.Date.valueOf(effectiveFromRaw);
            }
            if (!expiredDateRaw.isEmpty()) {
                expired = java.sql.Date.valueOf(expiredDateRaw);
            }
        } catch (IllegalArgumentException e) {
            String prefix = "add".equals(action) ? "Thêm thuế" : "Cập nhật thuế";
            request.getSession().setAttribute("error", prefix + " không thành công. Định dạng ngày không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/taxes");
            return;
        }

        if (effective != null && expired != null && !effective.before(expired)) {
            String prefix = "add".equals(action) ? "Thêm thuế" : "Cập nhật thuế";
            request.getSession().setAttribute("error", prefix + " không thành công. Ngày hiệu lực phải bé hơn ngày hết hạn!");
            response.sendRedirect(request.getContextPath() + "/taxes");
            return;
        }

        Tax t = new Tax();
        if (!idRaw.isEmpty()) {
            try {
                t.setId(Integer.parseInt(idRaw));
            } catch (NumberFormatException ignored) {}
        }
        t.setTaxName(taxName);
        t.setTaxRate(taxRate);
        t.setEffectiveFrom(effective);
        t.setExpiredDate(expired);

        if ("update".equals(action)) {
            dao.update(t);
            request.getSession().setAttribute("success", "Cập nhật thuế thành công!");
        } else {
            dao.insert(t);
            request.getSession().setAttribute("success", "Thêm thuế mới thành công!");
        }

        response.sendRedirect(request.getContextPath() + "/taxes");
    }

    private static String trimParam(String s) {
        return s == null ? "" : s.trim();
    }
}

