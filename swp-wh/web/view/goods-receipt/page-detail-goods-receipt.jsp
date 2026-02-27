<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
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
        .diff-ok { color: #28a745; font-weight: 700; }
        .diff-warn { color: #dc3545; font-weight: 700; }
        .qty-actual-input { border: 2px solid #28a745; font-weight: 700; }
        .qty-actual-input:focus { box-shadow: 0 0 0 0.2rem rgba(40,167,69,.25); border-color: #28a745; }
        .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
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

                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <div class="header-title">
                                <h4 class="card-title">
                                    <i class="fas fa-clipboard-list mr-2 text-info"></i>
                                    Chi Tiết Goods Receipt: <strong>${gr.receiptCode}</strong>
                                </h4>
                            </div>
                            <a href="${pageContext.request.contextPath}/goods-receipt" class="btn btn-secondary">
                                <i class="fas fa-arrow-left mr-1"></i> Quay lại
                            </a>
                        </div>
                        <div class="card-body">

                            <!-- Alerts -->
                            <c:if test="${param.success == 'confirmed'}">
                                <div class="alert alert-success">
                                    <i class="fas fa-check-circle mr-2"></i>Đã hoàn thành (Completed) phiếu nhập kho.
                                </div>
                            </c:if>
                            <c:if test="${param.success == 'cancelled'}">
                                <div class="alert alert-warning">
                                    <i class="fas fa-ban mr-2"></i>Đã huỷ (Cancelled) phiếu nhập kho.
                                </div>
                            </c:if>
                            <c:if test="${not empty param.error}">
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-triangle mr-2"></i>
                                    <c:choose>
                                        <c:when test="${param.error == 'confirm_failed'}">Không thể hoàn thành phiếu (Confirm failed).</c:when>
                                        <c:when test="${param.error == 'cancel_failed'}">Không thể huỷ phiếu (Cancel failed).</c:when>
                                        <c:otherwise>Có lỗi xảy ra. Vui lòng thử lại.</c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>

                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-borderless mb-0">
                                        <tr>
                                            <td class="font-weight-bold" width="40%">Mã GRO:</td>
                                            <td><span class="mono text-primary font-weight-bold">${gr.receiptCode}</span></td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">Ngày nhập:</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty gr.receiptDate}">
                                                        <fmt:formatDate value="${gr.receiptDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">Location:</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty gr.location}">
                                                        ${gr.location.locationName}
                                                        <c:if test="${not empty gr.location.locationCode}">
                                                            (<span class="mono">${gr.location.locationCode}</span>)
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <table class="table table-borderless mb-0">
                                        <tr>
                                            <td class="font-weight-bold" width="40%">Trạng thái:</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${gr.status == 1}">
                                                        <span class="badge badge-warning badge-lg">Draft</span>
                                                    </c:when>
                                                    <c:when test="${gr.status == 2}">
                                                        <span class="badge badge-success badge-lg">Completed</span>
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
                                            <td class="font-weight-bold">Purchase Order:</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty gr.purchaseOrder}">
                                                        <span class="mono"><code>${gr.purchaseOrder.orderCode}</code></span>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="font-weight-bold">Supplier:</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty gr.purchaseOrder && not empty gr.purchaseOrder.supplier}">
                                                        <strong>${gr.purchaseOrder.supplier.name}</strong>
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <c:if test="${not empty gr.note}">
                                <div class="mt-2">
                                    <strong>Ghi chú:</strong> <span class="text-muted">${gr.note}</span>
                                </div>
                            </c:if>

                            <!-- Actions for Draft -->
                            <c:if test="${gr.status == 1}">
                                <div class="border-top pt-3 mt-3 d-flex justify-content-between align-items-center flex-wrap">
                                   
                                    <div class="mt-2 mt-md-0">
                                        <button type="submit" form="confirmForm" class="btn btn-success"
                                                onclick="return confirm('Xác nhận hoàn thành phiếu nhập kho? Thao tác này sẽ cập nhật tồn kho.');">
                                            <i class="fas fa-check mr-1"></i> Confirm (Completed)
                                        </button>
                                        <form method="post" action="${pageContext.request.contextPath}/confirm-goods-receipt" class="d-inline ml-2">
                                            <input type="hidden" name="receiptId" value="${gr.id}">
                                            <input type="hidden" name="action" value="cancel">
                                            <button type="submit" class="btn btn-danger"
                                                    onclick="return confirm('Huỷ phiếu nhập kho?');">
                                                <i class="fas fa-times mr-1"></i> Cancel
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Receipt details -->
                    <div class="card mt-3">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-list mr-2"></i>Chi Tiết Nhập Kho
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">

                                <!-- If draft: wrap table inside confirm form to send detailId[] + qtyActual[] -->
                                <c:choose>
                                    <c:when test="${gr.status == 1}">
                                        <form id="confirmForm" method="post" action="${pageContext.request.contextPath}/confirm-goods-receipt">
                                            <input type="hidden" name="receiptId" value="${gr.id}">

                                            <table class="table table-bordered table-hover">
                                                <thead class="thead-light">
                                                <tr>
                                                    <th>#</th>
                                                    <th>Mã SP</th>
                                                    <th>Tên Sản Phẩm</th>
                                                    <th class="text-center">SL Dự Kiến</th>
                                                    <th class="text-center">SL Thực Tế Nhận</th>
                                                    <th class="text-center">Chênh Lệch (Dự kiến - Thực tế)</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                    <c:when test="${empty gr.details}">
                                                        <tr>
                                                            <td colspan="6" class="text-center text-muted py-4">
                                                                <i class="fas fa-inbox mr-1"></i>
                                                                Không có dữ liệu chi tiết.
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="d" items="${gr.details}" varStatus="st">
                                                            <tr class="gr-detail-row">
                                                                <td>${st.index + 1}</td>
                                                                <td><code class="mono">${d.product.code}</code></td>
                                                                <td>${d.product.name}</td>
                                                                <td class="text-center font-weight-bold expected-qty">${d.quantityExpected}</td>
                                                                <td class="text-center" style="min-width:180px;">
                                                                    <input type="hidden" name="detailId[]" value="${d.id}">
                                                                    <input type="number"
                                                                           class="form-control qty-actual-input text-center"
                                                                           name="qtyActual[]"
                                                                           min="0"
                                                                           value="${d.quantityActual}"
                                                                           required
                                                                           style="width:110px;margin:auto;">
                                                                </td>
                                                                <td class="text-center">
                                                                    <span class="diff-display">0</span>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                                </tbody>
                                            </table>

                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <table class="table table-bordered table-hover">
                                            <thead class="thead-light">
                                            <tr>
                                                <th>#</th>
                                                <th>Mã SP</th>
                                                <th>Tên Sản Phẩm</th>
                                                <th class="text-center">SL Dự Kiến</th>
                                                <th class="text-center">SL Thực Tế Nhận</th>
                                                <th class="text-center">Chênh Lệch (Dự kiến - Thực tế)</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:choose>
                                                <c:when test="${empty gr.details && not empty gr.purchaseOrder && not empty gr.purchaseOrder.details}">
                                                    <c:forEach var="pod" items="${gr.purchaseOrder.details}" varStatus="st">
                                                        <tr>
                                                            <td>${st.index + 1}</td>
                                                            <td><code class="mono">${pod.product.code}</code></td>
                                                            <td>${pod.product.name}</td>
                                                            <td class="text-center font-weight-bold">${pod.quantity}</td>
                                                            <td class="text-center font-weight-bold">—</td>
                                                            <td class="text-center">
                                                                <span class="text-muted">—</span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:when test="${empty gr.details}">
                                                    <tr>
                                                        <td colspan="6" class="text-center text-muted py-4">
                                                            <i class="fas fa-inbox mr-1"></i>Không có dữ liệu chi tiết
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="d" items="${gr.details}" varStatus="st">
                                                        <c:set var="diff" value="${d.quantityExpected - d.quantityActual}"/>
                                                        <tr>
                                                            <td>${st.index + 1}</td>
                                                            <td><code class="mono">${d.product.code}</code></td>
                                                            <td>${d.product.name}</td>
                                                            <td class="text-center font-weight-bold">${d.quantityExpected}</td>
                                                            <td class="text-center font-weight-bold">${d.quantityActual}</td>
                                                            <td class="text-center">
                                                                <span class="${diff <= 0 ? 'diff-ok' : 'diff-warn'}">${diff}</span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                            </tbody>
                                        </table>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>
                    </div>

                    <!-- PO details (optional) -->
                    <c:if test="${not empty gr.purchaseOrder && not empty gr.purchaseOrder.details}">
                        <div class="card mt-3">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="fas fa-file-invoice mr-2"></i>Chi Tiết Purchase Order
                                    <span class="text-muted">(${gr.purchaseOrder.orderCode})</span>
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover">
                                        <thead class="thead-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Mã SP</th>
                                            <th>Tên Sản Phẩm</th>
                                            <th class="text-center">SL Đặt</th>
                                            <th class="text-right">Đơn giá</th>
                                            <th class="text-right">Thành tiền</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="pod" items="${gr.purchaseOrder.details}" varStatus="st">
                                            <tr>
                                                <td>${st.index + 1}</td>
                                                <td><code class="mono">${pod.product.code}</code></td>
                                                <td>${pod.product.name}</td>
                                                <td class="text-center font-weight-bold">${pod.quantity}</td>
                                                <td class="text-right">
                                                    <fmt:formatNumber value="${pod.price}" type="number" groupingUsed="true"/> đ
                                                </td>
                                                <td class="text-right font-weight-bold">
                                                    <fmt:formatNumber value="${pod.subTotal}" type="number" groupingUsed="true"/> đ
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
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
                    <div class="col-lg-6 text-right">
                        <span class="mr-1"><script>document.write(new Date().getFullYear())</script>©</span>
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
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

<script>
    function updateDiffRow(row) {
        if (!row) return;
        var expectedEl = row.querySelector('.expected-qty');
        var actualInput = row.querySelector('input[name="qtyActual[]"]');
        var diffSpan = row.querySelector('.diff-display');
        if (!expectedEl || !actualInput || !diffSpan) return;

        var expected = parseInt(expectedEl.textContent, 10) || 0;
        var actual = parseInt(actualInput.value, 10) || 0;
        if (actual < 0) {
            actual = 0;
            actualInput.value = 0;
        }
        var diff = expected - actual;
        diffSpan.textContent = diff;
        diffSpan.className = 'diff-display ' + (diff <= 0 ? 'diff-ok' : 'diff-warn');
    }

    window.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.gr-detail-row').forEach(function (row) {
            updateDiffRow(row);
            var input = row.querySelector('input[name="qtyActual[]"]');
            if (!input) return;
            input.addEventListener('input', function () { updateDiffRow(row); });
            input.addEventListener('change', function () { updateDiffRow(row); });
        });
    });
</script>

</body>
</html>
