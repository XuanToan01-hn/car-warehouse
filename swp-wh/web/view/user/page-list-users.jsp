<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>POS Dash | User Management</title>

        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/modeladmin.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">
    </head>
    <body>
        <div id="loading">
            <div id="loading-center"></div>
        </div>
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>

            <div class="content-page">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4">
                                <div>
                                    <h4 class="mb-3">User List</h4>
                                    <form action="userlist" method="get" class="searchbox-custom">
                                        <div class="search-row">
                                            <div class="search-input-container">
                                                <input type="text" name="keyword" value="${keyword}" class="search-input-custom" placeholder="User Search...">
                                                <button type="submit" class="search-btn-inside" title="Search">🔎</button>
                                            </div>

                                            <select name="roleId" onchange="this.form.submit()" class="search-select-custom">
                                                <option value="">-- All Role --</option>
                                                <c:forEach var="r" items="${roles}">
                                                    <option value="${r.id}" ${roleId == r.id ? 'selected' : ''}>${r.roleName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </form>
                                </div>
                                <c:if test="${not empty errorS}">
                                    <div class="alert alert-danger">${errorS}</div>
                                </c:if>
                                <a href="registeruser" class="btn btn-primary add-list">Add User</a>
                            </div>
                        </div>
                        
                        <div class="col-lg-12">
                            <div class="table-responsive rounded mb-3">
                                <table class="data-table table mb-0 tbl-server-info">
                                    <thead class="bg-white text-uppercase">
                                        <tr class="ligth ligth-data">
                                            <th>Full Name</th>
                                            <th>User Code</th>
                                            <th>Username</th>
                                            <th>Gender</th>
                                            <th>DOB</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Role</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody class="ligth-body">
                                        <c:forEach var="u" items="${listUser}">
                                            <tr>
                                                <td>${u.fullName}</td>
                                                <td>${u.userCode}</td>
                                                <td>${u.username}</td>
                                                <td>${u.male == 1 ? 'Male' : 'Female'}</td>
                                                <td>${u.dateOfBirth}</td>
                                                <td>${u.email}</td>
                                                <td>${u.phone}</td>
                                                <td>${u.role.roleName}</td>
                                                <td class="actions-group">
                                                    <a href="javascript:void(0);" class="action-link reset-link" 
                                                       onclick="openUserChangePasswordModal('${u.id}', '${currentPage}', '${u.userCode}', '${keyword}')">
                                                        Reset
                                                    </a> |
                                                    <a class="action-link edit-link" href="javascript:void(0);" 
                                                       onclick="openEditModel('${u.id}', '${u.userCode}', '${u.fullName}', '${u.username}', '${u.male}', '${u.dateOfBirth}', '${u.email}', '${u.phone}', '${u.role.id}', '${currentPage}', '${keyword}', '${u.warehouse != null ? u.warehouse.id : 0}')">
                                                        Edit
                                                    </a> |
                                                    <a href="javascript:void(0);" class="action-link delete-link" 
                                                       onclick="confirmDelete('${u.id}', '${u.fullName}', '${currentPage}', '${keyword}')">
                                                        Delete
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="pagination mt-3 d-flex justify-content-end">
                                <c:if test="${currentPage > 1}">
                                    <a href="userlist?page=${currentPage - 1}&keyword=${keyword}&roleId=${roleId}" class="btn btn-outline-primary mx-1">&lt;</a>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a href="userlist?page=${i}&keyword=${keyword}&roleId=${roleId}" 
                                       class="${i == currentPage ? 'btn btn-primary' : 'btn btn-outline-primary'} mx-1">${i}</a>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="userlist?page=${currentPage + 1}&keyword=${keyword}&roleId=${roleId}" class="btn btn-outline-primary mx-1">&gt;</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="customChangePasswordModal" class="custom-modal" style="display:none;">
            <div class="custom-modal-content">
                <h3 id="changePasswordTitle">Update Password</h3>
                <form method="post" action="resetpassadmin">
                    <input type="hidden" name="userId" id="customChangePasswordUserId">
                    <input type="hidden" name="page" id="changePasswordPage">
                    <input type="hidden" name="keyword" id="changePasswordKeyword">
                    <div class="custom-input-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" required>
                    </div>
                    <div class="custom-input-group">
                        <label>Confirm Password</label>
                        <input type="password" name="confirmPassword" required>
                    </div>
                    <div class="custom-modal-buttons">
                        <button type="button" onclick="closeUserChangePasswordModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="customEditUserModal" class="custom-modal" style="display:none;">
            <div class="custom-modal-content">
                <h3>Edit User</h3>
                <form method="post" action="update-user">
                    <input type="hidden" name="userId" id="editUserId">
                    <input type="hidden" name="page" id="editPage">
                    <input type="hidden" name="keyword" id="editKeyword">

                    <div class="custom-input-group"><label>Full Name</label><input type="text" name="fullName" id="editFullName" required></div>
                    <div class="custom-input-group"><label>User Code</label><input type="text" name="userCode" id="editUserCode" required></div>
                    <div class="custom-input-group"><label>Username</label><input type="text" name="userName" id="editUserName" required></div>
                    <div class="custom-input-group">
                        <label>Gender</label>
                        <select name="male" id="editMale">
                            <option value="1">Male</option>
                            <option value="0">Female</option>
                        </select>
                    </div>
                    <div class="custom-input-group"><label>DOB</label><input type="date" name="dateOfBirth" id="editDateOfBirth"></div>
                    <div class="custom-input-group"><label>Email</label><input type="email" name="email" id="editEmail" required></div>
                    <div class="custom-input-group"><label>Phone</label><input type="text" name="phone" id="editPhone" required></div>
                    <div class="custom-input-group">
                        <label>Role</label>
                        <select name="roleId" id="editRoleId">
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.id}">${r.roleName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="custom-input-group" id="editWarehouseGroup">
                        <label>Warehouse</label>
                        <select name="warehouseId" id="editWarehouseId">
                            <option value="0">-- No Warehouse --</option>
                            <c:forEach var="w" items="${listWarehouse}">
                                <option value="${w.id}">${w.warehouseName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="custom-modal-buttons">
                        <button type="button" onclick="closeEditUserModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="customDeleteUserModal" class="custom-modal" style="display:none;">
            <div class="custom-modal-content">
                <h3>Confirm Delete</h3>
                <p>Delete user <strong id="deleteUserName"></strong>?</p>
                <form method="post" action="deleteuser">
                    <input type="hidden" name="userId" id="deleteUserId">
                    <input type="hidden" name="page" id="deletePage">
                    <input type="hidden" name="keyword" id="deleteKeyword">
                    <div class="custom-modal-buttons">
                        <button type="button" onclick="closeDeleteUserModal()">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

        <script>
            function openUserChangePasswordModal(id, page, code, kw) {
                document.getElementById("customChangePasswordUserId").value = id;
                document.getElementById("changePasswordPage").value = page;
                document.getElementById("changePasswordKeyword").value = kw;
                document.getElementById("changePasswordTitle").innerText = "Reset Password - " + code;
                document.getElementById("customChangePasswordModal").style.display = "flex";
            }
            function closeUserChangePasswordModal() { document.getElementById("customChangePasswordModal").style.display = "none"; }

            function openEditModel(id, code, name, user, male, dob, email, phone, roleId, page, kw, whId) {
                document.getElementById("editUserId").value = id;
                document.getElementById("editUserCode").value = code;
                document.getElementById("editFullName").value = name;
                document.getElementById("editUserName").value = user;
                document.getElementById("editMale").value = male;
                document.getElementById("editDateOfBirth").value = dob;
                document.getElementById("editEmail").value = email;
                document.getElementById("editPhone").value = phone;
                document.getElementById("editRoleId").value = roleId;
                document.getElementById("editPage").value = page;
                document.getElementById("editKeyword").value = kw;
                document.getElementById("editWarehouseId").value = whId;
                
                // Logic ẩn hiện kho nếu cần (Ví dụ role 2 hoặc 4)
                document.getElementById("editWarehouseGroup").style.display = (id == "1" || roleId == "4") ? "block" : "none";
                document.getElementById("customEditUserModal").style.display = "flex";
            }
            function closeEditUserModal() { document.getElementById("customEditUserModal").style.display = "none"; }

            function confirmDelete(id, name, page, kw) {
                document.getElementById("deleteUserId").value = id;
                document.getElementById("deleteUserName").innerText = name;
                document.getElementById("deletePage").value = page;
                document.getElementById("deleteKeyword").value = kw;
                document.getElementById("customDeleteUserModal").style.display = "flex";
            }
            function closeDeleteUserModal() { document.getElementById("customDeleteUserModal").style.display = "none"; }
        </script>
    </body>
</html>