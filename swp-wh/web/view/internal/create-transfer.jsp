<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Create Internal Transfer | InventoryPro</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
            <style>
                body {
                    background-color: #f8fafc;

                }

                .content-page {
                    padding-top: 0px !important;
                }

                .container-fluid {
                    padding-top: 0 !important;
                }

                .page-header {
                    padding: 1rem 0 0.5rem 0;
                    margin-bottom: 0.5rem !important;
                }

                .card-form {
                    border-radius: 12px;
                    border: none;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    background: white;
                }

                .form-label {
                    font-weight: 700;
                    color: #334155;
                    margin-bottom: 8px;
                }

                .step-title {
                    font-size: 1.1rem;
                    font-weight: 800;
                    color: #2563eb;
                    margin-bottom: 15px;
                    padding-bottom: 8px;
                    border-bottom: 2px solid #eff6ff;
                }

                .form-control-custom {
                    height: 48px;
                    border-radius: 10px;
                    border: 1px solid #e2e8f0;
                }

                .loading-spinner {
                    display: none;
                    font-size: 0.85rem;
                    color: #64748b;
                    margin-top: 5px;
                }

                /* Product Table */
                .product-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .product-table th {
                    background: #f8fafc;
                    color: #64748b;
                    font-size: 0.75rem;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    padding: 10px 12px;
                    border-bottom: 2px solid #e2e8f0;
                }

                .product-table td {
                    padding: 10px 12px;
                    border-bottom: 1px solid #f1f5f9;
                    vertical-align: middle;
                }

                .product-table tr:hover {
                    background: #f8fafc;
                }

                .product-table .qty-input {
                    width: 80px;
                    height: 36px;
                    border-radius: 8px;
                    border: 1px solid #e2e8f0;
                    text-align: center;
                    font-weight: 600;
                }

                .product-table .qty-input:focus {
                    border-color: #2563eb;
                    outline: none;
                    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
                }

                .product-table .chk-product {
                    width: 18px;
                    height: 18px;
                    cursor: pointer;
                }

                .badge-stock {
                    background: #dcfce7;
                    color: #166534;
                    padding: 3px 8px;
                    border-radius: 6px;
                    font-weight: 700;
                    font-size: 0.8rem;
                }

                .badge-capacity {
                    background: #e0f2fe;
                    color: #0369a1;
                    padding: 3px 8px;
                    border-radius: 6px;
                    font-weight: 700;
                    font-size: 0.8rem;
                }

                .empty-state {
                    text-align: center;
                    padding: 30px;
                    color: #94a3b8;
                }

                .empty-state i {
                    font-size: 2rem;
                    margin-bottom: 10px;
                    display: block;
                }

                .validation-error {
                    color: #dc2626;
                    font-size: 0.8rem;
                    margin-top: 4px;
                }

                .info-badge {
                    display: inline-block;
                    margin-top: 8px;
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <%@ include file="../sidebar.jsp" %>
                    <jsp:include page="../header.jsp" />
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header">
                                <h1 class="font-weight-bold h3">Create Internal Transfer Request</h1>
                                <p class="text-muted">Transfer products between locations within the same warehouse.</p>
                            </div>

                            <div class="row">
                                <div class="col-lg-10 offset-lg-1">
                                    <c:if test="${not empty sessionScope.err}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <strong>Error:</strong> ${sessionScope.err}
                                            <button type="button" class="close"
                                                data-dismiss="alert"><span>&times;</span></button>
                                        </div>
                                        <% session.removeAttribute("err"); %>
                                    </c:if>
                                    <div id="js-flash-msg"></div>

                                    <div class="card card-form">
                                        <div class="card-body p-4">
                                            <form action="internal-transfer" method="post" id="transferForm">
                                                <input type="hidden" name="action" value="create">
                                                <!-- Hidden container for multi-page selection -->
                                                <div id="consolidatedInputs" style="display:none;"></div>

                                                <!-- STEP 1: SOURCE & DESTINATION LOCATION -->
                                                <div class="row mb-4">
                                                    <div class="col-md-6">
                                                        <div class="step-title"><i class="ri-map-pin-line mr-1"></i>
                                                            Step 1: Source Location</div>
                                                        <label class="form-label">Select where to transfer FROM</label>
                                                        <select id="fromLoc" name="fromLoc"
                                                            class="form-control form-control-custom" required
                                                            onchange="onSourceLocationChange()">
                                                            <option value="">-- Select Source Location --</option>
                                                            <c:forEach var="loc" items="${locations}">
                                                                <option value="${loc.id}"
                                                                    data-current="${loc.currentStock}"
                                                                    data-max="${loc.maxCapacity}">
                                                                    ${loc.locationName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div id="srcInfo" class="info-badge" style="display:none;">
                                                            <span class="badge-stock">Stock: <span
                                                                    id="srcStock">0</span></span>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="step-title"><i class="ri-map-pin-add-line mr-1"></i>
                                                            Step 2: Destination Location</div>
                                                        <label class="form-label">Select where to transfer TO</label>
                                                        <select id="toLoc" name="toLoc"
                                                            class="form-control form-control-custom" required
                                                            onchange="onDestLocationChange()">
                                                            <option value="">-- Select Destination Location --</option>
                                                            <c:forEach var="loc" items="${locations}">
                                                                <option value="${loc.id}"
                                                                    data-current="${loc.currentStock}"
                                                                    data-max="${loc.maxCapacity}">
                                                                    ${loc.locationName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div id="destInfo" class="info-badge" style="display:none;">
                                                            <span class="badge-capacity">Capacity: <span
                                                                    id="destCap">0/0</span></span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- STEP 3: SELECT PRODUCTS -->
                                                <div class="mb-4">
                                                    <div class="step-title"><i class="ri-car-line mr-1"></i> Step 3:
                                                        Select Products to Transfer</div>
                                                    <div id="loadingProducts" class="loading-spinner">
                                                        <i class="ri-loader-4-line ri-spin mr-1"></i> Loading products
                                                        from source location...
                                                    </div>
                                                    <div id="productListContainer">
                                                        <div class="empty-state" id="emptyProducts">
                                                            <i class="ri-inbox-line"></i>
                                                            <p>Please select a Source Location first to see available
                                                                products.</p>
                                                        </div>
                                                        <table class="product-table" id="productTable"
                                                            style="display:none;">
                                                            <thead>
                                                                <tr>
                                                                    <th style="width:40px;"><input type="checkbox"
                                                                            id="checkAll" onclick="toggleAll(this)"
                                                                            class="chk-product"></th>
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
                                                        <!-- Pagination UI -->
                                                        <div id="productPagination"
                                                            class="mt-3 d-flex justify-content-between align-items-center"
                                                            style="display:none !important;">
                                                            <span class="text-muted small" id="pageInfo">Items 1-5 of
                                                                10</span>
                                                            <div class="btn-group btn-group-sm">
                                                                <button type="button" class="btn btn-outline-primary"
                                                                    onclick="changePage(-1)" id="prevBtn"><i
                                                                        class="ri-arrow-left-s-line"></i> Prev</button>
                                                                <div id="pageNumberButtons"
                                                                    class="btn-group btn-group-sm"></div>
                                                                <button type="button" class="btn btn-outline-primary"
                                                                    onclick="changePage(1)" id="nextBtn">Next <i
                                                                        class="ri-arrow-right-s-line"></i></button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div id="productError" class="validation-error"
                                                        style="display:none;"></div>
                                                </div>

                                                <!-- REASON -->
                                                <div class="mb-4 border-top pt-4">
                                                    <label class="form-label">Reason for Transfer</label>
                                                    <select name="note" class="form-control form-control-custom">
                                                        <option value="Stock Replenishment">Stock Replenishment</option>
                                                        <option value="Showroom Display">Showroom Display</option>
                                                        <option value="Rebalancing">Rebalancing</option>
                                                        <option value="Other">Other</option>
                                                    </select>
                                                </div>

                                                <div class="d-flex justify-content-end mt-4">
                                                    <a href="internal-transfer"
                                                        class="btn btn-light px-4 mr-3">Cancel</a>
                                                    <button type="submit" class="btn btn-primary px-5" id="submitBtn">
                                                        <i class="ri-send-plane-fill mr-1"></i> Submit Transfer Request
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
                let allProducts = [];
                let currentPage = 1;
                let windowStart = 1;
                const pageSize = 3;

                function onSourceLocationChange() {
                    const fromLoc = document.getElementById('fromLoc');
                    const selected = fromLoc.options[fromLoc.selectedIndex];
                    const srcInfo = document.getElementById('srcInfo');

                    if (selected && selected.value) {
                        document.getElementById('srcStock').textContent = selected.dataset.current;
                        srcInfo.style.display = 'block';
                    } else {
                        srcInfo.style.display = 'none';
                    }

                    applyMutualExclusion();
                    loadProducts();
                }

                function onDestLocationChange() {
                    const toLoc = document.getElementById('toLoc');
                    const selected = toLoc.options[toLoc.selectedIndex];
                    const destInfo = document.getElementById('destInfo');

                    if (selected && selected.value) {
                        document.getElementById('destCap').textContent = selected.dataset.current + '/' + selected.dataset.max;
                        destInfo.style.display = 'block';
                    } else {
                        destInfo.style.display = 'none';
                    }

                    applyMutualExclusion();
                    validateAll();
                }

                function applyMutualExclusion() {
                    const fromLoc = document.getElementById('fromLoc');
                    const toLoc = document.getElementById('toLoc');
                    const fromId = fromLoc.value;
                    const toId = toLoc.value;

                    for (let i = 0; i < toLoc.options.length; i++) {
                        const opt = toLoc.options[i];
                        if (opt.value === "") continue;
                        opt.style.display = (opt.value === fromId && fromId) ? "none" : "block";
                    }

                    for (let i = 0; i < fromLoc.options.length; i++) {
                        if (fromLoc.options[i].value === "") continue;
                        fromLoc.options[i].style.display = (fromLoc.options[i].value === toId && toId !== "") ? "none" : "block";
                    }
                }

                function loadProducts() {
                    const fromLocId = document.getElementById('fromLoc').value;
                    const table = document.getElementById('productTable');
                    const empty = document.getElementById('emptyProducts');
                    const loading = document.getElementById('loadingProducts');
                    const pagination = document.getElementById('productPagination');

                    allProducts = [];
                    currentPage = 1;
                    windowStart = 1;
                    table.style.display = 'none';
                    empty.style.display = 'none';
                    pagination.style.setProperty('display', 'none', 'important');

                    if (!fromLocId) {
                        empty.style.display = 'block';
                        return;
                    }

                    loading.style.display = 'block';
                    fetch(contextPath + "/internal-transfer?action=getProductsByLocation&locId=" + fromLocId)
                        .then(res => res.json())
                        .then(data => {
                            loading.style.display = 'none';
                            if (!data || data.length === 0) {
                                empty.style.display = 'block';
                                empty.innerHTML = '<i class="ri-inbox-line"></i><p>No products found at this location.</p>';
                                return;
                            }
                            allProducts = data.map(item => ({ ...item, selected: false, transferQty: 1 }));
                            table.style.display = 'table';
                            if (allProducts.length > pageSize) {
                                pagination.style.setProperty('display', 'flex', 'important');
                            }
                            renderPage();
                        })
                        .catch(err => {
                            loading.style.display = 'none';
                            empty.style.display = 'block';
                            empty.innerHTML = '<i class="ri-error-warning-line"></i><p>Error: ' + err.message + '</p>';
                        });
                }

                function renderPage() {
                    const tbody = document.getElementById('productTableBody');
                    const start = (currentPage - 1) * pageSize;
                    const end = Math.min(start + pageSize, allProducts.length);
                    const totalPages = Math.ceil(allProducts.length / pageSize);

                    let rows = '';
                    allProducts.slice(start, end).forEach((item, i) => {
                        const globalIdx = start + i;
                        rows += '<tr>' +
                            '<td><input type="checkbox" class="chk-product" value="' + item.pdId + '" ' + (item.selected ? 'checked' : '') + ' onchange="onCheckProduct(' + globalIdx + ', this)"></td>' +
                            '<td class="font-weight-bold">' + item.productName + '</td>' +
                            '<td><code>' + item.serialNumber + '</code></td>' +
                            '<td>' + item.color + '</td>' +
                            '<td><span class="badge-stock">' + item.available + '</span></td>' +
                            '<td><input type="number" class="qty-input" min="1" max="' + item.available + '" value="' + item.transferQty + '" ' + (!item.selected ? 'disabled' : '') + ' onchange="onQtyChange(' + globalIdx + ', this)"></td>' +
                            '</tr>';
                    });
                    tbody.innerHTML = rows;

                    let btns = '';
                    const endWindow = Math.min(totalPages, windowStart + 2);
                    for (let i = windowStart; i <= endWindow; i++) {
                        btns += '<button type="button" class="btn ' + (i === currentPage ? 'btn-primary' : 'btn-outline-primary') + '" onclick="goToPage(' + i + ')">' + i + '</button>';
                    }
                    document.getElementById('pageNumberButtons').innerHTML = btns;

                    document.getElementById('pageInfo').textContent = 'Items ' + (start + 1) + '-' + end + ' of ' + allProducts.length;
                    document.getElementById('prevBtn').disabled = (currentPage === 1);
                    document.getElementById('nextBtn').disabled = (currentPage === totalPages);
                    document.getElementById('checkAll').checked = (end > start && allProducts.slice(start, end).every(p => p.selected));
                }

                function goToPage(p) {
                    currentPage = p;
                    renderPage();
                }

                function changePage(delta) {
                    const totalPages = Math.ceil(allProducts.length / pageSize);
                    const nextP = currentPage + delta;
                    if (nextP >= 1 && nextP <= totalPages) {
                        currentPage = nextP;
                        if (currentPage > windowStart + 2) windowStart++;
                        if (currentPage < windowStart) windowStart--;
                        renderPage();
                    }
                }

                function onCheckProduct(globalIdx, chk) {
                    allProducts[globalIdx].selected = chk.checked;
                    renderPage();
                    validateAll();
                }

                function onQtyChange(globalIdx, input) {
                    allProducts[globalIdx].transferQty = parseInt(input.value) || 1;
                    validateAll();
                }

                function toggleAll(masterChk) {
                    const start = (currentPage - 1) * pageSize;
                    const end = Math.min(start + pageSize, allProducts.length);
                    for (let i = start; i < end; i++) {
                        allProducts[i].selected = masterChk.checked;
                    }
                    renderPage();
                    validateAll();
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
                        allProducts.forEach(item => {
                            if (item.selected) {
                                totalTransferQty += item.transferQty;
                            }
                        });

                        if (totalTransferQty > availableSpace && availableSpace >= 0) {
                            errorDiv.textContent = 'Total transfer quantity (' + totalTransferQty + ') exceeds destination capacity (' + availableSpace + ' available)!';
                            errorDiv.style.display = 'block';
                            submitBtn.disabled = true;
                            return false;
                        }
                    }

                    // Check individual quantity vs available
                    for (let item of allProducts) {
                        if (item.selected) {
                            if (item.transferQty > item.available) {
                                errorDiv.textContent = 'Quantity for ' + item.productName + ' exceeds available stock!';
                                errorDiv.style.display = 'block';
                                submitBtn.disabled = true;
                                return false;
                            }
                            if (item.transferQty < 1) {
                                errorDiv.textContent = 'Quantity for ' + item.productName + ' must be at least 1!';
                                errorDiv.style.display = 'block';
                                submitBtn.disabled = true;
                                return false;
                            }
                        }
                    }
                    return true;
                }

                function showFlashMsg(msg) {
                    var container = document.getElementById('js-flash-msg');
                    container.innerHTML = '<div class="alert alert-danger alert-dismissible fade show" role="alert"><strong>Error:</strong> ' + msg + '<button type="button" class="close" data-dismiss="alert"><span>&times;</span></button></div>';
                    window.scrollTo(0, 0);
                }

                document.getElementById('transferForm').onsubmit = function (e) {
                    const selectedOnes = allProducts.filter(p => p.selected);
                    if (selectedOnes.length === 0) {
                        showFlashMsg('Please select at least one product to transfer!');
                        return false;
                    }

                    const fromLoc = document.getElementById('fromLoc').value;
                    const toLoc = document.getElementById('toLoc').value;
                    if (!fromLoc || !toLoc) {
                        showFlashMsg('Please select both Source and Destination locations!');
                        return false;
                    }
                    if (fromLoc === toLoc) {
                        showFlashMsg('Source and Destination must be different!');
                        return false;
                    }

                    if (!validateAll()) return false;

                    // CONSOLIDATE DATA FROM ALL PAGES
                    const container = document.getElementById('consolidatedInputs');
                    container.innerHTML = '';
                    selectedOnes.forEach(p => {
                        container.innerHTML += '<input type="hidden" name="selectedProducts" value="' + p.pdId + '">';
                        container.innerHTML += '<input type="hidden" name="qty_' + p.pdId + '" value="' + p.transferQty + '">';
                    });

                    return confirm('Are you sure you want to submit this transfer request with ' + selectedOnes.length + ' product(s)?');
                };
            </script>
        </body>

        </html>