<%-- 
    Document   : page-add-users
    Created on : May 20, 2025, 8:26:36 PM
    Author     : Nhat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Thêm Người Dùng</title>

        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">  
    </head>
    <body>
        <!-- loader Start -->
        <div id="loading">
            <div id="loading-center"></div>
        </div>
        <!-- loader END -->
        <!-- Wrapper Start -->
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>
            <%@ include file="../header.jsp" %>
            <div class="content-page">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between">
                                    <div class="header-title">
                                        <h4 class="card-title">Thêm Người Dùng Mới</h4>
                                    </div>
                                    <a href="userlist" class="btn btn-secondary">Quay lại</a>
                                </div>
                                <div class="card-body">
                                    <!-- Error Message -->
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <strong>Lỗi:</strong> ${error}
                                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                    </c:if>
                                    <!-- Success Message -->
                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <strong>Thành công:</strong> ${success}
                                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                    </c:if>

                                    <form action="registeruser" method="post">
                                        <div class="row">
                                            <div class="col-md-6">                      
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Họ và Tên *</label>
                                                    <input type="text" class="form-control" name="name" value="${name}" placeholder="Nhập họ và tên" required>
                                                    <c:if test="${not empty error_name}">
                                                        <small class="text-danger">${error_name}</small>
                                                    </c:if>
                                                </div>
                                            </div>    

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Số Điện Thoại *</label>
                                                    <input type="text" class="form-control" name="phone" value="${phone}" placeholder="Nhập số điện thoại" required>
                                                    <c:if test="${not empty error_phone}">
                                                        <small class="text-danger">${error_phone}</small>
                                                    </c:if>
                                                </div>
                                            </div> 

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Mã Nhân Viên *</label>
                                                    <input type="text" class="form-control" name="userCode" value="${userCode}" placeholder="Nhập mã nhân viên" required>
                                                    <c:if test="${not empty error_userCode}">
                                                        <small class="text-danger">${error_userCode}</small>
                                                    </c:if>
                                                </div>
                                            </div> 

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Email *</label>
                                                    <input type="email" class="form-control" name="email" value="${email}" placeholder="Nhập email" required>
                                                    <c:if test="${not empty error_email}">
                                                        <small class="text-danger">${error_email}</small>
                                                    </c:if>
                                                </div>
                                            </div> 

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Vai Trò</label>
                                                    <select name="role" class="form-control">
                                                        <c:forEach var="r" items="${listR}">
                                                            <option value="${r.id}" <c:if test="${r.id == role}">selected</c:if>>${r.roleName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div> 

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Giới Tính</label>
                                                    <select name="male" class="form-control">
                                                        <option value="0" <c:if test="${male == '0'}">selected</c:if>>Nam</option>
                                                        <option value="1" <c:if test="${male == '1'}">selected</c:if>>Nữ</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Tên Đăng Nhập *</label>
                                                    <input type="text" class="form-control" name="username" value="${username}" placeholder="Nhập tên đăng nhập" required>
                                                    <c:if test="${not empty error_username}">
                                                        <small class="text-danger">${error_username}</small>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="col-md-6">                      
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Ngày Sinh *</label>
                                                    <input type="date" class="form-control" name="dateOfBirth" value="${dateOfBirth}" required>
                                                    <c:if test="${not empty error_dateOfBirth}">
                                                        <small class="text-danger">${error_dateOfBirth}</small>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="col-md-6">                      
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Mật Khẩu *</label>
                                                    <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu" required>
                                                    <c:if test="${not empty error_password}">
                                                        <small class="text-danger">${error_password}</small>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="col-md-6">                      
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Xác Nhận Mật Khẩu *</label>
                                                    <input type="password" class="form-control" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                                                    <c:if test="${not empty error_confirmPassword}">
                                                        <small class="text-danger">${error_confirmPassword}</small>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="col-md-6" id="warehouseDropdown" style="display: none;">
                                                <div class="form-group">
                                                    <label class="form-label font-weight-bold">Kho Hàng</label>
                                                    <select name="warehouseId" class="form-control">
                                                        <option value="">-- Chọn Kho Hàng --</option>
                                                        <c:forEach var="w" items="${listWarehouse}">
                                                            <option value="${w.id}" <c:if test="${w.id == warehouseId}">selected</c:if>>${w.warehouseName} - ${w.address}</option>
                                                        </c:forEach>
                                                    </select>
                                                    <c:if test="${not empty error_warehouse}">
                                                        <small class="text-danger">${error_warehouse}</small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mt-3">
                                            <button type="submit" class="btn btn-primary">
<%--                                                <i class="fas fa-save mr-2"></i>--%>
                                                Thêm Người Dùng
                                            </button>
                                            <button type="reset" class="btn btn-secondary ml-2">
<%--                                                <i class="fas fa-redo mr-2"></i>--%>
                                                Đặt Lại
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <footer class="iq-footer">
            <div class="container-fluid">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-lg-6">
                                <ul class="list-inline mb-0">
                                    <li class="list-inline-item"><a href="#">Privacy Policy</a></li>
                                    <li class="list-inline-item"><a href="#">Terms of Use</a></li>
                                </ul>
                            </div>
                            <div class="col-lg-6 text-right">
                                <span class="mr-1">
                                    <script>document.write(new Date().getFullYear())</script>©
                                </span>
                                <a href="#">POS Dash</a>.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Backend Bundle JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
        <!-- Table Treeview JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>
        <!-- Customizer JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
        <!-- Chart Custom JavaScript -->
        <script async src="${pageContext.request.contextPath}/assets/js/chart-custom.js"></script>
        <!-- app JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

        <script>
            const roleSelect = document.querySelector('select[name="role"]');
            const warehouseDropdown = document.getElementById('warehouseDropdown');

            function toggleWarehouseField() {
                const selectedText = roleSelect.options[roleSelect.selectedIndex].text;
                if (selectedText === 'Inventory Staff' || selectedText === 'Sales Staff') {
                    warehouseDropdown.style.display = 'block';
                } else {
                    warehouseDropdown.style.display = 'none';
                }
            }

            roleSelect.addEventListener('change', toggleWarehouseField);
            window.onload = toggleWarehouseField;
        </script>
    </body>
</html>