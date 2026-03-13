<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Goods Receipt Details | InventoryPro</title>

                <link
                    href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">

                <style>
                    :root {
                        --primary: #0EA5E9;
                    }

                    body {
                        font-family: 'Be Vietnam Pro', sans-serif;
                        background: #f1f5f9;
                        color: #1e293b;
                    }

                    /* ---------- Info Card ---------- */
                    .card-detail {
                        background: #fff;
                        border-radius: 16px;
                        border: 1px solid #e2e8f0;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, .05);
                        margin-bottom: 1.5rem;
                    }

                    .card-detail-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 1.2rem 1.5rem;
                        border-bottom: 1px solid #f1f5f9;
                    }

                    .card-detail-header h4 {
                        margin: 0;
                        font-weight: 700;
                        font-size: 1.1rem;
                    }

                    .card-detail-body {
                        padding: 1.5rem;
                    }

                    /* ---------- Info Grid ---------- */
                    .info-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 0;
                    }

                    .info-row {
                        display: flex;
                        align-items: flex-start;
                        padding: 0.75rem 0;
                        border-bottom: 1px solid #f1f5f9;
                    }

                    .info-row:last-child {
                        border-bottom: none;
                    }

                    .info-label {
                        font-weight: 600;
                        color: #64748b;
                        font-size: 0.85rem;
                        min-width: 130px;
                        padding-right: 1rem;
                    }

                    .info-value {
                        color: #1e293b;
                        font-size: 0.9rem;
                    }

                    .info-value.mono {
                        font-family: ui-monospace, monospace;
                        color: #0EA5E9;
                        font-weight: 700;
                    }

                    .info-value.code {
                        font-family: ui-monospace, monospace;
                        color: #F59E0B;
                        font-size: 0.85rem;
                    }

                    /* ---------- Badges ---------- */
                    .badge-status {
                        display: inline-block;
                        padding: 0.35rem 0.9rem;
                        border-radius: 8px;
                        font-weight: 700;
                        font-size: 0.72rem;
                        letter-spacing: .04em;
                    }

                    .bs-draft {
                        background: #FEF3C7;
                        color: #92400E;
                    }

                    .bs-completed {
                        background: #D1FAE5;
                        color: #065F46;
                    }

                    .bs-cancelled {
                        background: #FEE2E2;
                        color: #991B1B;
                    }

                    .bs-partial {
                        background: #FEF9C3;
                        color: #854D0E;
                        border: 1px solid #FDE047;
                    }

                    /* ---------- Action bar ---------- */
                    .action-bar {
                        padding: 1rem 1.5rem;
                        border-top: 1px solid #f1f5f9;
                        display: flex;
                        gap: 0.75rem;
                        align-items: center;
                        flex-wrap: wrap;
                    }

                    /* ---------- Table Card ---------- */
                    .card-table {
                        background: #fff;
                        border-radius: 16px;
                        border: 1px solid #e2e8f0;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, .05);
                        margin-bottom: 1.5rem;
                        overflow: hidden;
                    }

                    .card-table-header {
                        padding: 1rem 1.5rem;
                        border-bottom: 1px solid #f1f5f9;
                        font-weight: 700;
                        font-size: 0.95rem;
                        color: #374151;
                    }

                    .table thead th {
                        background: #f8fafc;
                        font-weight: 700;
                        color: #64748b;
                        text-transform: uppercase;
                        font-size: 0.72rem;
                        letter-spacing: .05em;
                        padding: 0.9rem 1rem;
                        border-bottom: 2px solid #e2e8f0;
                    }

                    .table tbody td {
                        padding: 0.85rem 1rem;
                        vertical-align: middle;
                    }

                    .table tbody tr:hover {
                        background: #f8fafc;
                    }

                    /* ---------- Qty input ---------- */
                    .qty-actual-input {
                        border: 2px solid #16A34A;
                        border-radius: 8px;
                        font-weight: 700;
                        text-align: center;
                        width: 100px;
                        margin: auto;
                        padding: 0.4rem;
                        display: block;
                    }

                    .qty-actual-input:focus {
                        outline: none;
                        box-shadow: 0 0 0 3px rgba(22, 163, 74, .2);
                        border-color: #16A34A;
                    }

                    .diff-ok {
                        color: #16A34A;
                        font-weight: 700;
                    }

                    .diff-warn {
                        color: #EF4444;
                        font-weight: 700;
                    }

                    .partial-note {
                        background: #FFFBEB;
                        border: 1px solid #FDE68A;
                        border-radius: 10px;
                        padding: 0.6rem 1rem;
                        color: #92400E;
                        font-size: 0.83rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .mono {
                        font-family: ui-monospace, monospace;
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

                                        <!-- ===== INFO CARD ===== -->
                                        <div class="card-detail">
                                            <div class="card-detail-header">
                                                <h4>
                                                    <i class="fas fa-clipboard-list mr-2 text-info"></i>
                                                    Goods Receipt Details:
                                                    <span class="text-primary">${gr.receiptCode}</span>
                                                </h4>
                                                <a href="${pageContext.request.contextPath}/goods-receipt"
                                                    class="btn btn-secondary">
                                                    <i class="fas fa-arrow-left mr-1"></i> Back
                                                </a>
                                            </div>

                                            <!-- Alerts -->
                                            <c:if test="${param.success == 'confirmed'}">
                                                <div class="alert alert-success mx-3 mt-3">
                                                    <i class="fas fa-check-circle mr-2"></i>The warehouse receipt has
                                                    been completed.
                                                </div>
                                            </c:if>
                                            <c:if test="${param.success == 'cancelled'}">
                                                <div class="alert alert-warning mx-3 mt-3">
                                                    <i class="fas fa-ban mr-2"></i>The warehouse receipt has been
                                                    cancelled.
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty param.error}">
                                                <div class="alert alert-danger mx-3 mt-3">
                                                    <i class="fas fa-exclamation-triangle mr-2"></i>
                                                    <c:choose>
                                                        <c:when test="${param.error == 'confirm_failed'}">Confirm
                                                            failed.</c:when>
                                                        <c:when test="${param.error == 'cancel_failed'}">Cancel failed.
                                                        </c:when>
                                                        <c:otherwise>An error occurred. Please try again.</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:if>

                                            <div class="card-detail-body">
                                                <div class="info-grid">
                                                    <!-- Left column -->
                                                    <div style="padding-right: 2rem; border-right: 1px solid #f1f5f9;">
                                                        <div class="info-row">
                                                            <span class="info-label">GRO Code:</span>
                                                            <span class="info-value mono">${gr.receiptCode}</span>
                                                        </div>
                                                        <div class="info-row">
                                                            <span class="info-label">Date of Entry:</span>
                                                            <span class="info-value">
                                                                <c:choose>
                                                                    <c:when test="${not empty gr.receiptDate}">
                                                                        <fmt:formatDate value="${gr.receiptDate}"
                                                                            pattern="dd/MM/yyyy HH:mm" />
                                                                    </c:when>
                                                                    <c:otherwise><span class="text-muted">—</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                        <div class="info-row">
                                                            <span class="info-label">Location:</span>
                                                            <span class="info-value">
                                                                <c:choose>
                                                                    <c:when test="${not empty gr.location}">
                                                                        ${gr.location.locationName}
                                                                        <c:if
                                                                            test="${not empty gr.location.locationCode}">
                                                                            (<span class="mono"
                                                                                style="font-size:.85rem;">${gr.location.locationCode}</span>)
                                                                        </c:if>
                                                                    </c:when>
                                                                    <c:otherwise><span class="text-muted">—</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                    </div>

                                                    <!-- Right column -->
                                                    <div style="padding-left: 2rem;">
                                                        <div class="info-row">
                                                            <span class="info-label">Status:</span>
                                                            <span class="info-value">
                                                                <c:choose>
                                                                    <c:when test="${gr.status == 1}">
                                                                        <span class="badge-status bs-draft">Draft</span>
                                                                    </c:when>
                                                                    <c:when test="${gr.status == 2}">
                                                                        <span
                                                                            class="badge-status bs-completed">Completed</span>
                                                                    </c:when>
                                                                    <c:when test="${gr.status == 3}">
                                                                        <span
                                                                            class="badge-status bs-cancelled">Cancelled</span>
                                                                    </c:when>
                                                                    <c:when test="${gr.status == 4}">
                                                                        <span class="badge-status bs-partial">Partially
                                                                            Received</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge-status"
                                                                            style="background:#e2e8f0;color:#64748b;">${gr.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                        <div class="info-row">
                                                            <span class="info-label">Purchase Order:</span>
                                                            <span class="info-value">
                                                                <c:choose>
                                                                    <c:when test="${not empty gr.purchaseOrder}">
                                                                        <span
                                                                            class="info-value code">${gr.purchaseOrder.orderCode}</span>
                                                                    </c:when>
                                                                    <c:otherwise><span class="text-muted">—</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                        <div class="info-row">
                                                            <span class="info-label">Supplier:</span>
                                                            <span class="info-value font-weight-bold">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${not empty gr.purchaseOrder && not empty gr.purchaseOrder.supplier}">
                                                                        ${gr.purchaseOrder.supplier.name}
                                                                    </c:when>
                                                                    <c:otherwise><span class="text-muted">—</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <c:if test="${not empty gr.note}">
                                                    <div class="mt-3 p-3"
                                                        style="background:#f8fafc;border-radius:10px;">
                                                        <span
                                                            class="font-weight-bold text-secondary small text-uppercase">Note:
                                                        </span>
                                                        <span class="text-muted">${gr.note}</span>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <!-- Action bar: shown for Draft (1) OR Partially Received (4) -->
                                            <c:if test="${gr.status == 1 || gr.status == 4}">
                                                <div class="action-bar">
                                                    <button type="submit" form="confirmForm" class="btn btn-success"
                                                        onclick="return confirm('Confirm and update inventory? This action cannot be undone.');">
                                                        <i class="fas fa-check mr-1"></i> Confirm Receipt
                                                    </button>

                                                    <c:if test="${gr.status == 1}">
                                                        <form method="post"
                                                            action="${pageContext.request.contextPath}/confirm-goods-receipt"
                                                            class="d-inline m-0">
                                                            <input type="hidden" name="receiptId" value="${gr.id}">
                                                            <input type="hidden" name="action" value="cancel">
                                                            <button type="submit" class="btn btn-outline-danger"
                                                                onclick="return confirm('Are you sure you want to cancel this receipt?');">
                                                                <i class="fas fa-times mr-1"></i> Cancel
                                                            </button>
                                                        </form>
                                                    </c:if>

                                                    <c:if test="${gr.status == 4}">
                                                        <span class="partial-note">
                                                            <i class="fas fa-info-circle"></i>
                                                            Some items were partially received. Update the actual
                                                            quantities below before re-confirming.
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- ===== RECEIPT DETAILS TABLE ===== -->
                                        <div class="card-table">
                                            <div class="card-table-header">
                                                <i class="fas fa-list mr-2 text-primary"></i>Receipt Details
                                            </div>
                                            <div class="table-responsive">

                                                <%-- Editable: Draft (1) OR Partially Received (4) --%>
                                                    <c:choose>
                                                        <c:when test="${gr.status == 1 || gr.status == 4}">
                                                            <form id="confirmForm" method="post"
                                                                action="${pageContext.request.contextPath}/confirm-goods-receipt">
                                                                <input type="hidden" name="receiptId" value="${gr.id}">
                                                                <table class="table mb-0">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>#</th>
                                                                            <th>Product Code</th>
                                                                            <th>Product Name</th>
                                                                            <th class="text-center">Order quantity</th>
                                                                            <th class="text-center">Actual quantity received
                                                                            </th>
                                                                            <th class="text-center">Difference</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:choose>
                                                                            <c:when test="${empty gr.details}">
                                                                                <tr>
                                                                                    <td colspan="6"
                                                                                        class="text-center text-muted py-5">
                                                                                        <i
                                                                                            class="fas fa-inbox mr-1"></i>
                                                                                        No detailed data available.
                                                                                    </td>
                                                                                </tr>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:forEach var="d" items="${gr.details}"
                                                                                    varStatus="st">
                                                                                    <tr class="gr-detail-row">
                                                                                        <td>${st.index + 1}</td>
                                                                                        <td>
                                                                                            <code
                                                                                                class="mono">${d.product.code}
                                                                                            </code>
                                                                                        </td>
                                                                                        <td>
                                                                                            ${d.product.name}
                                                                                        </td>
                                                                                        <td
                                                                                            class="text-center font-weight-bold expected-qty">
                                                                                            ${d.quantityExpected}
                                                                                        </td>
                                                                                        <td class="text-center">
                                                                                            <input type="hidden"
                                                                                                name="detailId[]"
                                                                                                value="${d.id}">
                                                                                            <input type="number"
                                                                                                class="qty-actual-input"
                                                                                                name="qtyActual[]"
                                                                                                min="0"
                                                                                                max="${d.quantityExpected}"
                                                                                                value="${d.quantityActual}"
                                                                                                required>
                                                                                        </td>
                                                                                        <td class="text-center">
                                                                                            <span
                                                                                                class="diff-display font-weight-bold">0</span>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </tbody>
                                                                </table>
                                                            </form>
                                                        </c:when>

                                                        <%-- Read-only: Completed (2), Cancelled (3), etc. --%>
                                                            <c:otherwise>
                                                                <table class="table mb-0">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>#</th>
                                                                            <th>Product Code</th>
                                                                            <th>Product Name</th>
                                                                            <th class="text-center">Expected Qty</th>
                                                                            <th class="text-center">Actual Received Qty
                                                                            </th>
                                                                            <th class="text-center">Difference</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${empty gr.details && not empty gr.purchaseOrder && not empty gr.purchaseOrder.details}">
                                                                                <c:forEach var="pod"
                                                                                    items="${gr.purchaseOrder.details}"
                                                                                    varStatus="st">
                                                                                    <tr>
                                                                                        <td>${st.index + 1}</td>
                                                                                        <td><code
                                                                                                class="mono">${pod.product.code}</code>
                                                                                        </td>
                                                                                        <td>${pod.product.name}</td>
                                                                                        <td
                                                                                            class="text-center font-weight-bold">
                                                                                            ${pod.quantity}</td>
                                                                                        <td
                                                                                            class="text-center text-muted">
                                                                                            —</td>
                                                                                        <td
                                                                                            class="text-center text-muted">
                                                                                            —</td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </c:when>
                                                                            <c:when test="${empty gr.details}">
                                                                                <tr>
                                                                                    <td colspan="6"
                                                                                        class="text-center text-muted py-5">
                                                                                        <i
                                                                                            class="fas fa-inbox mr-1"></i>No
                                                                                        detailed data available.
                                                                                    </td>
                                                                                </tr>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:forEach var="d" items="${gr.details}"
                                                                                    varStatus="st">
                                                                                    <c:set var="diff"
                                                                                        value="${d.quantityExpected - d.quantityActual}" />
                                                                                    <tr>
                                                                                        <td>${st.index + 1}</td>
                                                                                        <td><code
                                                                                                class="mono">${d.product.code}</code>
                                                                                        </td>
                                                                                        <td>${d.product.name}</td>
                                                                                        <td
                                                                                            class="text-center font-weight-bold">
                                                                                            ${d.quantityExpected}</td>
                                                                                        <td
                                                                                            class="text-center font-weight-bold">
                                                                                            ${d.quantityActual}</td>
                                                                                        <td class="text-center">
                                                                                            <span
                                                                                                class="${diff <= 0 ? 'diff-ok' : 'diff-warn'}">${diff}</span>
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

                                        <!-- ===== PO DETAILS TABLE ===== -->
                                        <c:if
                                            test="${not empty gr.purchaseOrder && not empty gr.purchaseOrder.details}">
                                            <div class="card-table">
                                                <div class="card-table-header">
                                                    <i class="fas fa-file-invoice mr-2 text-warning"></i>
                                                    Purchase Order Details
                                                    <span class="text-muted font-weight-normal"
                                                        style="font-size:.85rem;">
                                                        (${gr.purchaseOrder.orderCode})
                                                    </span>
                                                </div>
                                                <div class="table-responsive">
                                                    <table class="table mb-0">
                                                        <thead>
                                                            <tr>
                                                                <th>#</th>
                                                                <th>Product Code</th>
                                                                <th>Product Name</th>
                                                                <th class="text-center">Ordered Qty</th>
                                                                <th class="text-right">Unit Price</th>
                                                                <th class="text-right">Total Amount</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="pod" items="${gr.purchaseOrder.details}"
                                                                varStatus="st">
                                                                <tr>
                                                                    <td>${st.index + 1}</td>
                                                                    <td><code class="mono">${pod.product.code}</code>
                                                                    </td>
                                                                    <td>${pod.product.name}</td>
                                                                    <td class="text-center font-weight-bold">
                                                                        ${pod.quantity}</td>
                                                                    <td class="text-right">
                                                                        <fmt:formatNumber value="${pod.price}"
                                                                            type="number" groupingUsed="true" /> VND
                                                                    </td>
                                                                    <td class="text-right font-weight-bold">
                                                                        <fmt:formatNumber value="${pod.subTotal}"
                                                                            type="number" groupingUsed="true" /> VND
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
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
                                        <span>
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
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

                <script>
                    function updateDiffRow(row) {
                        var expectedEl = row.querySelector('.expected-qty');
                        var actualInput = row.querySelector('input[name="qtyActual[]"]');
                        var diffSpan = row.querySelector('.diff-display');
                        if (!expectedEl || !actualInput || !diffSpan) return;

                        var expected = parseInt(expectedEl.textContent, 10) || 0;
                        var actual = parseInt(actualInput.value, 10) || 0;
                        if (actual < 0) { actual = 0; actualInput.value = 0; }
                        if (actual > expected) { actual = expected; actualInput.value = expected; }

                        var diff = expected - actual;
                        diffSpan.textContent = diff;
                        diffSpan.className = 'diff-display font-weight-bold ' + (diff <= 0 ? 'diff-ok' : 'diff-warn');
                    }

                    window.addEventListener('DOMContentLoaded', function () {
                        var form = document.getElementById('confirmForm');

                        document.querySelectorAll('.gr-detail-row').forEach(function (row) {
                            updateDiffRow(row);
                            var input = row.querySelector('input[name="qtyActual[]"]');
                            if (!input) return;
                            input.addEventListener('input', function () { updateDiffRow(row); });
                            input.addEventListener('change', function () { updateDiffRow(row); });
                        });

                        if (form) {
                            form.addEventListener('submit', function (e) {
                                var invalid = false;
                                document.querySelectorAll('.gr-detail-row').forEach(function (row) {
                                    var expectedEl = row.querySelector('.expected-qty');
                                    var actualInput = row.querySelector('input[name="qtyActual[]"]');
                                    if (!expectedEl || !actualInput) return;
                                    var expected = parseInt(expectedEl.textContent, 10) || 0;
                                    var actual = parseInt(actualInput.value, 10) || 0;
                                    if (actual > expected) {
                                        actualInput.style.borderColor = '#EF4444';
                                        actualInput.style.boxShadow = '0 0 0 3px rgba(239,68,68,.2)';
                                        invalid = true;
                                    } else {
                                        actualInput.style.borderColor = ''; // Reset to default or a success color
                                        actualInput.style.boxShadow = '';
                                    }
                                });
                                if (invalid) {
                                    e.preventDefault();
                                    alert('Actual Received Qty cannot exceed Expected Qty. Please correct the highlighted rows.');
                                }
                            });
                        }
                    });
                </script>

            </body>

            </html>