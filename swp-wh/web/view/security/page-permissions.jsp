<%-- 
    Document   : page-permissions
    Created on : Mar 28, 2026, 2:51:49 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>POS Dash | Responsive Bootstrap 4 Admin Dashboard Template</title>

        <!-- Favicon -->
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customerManagement.css">
        <style>
            /* --- Form Elements --- */
            .form-section {
                margin-bottom: 30px;
            }

            .form-label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #495057;
            }

            .form-select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ced4da;
                border-radius: 8px;
                background-color: #fff;
                font-size: 16px;
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
            }

            .form-select:focus {
                outline: none;
                border-color: #0d6efd;
                box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.25);
            }

            /* --- Permissions Grid --- */
            .permissions-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
                gap: 25px;
            }

            /* --- Permission Group Card --- */
            .permission-group {
                border: 1px solid #e9ecef;
                border-radius: 10px;
                padding: 20px;
                background-color: #fff;
                transition: box-shadow 0.3s ease;
            }

            .permission-group:hover {
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .group-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #dee2e6;
                padding-bottom: 15px;
                margin-bottom: 15px;
            }

            .group-header h3 {
                margin: 0;
                font-size: 18px;
                font-weight: 700;
                color: #0d6efd;
            }

            .permission-list {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .permission-item .description {
                font-size: 13px;
                color: #6c757d;
                margin-left: 24px; /* Align with checkbox text */
            }

            /* --- Custom Checkbox --- */
            .form-check {
                display: flex;
                align-items: center;
            }

            .form-check-input {
                width: 18px;
                height: 18px;
                margin-right: 10px;
                cursor: pointer;
            }

            .form-check-label {
                font-weight: 500;
                cursor: pointer;
            }

            .group-header .form-check-label {
                font-size: 14px;
                font-weight: 500;
                color: #495057;
            }


            /* --- Action Button --- */
            .action-area {
                text-align: right;
                margin-top: 30px;
            }

            .btn-save {
                background-color: #0d6efd;
                color: white;
                border: none;
                padding: 12px 25px;
                font-size: 16px;
                font-weight: 500;
                border-radius: 8px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .btn-save:hover {
                background-color: #0b5ed7;
            }

            /* --- Empty State --- */
            .empty-state {
                text-align: center;
                padding: 40px;
                border: 2px dashed #ced4da;
                border-radius: 10px;
                color: #6c757d;
            }

        </style>
    </head>

    <body class=" color-light ">
        <!-- Wrapper Start -->
        <div class="wrapper">

            <%@ include file="../sidebar.jsp" %>

            <div class="content-page">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12">
                            <h1>Permissions</h1>
                            <form id="roleSelectionForm" action="permissions" method="POST">
                                <div class="form-section">
                                    <label for="roleSelect" class="form-label">Select a role to manage permissions:</label>
                                    <select id="roleSelect" name="roleId" class="form-select" onchange="this.form.submit()">
                                        <option value="0">-- Please select a role --</option>
                                        <c:forEach var="r" items="${requestScope.listRole}">
                                            <option value="${r.id}" ${r.id == requestScope.selectedRoleId ? 'selected' : ''}>
                                                ${r.roleName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </form>
                            <c:if test="${not empty requestScope.selectedRoleId && requestScope.selectedRoleId != 0}">
                                <form action="update-permissions" method="POST">
                                    <input type="hidden" name="roleId" value="${requestScope.selectedRoleId}">
                                    <div class="permissions-section">
                                        <div class="permissions-grid">
                                            <c:forEach var="pg" items="${requestScope.listPermissionGroup}">
                                                <div class="permission-group">
                                                    <div class="group-header">
                                                        <h3>${pg.groupName}</h3>
                                                        <!--                                                        <div class="form-check">
                                                                                                                    <input class="form-check-input" type="checkbox" id="selectAll-1">
                                                                                                                    <label class="form-check-label" for="selectAll-1">Select All</label>
                                                                                                                </div>-->
                                                    </div>

                                                    <div class="permission-list">
                                                        <c:forEach items="${pg.listPermissions}" var="p">

                                                            <div class="permission-item">
                                                                <div class="form-check">

                                                                    <input class="form-check-input permission-checkbox" type="checkbox" name="permissionId" value="${p.id}" ${rolePermissionIds.contains(p.id) ? 'checked' : ''}>

                                                                    <label class="form-check-label" for="perm-1">${p.name}</label>
                                                                </div>
                                                                <div class="description">${p.description}</div>
                                                            </div>

                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div class="action-area" style="margin-bottom: 70px;">
                                            <button type="submit" class="btn-save">Save change.</button>
                                        </div>
                                    </div>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${sessionScope.toast == false}">
                        <div id="errorToast" class="toast-message alert alert-error" >
                            <strong>Error!</strong> ${sessionScope.message}
                        </div>
                        <c:remove var="toast" scope="session" />
                        <c:remove var="message" scope="session" />
                    </c:when>
                    <c:when test="${sessionScope.toast == true}">
                        <div id="successToast" class="toast-message alert alert-success">
                            <strong>Success!</strong> ${sessionScope.message}
                        </div>
                        <c:remove var="toast" scope="session" />
                        <c:remove var="message" scope="session" />
                    </c:when>
                </c:choose>


            </div>

        </div>
        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>                                                    
        <script src="${pageContext.request.contextPath}/assets/js/sales-order.js"></script>
    </body>

</html>
