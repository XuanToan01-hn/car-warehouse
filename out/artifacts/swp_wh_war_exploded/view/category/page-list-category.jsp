<%-- 
    Document   : page-list-category
    Created on : May 20, 2025, 2:45:24 PM
    Author     : Nhat
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:out value="${listCategory}" default="listCategory is null hoặc rỗng"/><br>

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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">  </head>
    <body class="  ">
        <!-- loader Start -->
        <div id="loading">
            <div id="loading-center">
            </div>
        </div>
        <!-- loader END -->
        <!-- Wrapper Start -->
        <div class="wrapper">

            <%@ include file="../sidebar.jsp" %>
                                                            
            <div class="content-page">
                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4>Category List</h4>
                        <a href="${pageContext.request.contextPath}/add-category" class="btn btn-primary">Add Category</a>
                    </div>

                    <form method="get" action="list-category" class="form-inline mb-3">
                        <input type="text" name="search" class="form-control mr-2" placeholder="Search by name..." value="${fn:escapeXml(search)}" />
                        <button type="submit" class="btn btn-primary">Search</button>
                    </form>

                    <div class="table-responsive">
                        <c:if test="${not empty sessionScope.msg}">
                            <div class="alert alert-info">${sessionScope.msg}</div>
                            <c:remove var="msg" scope="session" />
                        </c:if>

                        <table class="table table-bordered">
                            <thead class="thead-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${categoryList}">
                                    <tr>
                                        <td>${c.id}</td>
                                        <td>${c.name}</td>
                                        <td>${c.description}</td>
                                        <td>
                                            <a href="edit-category?id=${c.id}" class="btn btn-sm btn-success">Edit</a>
                                            <a  href="javascript:void(0);" onclick="confirmDelete(${c.id})"
                                                class="btn btn-sm btn-danger" style="background-color: #FE9369;">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty categoryList}">
                                    <tr>
                                        <td colspan="4" class="text-center text-danger">No category records found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>

                        <nav class="mt-3">
                            <ul class="pagination justify-content-center">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <c:url var="pageUrl" value="list-category">
                                        <c:param name="page" value="${i}" />
                                        <c:param name="search" value="${search}" />
                                    </c:url>
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="${pageUrl}">${i}</a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>

            <script>
                function confirmDelete(id) {
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "This action cannot be undone!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Yes, delete it!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = 'delete-category?id=' + id;
                        }
                    });
                }

            </script>

        </footer>
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
</body>
</html>