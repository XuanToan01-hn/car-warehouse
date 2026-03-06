/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.user;

import dal.RoleDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.List;
import model.Location;
import model.Role;
import model.User;
import model.Warehouse;
import utils.EndCode;
import utils.InputValidator;

/**
 *
 * @author LEGION
 */
@WebServlet(name = "EditUserServlet", urlPatterns = {"/update-user"})
public class UpdateUserServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditUserServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditUserServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        RoleDAO roleService = new RoleDAO();
//        UserDAO userService = new UserDAO();
//        List<Role> listR = roleService.getAllRole();
//        String userId = request.getParameter("userId");
//        User user = userService.getUserByUserId(Integer.parseInt(userId));
//        request.setAttribute("listR", listR);
//        request.setAttribute("user", user);
//        request.getRequestDispatcher("view/system-edit-user.jsp").forward(request, response);
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
  @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession();
    String page = request.getParameter("page");
    String keyword = request.getParameter("keyword");

    try {
        // 1. Lấy các thông tin từ form
        String idStr = request.getParameter("userId");
        String fullName = request.getParameter("fullName");
        String maleStr = request.getParameter("male");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roleIdStr = request.getParameter("roleId");
        String warehouseIdStr = request.getParameter("warehouseId");

        // Lưu ý: userCode và userName được gửi về từ input readonly, 
        // nhưng chúng ta sẽ không dùng chúng để cập nhật vào DB cho an toàn.

        // 2. Validate ID
        if (InputValidator.isEmpty(idStr)) {
            session.setAttribute("error", "Không tìm thấy ID người dùng!");
            response.sendRedirect("userlist?page=" + page);
            return;
        }
        int userId = Integer.parseInt(idStr);

        // 3. Lấy dữ liệu hiện tại từ Database
        UserDAO userService = new UserDAO();
        User existing = userService.getById(userId);

        if (existing == null) {
            session.setAttribute("error", "Người dùng không tồn tại!");
            response.sendRedirect("userlist?page=" + page);
            return;
        }

        // 4. Validate các trường ĐƯỢC PHÉP sửa
        if (InputValidator.isEmpty(fullName) || !InputValidator.isValid(fullName, InputValidator.NAME_USER)) {
            session.setAttribute("error", "Họ tên không hợp lệ!");
            redirectBack(response, page, keyword);
            return;
        }

        if (InputValidator.isEmpty(email) || !InputValidator.isValid(email, InputValidator.EMAIL_REGEX)) {
            session.setAttribute("error", "Email không hợp lệ!");
            redirectBack(response, page, keyword);
            return;
        }

        if (InputValidator.isEmpty(phone) || !InputValidator.isValid(phone, InputValidator.PHONE_NUMBER)) {
            session.setAttribute("error", "Số điện thoại không hợp lệ!");
            redirectBack(response, page, keyword);
            return;
        }

        // Kiểm tra 18 tuổi
        LocalDate dob = LocalDate.parse(dateOfBirthStr);
        if (!InputValidator.isOver18(dob)) {
            session.setAttribute("error", "Người dùng phải từ 18 tuổi trở lên!");
            redirectBack(response, page, keyword);
            return;
        }

        // 5. Kiểm tra trùng lặp Email và Phone (chỉ kiểm tra nếu có sự thay đổi)
        if (!email.equals(existing.getEmail()) && userService.isEmailExist(email)) {
            session.setAttribute("error", "Email đã tồn tại trong hệ thống!");
            redirectBack(response, page, keyword);
            return;
        }

        if (!phone.equals(existing.getPhone()) && userService.isPhoneExist(phone)) {
            session.setAttribute("error", "Số điện thoại đã tồn tại!");
            redirectBack(response, page, keyword);
            return;
        }

        // 6. Xử lý logic Warehouse và Role
        int roleId = Integer.parseInt(roleIdStr);
        Integer warehouseId = null;
        // Kiểm tra các Role yêu cầu có Warehouse (ví dụ ID: 3, 4, 5)
        if (roleId == 3 || roleId == 4 || roleId == 5) {
            if (InputValidator.isEmpty(warehouseIdStr) || "0".equals(warehouseIdStr)) {
                session.setAttribute("error", "Vui lòng chọn Kho hàng cho vai trò này!");
                redirectBack(response, page, keyword);
                return;
            }
            warehouseId = Integer.parseInt(warehouseIdStr);
        }

        // 7. CẬP NHẬT ĐỐI TƯỢNG (Chỉ set các trường được phép thay đổi)
        existing.setFullName(fullName);
        existing.setMale(Integer.parseInt(maleStr));
        existing.setDateOfBirth(dateOfBirthStr);
        existing.setEmail(email);
        existing.setPhone(phone);
        existing.setRole(new Role(roleId));
        
        if (warehouseId != null && warehouseId > 0) {
            existing.setWarehouse(new Warehouse(warehouseId));
        } else {
            existing.setWarehouse(null);
        }

        // Lưu ý: KHÔNG gọi existing.setUserCode() và existing.setUserName() 
        // để giữ nguyên dữ liệu gốc trong DB.

        boolean updated = userService.update(existing);

        if (updated) {
            session.setAttribute("success", "Cập nhật người dùng thành công!");
        } else {
            session.setAttribute("error", "Cập nhật thất bại tại hệ thống!");
        }

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
    }

    response.sendRedirect("userlist?page=" + page + "&keyword=" + URLEncoder.encode(keyword == null ? "" : keyword, "UTF-8"));
}

private void redirectBack(HttpServletResponse response, String page, String keyword) throws IOException {
    response.sendRedirect("userlist?page=" + page + "&keyword=" + URLEncoder.encode(keyword == null ? "" : keyword, "UTF-8"));
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
