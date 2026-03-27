<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Create External Transfer | InventoryPro</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    <style>
        body { background-color: #f8fafc; }
        .card-form { border-radius: 12px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); background: white; }
        .form-label { font-weight: 700; color: #334155; margin-bottom: 8px; }
        .step-title { font-size: 1.1rem; font-weight: 800; color: #f97316; margin-bottom: 15px; padding-bottom: 8px; border-bottom: 2px solid #fff7ed; }
        .form-control-custom { height: 48px; border-radius: 10px; border: 1px solid #e2e8f0; }
        .loading-spinner { display: none; font-size: 0.85rem; color: #64748b; margin-top: 5px; }

        .product-table { width: 100%; border-collapse: collapse; }
        .product-table th { background: #f8fafc; color: #64748b; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; padding: 10px 12px; border-bottom: 2px solid #e2e8f0; }
        .product-table td { padding: 10px 12px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .product-table tr:hover { background: #f8fafc; }
        .product-table .qty-input { width: 80px; height: 36px; border-radius: 8px; border: 1px solid #e2e8f0; text-align: center; font-weight: 600; }
        .product-table .qty-input:focus { border-color: #f97316; outline: none; box-shadow: 0 0 0 3px rgba(249,115,22,0.1); }
        .product-table .chk-product { width: 18px; height: 18px; cursor: pointer; }

        .badge-stock { background: #dcfce7; color: #166534; padding: 3px 8px; border-radius: 6px; font-weight: 700; font-size: 0.8rem; }
        .badge-capacity { background: #e0f2fe; color: #0369a1; padding: 3px 8px; border-radius: 6px; font-weight: 700; font-size: 0.8rem; }
        .badge-wh { background: #fff7ed; color: #f97316; padding: 3px 8px; border-radius: 6px; font-weight: 700; font-size: 0.8rem; }

        .empty-state { text-align: center; padding: 30px; color: #94a3b8; }
        .empty-state i { font-size: 2rem; margin-bottom: 10px; display: block; }

        .validation-error { color: #dc2626; font-size: 0.8rem; margin-top: 4px; }
        .info-badge { display: inline-block; margin-top: 8px; }

        .step-section { border: 1px solid #f1f5f9; border-radius: 10px; padding: 20px; margin-bottom: 20px; background: #fafafa; }
    </style>
</head>

<body>
    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>
        <jsp:include page="header.jsp" />
        <div class="content-page">
            <div class="container-fluid">
                <div class="page-header mb-4">
                    <h1 class="font-weight-bold h3">Create External Transfer Request</h1>
                    <p class="text-muted">Transfer products between <strong>different warehouses</strong>.</p>
                </div>

                <div class="row">
                    <div class="col-lg-10 offset-lg-1">
                        <c:if test="${not empty sessionScope.err}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <strong>Error:</strong> ${sessionScope.err}
                                <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                            </div>
                            <% session.removeAttribute("err"); %>
                        </c:if>
                        <div id="js-flash-msg"></div>

                        <div class="card card-form">
                            <div class="card-body p-4">
                                <form action="external-transfer" method="post" id="transferForm">
                                    <input type="hidden" name="action" value="create">

                                    <!-- STEP 1: WAREHOUSES -->
                                    <div class="step-section">
                                        <div class="step-title"><i class="ri-building-line mr-1"></i> Step 1: Select Warehouses</div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <label class="form-label">Source Warehouse <small class="text-muted">(your warehouse)</small></label>
                                                <select id="fromWh" name="fromWh" class="form-control form-control-custom" required style="background-color: #f1f5f9; font-weight: 700;">
                                                    <c:forEach var="wh" items="${warehouses}">
                                                        <c:if test="${wh.id == userWarehouseId}">
                                                            <option value="${wh.id}" selected>${wh.warehouseName}</option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                                <input type="hidden" name="fromWh" value="${userWarehouseId}">
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Destination Warehouse</label>
                                                <select id="toWh" name="toWh" class="form-control form-control-custom" required onchange="onDestWhChange()">
                                                    <option value="">-- Select Destination Warehouse --</option>
                                                    <c:forEach var="wh" items="${warehouses}">
                                                        <c:if test="${wh.id != userWarehouseId}">
                                                            <option value="${wh.id}">${wh.warehouseName}</option>
                                                        </c:if>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- STEP 2: LOCATIONS -->
                                    <div class="step-section">
                                        <div class="step-title"><i class="ri-map-pin-line mr-1"></i> Step 2: Select Locations</div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <label class="form-label">Source Location</label>
                                                <select id="fromLoc" name="fromLoc" class="form-control form-control-custom" required disabled onchange="onSourceLocChange()">
                                                    <option value="">-- Select Source Location --</option>
                                                </select>
                                                <div id="loadingSrcLoc" class="loading-spinner">
                                                    <i class="ri-loader-4-line ri-spin mr-1"></i> Loading locations...
                                                </div>
                                                <div id="srcInfo" class="info-badge" style="display:none;">
                                                    <span class="badge-stock">Stock: <span id="srcStock">0</span></span>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label">Destination Location</label>
                                                <select id="toLoc" name="toLoc" class="form-control form-control-custom" required disabled onchange="onDestLocChange()">
                                                    <option value="">-- Select Destination Location --</option>
                                                </select>
                                                <div id="loadingDestLoc" class="loading-spinner">
                                                    <i class="ri-loader-4-line ri-spin mr-1"></i> Loading locations...
                                                </div>
                                                <div id="destInfo" class="info-badge" style="display:none;">
                                                    <span class="badge-capacity">Capacity: <span id="destCap">0/0</span></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- STEP 3: PRODUCTS -->
                                    <div class="step-section">
                                        <div class="step-title"><i class="ri-car-line mr-1"></i> Step 3: Select Products to Transfer</div>
                                        <div id="loadingProducts" class="loading-spinner">
                                            <i class="ri-loader-4-line ri-spin mr-1"></i> Loading products...
                                        </div>
                                        <div id="productListContainer">
                                            <div class="empty-state" id="emptyProducts">
                                                <i class="ri-inbox-line"></i>
                                                <p>Please select Source Warehouse & Location first to see available products.</p>
                                            </div>
                                            <table class="product-table" id="productTable" style="display:none;">
                                                <thead>
                                                    <tr>
                                                        <th style="width:40px;"><input type="checkbox" id="checkAll" onclick="toggleAll(this)" class="chk-product"></th>
                                                        <th>Product</th>
                                                        <th>Serial / VIN</th>
                                                        <th>Color</th>
                                                        <th>Available</th>
                                                        <th style="width:120px;">Transfer Qty</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="productTableBody">
                                                </tbody>
                                            </table>
                                        </div>
                                        <div id="productError" class="validation-error" style="display:none;"></div>
                                    </div>

                                    <!-- REASON -->
                                    <div class="mb-4">
                                        <label class="form-label">Reason for Transfer</label>
                                        <select name="note" class="form-control form-control-custom">
                                            <option value="Inter-Warehouse Restock">Inter-Warehouse Restock</option>
                                            <option value="Customer Demand Allocation">Customer Demand Allocation</option>
                                            <option value="Emergency Relief">Emergency Relief</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>

                                    <div class="d-flex justify-content-end mt-4">
                                        <a href="external-transfer" class="btn btn-light px-4 mr-3">Cancel</a>
                                        <button type="submit" class="btn btn-primary px-5" id="submitBtn" style="background: #f97316; border-color: #f97316;">
                                            <i class="ri-send-plane-fill mr-1"></i> Submit External Transfer
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script>
        const contextPath = "${pageContext.request.contextPath}";

        // ===== STEP 1: Warehouse selection =====
        function onSourceWhChange() {
            const fromWhId = document.getElementById('fromWh').value;
            applyWhExclusion();

            // Load source locations
            const fromLoc = document.getElementById('fromLoc');
            fromLoc.innerHTML = '<option value="">-- Select Source Location --</option>';
            fromLoc.disabled = true;
            document.getElementById('srcInfo').style.display = 'none';
            clearProducts();

            if (!fromWhId) return;

            document.getElementById('loadingSrcLoc').style.display = 'block';
            fetch(contextPath + "/external-transfer?action=getLocationsByWarehouse&whId=" + fromWhId)
                .then(res => res.json())
                .then(data => {
                    document.getElementById('loadingSrcLoc').style.display = 'none';
                    if (data.length === 0) {
                        fromLoc.innerHTML = '<option value="">(No locations found)</option>';
                        return;
                    }
                    fromLoc.disabled = false;
                    data.forEach(item => {
                        const opt = document.createElement('option');
                        opt.value = item.id;
                        opt.text = item.name;
                        opt.dataset.current = item.current;
                        opt.dataset.max = item.max;
                        fromLoc.appendChild(opt);
                    });
                })
                .catch(() => { document.getElementById('loadingSrcLoc').style.display = 'none'; });
        }

        function onDestWhChange() {
            const toWhId = document.getElementById('toWh').value;
            applyWhExclusion();

            const toLoc = document.getElementById('toLoc');
            toLoc.innerHTML = '<option value="">-- Select Destination Location --</option>';
            toLoc.disabled = true;
            document.getElementById('destInfo').style.display = 'none';

            if (!toWhId) return;

            document.getElementById('loadingDestLoc').style.display = 'block';
            fetch(contextPath + "/external-transfer?action=getLocationsByWarehouse&whId=" + toWhId)
                .then(res => res.json())
                .then(data => {
                    document.getElementById('loadingDestLoc').style.display = 'none';
                    if (data.length === 0) {
                        toLoc.innerHTML = '<option value="">(No locations found)</option>';
                        return;
                    }
                    toLoc.disabled = false;
                    data.forEach(item => {
                        const opt = document.createElement('option');
                        opt.value = item.id;
                        opt.text = item.name;
                        opt.dataset.current = item.current;
                        opt.dataset.max = item.max;
                        toLoc.appendChild(opt);
                    });
                })
                .catch(() => { document.getElementById('loadingDestLoc').style.display = 'none'; });
        }

        function applyWhExclusion() {
            const fromWhId = document.getElementById('fromWh').value;
            const toWhId = document.getElementById('toWh').value;
            const toOpts = document.getElementById('toWh').options;
            const fromOpts = document.getElementById('fromWh').options;

            for (let i = 0; i < toOpts.length; i++) {
                if (toOpts[i].value === "") continue;
                toOpts[i].style.display = (toOpts[i].value === fromWhId && fromWhId) ? "none" : "block";
            }
            for (let i = 0; i < fromOpts.length; i++) {
                if (fromOpts[i].value === "") continue;
                fromOpts[i].style.display = (fromOpts[i].value === toWhId && toWhId) ? "none" : "block";
            }
        }

        // ===== STEP 2: Location selection =====
        function onSourceLocChange() {
            const fromLoc = document.getElementById('fromLoc');
            const sel = fromLoc.options[fromLoc.selectedIndex];
            const srcInfo = document.getElementById('srcInfo');

            if (sel && sel.value) {
                document.getElementById('srcStock').textContent = sel.dataset.current;
                srcInfo.style.display = 'block';
            } else {
                srcInfo.style.display = 'none';
            }
            loadProducts();
        }

        function onDestLocChange() {
            const toLoc = document.getElementById('toLoc');
            const sel = toLoc.options[toLoc.selectedIndex];
            const destInfo = document.getElementById('destInfo');

            if (sel && sel.value) {
                document.getElementById('destCap').textContent = sel.dataset.current + '/' + sel.dataset.max;
                destInfo.style.display = 'block';
            } else {
                destInfo.style.display = 'none';
            }
            validateAll();
        }

        // ===== STEP 3: Products =====
        function clearProducts() {
            document.getElementById('productTableBody').innerHTML = '';
            document.getElementById('productTable').style.display = 'none';
            document.getElementById('emptyProducts').style.display = 'block';
            document.getElementById('emptyProducts').innerHTML = '<i class="ri-inbox-line"></i><p>Please select Source Location first.</p>';
        }

        function loadProducts() {
            const fromLocId = document.getElementById('fromLoc').value;
            const tbody = document.getElementById('productTableBody');
            const table = document.getElementById('productTable');
            const empty = document.getElementById('emptyProducts');
            const loading = document.getElementById('loadingProducts');

            tbody.innerHTML = '';
            table.style.display = 'none';
            empty.style.display = 'none';

            if (!fromLocId) {
                clearProducts();
                return;
            }

            loading.style.display = 'block';
            fetch(contextPath + "/external-transfer?action=getProductsByLocation&locId=" + fromLocId)
                .then(res => res.json())
                .then(data => {
                    loading.style.display = 'none';
                    if (!data || data.length === 0) {
                        empty.style.display = 'block';
                        empty.innerHTML = '<i class="ri-inbox-line"></i><p>No products found at this location.</p>';
                        return;
                    }
                    table.style.display = 'table';
                    data.forEach((item, idx) => {
                        const tr = document.createElement('tr');
                        tr.innerHTML =
                            '<td><input type="checkbox" class="chk-product" name="selectedProducts" value="' + item.pdId + '" onchange="onCheckProduct(this, ' + idx + ')"></td>' +
                            '<td class="font-weight-bold">' + item.productName + '</td>' +
                            '<td><code>' + item.serialNumber + '</code></td>' +
                            '<td>' + item.color + '</td>' +
                            '<td><span class="badge-stock">' + item.available + '</span></td>' +
                            '<td><input type="number" class="qty-input" name="qty_' + item.pdId + '" id="qty_' + idx + '" min="1" max="' + item.available + '" value="1" disabled onchange="validateAll()"></td>';
                        tbody.appendChild(tr);
                    });
                })
                .catch(err => {
                    loading.style.display = 'none';
                    empty.style.display = 'block';
                    empty.innerHTML = '<i class="ri-error-warning-line"></i><p>Error: ' + err.message + '</p>';
                });
        }

        function onCheckProduct(chk, idx) {
            const qtyInput = document.getElementById('qty_' + idx);
            qtyInput.disabled = !chk.checked;
            if (!chk.checked) qtyInput.value = 1;
            validateAll();
        }

        function toggleAll(masterChk) {
            const checkboxes = document.querySelectorAll('input[name="selectedProducts"]');
            checkboxes.forEach((chk, idx) => {
                chk.checked = masterChk.checked;
                onCheckProduct(chk, idx);
            });
        }

        function validateAll() {
            const errorDiv = document.getElementById('productError');
            const submitBtn = document.getElementById('submitBtn');
            errorDiv.style.display = 'none';
            submitBtn.disabled = false;

            // Check destination capacity
            const toLoc = document.getElementById('toLoc');
            const toSel = toLoc.options[toLoc.selectedIndex];
            if (toSel && toSel.value) {
                const maxCap = parseInt(toSel.dataset.max);
                const currentStock = parseInt(toSel.dataset.current);
                const availableSpace = maxCap - currentStock;

                let totalTransferQty = 0;
                document.querySelectorAll('input[name="selectedProducts"]:checked').forEach(chk => {
                    const qtyInput = chk.closest('tr').querySelector('.qty-input');
                    totalTransferQty += parseInt(qtyInput.value) || 0;
                });

                if (totalTransferQty > availableSpace && availableSpace >= 0) {
                    errorDiv.textContent = 'Total quantity (' + totalTransferQty + ') exceeds destination capacity (' + availableSpace + ' available)!';
                    errorDiv.style.display = 'block';
                    submitBtn.disabled = true;
                    return false;
                }
            }

            // Check individual qty
            const checked = document.querySelectorAll('input[name="selectedProducts"]:checked');
            for (let chk of checked) {
                const qtyInput = chk.closest('tr').querySelector('.qty-input');
                const qty = parseInt(qtyInput.value);
                const max = parseInt(qtyInput.max);
                if (qty > max) {
                    errorDiv.textContent = 'Quantity exceeds available stock for one or more products!';
                    errorDiv.style.display = 'block';
                    submitBtn.disabled = true;
                    return false;
                }
                if (qty < 1) {
                    errorDiv.textContent = 'Quantity must be at least 1!';
                    errorDiv.style.display = 'block';
                    submitBtn.disabled = true;
                    return false;
                }
            }
            return true;
        }

        function showFlashMsg(msg) {
            var container = document.getElementById('js-flash-msg');
            container.innerHTML = '<div class="alert alert-danger alert-dismissible fade show" role="alert"><strong>Error:</strong> ' + msg + '<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
            window.scrollTo(0, 0);
        }

        document.getElementById('transferForm').onsubmit = function(e) {
            const checked = document.querySelectorAll('input[name="selectedProducts"]:checked');
            if (checked.length === 0) {
                showFlashMsg('Please select at least one product to transfer!');
                return false;
            }

            const fromWh = document.getElementById('fromWh').value;
            const toWh = document.getElementById('toWh').value;
            if (!fromWh || !toWh) {
                showFlashMsg('Please select both Source and Destination warehouses!');
                return false;
            }
            if (fromWh === toWh) {
                showFlashMsg('External transfers must be between different warehouses!');
                return false;
            }

            const fromLoc = document.getElementById('fromLoc').value;
            const toLoc = document.getElementById('toLoc').value;
            if (!fromLoc || !toLoc) {
                showFlashMsg('Please select both Source and Destination locations!');
                return false;
            }

            if (!validateAll()) return false;
            return confirm('Submit external transfer with ' + checked.length + ' product(s)?');
        };
    </script>
</body>
</html>
