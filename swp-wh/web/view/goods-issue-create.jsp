<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Process Goods Issue | InventoryPro</title>

                <link
                    href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">

                <style>
                    :root {
                        --primary: #0EA5E9;
                        --success: #15803d;
                        --gray-dark: #0f172a;
                    }

                    body {
                        font-family: 'Be Vietnam Pro', sans-serif;
                        background-color: #f1f5f9;
                        color: #1e293b;
                    }

                    .page-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 2rem;
                        padding: 1.5rem 0;
                    }

                    .card-main {
                        border-radius: 16px;
                        border: none;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                        background: white;
                        overflow: hidden;
                        margin-bottom: 2rem;
                    }

                    .section-header {
                        font-size: 1rem;
                        font-weight: 800;
                        color: #0f172a;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        padding: 1.25rem 1.5rem;
                        background: #f8fafc;
                        border-bottom: 1px solid #f1f5f9;
                        display: flex;
                        align-items: center;
                        gap: 0.75rem;
                    }

                    .section-header i {
                        color: var(--primary);
                        font-size: 1.2rem;
                    }

                    .info-label {
                        color: #64748b;
                        font-size: 0.75rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        margin-bottom: 0.25rem;
                    }

                    .info-value {
                        color: #1e293b;
                        font-weight: 700;
                        font-size: 1.05rem;
                    }

                    .table thead th {
                        background: #f1f5f9;
                        font-weight: 800;
                        color: #475569;
                        text-transform: uppercase;
                        font-size: 0.75rem;
                        letter-spacing: 0.05em;
                        padding: 1rem 1.5rem;
                        border-bottom: 1px solid #e2e8f0;
                    }

                    .table tbody td {
                        padding: 1rem 1.5rem;
                        vertical-align: middle;
                        font-weight: 500;
                        border-bottom: 1px solid #f1f5f9;
                    }

                    .qty-input {
                        width: 100px;
                        text-align: center;
                        border-radius: 10px;
                        border: 2px solid #e2e8f0;
                        font-weight: 700;
                        padding: 0.5rem;
                        transition: all 0.2s;
                    }

                    .qty-input:focus {
                        border-color: var(--primary);
                        outline: none;
                        box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.1);
                    }

                    .is-invalid {
                        border-color: #ef4444 !important;
                        background-color: #fef2f2 !important;
                    }

                    .btn-standard {
                        border-radius: 12px;
                        padding: 0.75rem 1.5rem;
                        font-weight: 700;
                        transition: all 0.2s;
                    }

                    .btn-save {
                        background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
                        color: white;
                        border: none;
                        box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                    }

                    .btn-save:hover:not(:disabled) {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
                        color: white;
                    }

                    .btn-save:disabled {
                        background: #cbd5e1;
                        box-shadow: none;
                        cursor: not-allowed;
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <jsp:include page="sidebar.jsp" />
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header">
                                <div>
                                    <h1 class="font-weight-bold mb-1">Process Goods Issue</h1>
                                    <p class="text-secondary mb-0">Sales Order: <span
                                            class="text-primary font-weight-bold">${order.orderCode}</span></p>
                                </div>
                                <a href="goods-issue?action=list" class="btn btn-light btn-standard shadow-sm">
                                    <i class="ri-arrow-left-line mr-1"></i> Back to List
                                </a>
                            </div>

                            <c:if test="${param.msg == 'error'}">
                                <div class="alert alert-danger border-0 shadow-sm mb-4" style="border-radius: 12px;">
                                    <strong>Error!</strong> An error occurred during confirmation. Ensure stock is
                                    sufficient.
                                </div>
                            </c:if>

                            <!-- 1️⃣ Order Info & Items -->
                            <div class="card card-main">
                                <div class="section-header">
                                    <i class="ri-information-line"></i> 1. Order Details & Items
                                </div>
                                <div class="card-body">
                                    <div class="row mb-4 px-2">
                                        <div class="col-md-3">
                                            <div class="info-label">Customer</div>
                                            <div class="info-value">${order.customer.name}</div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="info-label">Order Date</div>
                                            <div class="info-value">
                                                <fmt:formatDate value="${order.createdDate}" pattern="dd/MM/yyyy" />
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="info-label">Current Status</div>
                                            <div class="mt-1">
                                                <c:choose>
                                                    <c:when test="${order.status == 1}">
                                                        <span class="badge badge-pill px-3 py-2"
                                                            style="background: #e0f2fe; color: #0369a1; font-weight: 700;">Created</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 2}">
                                                        <span class="badge badge-pill px-3 py-2"
                                                            style="background: #fef3c7; color: #92400e; font-weight: 700;">Partial</span>
                                                    </c:when>
                                                    <c:when test="${order.status == 3}">
                                                        <span class="badge badge-pill px-3 py-2"
                                                            style="background: #dcfce7; color: #166534; font-weight: 700;">Completed</span>
                                                    </c:when>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Product Name</th>
                                                    <th>Lot / Serial Number</th>
                                                    <th class="text-center">Ordered</th>
                                                    <th class="text-center">Remaining</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${details}">
                                                    <tr>
                                                        <td><span class="font-weight-800 text-dark">${r[0]}</span></td>
                                                        <td><code class="px-2 py-1 bg-light rounded text-muted"
                                                                style="font-size: 0.9rem;">${r[1]}</code></td>
                                                        <td class="text-center font-weight-600">${r[2]}</td>
                                                        <td class="text-center font-weight-800 text-primary">${r[4]}
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- 2️⃣ Location Selection -->
                            <div class="card card-main">
                                <div class="section-header">
                                    <i class="ri-home-4-line"></i> 2. Select Source Zone
                                </div>
                                <div class="card-body">
                                    <form action="goods-issue" method="get">
                                        <input type="hidden" name="action" value="create">
                                        <input type="hidden" name="soId" value="${order.id}">
                                        <div class="row align-items-center">
                                            <div class="col-md-5">
                                                <div class="form-group mb-0">
                                                    <label class="info-label">Warehouse Location (Zone)</label>
                                                    <select name="locationId" class="form-control"
                                                        style="border-radius: 12px; height: 50px; font-weight: 600; border: 2px solid #e2e8f0;"
                                                        onchange="this.form.submit()">
                                                        <option value="0">-- Select Zone to view Stock --</option>
                                                        <c:forEach var="l" items="${locations}">
                                                            <option value="${l.id}" ${selectedLocationId==l.id
                                                                ? 'selected' : '' }>
                                                                ${l.locationName} (${l.locationCode})
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-7 pt-4">
                                                <div class="d-flex align-items-center p-3 rounded"
                                                    style="background: #f0f9ff; color: #0369a1; border: 1px solid #bae6fd;">
                                                    <i class="ri-information-fill mr-3" style="font-size: 1.5rem;"></i>
                                                    <span class="font-weight-500">Pick items from this zone. Inventory
                                                        levels below will refresh based on your selection.</span>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- 3️⃣ Quantity Table -->
                            <c:if test="${selectedLocationId > 0}">
                                <form action="goods-issue?action=confirm" method="post" id="issueForm">
                                    <input type="hidden" name="soId" value="${order.id}">
                                    <input type="hidden" name="locationId" value="${selectedLocationId}">

                                    <div class="card card-main p-0">
                                        <div class="section-header">
                                            <i class="ri-list-settings-line"></i> 3. Quantities to Ship
                                        </div>
                                        <div class="table-responsive">
                                            <table class="table mb-0">
                                                <thead>
                                                    <tr>
                                                        <th>Product</th>
                                                        <th>Lot/Serial</th>
                                                        <th class="text-center">Stock At Zone</th>
                                                        <th class="text-center">Remaining</th>
                                                        <th class="text-center" style="width: 180px;">Issue Qty</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="r" items="${details}">
                                                        <tr>
                                                            <td><span class="font-weight-800 text-dark">${r[0]}</span>
                                                            </td>
                                                            <td><code class="text-muted">${r[1]}</code></td>
                                                            <td
                                                                class="text-center font-weight-800 ${r[5] < r[4] ? 'text-danger' : 'text-success'}">
                                                                ${r[5]}
                                                            </td>
                                                            <td class="text-center font-weight-700">${r[4]}</td>
                                                            <td class="text-center">
                                                                <input type="hidden" name="productDetailId"
                                                                    value="${r[6]}">
                                                                <input type="hidden" name="remainingQty"
                                                                    value="${r[4]}">
                                                                <input type="hidden" name="stockQty" value="${r[5]}">
                                                                <input type="number" name="qtyActual" value="0" min="0"
                                                                    class="qty-input mx-auto" oninput="validate()">
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <div class="card card-main">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-12 mb-4">
                                                    <label class="info-label">Shipment Notes / Remissions</label>
                                                    <textarea name="note" class="form-control" rows="3"
                                                        style="border-radius: 12px; border: 2px solid #e2e8f0; font-weight: 500;"
                                                        placeholder="Add tracking number, carrier info, or consignment notes..."></textarea>
                                                </div>
                                                <div class="col-md-12 text-right">
                                                    <a href="goods-issue?action=list"
                                                        class="btn btn-light btn-standard mr-3 shadow-sm">Cancel</a>
                                                    <button type="submit" id="btnConfirm"
                                                        class="btn btn-save btn-standard px-5" disabled>
                                                        Confirm Shipment
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </c:if>

                            <c:if test="${selectedLocationId == 0}">
                                <div class="card card-main py-5 text-center">
                                    <div class="card-body">
                                        <i class="ri-map-pin-line display-3 text-muted opacity-25 d-block mb-3"></i>
                                        <h5 class="text-secondary font-weight-bold">Select a Warehouse Zone in Step 2 to
                                            continue.</h5>
                                        <p class="text-muted">You must specify the physical location from which cars
                                            will be picked.</p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

                <script>
                    function validate() {
                        const btn = document.getElementById('btnConfirm');
                        const inputs = document.querySelectorAll('input[name="qtyActual"]');
                        let anyError = false;
                        let total = 0;

                        inputs.forEach(input => {
                            const row = input.closest('tr');
                            const rem = parseInt(row.querySelector('input[name="remainingQty"]').value);
                            const stock = parseInt(row.querySelector('input[name="stockQty"]').value);
                            const val = parseInt(input.value) || 0;

                            input.classList.remove('is-invalid');
                            if (val < 0 || val > rem || val > stock) {
                                anyError = true;
                                input.classList.add('is-invalid');
                            }
                            total += val;
                        });

                        btn.disabled = anyError || total <= 0;
                    }

                    document.getElementById('issueForm')?.addEventListener('submit', function (e) {
                        if (!confirm('Proceed with this goods issue? Stock will be updated immediately.')) e.preventDefault();
                    });
                </script>
            </body>

            </html>