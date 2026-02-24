<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!doctype html>
            <html lang="vi">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Chi Tiết Purchase Order</title>
                <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">
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
                                    <div class="col-sm-12">
                                        <!-- Header card -->
                                        <div class="card">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <div class="header-title">
                                                    <h4 class="card-title">Chi Tiết Purchase Order:
                                                        <strong>${po.orderCode}</strong>
                                                    </h4>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/purchase-orders"
                                                    class="btn btn-secondary">
                                                    <i class="fas fa-arrow-left mr-1"></i> Quay lại
                                                </a>
                                            </div>
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <table class="table table-borderless">
                                                            <tr>
                                                                <td class="font-weight-bold" width="40%">Mã đơn hàng:
                                                                </td>
                                                                <td>${po.orderCode}</td>
                                                            </tr>
                                                            <tr>
                                                                <td class="font-weight-bold">Supplier:</td>
                                                                <td>
                                                                    <strong>${po.supplier.name}</strong><br>
                                                                    <small class="text-muted">
                                                                        <i
                                                                            class="fas fa-phone mr-1"></i>${po.supplier.phone}
                                                                        &nbsp;|&nbsp;
                                                                        <i
                                                                            class="fas fa-envelope mr-1"></i>${po.supplier.email}
                                                                    </small>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="font-weight-bold">Ngày tạo:</td>
                                                                <td>
                                                                    <fmt:formatDate value="${po.createdDate}"
                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <table class="table table-borderless">
                                                            <tr>
                                                                <td class="font-weight-bold" width="40%">Trạng thái:
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${po.status == 1}"><span
                                                                                class="badge badge-warning badge-lg">Draft</span>
                                                                        </c:when>
                                                                        <c:when test="${po.status == 2}"><span
                                                                                class="badge badge-primary badge-lg">Confirmed</span>
                                                                        </c:when>
                                                                        <c:when test="${po.status == 3}"><span
                                                                                class="badge badge-success badge-lg">Received</span>
                                                                        </c:when>
                                                                        <c:when test="${po.status == 4}"><span
                                                                                class="badge badge-danger badge-lg">Cancelled</span>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="font-weight-bold">Tổng tiền:</td>
                                                                <td class="h5 text-primary">
                                                                    <fmt:formatNumber value="${po.totalAmount}"
                                                                        type="number" groupingUsed="true" /> đ
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="font-weight-bold">Địa chỉ supplier:</td>
                                                                <td>${po.supplier.address}</td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>

                                                <!-- Nút thay đổi trạng thái -->
                                                <c:if test="${po.status != 4}">
                                                    <div class="border-top pt-3 mt-2">
                                                        <strong class="mr-2">Cập nhật trạng thái:</strong>
                                                        <c:if test="${po.status == 1}">
                                                            <form
                                                                action="${pageContext.request.contextPath}/detail-purchase-order"
                                                                method="post" class="d-inline">
                                                                <input type="hidden" name="id" value="${po.id}">
                                                                <input type="hidden" name="status" value="2">
                                                                <button type="submit" class="btn btn-primary mr-2">
                                                                    <i class="fas fa-check mr-1"></i> Confirm
                                                                </button>
                                                            </form>
                                                            <form
                                                                action="${pageContext.request.contextPath}/detail-purchase-order"
                                                                method="post" class="d-inline">
                                                                <input type="hidden" name="id" value="${po.id}">
                                                                <input type="hidden" name="status" value="4">
                                                                <button type="submit" class="btn btn-danger">
                                                                    <i class="fas fa-times mr-1"></i> Cancel
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                        <c:if test="${po.status == 2}">
                                                            <form
                                                                action="${pageContext.request.contextPath}/detail-purchase-order"
                                                                method="post" class="d-inline">
                                                                <input type="hidden" name="id" value="${po.id}">
                                                                <input type="hidden" name="status" value="3">
                                                                <button type="submit" class="btn btn-success mr-2">
                                                                    <i class="fas fa-truck mr-1"></i> Mark Received
                                                                </button>
                                                            </form>
                                                            <form
                                                                action="${pageContext.request.contextPath}/detail-purchase-order"
                                                                method="post" class="d-inline">
                                                                <input type="hidden" name="id" value="${po.id}">
                                                                <input type="hidden" name="status" value="4">
                                                                <button type="submit" class="btn btn-danger">
                                                                    <i class="fas fa-times mr-1"></i> Cancel
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>

                                        <!-- Chi tiết sản phẩm -->
                                        <div class="card mt-3">
                                            <div class="card-header">
                                                <h5 class="card-title mb-0"><i class="fas fa-list mr-2"></i>Chi Tiết Sản
                                                    Phẩm</h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="table-responsive">
                                                    <table class="table table-bordered table-hover">
                                                        <thead class="thead-light">
                                                            <tr>
                                                                <th>#</th>
                                                                <th>Mã SP</th>
                                                                <th>Tên Sản Phẩm</th>
                                                                <th>Số Lượng</th>
                                                                <th>Đơn Giá</th>
                                                                <th>Thuế</th>
                                                                <th>Thành Tiền</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="d" items="${po.details}" varStatus="st">
                                                                <tr>
                                                                    <td>${st.index + 1}</td>
                                                                    <td><code>${d.product.code}</code></td>
                                                                    <td>${d.product.name}</td>
                                                                    <td class="text-center">${d.quantity}</td>
                                                                    <td class="text-right">
                                                                        <fmt:formatNumber value="${d.price}"
                                                                            type="number" groupingUsed="true" /> đ
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${d.tax != null}">
                                                                                ${d.tax.taxName} (
                                                                                <fmt:formatNumber
                                                                                    value="${d.tax.taxRate}"
                                                                                    type="number" />%)
                                                                            </c:when>
                                                                            <c:otherwise><span
                                                                                    class="text-muted">—</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-right font-weight-bold">
                                                                        <fmt:formatNumber value="${d.subTotal}"
                                                                            type="number" groupingUsed="true" /> đ
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                        <tfoot>
                                                            <tr class="table-warning">
                                                                <td colspan="6" class="text-right font-weight-bold">TỔNG
                                                                    CỘNG:</td>
                                                                <td class="text-right font-weight-bold text-primary h5">
                                                                    <fmt:formatNumber value="${po.totalAmount}"
                                                                        type="number" groupingUsed="true" /> đ
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