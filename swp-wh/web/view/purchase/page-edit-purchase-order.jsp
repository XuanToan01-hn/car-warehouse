<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Edit Purchase Order</title>
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
                    .step-badge {
                        width: 32px;
                        height: 32px;
                        border-radius: 50%;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: bold;
                        font-size: 14px;
                        color: #fff;
                    }

                    .step-badge.active {
                        background: #F59E0B;
                    }

                    .step-badge.inactive {
                        background: #adb5bd;
                    }

                    .product-row {
                        background: #f8f9fa;
                        border: 1px solid #dee2e6;
                        border-radius: 6px;
                        padding: 12px;
                        margin-bottom: 10px;
                    }

                    .total-bar {
                        background: #F59E0B;
                        color: #fff;
                        border-radius: 8px;
                        padding: 14px 20px;
                        font-size: 18px;
                    }
                </style>
            </head>

            <body>
                <div id="loading">
                    <div id="loading-center"></div>
                </div>
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <%@ include file="../header.jsp" %>
                            <div class="content-page">
                                <div class="container-fluid add-form-list">

                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <strong>Error.</strong> ${error}
                                            <button type="button" class="close"
                                                data-dismiss="alert"><span>&times;</span></button>
                                        </div>
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/edit-purchase-order?id=${poId}"
                                        method="post" id="poForm">

                                        <div class="card mb-3">
                                            <div
                                                class="card-header d-flex align-items-center justify-content-between flex-wrap">
                                                <div class="d-flex align-items-center">
                                                    <span class="step-badge active mr-2">1</span>
                                                    <h5 class="mb-0">Edit Purchase Order</h5>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/edit-purchase-order?id=${poId}&reload=1"
                                                    class="btn btn-sm btn-outline-secondary">Reload Original</a>
                                            </div>
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label>Order Code *</label>
                                                            <input type="text" name="orderCode" id="orderCode"
                                                                class="form-control" value="${draft.orderCode}"
                                                                placeholder="Order Code" readonly
                                                                style="background-color:#e9ecef;">
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label>Supplier *</label>
                                                            <div class="input-group">
                                                                <select name="supplierId" id="supplierSelect"
                                                                    class="form-control" required>
                                                                    <option value="">-- Select Supplier --</option>
                                                                    <c:forEach var="s" items="${supplierList}">
                                                                        <option value="${s.id}" <c:if
                                                                            test="${draft.supplierId eq s.id}">
                                                                            selected="selected"</c:if>>
                                                                            <c:out value="${s.name}" />
                                                                            <c:if test="${not empty s.phone}"> —
                                                                                <c:out value="${s.phone}" />
                                                                            </c:if>
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                                <div class="input-group-append">
                                                                    <button type="button" id="applySupplierBtn"
                                                                        class="btn btn-outline-primary"
                                                                        title="Apply selected supplier"
                                                                        onclick="confirmApplySupplier()">
                                                                        Apply
                                                                    </button>
                                                                </div>
                                                                <input type="hidden" name="setSupplier"
                                                                    id="setSupplierInput" disabled value="1">
                                                            </div>
                                                            <small class="text-muted">Changing supplier will reset all
                                                                product lines.</small>
                                                        </div>
                                                    </div>
                                                </div>
                                                <c:if test="${draft.supplierId gt 0}">
                                                    <div class="alert alert-warning py-2">
                                                        Editing draft PO — changes will not affect status.
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>

                                        <c:if test="${draft.supplierId gt 0}">
                                            <div class="card mb-3" id="productSection">
                                                <div
                                                    class="card-header d-flex align-items-center justify-content-between">
                                                    <div class="d-flex align-items-center">
                                                        <span class="step-badge active mr-2" id="step2Badge">2</span>
                                                        <h5 class="mb-0">Product Details</h5>
                                                    </div>
                                                    <button type="submit" name="addLine" value="1"
                                                        class="btn btn-success">
                                                        Add Line
                                                    </button>
                                                </div>
                                                <div class="card-body">
                                                    <c:choose>
                                                        <c:when test="${empty detailOptions}">
                                                            <p class="text-center text-warning py-3 mb-0">
                                                                No variants (details) found for this supplier's
                                                                products. Please create products and details in the
                                                                inventory module first.
                                                            </p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="line" items="${draft.lines}" varStatus="st">
                                                                <div class="product-row">
                                                                    <div class="row align-items-end">
                                                                        <div class="col-md-4">
                                                                            <label
                                                                                class="small font-weight-bold">Variant
                                                                                *</label>
                                                                            <select name="productDetailId"
                                                                                class="form-control variant-select"
                                                                                required
                                                                                onchange="onVariantChange(this)">
                                                                                <option value="" data-color="">-- Select
                                                                                    Variant --</option>
                                                                                <c:forEach var="opt"
                                                                                    items="${detailOptions}">
                                                                                    <option value="${opt.id}"
                                                                                        data-color="${opt.color}"
                                                                                        data-price="<fmt:formatNumber value="
                                                                                        ${opt.price}"
                                                                                        groupingUsed="false"
                                                                                        maxFractionDigits="2" />"
                                                                                    <c:if
                                                                                        test="${line.productDetailId eq opt.id}">
                                                                                        selected="selected"</c:if>>
                                                                                    <c:out value="${opt.label}" />
                                                                                    </option>
                                                                                </c:forEach>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-2">
                                                                            <label
                                                                                class="small font-weight-bold">Color</label>
                                                                            <c:set var="currentColor" value="" />
                                                                            <c:forEach var="opt"
                                                                                items="${detailOptions}">
                                                                                <c:if
                                                                                    test="${line.productDetailId eq opt.id}">
                                                                                    <c:set var="currentColor"
                                                                                        value="${opt.color}" />
                                                                                </c:if>
                                                                            </c:forEach>
                                                                            <input type="text"
                                                                                class="form-control color-display"
                                                                                value="${currentColor}" readonly
                                                                                placeholder="—"
                                                                                style="background-color:#e9ecef;">
                                                                        </div>
                                                                        <div class="col-md-2">
                                                                            <label class="small font-weight-bold">Unit
                                                                                Price *</label>
                                                                            <input type="text" name="price"
                                                                                class="form-control"
                                                                                value="<c:if test='${line.price != null}'><fmt:formatNumber value='${line.price}' groupingUsed='false' maxFractionDigits='2' /></c:if>"
                                                                                min="0" required
                                                                                placeholder="Enter price"
                                                                                oninput="this.value=this.value.replace(/[^0-9.]/g,'')">
                                                                        </div>
                                                                        <div class="col-md-2">
                                                                            <label
                                                                                class="small font-weight-bold">Quantity
                                                                                *</label>
                                                                            <input type="number" name="quantity"
                                                                                class="form-control"
                                                                                value="${line.quantity}" min="1"
                                                                                required>
                                                                        </div>
                                                                        <div class="col-md-2 text-right">
                                                                            <label
                                                                                class="small font-weight-bold d-block">&nbsp;</label>
                                                                            <button type="submit" name="removeLine"
                                                                                value="${st.index}"
                                                                                class="btn btn-outline-danger btn-sm"
                                                                                title="Remove line">Remove</button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>

                                                            <div
                                                                class="total-bar mt-3 d-flex justify-content-between align-items-center">
                                                                <span>Estimated Subtotal:</span>
                                                                <span class="font-weight-bold">
                                                                    <fmt:formatNumber value="${grandTotal}"
                                                                        type="number" maxFractionDigits="0" /> VND
                                                                </span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:if>

                                        <div class="d-flex justify-content-between mb-4">
                                            <a href="${pageContext.request.contextPath}/detail-purchase-order?id=${poId}"
                                                class="btn btn-secondary btn-lg">
                                                Back to Detail
                                            </a>
                                            <c:if test="${draft.supplierId gt 0 and not empty detailOptions}">
                                                <button type="submit" name="savePO" value="1"
                                                    class="btn btn-warning btn-lg">
                                                    Save Changes
                                                </button>
                                            </c:if>
                                        </div>
                                    </form>
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

                <script>
                    var currentSupplierId = '${draft.supplierId}';
                    var hasProductLines = ${ not empty draft.lines && draft.lines.size() > 0 && draft.supplierId > 0 ? 'true' : 'false'};

                    function confirmApplySupplier() {
                        var sel = document.getElementById('supplierSelect');
                        var newVal = sel.value;
                        if (!newVal) {
                            alert('Please select a supplier first.');
                            return;
                        }
                        if (hasProductLines && currentSupplierId !== '0' && currentSupplierId !== '' && newVal !== currentSupplierId) {
                            if (!confirm('Changing the supplier will clear all current product lines. Do you want to continue?')) {
                                sel.value = currentSupplierId;
                                return;
                            }
                        }
                        document.getElementById('setSupplierInput').disabled = false;
                        document.getElementById('poForm').submit();
                    }

                    function onVariantChange(selectEl) {
                        var val = selectEl.value;
                        if (!val) {
                            var r = selectEl.closest('.product-row');
                            if (r.querySelector('.color-display')) r.querySelector('.color-display').value = '';
                            refreshVariantOptions();
                            return;
                        }

                        var row = selectEl.closest('.product-row');
                        var selectedOption = selectEl.options[selectEl.selectedIndex];
                        var color = selectedOption.getAttribute('data-color') || '';
                        var price = selectedOption.getAttribute('data-price') || '';

                        var colorInput = row.querySelector('.color-display');
                        if (colorInput) {
                            colorInput.value = color;
                        }

                        var priceInput = row.querySelector('input[name="price"]');
                        if (priceInput && (!priceInput.value || priceInput.value === '0')) {
                            priceInput.value = price;
                        }
                        refreshVariantOptions();
                        recalcTotal();
                    }

                    function refreshVariantOptions() {
                        var allSelects = document.querySelectorAll('.variant-select');
                        var occupiedValues = [];
                        allSelects.forEach(function (s) {
                            if (s.value) occupiedValues.push(s.value);
                        });

                        allSelects.forEach(function (select) {
                            var currentVal = select.value;
                            for (var i = 0; i < select.options.length; i++) {
                                var opt = select.options[i];
                                if (!opt.value) continue; // Skip placeholder

                                // Hide if selected in ANOTHER select
                                var isSelectedElsewhere = occupiedValues.includes(opt.value) && opt.value !== currentVal;
                                if (isSelectedElsewhere) {
                                    opt.disabled = true;
                                    opt.style.display = 'none';
                                } else {
                                    opt.disabled = false;
                                    opt.style.display = 'block';
                                }
                            }
                        });
                    }

                    function recalcTotal() {
                        var rows = document.querySelectorAll('.product-row');
                        var total = 0;
                        rows.forEach(function (row) {
                            var priceInput = row.querySelector('input[name="price"]');
                            var qtyInput = row.querySelector('input[name="quantity"]');
                            var price = parseFloat(priceInput ? priceInput.value : 0) || 0;
                            var qty = parseFloat(qtyInput ? qtyInput.value : 0) || 0;
                            total += price * qty;
                        });
                        var totalSpan = document.querySelector('.total-bar .font-weight-bold');
                        if (totalSpan) {
                            totalSpan.textContent = Math.round(total).toLocaleString('en-US') + ' VND';
                        }
                    }

                    document.addEventListener('DOMContentLoaded', function () {
                        function attachListeners(row) {
                            var priceInput = row.querySelector('input[name="price"]');
                            var qtyInput = row.querySelector('input[name="quantity"]');
                            if (priceInput) priceInput.addEventListener('input', recalcTotal);
                            if (qtyInput) qtyInput.addEventListener('input', recalcTotal);
                        }
                        document.querySelectorAll('.product-row').forEach(attachListeners);
                        refreshVariantOptions();
                        recalcTotal();
                    });
                </script>
            </body>

            </html>