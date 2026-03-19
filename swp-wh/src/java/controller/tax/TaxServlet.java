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

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    TaxDAO dao = new TaxDAO();
                    dao.delete(id);
                } catch (NumberFormatException ignored) {
                }
            }
            response.sendRedirect(request.getContextPath() + "/taxes");
            return;
        }

        TaxDAO dao = new TaxDAO();
        List<Tax> taxes = dao.getAll();
        request.setAttribute("taxes", taxes);
        request.getRequestDispatcher("/view/tax.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = trim(request.getParameter("action"));
        String taxName = trim(request.getParameter("taxName"));
        String taxRateRaw = trim(request.getParameter("taxRate"));
        String effectiveFromRaw = trim(request.getParameter("effectiveFrom"));
        String expiredDateRaw = trim(request.getParameter("expiredDate"));
        String idRaw = trim(request.getParameter("taxId"));

        if (taxName.isEmpty() || taxRateRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/taxes");
            return;
        }

        double taxRate;
        try {
            taxRate = Double.parseDouble(taxRateRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/taxes");
            return;
        }

        Tax t = new Tax();
        if (!idRaw.isEmpty()) {
            t.setId(Integer.parseInt(idRaw));
        }
        t.setTaxName(taxName);
        t.setTaxRate(taxRate);

        if (!effectiveFromRaw.isEmpty()) {
            try {
                t.setEffectiveFrom(java.sql.Date.valueOf(effectiveFromRaw));
            } catch (IllegalArgumentException ignored) {
            }
        }
        if (!expiredDateRaw.isEmpty()) {
            try {
                t.setExpiredDate(java.sql.Date.valueOf(expiredDateRaw));
            } catch (IllegalArgumentException ignored) {
            }
        }

        TaxDAO dao = new TaxDAO();
        if ("update".equals(action)) {
            dao.update(t);
        } else {
            dao.insert(t);
        }

        response.sendRedirect(request.getContextPath() + "/taxes");
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }
}

