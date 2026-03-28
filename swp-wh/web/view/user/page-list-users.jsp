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

        <style>
            input[readonly] {
                background-color: #e9ecef !important;
                cursor: not-allowed;
                border: 1px solid #ced4da;
            }
            .actions-group {
                white-space: nowrap;
            }
            .badge-success {
                background-color: #28a745;
                color: white;
            }
            .badge-danger {
                background-color: #dc3545;
                color: white;
            }
            .font-weight-bold {
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div id="loading"><div id="loading-center"></div></div>
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>
            <jsp:include page="../header.jsp" />

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
                                                <input type="text" name="keyword" value="${keyword}" class="search-input-custom" placeholder="Search by name, email, phone...">
                                                <button type="submit" class="search-btn-inside" title="Search">🔎</button>
                                            </div>

                                            <select name="roleId" onchange="this.form.submit()" class="search-select-custom">
                                                <option value="">-- All Roles --</option>
                                                <c:forEach var="r" items="${roles}">
                                                    <option value="${r.id}" ${roleId == r.id ? 'selected' : ''}>${r.roleName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </form>
                                </div>

                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger">${error}</div>
                                </c:if>
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success">${success}</div>
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
                                            <th>Code</th>
                                            <th>Username</th>
                                            <th>Gender</th>
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
                                                <td>${u.email}</td>
                                                <td>${u.phone}</td>
                                                <td>${u.role.roleName}</td>
                                                <td class="actions-group">
                                                    <a href="javascript:void(0);" class="action-link text-primary" 
                                                       onclick="openUserChangePasswordModal('${u.id}', '${currentPage}', '${u.userCode}', '${keyword}')">Reset</a> |
                                                    <a href="javascript:void(0);" class="action-link text-primary" 
                                                       onclick="openEditModel('${u.id}', '${u.userCode}', '${u.fullName}', '${u.username}', '${u.male}', '${u.dateOfBirth}', '${u.email}', '${u.phone}', '${u.role.id}', '${currentPage}', '${keyword}', '${u.warehouse != null ? u.warehouse.id : 0}')">Edit</a> |

                                                    <c:choose>
                                                        <c:when test="${u.isActive}">
                                                            <a href="javascript:void(0);" class="text-danger font-weight-bold" 
                                                               onclick="confirmToggleStatus('${u.id}', '${u.fullName}', 0, '${currentPage}', '${keyword}')">Deactivate</a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="javascript:void(0);" class="text-success font-weight-bold" 
                                                               onclick="confirmToggleStatus('${u.id}', '${u.fullName}', 1, '${currentPage}', '${keyword}')">Activate</a>
                                                        </c:otherwise>
                                                    </c:choose>
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
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="customEditUserModal" class="custom-modal" style="display:none;">
            <div class="custom-modal-content">
                <h3>Edit User Profile</h3>
                <form method="post" action="update-user">
                    <input type="hidden" name="userId" id="editUserId">
                    <input type="hidden" name="page" id="editPage">
                    <input type="hidden" name="keyword" id="editKeyword">

                    <div class="custom-input-group"><label>Full Name</label><input type="text" name="fullName" id="editFullName" required></div>
                    <div class="custom-input-group">
                        <label>Gender</label>
                        <select name="male" id="editMale">
                            <option value="1">Male</option>
                            <option value="0">Female</option>
                        </select>
                    </div>
                    <div class="custom-input-group"><label>Date of Birth</label><input type="date" name="dateOfBirth" id="editDateOfBirth"></div>
                    <div class="custom-input-group"><label>Email Address</label><input type="email" name="email" id="editEmail" required></div>
                    <div class="custom-input-group"><label>Phone Number</label><input type="text" name="phone" id="editPhone" required></div>
                    <div class="custom-input-group">
                        <label>Role</label>
                        <select name="roleId" id="editRoleId" onchange="toggleWarehouseEdit()">
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.id}">${r.roleName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="custom-input-group" id="editWarehouseGroup">
                        <label>Assigned Warehouse</label>
                        <select name="warehouseId" id="editWarehouseId">
                            <option value="0">-- No Warehouse --</option>
                            <c:forEach var="w" items="${listWarehouse}">
                                <option value="${w.id}">${w.warehouseName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="custom-modal-buttons">
                        <button type="button" onclick="closeEditUserModal()">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update User</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="customStatusModal" class="custom-modal" style="display:none;">
            <div class="custom-modal-content">
                <h3 id="statusModalTitle">Confirm Status Change</h3>
                <p id="statusModalMessage"></p>
                <form method="post" action="deleteuser">
                    <input type="hidden" name="userId" id="statusUserId">
                    <input type="hidden" name="status" id="statusValue">
                    <input type="hidden" name="page" id="statusPage">
                    <input type="hidden" name="keyword" id="statusKeyword">
                    <div class="custom-modal-buttons">
                        <button type="button" onclick="closeStatusModal()">Cancel</button>
                        <button type="submit" id="statusSubmitBtn" class="btn">Confirm</button>
                    </div>
                </form>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

        <script>
                            // --- Password Modal ---
                            function openUserChangePasswordModal(id, page, code, kw) {
                                document.getElementById("customChangePasswordUserId").value = id;
                                document.getElementById("changePasswordPage").value = page;
                                document.getElementById("changePasswordKeyword").value = kw;
                                document.getElementById("changePasswordTitle").innerText = "Reset Password: " + code;
                                document.getElementById("customChangePasswordModal").style.display = "flex";
                            }
                            function closeUserChangePasswordModal() {
                                document.getElementById("customChangePasswordModal").style.display = "none";
                            }

                            // --- Edit Modal ---
                            function toggleWarehouseEdit() {
                                const roleId = document.getElementById("editRoleId").value;
                                const warehouseGroup = document.getElementById("editWarehouseGroup");
                                if (roleId == "3" || roleId == "4" || roleId == "5") {
                                    warehouseGroup.style.display = "block";
                                } else {
                                    warehouseGroup.style.display = "none";
                                    document.getElementById("editWarehouseId").value = "0";
                                }
                            }

                            function openEditModel(id, code, name, user, male, dob, email, phone, roleId, page, kw, whId) {
                                document.getElementById("editUserId").value = id;
                                document.getElementById("editFullName").value = name;
                                document.getElementById("editMale").value = male;
                                document.getElementById("editDateOfBirth").value = dob;
                                document.getElementById("editEmail").value = email;
                                document.getElementById("editPhone").value = phone;
                                document.getElementById("editRoleId").value = roleId;
                                document.getElementById("editPage").value = page;
                                document.getElementById("editKeyword").value = kw;
                                document.getElementById("editWarehouseId").value = (whId && whId !== 'null' && whId !== '0') ? whId : "0";
                                toggleWarehouseEdit();
                                document.getElementById("customEditUserModal").style.display = "flex";
                            }
                            function closeEditUserModal() {
                                document.getElementById("customEditUserModal").style.display = "none";
                            }

function confirmToggleStatus(id, name, targetStatus, page, kw) {
    document.getElementById("statusUserId").value = id;
    document.getElementById("statusValue").value = targetStatus;
    document.getElementById("statusPage").value = page;
    document.getElementById("statusKeyword").value = kw;

    const title = document.getElementById("statusModalTitle");
    const msg = document.getElementById("statusModalMessage");
    const btn = document.getElementById("statusSubmitBtn");

    if (targetStatus === 1) { // Logic sửa lại tại đây
        title.innerText = "Activate Account";
        title.style.color = "#28a745";
        msg.innerHTML = "Are you sure you want to <b>Activate</b> account for <b>" + name + "</b>?";
        btn.innerText = "Activate Now";
        btn.className = "btn btn-success";
    } else {
        title.innerText = "Deactivate Account";
        title.style.color = "#dc3545";
        msg.innerHTML = "Are you sure you want to <b>Deactivate</b> account for <b>" + name + "</b>?<br>This user will no longer be able to login.";
        btn.innerText = "Deactivate Now";
        btn.className = "btn btn-danger";
    }
    document.getElementById("customStatusModal").style.display = "flex";
}
        </script>
    </body>
</html>