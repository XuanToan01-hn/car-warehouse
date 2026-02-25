<%-- 
    Document   : page-add-users
    Created on : May 20, 2025, 8:26:36 PM
    Author     : Nhat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
﻿<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>POS Dash | Responsive Bootstrap 4 Admin Dashboard Template</title>

        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modeladmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">  

    </head>
    <body class="  ">
        <!-- loader Start -->
        <div id="loading">
            <div id="loading-center">
            </div>
        </div>
        <!-- loader END -->
        <!-- Wrapper Start -->
        <div class="wrapper">



            <div class="content-page">
                <div class="container-fluid add-form-list">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between">
                                    <div class="header-title">
                                        <h4 class="card-title">Add Users</h4>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <form action="registeruser" method="post">
                                        <div class="row">
                                            <div class="col-md-6">                      
                                                <div class="form-group">
                                                    <label>Full Name *</label>
                                                    <input type="text" class="form-control" name="name" value="${name}" placeholder="Enter full name" required>
                                                    <c:if test="${not empty error_name}">
                                                        <small class="text-red">${error_name}</small>
                                                    </c:if>
                                                </div>
                                            </div>    

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Phone Number *</label>
                                                    <input type="text" class="form-control" name="phone" value="${phone}" placeholder="Enter phone number" required>
                                                    <c:if test="${not empty error_phone}">
                                                        <small class="text-red">${error_phone}</small>
                                                    </c:if>
                                                </div>
                                            </div> 

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Employee Code *</label>
                                                    <input type="text" class="form-control" name="userCode" value="${userCode}" placeholder="Enter employee code" required>
                                                    <c:if test="${not empty error_userCode}">
                                                        <small class="text-red">${error_userCode}</small>
                                                    </c:if>
                                                </div>
                                            </div> 

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Email *</label>
                                                    <input type="email" class="form-control" name="email" value="${email}" placeholder="Enter email" required>
                                                    <c:if test="${not empty error_email}">
                                                        <small class="text-red">${error_email}</small>
                                                    </c:if>
                                                </div>
                                            </div> 

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Role</label>
                                                    <select name="role" class="selectpicker form-control" data-style="py-0">
                                                        <c:forEach var="r" items="${listR}">
                                                            <option value="${r.id}" <c:if test="${r.id == role}">selected</c:if>>${r.roleName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div> 

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Gender</label>
                                                    <select name="male" class="selectpicker form-control" data-style="py-0">
                                                        <option value="0" <c:if test="${male == '0'}">selected</c:if>>Male</option>
                                                        <option value="1" <c:if test="${male == '1'}">selected</c:if>>Female</option>
                                                        </select>
                                                    </div>
                                                </div> 

                                                <div class="col-md-6">                      
                                                    <div class="form-group">
                                                        <label>Username *</label>
                                                        <input type="text" class="form-control" name="username" value="${username}" placeholder="Enter username" required>
                                                    <c:if test="${not empty error_username}">
                                                        <small class="text-red">${error_username}</small>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="col-md-6">                      
                                                <div class="form-group">
                                                    <label>Date of Birth *</label>
                                                    <input type="date" class="form-control" name="dateOfBirth" value="${dateOfBirth}" required>
                                                    <c:if test="${not empty error_dateOfBirth}">
                                                        <small class="text-red">${error_dateOfBirth}</small>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="col-md-6">                      
                                                <div class="form-group">
                                                    <label>Password *</label>
                                                    <input type="text" class="form-control" name="password" placeholder="Enter password" required>
                                                    <c:if test="${not empty error_password}">
                                                        <small class="text-red">${error_password}</small>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="col-md-6">                      
                                                <div class="form-group">
                                                    <label>Confirm Password *</label>
                                                    <input type="text" class="form-control" name="confirmPassword" placeholder="Re-enter password" required>
                                                    <c:if test="${not empty error_confirmPassword}">
                                                        <small class="text-red">${error_confirmPassword}</small>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <div class="col-md-6" id="warehouseDropdown" style="display: none;">
                                                <div class="form-group">
                                                    <label>Warehouse</label>
                                                    <select name="warehouseId" class="form-control">
                                                        <c:forEach var="w" items="${listWarehouse}">
                                                            <option value="${w.id}" <c:if test="${w.id == warehouseId}">selected</c:if>>${w.warehouseName}- ${w.address}</option>
                                                        </c:forEach>
                                                    </select>
                                                    <c:if test="${not empty error_warehouse}">
                                                        <small class="text-red">${error_warehouse}</small>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>


                                        <button type="submit" class="btn btn-primary mr-2">Add User</button>
                                        <button type="reset" class="btn btn-danger">Reset</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Page end  -->
                </div>
            </div>
        </div>
        <!-- Backend Bundle JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>

        <!-- Table Treeview JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>

        <!-- Chart Custom JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>

        <!-- Chart Custom JavaScript -->
        <script async="" src="${pageContext.request.contextPath}/assets/js/chart-custom.js"></script>

        <!-- app JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

        <div id="errorToast" class="toast-message" style="display: none;">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
        </div>

        <div id="successToast" class="toast-message" style="display: none;">
            <%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %>
        </div>

    </body>

    <script>
        const roleSelect = document.querySelector('select[name="role"]');
        const warehouseDropdown = document.getElementById('warehouseDropdown');

        function toggleWarehouseField() {
            const selectedText = roleSelect.options[roleSelect.selectedIndex].text;
            if (selectedText === 'Warehouse Staff' || selectedText === 'Sales Staff') {
                warehouseDropdown.style.display = 'block';
            } else {
                warehouseDropdown.style.display = 'none';
            }
        }

        roleSelect.addEventListener('change', toggleWarehouseField);
        window.onload = toggleWarehouseField; // kiểm tra lại khi reload form (giữ trạng thái đã chọn)
    </script>
    <% if (request.getAttribute("error") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var toast = document.getElementById("errorToast");
            toast.style.display = "block";
            setTimeout(function () {
                toast.style.display = "none";
            }, 4000); // Tự động ẩn sau 4 giây
        });
    </script>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var toast = document.getElementById("successToast");
            toast.style.display = "block";
            setTimeout(function () {
                toast.style.display = "none";
            }, 4000); // Tự động ẩn sau 4 giây
        });
    </script>
    <% } %>
</script>
</html>