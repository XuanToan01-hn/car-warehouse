<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!doctype html>
            <html lang="vi">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Chi Tiết Goods Receipt</title>
                <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">
                <style>
                    .info-label {
                        font-weight: 600;
                        color: #495057;
                    }

                    .badge-lg {
                        font-size: 0.9rem;
                        padding: 6px 14px;
                    }

                    .diff-ok {
                        color: #28a745;
                        font-weight: bold;
                    }

                    .diff-warn {
                        color: #dc3545;
                        font-weight: bold;
                    }

                    .summary-card {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: #fff;
                        border-radius: 8px;
                        padding: 20px;
                    }
                </style>
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
                                                    <h4 class="card-title">
                                                        <i class="fas fa-clipboard-check mr-2 text-success"></i>
                                                        Chi Tiết Goods Receipt: <strong>${gr.receiptCode}</strong>
                                                    </h4>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/goods-receipt"
                                                    class="btn btn-secondary">
                                                    <i class="fas fa-arrow-left mr-1"></i> Quay lại
                                                </a>
                                            </div>
                                            <div class="card-body">
                                                <div class="row">
                                                    <!-- Left column -->
                                                    <div class="col-md-6">
                                                        <table class="table table-borderless">
                                                            <tr>
                                                                <td class="info-label" width="40%">Mã GRO:</td>
                                                                <td><strong
                                                                        class="text-primary">${gr.receiptCode}</strong>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="info-label">Purchase Order:</td>
                                                                <td>
                                                                    <a
                                                                        href="${pageContext.request.contextPath}/detail-purchase-order?id=${gr.purchaseOrder.id}">
                                                                        <code>${gr.purchaseOrder.orderCode}</code>
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="info-label">Ngày Nhập:</td>
                                                                <td>
                                                                    <fmt:formatDate value="${gr.receiptDate}"
                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <!-- Right column -->
                                                    <div class="col-md-6">
                                                        <table class="table table-borderless">
                                                            <tr>
                                                                <td class="info-label" width="40%">Trạng Thái:</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${gr.status == 1}">
                                                                            <span class="badge badge-warning badge-lg">Draft</span>
                                                                        </c:when>
                                                                        <c:when test="${gr.status == 2}">
                                                                            <span class="badge badge-success badge-lg">
                                                                                <i class="fas fa-check mr-1"></i>Completed
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${gr.status == 3}">
                                                                            <span class="badge badge-danger badge-lg">Cancelled</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge badge-secondary badge-lg">${gr.status}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="info-label">Location:</td>
                                                                <td>${gr.location.locationName}</td>
                                                            </tr>
                                                            <tr>
                                                                <td class="info-label">Ghi Chú:</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty gr.note}">${gr.note}
                                                                        </c:when>
                                                                        <c:otherwise><span class="text-muted">—</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Product details card -->
                                        <div class="card mt-3">
                                            <div class="card-header">
                                                <h5 class="card-title mb-0"><i class="fas fa-boxes mr-2"></i>Chi Tiết
                                                    Sản Phẩm Nhập Kho</h5>
                                            </div>
                                            <div class="card-body">
                                                <c:choose>
                                                    <c:when test="${gr.status == 1}">
                                                        <form method="post" action="${pageContext.request.contextPath}/confirm-goods-receipt">
                                                            <input type="hidden" name="receiptId" value="${gr.id}" />
                                                            <div class="table-responsive">
                                                                <table class="table table-bordered table-hover">
                                                                    <thead class="thead-dark">
                                                                        <tr>
                                                                            <th>#</th>
                                                                            <th>Mã SP</th>
                                                                            <th>Tên Sản Phẩm</th>
                                                                            <th class="text-center">SL Kỳ Vọng</th>
                                                                            <th class="text-center">SL Thực Tế</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:forEach var="d" items="${gr.details}" varStatus="st">
                                                                            <tr>
                                                                                <td>${st.index + 1}</td>
                                                                                <td><code>${d.product.code}</code></td>
                                                                                <td>${d.product.name}</td>
                                                                                <td class="text-center">${d.quantityExpected}</td>
                                                                                <td class="text-center">
                                                                                    <input type="number"
                                                                                           name="qtyActual[]"
                                                                                           class="form-control text-center"
                                                                                           min="0"
                                                                                           value="${d.quantityActual}"
                                                                                           style="width:100px;margin:auto;" />
                                                                                    <input type="hidden" name="detailId[]" value="${d.id}" />
                                                                                </td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                        <c:if test="${empty gr.details}">
                                                                            <tr>
                                                                                <td colspan="5" class="text-center text-muted py-4">
                                                                                    Không có chi tiết sản phẩm
                                                                                </td>
                                                                            </tr>
                                                                        </c:if>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                            <div class="d-flex justify-content-between mt-3">
                                                                <button type="submit" class="btn btn-success">
                                                                    <i class="fas fa-check mr-1"></i> Xác Nhận Nhập Kho
                                                                </button>
                                                                <button type="submit" name="action" value="cancel"
                                                                        class="btn btn-danger"
                                                                        onclick="return confirm('Bạn có chắc muốn hủy phiếu này?');">
                                                                    <i class="fas fa-times mr-1"></i> Hủy Phiếu
                                                                </button>
                                                            </div>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="table-responsive">
                                                            <table class="table table-bordered table-hover">
                                                                <thead class="thead-dark">
                                                                    <tr>
                                                                        <th>#</th>
                                                                        <th>Mã SP</th>
                                                                        <th>Tên Sản Phẩm</th>
                                                                        <th class="text-center">SL Kỳ Vọng</th>
                                                                        <th class="text-center">SL Thực Tế</th>
                                                                        <th class="text-center">Chênh Lệch</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="d" items="${gr.details}" varStatus="st">
                                                                        <c:set var="diff" value="${d.quantityActual - d.quantityExpected}" />
                                                                        <tr>
                                                                            <td>${st.index + 1}</td>
                                                                            <td><code>${d.product.code}</code></td>
                                                                            <td>${d.product.name}</td>
                                                                            <td class="text-center">${d.quantityExpected}</td>
                                                                            <td class="text-center font-weight-bold">
                                                                                ${d.quantityActual}
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <c:choose>
                                                                                    <c:when test="${diff == 0}">
                                                                                        <span class="diff-ok">✔ Đúng</span>
                                                                                    </c:when>
                                                                                    <c:when test="${diff > 0}">
                                                                                        <span class="diff-ok">+${diff}</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="diff-warn">${diff}</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                    <c:if test="${empty gr.details}">
                                                                        <tr>
                                                                            <td colspan="6" class="text-center text-muted py-4">
                                                                                Không có chi tiết sản phẩm
                                                                            </td>
                                                                        </tr>
                                                                    </c:if>
                                                                </tbody>
                                                            </table>
                                                        </div>

                                                        <!-- Summary box -->
                                                        <c:if test="${not empty gr.details}">
                                                            <div class="row mt-3">
                                                                <div class="col-md-4 offset-md-8">
                                                                    <div class="summary-card">
                                                                        <div class="d-flex justify-content-between mb-2">
                                                                            <span>Tổng loại sản phẩm:</span>
                                                                            <strong>${gr.details.size()}</strong>
                                                                        </div>
                                                                        <div class="d-flex justify-content-between">
                                                                            <span>Trạng thái nhập kho:</span>
                                                                            <strong>
                                                                                <c:choose>
                                                                                    <c:when test="${gr.status == 2}">
                                                                                        <i class="fas fa-check-circle mr-1"></i>Đã nhập kho
                                                                                    </c:when>
                                                                                    <c:when test="${gr.status == 3}">
                                                                                        Đã hủy
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        Đang xử lý
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </strong>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <!-- Related PO card -->
                                        <c:if test="${not empty gr.purchaseOrder.details}">
                                            <div class="card mt-3">
                                                <div class="card-header">
                                                    <h5 class="card-title mb-0"><i
                                                            class="fas fa-file-invoice mr-2 text-primary"></i>Purchase
                                                        Order Gốc: ${gr.purchaseOrder.orderCode}</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered">
                                                            <thead class="thead-light">
                                                                <tr>
                                                                    <th>#</th>
                                                                    <th>Mã SP</th>
                                                                    <th>Tên Sản Phẩm</th>
                                                                    <th class="text-center">SL Đặt</th>
                                                                    <th class="text-right">Đơn Giá</th>
                                                                    <th class="text-right">Thành Tiền</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="pod" items="${gr.purchaseOrder.details}"
                                                                    varStatus="st">
                                                                    <tr>
                                                                        <td>${st.index + 1}</td>
                                                                        <td><code>${pod.product.code}</code></td>
                                                                        <td>${pod.product.name}</td>
                                                                        <td class="text-center">${pod.quantity}</td>
                                                                        <td class="text-right">
                                                                            <fmt:formatNumber value="${pod.price}"
                                                                                type="number" groupingUsed="true" /> đ
                                                                        </td>
                                                                        <td class="text-right font-weight-bold">
                                                                            <fmt:formatNumber value="${pod.subTotal}"
                                                                                type="number" groupingUsed="true" /> đ
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                            <tfoot>
                                                                <tr class="table-primary">
                                                                    <td colspan="5" class="text-right font-weight-bold">
                                                                        TỔNG CỘNG:</td>
                                                                    <td class="text-right font-weight-bold h5">
                                                                        <fmt:formatNumber
                                                                            value="${gr.purchaseOrder.totalAmount}"
                                                                            type="number" groupingUsed="true" /> đ
                                                                    </td>
                                                                </tr>
                                                            </tfoot>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>

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
                                    <div class="col-lg-6 text-right"><span>
                                            <script>document.write(new Date().getFullYear())</script>©
                                        </span> <a href="#">POS Dash</a>.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </footer>
                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
            </body>

            </html>