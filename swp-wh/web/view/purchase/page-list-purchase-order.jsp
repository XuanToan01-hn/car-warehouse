<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Danh Sách Purchase Order</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">
</head>
<body>
<div id="loading"><div id="loading-center"></div></div>
<div class="wrapper">
    <%@ include file="../sidebar.jsp" %>
    <%@ include file="../header.jsp" %>
    <div class="content-page">
        <div class="container-fluid">
            <div class="row">
                <div class="col-sm-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div class="header-title">
                                <h4 class="card-title">Danh Sách Purchase Order</h4>
                            </div>
                            <a href="${pageContext.request.contextPath}/add-purchase-order"
                               class="btn btn-primary" style="background-color:#17AEDF">
                                <i class="fas fa-plus mr-1"></i> Tạo PO Mới
                            </a>
                        </div>
                        <div class="card-body">
                            <!-- Thông báo thành công -->
                            <c:if test="${param.success == 'created'}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <strong>Thành công!</strong> Purchase Order đã được tạo.
                                    <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                                </div>
                            </c:if>

                            <!-- Form tìm kiếm & filter -->
                            <form method="get" action="${pageContext.request.contextPath}/purchase-orders" class="mb-3">
                                <div class="row">
                                    <div class="col-md-5">
                                        <input type="text" name="search" class="form-control"
                                               placeholder="Tìm theo mã đơn, supplier..."
                                               value="${search}">
                                    </div>
                                    <div class="col-md-3">
                                        <select name="status" class="form-control">
                                            <option value="0" ${statusFilter == 0 ? 'selected' : ''}>-- Tất cả trạng thái --</option>
                                            <option value="1" ${statusFilter == 1 ? 'selected' : ''}>Draft</option>
                                            <option value="2" ${statusFilter == 2 ? 'selected' : ''}>Confirmed</option>
                                            <option value="3" ${statusFilter == 3 ? 'selected' : ''}>Received</option>
                                            <option value="4" ${statusFilter == 4 ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary w-100" style="background-color:#17AEDF">
                                            <i class="fas fa-search"></i> Tìm
                                        </button>
                                    </div>
                                    <div class="col-md-2">
                                        <a href="${pageContext.request.contextPath}/purchase-orders" class="btn btn-secondary w-100">
                                            <i class="fas fa-redo"></i> Reset
                                        </a>
                                    </div>
                                </div>
                            </form>

                            <!-- Bảng danh sách -->
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover" id="poTable">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Mã Đơn</th>
                                            <th>Supplier</th>
                                            <th>Ngày Tạo</th>
                                            <th>Trạng Thái</th>
                                            <th>Tổng Tiền</th>
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="po" items="${poList}" varStatus="st">
                                            <tr>
                                                <td>${(currentPage - 1) * 8 + st.index + 1}</td>
                                                <td><strong>${po.orderCode}</strong></td>
                                                <td>${po.supplier.name}</td>
                                                <td>
                                                    <fmt:formatDate value="${po.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${po.status == 1}">
                                                            <span class="badge badge-warning">Draft</span>
                                                        </c:when>
                                                        <c:when test="${po.status == 2}">
                                                            <span class="badge badge-primary">Confirmed</span>
                                                        </c:when>
                                                        <c:when test="${po.status == 3}">
                                                            <span class="badge badge-success">Received</span>
                                                        </c:when>
                                                        <c:when test="${po.status == 4}">
                                                            <span class="badge badge-danger">Cancelled</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${po.totalAmount}" type="number" groupingUsed="true"/> đ
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/detail-purchase-order?id=${po.id}"
                                                       class="btn btn-sm btn-info">
                                                        <i class="fas fa-eye"></i> Chi tiết
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty poList}">
                                            <tr>
                                                <td colspan="7" class="text-center text-muted py-4">
                                                    <i class="fas fa-inbox fa-2x mb-2"></i><br>
                                                    Không có Purchase Order nào
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Phân trang -->
                            <c:if test="${totalPages > 1}">
                                <nav>
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?search=${search}&status=${statusFilter}&page=${currentPage - 1}">
                                                &laquo;
                                            </a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?search=${search}&status=${statusFilter}&page=${p}">${p}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="?search=${search}&status=${statusFilter}&page=${currentPage + 1}">
                                                &raquo;
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<footer class="iq-footer">
    <div class="container-fluid">
        <div class="card"><div class="card-body">
            <div class="row">
                <div class="col-lg-6">
                    <ul class="list-inline mb-0">
                        <li class="list-inline-item"><a href="#">Privacy Policy</a></li>
                        <li class="list-inline-item"><a href="#">Terms of Use</a></li>
                    </ul>
                </div>
                <div class="col-lg-6 text-right">
                    <span class="mr-1"><script>document.write(new Date().getFullYear())</script>©</span>
                    <a href="#" class="">POS Dash</a>.
                </div>
            </div>
        </div></div>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
<script async src="${pageContext.request.contextPath}/assets/js/chart-custom.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
