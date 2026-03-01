<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>

    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">
</head>

<body>
    <div id="loading">
        <div id="loading-center"></div>
    </div>
    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>
        <%@ include file="header.jsp" %>
        <div class="content-page">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <div class="header-title">
                                    <h4 class="card-title">Danh Sách Sales Order</h4>
                                </div>
                                <a href="${pageContext.request.contextPath}/sales-order?action=create" class="btn btn-primary">
<%--                                    <i class="fas fa-plus mr-1"></i> --%>
                                    Tạo Đơn Hàng Mới
                                </a>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>Mã Đơn</th>
                                                <th>Khách Hàng</th>
                                                <th>Ngày Tạo</th>
                                                <th>SL Đặt / Giao</th>
                                                <th>Trạng Thái</th>
                                                <th class="text-right">Hành Động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="o" items="${orders}">
                                                <tr>
                                                    <td>
                                                        <span class="font-weight-bold text-primary">${o.orderCode}</span>
                                                    </td>
                                                    <td>
                                                        <span class="font-weight-bold">${o.customer.name}</span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${o.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                                    </td>
                                                    <td>
                                                        <span class="text-primary font-weight-bold">${o.orderedQty}</span>
                                                        /
                                                        <span class="text-success font-weight-bold">${o.deliveredQty}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${o.status == 1}">
                                                                <span class="badge badge-info">Created</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 2}">
                                                                <span class="badge badge-warning">Partially Delivered</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 3}">
                                                                <span class="badge badge-success">Completed</span>
                                                            </c:when>
                                                            <c:when test="${o.status == 4}">
                                                                <span class="badge badge-danger">Cancelled</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-right">
                                                        <a href="${pageContext.request.contextPath}/sales-order?action=view&id=${o.id}" class="btn btn-sm btn-info mr-2">
<%--                                                            <i class="fas fa-eye mr-1"></i>--%>
                                                            Xem
                                                        </a>
                                                        <c:if test="${o.status == 1}">
                                                            <form action="${pageContext.request.contextPath}/sales-order" method="post" style="display:inline-block;">
                                                                <input type="hidden" name="action" value="cancel">
                                                                <input type="hidden" name="id" value="${o.id}">
                                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                                                                    <i class="fas fa-times mr-1"></i> Hủy
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>

</html>
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
    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
    <script async src="${pageContext.request.contextPath}/assets/js/chart-custom.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>

</html>
