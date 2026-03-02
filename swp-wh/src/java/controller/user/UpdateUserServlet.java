package controller.user;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.time.LocalDate;
import model.Role;
import model.User;
import model.Warehouse;
import utils.InputValidator;

@WebServlet(name = "UpdateUserServlet", urlPatterns = {"/update-user"})
public class UpdateUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("userlist");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String page = request.getParameter("page");
        String keyword = request.getParameter("keyword");
        if (page == null || page.isEmpty()) page = "1";

        try {
            // 1. Lấy dữ liệu từ Request
            String idStr = request.getParameter("userId");
            String fullName = request.getParameter("fullName");
            String userCode = request.getParameter("userCode");
            String userName = request.getParameter("userName");
            String maleStr = request.getParameter("male");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String roleIdStr = request.getParameter("roleId");
            String warehouseIdStr = request.getParameter("warehouseId");

            // 2. Validate cơ bản
            if (InputValidator.isEmpty(idStr)) {
                session.setAttribute("error", "Invalid user ID!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            int userId = Integer.parseInt(idStr);
            UserDAO userService = new UserDAO();
            User existing = userService.getById(userId);

            if (existing == null) {
                session.setAttribute("error", "User not found!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            // Validate logic nghiệp vụ (Email, Phone, Age...)
            if (InputValidator.isEmpty(fullName)) {
                session.setAttribute("error", "Full name cannot be empty!");
                response.sendRedirect("userlist?page=" + page);
                return;
            }

            // 3. Xử lý Logic Role 3, 4, 5 và Warehouse
            int roleId = Integer.parseInt(roleIdStr);
            Integer warehouseId = null;

            // Chỉ cho Role 3, 4, 5 được phép/bắt buộc chọn Warehouse
            if (roleId == 3 || roleId == 4 || roleId == 5) {
                if (warehouseIdStr != null && !warehouseIdStr.equals("0") && !warehouseIdStr.isEmpty()) {
                    warehouseId = Integer.parseInt(warehouseIdStr);
                } else {
                    // Nếu bắt buộc Role này phải có kho thì báo lỗi, nếu không thì để null
                    // session.setAttribute("error", "Role này bắt buộc chọn nhà kho!");
                    // response.sendRedirect("userlist?page=" + page);
                    // return;
                }
            }

            // 4. Gán dữ liệu vào đối tượng User
            existing.setFullName(fullName);
            existing.setUserCode(userCode);
            existing.setUsername(userName);
            existing.setMale(Integer.parseInt(maleStr));
            existing.setDateOfBirth(dateOfBirthStr);
            existing.setEmail(email);
            existing.setPhone(phone);
            existing.setRole(new Role(roleId));

            // Set Warehouse: Nếu có ID hợp lệ thì set, ngược lại set NULL
            if (warehouseId != null && warehouseId > 0) {
                existing.setWarehouse(new Warehouse(warehouseId));
            } else {
                existing.setWarehouse(null);
            }

            // 5. Gọi DAO để Update
            boolean updated = userService.update(existing);

            if (updated) {
                session.setAttribute("success", "User updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update user in database!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "System error: " + e.getMessage());
        }

        // 6. Redirect về trang danh sách kèm keyword cũ
        String encodedKeyword = URLEncoder.encode(keyword == null ? "" : keyword, "UTF-8");
        response.sendRedirect("userlist?page=" + page + "&keyword=" + encodedKeyword);
    }
}