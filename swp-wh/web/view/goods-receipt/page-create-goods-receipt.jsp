<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!doctype html>
            <html lang="vi">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Tạo Goods Receipt Order</title>
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
                    .po-info-box {
                        background: #f8f9fa;
                        border-left: 4px solid #28a745;
                        padding: 12px 16px;
                        border-radius: 4px;
                        margin-bottom: 16px;
                    }

                    .product-table thead th {
                        background: #343a40;
                        color: #fff;
                    }

                    .qty-actual-input {
                        border: 2px solid #28a745;
                        font-weight: bold;
                    }

                    .qty-actual-input:focus {
                        box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, .25);
                        border-color: #28a745;
                    }

                    .diff-ok {
                        color: #28a745;
                        font-weight: bold;
                    }

                    .diff-warn {
                        color: #dc3545;
                        font-weight: bold;
                    }

                    #no-po-msg {
                        color: #6c757d;
                        text-align: center;
                        padding: 40px 0;
                        font-size: 1rem;
                    }

                    /* ---- Capacity badge ---- */
                    #location-group {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    #location-group select {
                        flex: 1;
                    }

                    #capacity-badge {
                        display: none;
                        white-space: nowrap;
                        padding: 5px 12px;
                        border-radius: 8px;
                        font-size: 0.82rem;
                        font-weight: 600;
                        background: #EFF6FF;
                        border: 1px solid #BFDBFE;
                        color: #1D4ED8;
                    }

                    #capacity-badge i {
                        margin-right: 4px;
                    }
                </style>
            </head>

            <body>
                <div id="loading">
                    <div id="loading-center"></div>
                </div>
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <jsp:include page="../header.jsp" />
                        <div class="content-page">
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-sm-12">

                                        <!-- Header card -->
                                        <div class="card">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <div class="header-title">
                                                    <h4 class="card-title"><i
                                                            class="fas fa-truck-loading mr-2 text-success"></i>Create
                                                        Goods
                                                        Receipt Order</h4>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/goods-receipt"
                                                    class="btn btn-secondary">
                                                    <%-- <i class="fas fa-arrow-left mr-1"></i> --%>
                                                        Back
                                                </a>
                                            </div>
                                            <div class="card-body">

                                                <!-- Error -->
                                                <c:if test="${not empty sessionScope.error}">
                                                    <div class="alert alert-danger"><i
                                                            class="fas fa-exclamation-triangle mr-2"></i>${sessionScope.error}
                                                    </div>
                                                    <c:remove var="error" scope="session" />
                                                </c:if>
                                                <c:if test="${not empty sessionScope.success}">
                                                    <div class="alert alert-success"><i
                                                            class="fas fa-check-circle mr-2"></i>${sessionScope.success}
                                                    </div>
                                                    <c:remove var="success" scope="session" />
                                                </c:if>

                                                <div id="js-flash-msg"></div>

                                                <form id="groForm" method="post"
                                                    action="${pageContext.request.contextPath}/create-goods-receipt">
                                                    <div class="row">
                                                        <!-- Chọn Purchase Order -->
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label class="font-weight-bold"><i
                                                                        class="fas fa-file-invoice mr-1 text-primary"></i>Purchase
                                                                    Order <span class="text-danger">*</span></label>
                                                                <select id="poSelect" name="poId" class="form-control"
                                                                    required onchange="loadPOProducts()">
                                                                    <option value="">-- Chọn Purchase Order --</option>
                                                                    <c:forEach var="po" items="${confirmedPOs}">
                                                                        <option value="${po.id}"
                                                                            data-code="${po.orderCode}"
                                                                            data-supplier="${po.supplier.name}"
                                                                            ${selectedPO !=null && selectedPO.id==po.id
                                                                            ? 'selected' : '' }>
                                                                            ${po.orderCode} — ${po.supplier.name}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <!-- Chọn Location -->
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label class="font-weight-bold"><i
                                                                        class="fas fa-map-marker-alt mr-1 text-danger"></i>Receiving
                                                                    Warehouse location
                                                                    <c:if test="${not empty sessionScope.user.warehouse}">
                                                                        <span class="badge badge-info ml-1" style="font-size: 0.75rem;">
                                                                            <i class="fas fa-warehouse mr-1"></i>${sessionScope.user.warehouse.warehouseName}
                                                                        </span>
                                                                    </c:if>
                                                                    <span class="text-danger">*</span>
                                                                </label>
                                                                <div id="location-group">
                                                                    <select id="locationSelect" name="locationId"
                                                                        class="form-control" required>
                                                                        <option value="">-- Chọn Location --</option>
                                                                        <c:forEach var="loc" items="${locations}">
                                                                            <option value="${loc.id}"
                                                                                data-maxcapacity="${loc.maxCapacity}"
                                                                                data-currentstock="${loc.currentStock}">
                                                                                ${loc.locationName}
                                                                                (${loc.locationCode})
                                                                            </option>
                                                                        </c:forEach>
                                                                    </select>
                                                                    <div id="capacity-badge">
                                                                        <i class="fas fa-boxes"></i>
                                                                        <span id="capacity-value">—</span>
                                                                    </div>
                                                                </div>
                                                                <!-- Vùng chứa thông báo capacity (cố định vị trí) -->
                                                                <div id="capacity-warnings"></div>
                                                            </div>
                                                        </div>

                                                        <!-- Ghi chú -->
                                                        <div class="col-md-12">
                                                            <div class="form-group">
                                                                <label class="font-weight-bold"><i
                                                                        class="fas fa-sticky-note mr-1 text-warning"></i>Note</label>
                                                                <textarea name="note" class="form-control" rows="2"
                                                                    placeholder="Nhập ghi chú (tuỳ chọn)..."></textarea>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>

                                        <!-- PO Info box (hiện khi chọn PO) -->
                                        <div id="po-info-area" class="d-none">
                                            <div class="card mt-3">
                                                <div class="card-header">
                                                    <h5 class="card-title mb-0"><i
                                                            class="fas fa-list mr-2 text-success"></i>Product Details to
                                                        be Imported</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div id="po-info-box" class="po-info-box d-none">
                                                        <strong>PO:</strong> <span id="po-code-label"></span>
                                                        &nbsp;|&nbsp;
                                                        <strong>Supplier:</strong> <span id="po-supplier-label"></span>
                                                    </div>

                                                    <div class="table-responsive">
                                                        <table class="product-table table table-bordered">
                                                            <thead>
                                                                <tr>
                                                                    <th>#</th>
                                                                    <th>Product Code</th>
                                                                    <th>Product Name</th>
                                                                    <th>Variant</th>
                                                                    <th class="text-center">Order Qty</th>
                                                                    <th class="text-center">Actual Qty Received</th>
                                                                    <th class="text-center">Remaining Qty</th>
                                                                    <th class="text-center">Current Stock</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="product-tbody">
                                                                <tr id="no-po-msg-row">
                                                                    <td colspan="8" id="no-po-msg"><i
                                                                            class="fas fa-hand-point-up mr-2"></i>Please
                                                                        select Purchase Order to view the product.</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>

                                                    <div class="text-right mt-3">
                                                        <button type="submit" form="groForm"
                                                            class="btn btn-warning btn-lg" id="submitBtn" disabled>
                                                            <i class="fas fa-save mr-2"></i>Save Receipt
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- JSP-rendered products for pre-selected PO -->
                                        <c:if test="${not empty selectedPO}">
                                            <script>
                                                window.preloadedPO = {
                                                    id: ${ selectedPO.id },
                                                code: '${selectedPO.orderCode}',
                                                    supplier: '${selectedPO.supplier.name}',
                                                        details: [
                                                            <c:forEach var="d" items="${selectedPO.details}" varStatus="st">
                                                                <c:set var="vLbl" value="-" />
                                                                <c:if test="${d.productDetail != null}">
                                                                    <c:set var="vLbl" value="${d.productDetail.serialNumber}" />
                                                                    <c:if test="${not empty d.productDetail.color}">
                                                                        <c:set var="vLbl" value="${vLbl} (${d.productDetail.color})" />
                                                                    </c:if>
                                                                </c:if>
                                                                {
                                                                    productId: ${d.product.id},
                                                                code: '${d.product.code}',
                                                                name: '${d.product.name}',
                                                                quantity: ${d.quantity},
                                                                pdId: ${d.productDetail != null ? d.productDetail.id : 0},
                                                                variantLabel: '${vLbl}'
                                                            }<c:if test="${!st.last}">,</c:if>
                                                            </c:forEach>
                                                        ]
                                                };
                                            </script>
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
                <script>
                    // PO data map built from dropdown option data attributes
                    var poDataMap = {};
                    document.querySelectorAll('#poSelect option[value]').forEach(function (opt) {
                        if (!opt.value) return;
                        poDataMap[opt.value] = {
                            code: opt.dataset.code,
                            supplier: opt.dataset.supplier
                        };
                    });

                    function getSelectedLocationId() {
                        var sel = document.getElementById('locationSelect');
                        return (sel && sel.value) ? sel.value : '';
                    }

                    function loadPOProducts() {
                        var poId = document.getElementById('poSelect').value;
                        var infoArea = document.getElementById('po-info-area');
                        var infoBox = document.getElementById('po-info-box');
                        var tbody = document.getElementById('product-tbody');
                        var submitBtn = document.getElementById('submitBtn');

                        if (!poId) {
                            infoArea.classList.add('d-none');
                            tbody.innerHTML = '<tr><td colspan="8" id="no-po-msg"><i class="fas fa-hand-point-up mr-2"></i>Vui lòng chọn Purchase Order để xem sản phẩm</td></tr>';
                            submitBtn.disabled = true;
                            return;
                        }

                        var locationId = getSelectedLocationId();
                        var apiUrl = '${pageContext.request.contextPath}/api/po-details?poId=' + poId;
                        if (locationId) apiUrl += '&locationId=' + locationId;

                        // Fetch PO details via AJAX
                        fetch(apiUrl)
                            .then(function (res) { return res.json(); })
                            .then(function (data) {
                                renderProducts(poId, data.code, data.supplier, data.details);
                            })
                            .catch(function () {
                                // Fallback: show preloaded data if available (for server-side pre-set PO)
                                if (window.preloadedPO && window.preloadedPO.id == poId) {
                                    renderProducts(poId, window.preloadedPO.code, window.preloadedPO.supplier, window.preloadedPO.details);
                                }
                            });
                    }

                    function renderProducts(poId, code, supplier, details) {
                        var infoArea = document.getElementById('po-info-area');
                        var infoBox = document.getElementById('po-info-box');
                        var tbody = document.getElementById('product-tbody');
                        var submitBtn = document.getElementById('submitBtn');

                        document.getElementById('po-code-label').textContent = code;
                        document.getElementById('po-supplier-label').textContent = supplier;
                        infoBox.classList.remove('d-none');
                        infoArea.classList.remove('d-none');

                        var html = '';
                        if (!details || details.length === 0) {
                            html = '<tr><td colspan="8" class="text-center text-muted">Không có sản phẩm trong PO này</td></tr>';
                            submitBtn.disabled = true;
                        } else {
                            details.forEach(function (d, idx) {
                                var remaining = (d.remainingQty !== undefined) ? d.remainingQty : d.quantity;
                                var currentStock = (d.currentStock !== undefined) ? d.currentStock : 0;
                                // Default actual = 0 (user enters how much received this time)
                                var defaultActual = 0;
                                // Build variant display
                                var variantHtml = '';
                                if (d.pdId && d.pdId > 0) {
                                    variantHtml = '<span class="text-primary font-weight-bold">' + (d.variantLabel || '') + '</span>' +
                                        '<input type="hidden" name="productDetailId[]" form="groForm" value="' + d.pdId + '">';
                                } else {
                                    variantHtml = '<span class="text-muted">-</span><input type="hidden" name="productDetailId[]" form="groForm" value="0">';
                                }
                                html += '<tr>' +
                                    '<td>' + (idx + 1) + '</td>' +
                                    '<td><code>' + (d.code || d.productCode || '') + '</code></td>' +
                                    '<td>' + (d.name || d.productName || '') + '</td>' +
                                    '<td>' + variantHtml + '</td>' +
                                    '<td class="text-center font-weight-bold">' + d.quantity + '</td>' +
                                    '<td class="text-center">' +
                                    '<input type="number" class="form-control qty-actual-input text-center" ' +
                                    'name="qtyActual[]" form="groForm" min="0" max="' + remaining + '" value="' + defaultActual + '" ' +
                                    'data-remaining="' + remaining + '" required style="width:100px;margin:auto;">' +
                                    '<input type="hidden" name="productId[]" form="groForm" value="' + d.productId + '">' +
                                    '<input type="hidden" name="qtyExpected[]" form="groForm" value="' + d.quantity + '">' +
                                    '</td>' +
                                    '<td class="text-center"><span class="remaining-display font-weight-bold" style="color:#0EA5E9;">0</span></td>' +
                                    '<td class="text-center font-weight-bold" style="color:#6366F1;">' + currentStock + '</td>' +
                                    '</tr>';
                            });
                            submitBtn.disabled = false;
                        }
                        tbody.innerHTML = html;
                        tbody.querySelectorAll('.qty-actual-input').forEach(function (input) {
                            input.addEventListener('input', updateDiffInRow);
                            input.addEventListener('change', updateDiffInRow);
                            // Trigger initial diff calculation
                            updateDiffInRow({ target: input });
                        });
                        // Re-check capacity whenever PO products are loaded
                        updateCapacityBadge();
                    }

                    function updateDiffInRow(e) {
                        var row = e.target.closest('tr');
                        if (!row) return;
                        var actualInput = row.querySelector('input[name="qtyActual[]"]');
                        var span = row.querySelector('.remaining-display');
                        if (!actualInput || !span) return;
                        var maxRemaining = parseInt(actualInput.getAttribute('data-remaining'), 10) || 0;
                        var actual = parseInt(actualInput.value, 10) || 0;
                        if (actual < 0) {
                            actual = 0;
                            actualInput.value = 0;
                        }
                        if (actual > maxRemaining) {
                            actual = maxRemaining;
                            actualInput.value = maxRemaining;
                        }
                        var leftover = maxRemaining - actual;
                        span.textContent = leftover;
                        span.className = 'remaining-display font-weight-bold ' + (leftover <= 0 ? 'diff-ok' : 'diff-warn');
                        span.style.color = leftover <= 0 ? '#22C55E' : '#EF4444';
                        // Re-check qty vs capacity whenever actual qty changes
                        var sel = document.getElementById('locationSelect');
                        var opt = sel ? sel.options[sel.selectedIndex] : null;
                        if (opt && opt.value) {
                            var cap = opt.getAttribute('data-maxcapacity');
                            var stock = opt.getAttribute('data-currentstock');
                            var capNum = (cap !== null && cap !== '' && cap !== 'null') ? parseInt(cap, 10) : null;
                            var stockNum = (stock !== null && stock !== '' && stock !== 'null') ? parseInt(stock, 10) : 0;
                            if (capNum !== null) {
                                checkQtyVsCapacity(capNum - stockNum);
                            }
                        }
                    }

                    // On page load: if preloaded PO exists, render it
                    window.addEventListener('DOMContentLoaded', function () {
                        if (window.preloadedPO) {
                            renderProducts(
                                window.preloadedPO.id,
                                window.preloadedPO.code,
                                window.preloadedPO.supplier,
                                window.preloadedPO.details
                            );
                        }
                        // Also bind change event
                        document.getElementById('poSelect').addEventListener('change', loadPOProducts);
                        // When location changes, reload PO products to get updated stock & remaining
                        document.getElementById('locationSelect').addEventListener('change', function () {
                            updateCapacityBadge();
                            // Re-fetch PO products with new locationId for stock data
                            var poId = document.getElementById('poSelect').value;
                            if (poId) loadPOProducts();
                        });
                    });

                    // ---- Location capacity badge & full-validation ----
                    function updateCapacityBadge() {
                        var sel = document.getElementById('locationSelect');
                        var badge = document.getElementById('capacity-badge');
                        var valEl = document.getElementById('capacity-value');
                        var opt = sel.options[sel.selectedIndex];

                        // Remove any previous full-warning
                        var prevWarn = document.getElementById('location-full-warning');
                        if (prevWarn) prevWarn.remove();

                        if (!opt || !opt.value) {
                            badge.style.display = 'none';
                            return;
                        }
                        var cap = opt.getAttribute('data-maxcapacity');
                        var stock = opt.getAttribute('data-currentstock');
                        var capNum = (cap !== null && cap !== '' && cap !== 'null') ? parseInt(cap, 10) : null;
                        var stockNum = (stock !== null && stock !== '' && stock !== 'null') ? parseInt(stock, 10) : 0;

                        if (capNum !== null) {
                            valEl.textContent = stockNum.toLocaleString() + ' / ' + capNum.toLocaleString() + ' units';
                            var remaining = capNum - stockNum;
                            if (remaining <= 0) {
                                // Location is completely full
                                badge.style.background = '#FEE2E2';
                                badge.style.borderColor = '#FCA5A5';
                                badge.style.color = '#DC2626';
                                var warnBox = document.getElementById('capacity-warnings');
                                warnBox.innerHTML = '<div id="location-full-warning" class="alert alert-danger mt-2 mb-0" style="border-radius:10px;">'
                                    + '<i class="fas fa-exclamation-triangle mr-2"></i>'
                                    + 'Kho <strong> ' + opt.text.trim() + '</strong>  đã đầy (<strong>' + stockNum + ' / ' + capNum + '</strong> units). Vui lòng chọn kho khác!'
                                    + '</div>';
                                document.getElementById('submitBtn').disabled = true;
                            } else {
                                badge.style.background = '#EFF6FF';
                                badge.style.borderColor = '#BFDBFE';
                                badge.style.color = '#1D4ED8';
                                checkQtyVsCapacity(remaining);
                            }
                        } else {
                            valEl.textContent = stockNum.toLocaleString() + ' units (no limit)';
                            badge.style.background = '#EFF6FF';
                            badge.style.borderColor = '#BFDBFE';
                            badge.style.color = '#1D4ED8';
                        }
                        badge.style.display = 'inline-flex';
                        badge.style.alignItems = 'center';
                    }

                    function getTotalActualQty() {
                        var total = 0;
                        document.querySelectorAll('input[name="qtyActual[]"]').forEach(function (inp) {
                            total += parseInt(inp.value, 10) || 0;
                        });
                        return total;
                    }

                    function checkQtyVsCapacity(remaining) {
                        var warnBox = document.getElementById('capacity-warnings');
                        // Xóa warning cũ (chỉ xóa qty-capacity, giữ full-warning nếu có)
                        var prevQtyWarn = document.getElementById('qty-capacity-warning');
                        if (prevQtyWarn) prevQtyWarn.remove();

                        var totalQty = getTotalActualQty();
                        var submitBtn = document.getElementById('submitBtn');
                        var items = document.querySelectorAll('input[name="productId[]"]');
                        if (items.length === 0) return; // no PO selected yet

                        if (remaining !== undefined && totalQty > remaining) {
                            warnBox.innerHTML = '<div id="qty-capacity-warning" class="alert alert-warning mt-2 mb-0" style="border-radius:10px;">'
                                + '<i class="fas fa-exclamation-circle mr-2"></i>'
                                + 'Tổng số lượng nhận (<strong>' + totalQty + '</strong>) vượt quá sức chứa còn lại của kho (<strong>' + remaining + '</strong> units). '
                                + 'Vui lòng giảm số lượng hoặc chọn kho khác.'
                                + '</div>';
                            submitBtn.disabled = true;
                        } else {
                            if (items.length > 0) submitBtn.disabled = false;
                        }
                    }

                    function showFlashMsg(msg, isError) {
                        var container = document.getElementById('js-flash-msg');
                        var alertClass = isError ? 'alert-danger' : 'alert-success';
                        var iconClass = isError ? 'fa-exclamation-triangle' : 'fa-check-circle';
                        container.innerHTML = '<div class="alert ' + alertClass + ' alert-dismissible fade show"><i class="fas ' + iconClass + ' mr-2"></i>' + msg + '<button type="button" class="close" data-dismiss="alert">&times;</button></div>';
                        window.scrollTo(0, 0);
                    }

                    // Form validation
                    document.getElementById('groForm').addEventListener('submit', function (e) {
                        var items = document.querySelectorAll('input[name="productId[]"]');
                        if (items.length === 0) {
                            e.preventDefault();
                            showFlashMsg('Please select Purchase Order before confirming!', true);
                            return;
                        }

                        var invalid = false;
                        document.querySelectorAll('#product-tbody tr').forEach(function (row) {
                            var actualInput = row.querySelector('input[name="qtyActual[]"]');
                            if (!actualInput) return;
                            var remaining = parseInt(actualInput.getAttribute('data-remaining'), 10) || 0;
                            var actual = parseInt(actualInput.value, 10) || 0;
                            if (actual > remaining) {
                                actualInput.style.borderColor = '#EF4444';
                                actualInput.style.boxShadow = '0 0 0 3px rgba(239,68,68,.2)';
                                invalid = true;
                            } else {
                                actualInput.style.borderColor = '';
                                actualInput.style.boxShadow = '';
                            }
                        });

                        if (invalid) {
                            e.preventDefault();
                            showFlashMsg('Actual Received Qty cannot exceed Remaining Qty. Please correct the highlighted rows.', true);
                        }
                    });

                </script>
            </body>

            </html>