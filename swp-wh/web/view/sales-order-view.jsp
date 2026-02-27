<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Chi Tiết Sales Order</title>
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
                        <!-- Header card -->
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <div class="header-title">
                                    <h4 class="card-title">Chi Tiết Sales Order:
                                        <strong>${order.orderCode}</strong>
                                    </h4>
                                </div>
                                <a href="${pageContext.request.contextPath}/sales-order?action=list" class="btn btn-secondary">
                                    Quay lại
                                </a>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <table class="table table-borderless">
                                            <tr>
                                                <td class="font-weight-bold" width="40%">Mã đơn hàng:</td>
                                                <td>${order.orderCode}</td>
                                            </tr>
                                            <tr>
                                                <td class="font-weight-bold">Khách hàng:</td>
                                                <td>
                                                    <strong>${order.customer.name}</strong>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="font-weight-bold">Ngày tạo:</td>
                                                <td>
                                                    <fmt:formatDate value="${order.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    <div class="col-md-6">
                                        <table class="table table-borderless">
                                            <tr>
                                                <td class="font-weight-bold" width="40%">Tổng tiền:</td>
                                                <td class="h5 text-primary">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" /> đ
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="font-weight-bold">Ghi chú:</td>
                                                <td>${order.note != null && order.note != '' ? order.note : "Không có ghi chú"}</td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">&nbsp;</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Chi tiết sản phẩm -->
                        <div class="card mt-3">
                            <div class="card-header">
                                <h5 class="card-title mb-0"><i class="fas fa-list mr-2"></i>Chi Tiết Sản Phẩm</h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>#</th>
                                                <th>Tên Sản Phẩm</th>
                                                <th>Màu sắc</th>
                                                <th>Số Lot</th>
                                                <th>Serial Number</th>
                                                <th>Ngày Sản Xuất</th>
                                                <th>Số Lượng</th>
                                                <th>Đơn Giá</th>
                                                <th>Thành Tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${order.details}" var="d" varStatus="st">
                                                <tr>
                                                    <td>${st.index + 1}</td>
                                                    <td>${d.productDetail.product.name}</td>
                                                    <td>
                                                        <span class="badge badge-info">
                                                            ${d.productDetail.color != null ? d.productDetail.color : 'N/A'}
                                                        </span>
                                                    </td>
                                                    <td>${d.productDetail.lotNumber != null ? d.productDetail.lotNumber : '—'}</td>
                                                    <td>${d.productDetail.serialNumber != null ? d.productDetail.serialNumber : '—'}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${d.productDetail.manufactureDate != null}">
                                                                <fmt:formatDate value="${d.productDetail.manufactureDate}" pattern="dd/MM/yyyy" />
                                                            </c:when>
                                                            <c:otherwise>—</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-center">${d.quantity}</td>
                                                    <td class="text-right">
                                                        <fmt:formatNumber value="${d.price}" type="number" groupingUsed="true" /> đ
                                                    </td>
                                                    <td class="text-right font-weight-bold">
                                                        <fmt:formatNumber value="${d.subTotal}" type="number" groupingUsed="true" /> đ
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                        <tfoot>
                                            <tr class="table-warning">
                                                <td colspan="8" class="text-right font-weight-bold">TỔNG CỘNG:</td>
                                                <td class="text-right font-weight-bold text-primary h5">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true" /> đ
                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </div>
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
    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
    <script async src="${pageContext.request.contextPath}/assets/js/chart-custom.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>

</html>