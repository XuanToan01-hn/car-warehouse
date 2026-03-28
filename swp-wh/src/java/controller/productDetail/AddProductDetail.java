/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.productDetail;

import dal.ProductDAO;
import dal.ProductDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import model.ProductDetail;
import utils.InputValidator;

/**
 *
 * @author Asus
 */
@WebServlet(name = "AddProductDetail", urlPatterns = { "/add-product-detail" })
public class AddProductDetail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách sản phẩm để người dùng chọn trong dropdown (Select Box)
        dal.ProductDAO pDao = new dal.ProductDAO();
        request.setAttribute("listProduct", pDao.getAll());
        request.getRequestDispatcher("view/product-detail/page-add-product-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // 1. Lấy dữ liệu từ form
            int productId = Integer.parseInt(request.getParameter("productId"));
            String lotNumber = request.getParameter("lotNumber");
            String serialNumber = request.getParameter("serialNumber");
            String manufactureDateStr = request.getParameter("mfdDate");
            double price = Double.parseDouble(request.getParameter("price"));
            String color = request.getParameter("color");

            // Validate Lot Number format (LN + 6 digits)
            if (!InputValidator.isEmpty(lotNumber) && !InputValidator.isValid(lotNumber, InputValidator.LOT_NUMBER)) {
                request.setAttribute("error", "Lot Number phải có định dạng LN + 6 chữ số (VD: LN000001)");
                request.setAttribute("listProduct", new ProductDAO().getAll());
                request.getRequestDispatcher("view/product-detail/page-add-product-detail.jsp").forward(request, response);
                return;
            }

            // Validate Serial Number format (SN + 6 digits)
            if (!InputValidator.isEmpty(serialNumber) && !InputValidator.isValid(serialNumber, InputValidator.SERIAL_NUMBER)) {
                request.setAttribute("error", "Serial Number phải có định dạng SN + 6 chữ số (VD: SN000001)");
                request.setAttribute("listProduct", new ProductDAO().getAll());
                request.getRequestDispatcher("view/product-detail/page-add-product-detail.jsp").forward(request, response);
                return;
            }

            // 2. Tạo đối tượng Model
            model.ProductDetail pd = new model.ProductDetail();
            model.Product p = new model.Product();
            p.setId(productId);
            pd.setProduct(p);
            pd.setLotNumber(lotNumber);
            pd.setSerialNumber(serialNumber);
            pd.setPrice(price);
            pd.setColor(color);
            // Parse ngày tháng
            if (manufactureDateStr == null || manufactureDateStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Manufacture date is required.");
            }
            pd.setManufactureDate(java.sql.Date.valueOf(manufactureDateStr.trim()));

            // 3. Lưu vào DB
            dal.ProductDetailDAO db = new dal.ProductDetailDAO();
            db.insert(pd);

            // 4. Thành công thì quay về trang danh sách
            response.sendRedirect("list-product-detail");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add-product-detail?error=1");
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
