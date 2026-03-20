<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Create Transfer Request | InventoryPro</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
            <style>
                body {
                    background-color: #f8fafc;
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

                .stock-badge {
                    background: #dcfce7;
                    color: #166534;
                    padding: 4px 10px;
                    border-radius: 6px;
                    font-weight: 700;
                    font-size: 0.9rem;
                    display: none;
                    margin-top: 8px;
                }

                .step-title {
                    font-size: 1.1rem;
                    font-weight: 800;
                    color: #2563eb;
                    margin-bottom: 15px;
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
            </style>
        </head>

        <body>
            <div class="wrapper">
                <%@ include file="sidebar.jsp" %>
                <jsp:include page="header.jsp" />
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header mb-4">
                                <h1 class="font-weight-bold h3">Create New Transfer Request</h1>
                                <p class="text-muted">Follow the steps to complete the request.</p>
                            </div>

                            <div class="row">
                                <div class="col-lg-10 offset-lg-1">
                                    <!-- Alert Error -->
                                    <c:if test="${not empty sessionScope.err}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <strong>Error:</strong> ${sessionScope.err}
                                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <% session.removeAttribute("err"); %>
                                    </c:if>

                                    <div class="card card-form">
                                        <div class="card-body p-4">
                                            <form action="internal-transfer" method="post" id="transferForm">
                                                <input type="hidden" name="action" value="create">

                                                <!-- BƯỚC 1: CHỌN SẢN PHẨM -->
                                                <div class="form-group mb-4">
                                                    <div class="step-title">Step 1: Select Vehicle / Product</div>
                                                    <label class="form-label">Vehicle Name & VIN</label>
                                                    <select name="pdId" id="pdId"
                                                        class="form-control form-control-custom" required
                                                        onchange="onProductChange()">
                                                        <option value="">-- Select specific product --</option>
                                                        <c:forEach var="pd" items="${productDetails}">
                                                            <option value="${pd.id}">[${pd.serialNumber}]
                                                                ${pd.product.name} - ${pd.color}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>

                                                <div class="row">
                                                    <!-- BƯỚC 2: CHỌN KHO XUẤT -->
                                                    <div class="col-md-6 mb-4">
                                                        <div class="step-title">Step 2: Select Source Location</div>
                                                        <label class="form-label">Source Store/Location</label>
                                                        <select name="fromLoc" id="fromLoc"
                                                            class="form-control form-control-custom" required disabled
                                                            onchange="onSourceChange()">
                                                            <option value="">-- Source Location --</option>
                                                        </select>
                                                        <div id="loadingLoc" class="loading-spinner">
                                                            <i class="ri-loader-4-line ri-spin mr-1"></i> Đang tìm kho
                                                            có hàng...
                                                        </div>
                                                        <div id="stockBadge" class="stock-badge">
                                                            Available: <span id="availQty">0</span> chiếc
                                                        </div>
                                                    </div>

                                                    <!-- BƯỚC 3: CHỌN KHO NHẬP -->
                                                    <div class="col-md-6 mb-4">
                                                        <div class="step-title">Step 3: Select Destination Location
                                                        </div>
                                                        <label class="form-label">Destination Store/Location</label>
                                                        <select name="toLoc" id="toLoc"
                                                            class="form-control form-control-custom" required
                                                            onchange="onDestinationChange()">
                                                            <option value="">-- Destination Location --</option>
                                                            <c:forEach var="loc" items="${locations}">
                                                                <option value="${loc.id}"
                                                                    data-current="${loc.currentStock}"
                                                                    data-max="${loc.maxCapacity}">
                                                                    ${loc.locationName} (${loc.warehouseName})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div id="capacityBadge" class="stock-badge"
                                                            style="background: #e0f2fe; color: #0369a1;">
                                                            Capacity: <span id="capInfo">0/0</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- THÔNG TIN BỔ SUNG -->
                                                <div class="row border-top pt-4">
                                                    <div class="col-md-4 mb-3">
                                                        <label class="form-label">Quantity</label>
                                                        <input type="number" name="qty" id="qty"
                                                            class="form-control form-control-custom" min="1" value="1"
                                                            required oninput="validateCapacity()">
                                                        <div id="qtyError" class="text-danger small mt-1"
                                                            style="display: none;"></div>
                                                    </div>
                                                    <div class="col-md-8 mb-3">
                                                        <label class="form-label">Reason</label>
                                                        <select name="note" class="form-control form-control-custom">
                                                            <option value="Stock Replenishment">Stock
                                                                Replenishment</option>
                                                            <option value="Showroom Display">Showroom
                                                                Display</option>
                                                            <option value="Rebalancing">Rebalancing
                                                            </option>
                                                            <option value="Other">Other</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="d-flex justify-content-end mt-4">
                                                    <a href="internal-transfer"
                                                        class="btn btn-light px-4 mr-3">Cancel</a>
                                                    <button type="submit" class="btn btn-primary px-5" id="submitBtn">
                                                        <i class="ri-send-plane-fill mr-1"></i> Submit
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
                function onProductChange() {
                    const pdId = document.getElementById('pdId').value;
                    const fromLoc = document.getElementById('fromLoc');
                    const loading = document.getElementById('loadingLoc');
                    const badge = document.getElementById('stockBadge');

                    // Reset
                    fromLoc.innerHTML = '<option value="">-- Kho đang có hàng --</option>';
                    fromLoc.disabled = true;
                    badge.style.display = 'none';

                    // Reset Step 3
                    document.getElementById('toLoc').value = "";
                    document.getElementById('capacityBadge').style.display = 'none';
                    applyMutualExclusion();

                    if (!pdId) return;

                    console.log("Fetching locations for ProductDetailID:", pdId);
                    loading.style.display = 'block';

                    // AJAX lấy các kho đang chứa sản phẩm này
                    // Dùng dấu cộng chuỗi thay vì Template Literal để tránh xung đột EL trong JSP
                    const url = "${pageContext.request.contextPath}/internal-transfer?action=getLocationsByProduct&pdId=" + pdId;

                    fetch(url)
                        .then(response => {
                            if (!response.ok) throw new Error("Server error: " + response.status);
                            return response.json();
                        })
                        .then(data => {
                            console.log("Data received:", data);
                            loading.style.display = 'none';
                            if (!data || data.length === 0) {
                                fromLoc.innerHTML = '<option value="">(No stock found)</option>';
                            } else {
                                fromLoc.disabled = false;
                                data.forEach(item => {
                                    const opt = document.createElement('option');
                                    opt.value = item.id;
                                    opt.text = item.name;
                                    opt.dataset.qty = item.available;

                                    // Kiểm tra xem kho này có đang được chọn bên Bước 3 không
                                    const toLocId = document.getElementById('toLoc').value;
                                    if (toLocId && item.id == toLocId) {
                                        opt.style.display = 'none';
                                    }

                                    fromLoc.appendChild(opt);
                                });
                            }
                        })
                        .catch(err => {
                            console.error("AJAX Error:", err);
                            loading.innerHTML = '<span class="text-danger">Error: ' + err.message + '</span>';
                        });
                }

                function onSourceChange() {
                    const fromLoc = document.getElementById('fromLoc');
                    const selected = fromLoc.options[fromLoc.selectedIndex];
                    const badge = document.getElementById('stockBadge');
                    const availSpan = document.getElementById('availQty');
                    const qtyInput = document.getElementById('qty');

                    if (selected && selected.value !== "") {
                        const qtyAvailable = selected.dataset.qty;
                        availSpan.innerText = qtyAvailable;
                        badge.style.display = 'inline-block';
                        qtyInput.max = qtyAvailable;
                    } else {
                        badge.style.display = 'none';
                        qtyInput.max = "";
                    }

                    // Cập nhật ẩn/hiện ở Bước 3
                    applyMutualExclusion();
                }

                function onDestinationChange() {
                    const toLoc = document.getElementById('toLoc');
                    const selected = toLoc.options[toLoc.selectedIndex];
                    const badge = document.getElementById('capacityBadge');
                    const capInfo = document.getElementById('capInfo');

                    if (selected && selected.value !== "") {
                        const current = parseInt(selected.dataset.current);
                        const max = parseInt(selected.dataset.max);
                        capInfo.innerText = current + "/" + max;
                        badge.style.display = 'inline-block';
                    } else {
                        badge.style.display = 'none';
                    }

                    // Cập nhật ẩn/hiện ở Bước 2 
                    applyMutualExclusion();
                    validateCapacity();
                }

                function validateCapacity() {
                    const toLoc = document.getElementById('toLoc');
                    const selected = toLoc.options[toLoc.selectedIndex];
                    const qtyInput = document.getElementById('qty');
                    const errorDiv = document.getElementById('qtyError');
                    const submitBtn = document.getElementById('submitBtn');

                    if (!selected || selected.value === "" || !qtyInput.value) {
                        errorDiv.style.display = 'none';
                        submitBtn.disabled = false;
                        return true;
                    }

                    const current = parseInt(selected.dataset.current);
                    const max = parseInt(selected.dataset.max);
                    const requested = parseInt(qtyInput.value);
                    const availableSpace = max - current;

                    if (requested > availableSpace) {
                        errorDiv.innerText = "Destination store only has " + availableSpace + " spots left!";
                        errorDiv.style.display = 'block';
                        submitBtn.disabled = true;
                        return false;
                    } else {
                        errorDiv.style.display = 'none';
                        submitBtn.disabled = false;
                        return true;
                    }
                }

                document.getElementById('transferForm').onsubmit = function (e) {
                    const fromLoc = document.getElementById('fromLoc');
                    const selectedSource = fromLoc.options[fromLoc.selectedIndex];
                    const qtyInput = document.getElementById('qty');

                    if (selectedSource && parseInt(qtyInput.value) > parseInt(selectedSource.dataset.qty)) {
                        alert("Quantity to transfer exceeds stock at the source store!");
                        return false;
                    }

                    if (!validateCapacity()) {
                        alert("Quantity to transfer exceeds capacity of the destination store!");
                        return false;
                    }
                    return true;
                };

                function applyMutualExclusion() {
                    const fromLoc = document.getElementById('fromLoc');
                    const toLoc = document.getElementById('toLoc');

                    const fromId = fromLoc.value;
                    const toId = toLoc.value;

                    // 1. Ẩn kho nguồn khỏi danh sách kho đích
                    const toOptions = toLoc.options;
                    for (let i = 0; i < toOptions.length; i++) {
                        if (toOptions[i].value === "") continue;
                        toOptions[i].style.display = (toOptions[i].value === fromId) ? "none" : "block";
                    }

                    // 2. Ẩn kho đích khỏi danh sách kho nguồn
                    const fromOptions = fromLoc.options;
                    for (let j = 0; j < fromOptions.length; j++) {
                        if (fromOptions[j].value === "") continue;
                        fromOptions[j].style.display = (fromOptions[j].value === toId) ? "none" : "block";
                    }
                }
            </script>
        </body>

        </html>