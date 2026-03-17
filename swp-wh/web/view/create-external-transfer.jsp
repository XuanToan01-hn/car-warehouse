<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Create External Transfer Request | InventoryPro</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    <style>
        body { background-color: #f8fafc; }
        .card-form { border-radius: 12px; border: none; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05); background: white; }
        .form-label { font-weight: 700; color: #334155; margin-bottom: 8px; }
        .stock-badge { background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 6px; font-weight: 700; font-size: 0.9rem; display: none; margin-top: 8px; }
        .step-title { font-size: 1.1rem; font-weight: 800; color: #2563eb; margin-bottom: 15px; }
        .form-control-custom { height: 48px; border-radius: 10px; border: 1px solid #e2e8f0; }
        .loading-spinner { display: none; font-size: 0.85rem; color: #64748b; margin-top: 5px; }
    </style>
</head>

<body>
<div class="wrapper">
    <%@ include file="sidebar.jsp" %>
    <div class="content-page">
        <div class="container-fluid">
            <div class="page-header mb-4">
                <h1 class="font-weight-bold h3">Create New External Transfer Request</h1>
                <p class="text-muted">Transfer products between different warehouses.</p>
            </div>

            <div class="row">
                <div class="col-lg-10 offset-lg-1">
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
                            <form action="external-transfer" method="post" id="transferForm">
                                <input type="hidden" name="action" value="create">

                                <!-- STEP 1: PRODUCT -->
                                <div class="form-group mb-4">
                                    <div class="step-title">Step 1: Select Vehicle / Product</div>
                                    <label class="form-label">Vehicle Name & VIN</label>
                                    <select name="pdId" id="pdId" class="form-control form-control-custom" required onchange="onProductChange()">
                                        <option value="">-- Select specific product --</option>
                                        <c:forEach var="pd" items="${productDetails}">
                                            <option value="${pd.id}">[${pd.serialNumber}] ${pd.product.name} - ${pd.color}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="row">
                                    <!-- STEP 2: SOURCE -->
                                    <div class="col-md-6 mb-4">
                                        <div class="step-title">Step 2: Source</div>
                                        
                                        <label class="form-label mt-2">Source Warehouse</label>
                                        <select name="fromWh" id="fromWh" class="form-control form-control-custom" required disabled onchange="onSourceWarehouseChange()">
                                            <option value="">-- Select Source Warehouse --</option>
                                        </select>
                                        <div id="loadingWhLoc" class="loading-spinner">
                                            <i class="ri-loader-4-line ri-spin mr-1"></i> Checking...
                                        </div>

                                        <label class="form-label mt-3">Source Location</label>
                                        <select name="fromLoc" id="fromLoc" class="form-control form-control-custom" required disabled onchange="onSourceLocationChange()">
                                            <option value="">-- Select Original Location --</option>
                                        </select>
                                        <div id="stockBadge" class="stock-badge">
                                            Available: <span id="availQty">0</span> chiếc
                                        </div>
                                    </div>

                                    <!-- STEP 3: DESTINATION -->
                                    <div class="col-md-6 mb-4">
                                        <div class="step-title">Step 3: Destination</div>
                                        
                                        <label class="form-label mt-2">Destination Warehouse</label>
                                        <select name="toWh" id="toWh" class="form-control form-control-custom" required onchange="onDestWarehouseChange()">
                                            <option value="">-- Select Destination Warehouse --</option>
                                            <c:forEach var="wh" items="${warehouses}">
                                                <option value="${wh.id}">${wh.name}</option>
                                            </c:forEach>
                                        </select>
                                        <div id="loadingDestLoc" class="loading-spinner">
                                            <i class="ri-loader-4-line ri-spin mr-1"></i> Checking...
                                        </div>

                                        <label class="form-label mt-3">Destination Location</label>
                                        <select name="toLoc" id="toLoc" class="form-control form-control-custom" required disabled onchange="onDestLocationChange()">
                                            <option value="">-- Select Destination Location --</option>
                                        </select>
                                        <div id="capacityBadge" class="stock-badge" style="background: #e0f2fe; color: #0369a1;">
                                            Capacity: <span id="capInfo">0/0</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="row border-top pt-4">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Quantity</label>
                                        <input type="number" name="qty" id="qty" class="form-control form-control-custom" min="1" value="1" required oninput="validateCapacity()">
                                        <div id="qtyError" class="text-danger small mt-1" style="display: none;"></div>
                                    </div>
                                    <div class="col-md-8 mb-3">
                                        <label class="form-label">Reason</label>
                                        <select name="note" class="form-control form-control-custom">
                                            <option value="Inter-Warehouse Restock">Inter-Warehouse Restock</option>
                                            <option value="Customer Demand Allocation">Customer Demand Allocation</option>
                                            <option value="Emergency Relief">Emergency Relief</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end mt-4">
                                    <a href="external-transfer" class="btn btn-light px-4 mr-3">Cancel</a>
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
        const fromWh = document.getElementById('fromWh');
        const fromLoc = document.getElementById('fromLoc');
        const loading = document.getElementById('loadingWhLoc');

        fromWh.innerHTML = '<option value="">-- Select Source Warehouse --</option>';
        fromWh.disabled = true;
        fromLoc.innerHTML = '<option value="">-- Select Original Location --</option>';
        fromLoc.disabled = true;
        document.getElementById('stockBadge').style.display = 'none';

        if (!pdId) return;

        loading.style.display = 'block';
        fetch("${pageContext.request.contextPath}/external-transfer?action=getWarehousesByProduct&pdId=" + pdId)
            .then(res => res.json())
            .then(data => {
                loading.style.display = 'none';
                if (!data || data.length === 0) {
                    fromWh.innerHTML = '<option value="">(No stock found)</option>';
                } else {
                    fromWh.disabled = false;
                    data.forEach(item => {
                        const opt = document.createElement('option');
                        opt.value = item.id;
                        opt.text = item.name;
                        fromWh.appendChild(opt);
                    });
                }
                applyMutualExclusion();
            }).catch(e => {
                loading.innerText = 'Error loading warehouses';
            });
    }

    function onSourceWarehouseChange() {
        const pdId = document.getElementById('pdId').value;
        const whId = document.getElementById('fromWh').value;
        const fromLoc = document.getElementById('fromLoc');
        const loading = document.getElementById('loadingWhLoc');

        fromLoc.innerHTML = '<option value="">-- Select Original Location --</option>';
        fromLoc.disabled = true;
        document.getElementById('stockBadge').style.display = 'none';
        applyMutualExclusion();

        if (!whId || !pdId) return;

        loading.style.display = 'block';
        fetch("${pageContext.request.contextPath}/external-transfer?action=getLocationsByWarehouseAndProduct&pdId=" + pdId + "&whId=" + whId)
            .then(res => res.json())
            .then(data => {
                loading.style.display = 'none';
                fromLoc.disabled = false;
                data.forEach(item => {
                    const opt = document.createElement('option');
                    opt.value = item.id;
                    opt.text = item.name;
                    opt.dataset.qty = item.available;
                    fromLoc.appendChild(opt);
                });
            }).catch(e => {
                loading.innerText = 'Error loading locations';
            });
    }

    function onSourceLocationChange() {
        const fromLoc = document.getElementById('fromLoc');
        const selected = fromLoc.options[fromLoc.selectedIndex];
        const badge = document.getElementById('stockBadge');
        if (selected && selected.value !== "") {
            document.getElementById('availQty').innerText = selected.dataset.qty;
            document.getElementById('qty').max = selected.dataset.qty;
            badge.style.display = 'inline-block';
        } else {
            badge.style.display = 'none';
        }
    }

    function onDestWarehouseChange() {
        const whId = document.getElementById('toWh').value;
        const toLoc = document.getElementById('toLoc');
        const loading = document.getElementById('loadingDestLoc');

        toLoc.innerHTML = '<option value="">-- Select Destination Location --</option>';
        toLoc.disabled = true;
        document.getElementById('capacityBadge').style.display = 'none';
        applyMutualExclusion();

        if (!whId) return;

        loading.style.display = 'block';
        fetch("${pageContext.request.contextPath}/external-transfer?action=getLocationsByWarehouse&whId=" + whId)
            .then(res => res.json())
            .then(data => {
                loading.style.display = 'none';
                toLoc.disabled = false;
                data.forEach(item => {
                    const opt = document.createElement('option');
                    opt.value = item.id;
                    opt.text = item.name;
                    opt.dataset.current = item.current;
                    opt.dataset.max = item.max;
                    toLoc.appendChild(opt);
                });
            });
    }

    function onDestLocationChange() {
        const toLoc = document.getElementById('toLoc');
        const selected = toLoc.options[toLoc.selectedIndex];
        const badge = document.getElementById('capacityBadge');
        if (selected && selected.value !== "") {
            document.getElementById('capInfo').innerText = selected.dataset.current + "/" + selected.dataset.max;
            badge.style.display = 'inline-block';
        } else {
            badge.style.display = 'none';
        }
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

    function applyMutualExclusion() {
        const fromWhId = document.getElementById('fromWh').value;
        const toWhOptions = document.getElementById('toWh').options;

        // Hide the selected source warehouse from destination, to ensure it's EXTERNAL transfer
        for (let i = 0; i < toWhOptions.length; i++) {
            if (toWhOptions[i].value === "") continue;
            toWhOptions[i].style.display = (toWhOptions[i].value === fromWhId && fromWhId !== "") ? "none" : "block";
        }
    }

    document.getElementById('transferForm').onsubmit = function (e) {
        const fromWhId = document.getElementById('fromWh').value;
        const toWhId = document.getElementById('toWh').value;

        if (fromWhId === toWhId && fromWhId !== "") {
            alert("External Transfers must be between different warehouses. Please choose different source and destination warehouses.");
            return false;
        }

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
</script>
</body>
</html>
