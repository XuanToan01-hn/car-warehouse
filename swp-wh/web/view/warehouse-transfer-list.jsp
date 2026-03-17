<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Warehouse Transfers | InventoryPro</title>

                <link
                    href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">

                <style>
                    :root {
                        --primary: #0EA5E9;
                        --success: #10b981;
                        --danger: #ef4444;
                        --warning: #f59e0b;
                        --info: #3b82f6;
                        --gray-dark: #0f172a;
                    }

                    body {
                        font-family: 'Be Vietnam Pro', sans-serif;
                        background-color: #f8fafc;
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

                    .filter-section {
                        padding: 1.5rem;
                        background: #fff;
                        border-bottom: 1px solid #f1f5f9;
                    }

                    .form-control,
                    .form-select {
                        border-radius: 10px;
                        border: 1px solid #e2e8f0;
                        padding: 0.6rem 1rem;
                        font-size: 0.9rem;
                    }

                    .form-control:focus,
                    .form-select:focus {
                        border-color: var(--primary);
                        box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
                    }

                    .btn-filter {
                        background: var(--primary);
                        color: white;
                        border-radius: 10px;
                        padding: 0.6rem 1.5rem;
                        font-weight: 600;
                        border: none;
                        transition: all 0.3s;
                    }

                    .btn-filter:hover {
                        background: #0284c7;
                        color: white;
                    }

                    .table thead th {
                        background: #f1f5f9;
                        font-weight: 800;
                        color: #475569;
                        text-transform: uppercase;
                        font-size: 0.75rem;
                        letter-spacing: 0.05em;
                        padding: 1.25rem 1.5rem;
                        border-bottom: 1px solid #e2e8f0;
                    }

                    .table tbody td {
                        padding: 1.25rem 1.5rem;
                        vertical-align: middle;
                        font-weight: 500;
                        border-bottom: 1px solid #f1f5f9;
                    }

                    .btn-action {
                        padding: 0.5rem 1rem;
                        border-radius: 8px;
                        font-weight: 600;
                        font-size: 0.85rem;
                        border: 1px solid transparent;
                        transition: all 0.2s;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        cursor: pointer;
                    }

                    .btn-out {
                        background: #fff7ed;
                        color: #9a3412;
                        border-color: #ffedd5;
                    }

                    .btn-out:hover {
                        background: #ffedd5;
                    }

                    .btn-in {
                        background: #ecfdf5;
                        color: #065f46;
                        border-color: #d1fae5;
                    }

                    .btn-in:hover {
                        background: #d1fae5;
                    }

                    .badge-status {
                        padding: 0.4rem 1rem;
                        border-radius: 8px;
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                        display: inline-block;
                    }

                    .badge-pending {
                        background: #fff7ed;
                        color: #9a3412;
                        border: 1px solid #ffedd5;
                    }

                    .badge-approved {
                        background: #f0fdf4;
                        color: #166534;
                        border: 1px solid #dcfce7;
                    }

                    .badge-intransit {
                        background: #eff6ff;
                        color: #1e40af;
                        border: 1px solid #dbeafe;
                    }

                    .badge-completed {
                        background: #f1f5f9;
                        color: #475569;
                        border: 1px solid #e2e8f0;
                    }

                    .progress-mini {
                        height: 6px;
                        width: 100px;
                        background: #e2e8f0;
                        border-radius: 10px;
                        margin-top: 8px;
                        overflow: hidden;
                    }

                    .progress-bar-fill {
                        height: 100%;
                        border-radius: 10px;
                        transition: width 0.3s;
                    }

                    .fill-step1 {
                        width: 25%;
                        background: var(--warning);
                    }

                    .fill-step2 {
                        width: 50%;
                        background: var(--success);
                    }

                    .fill-step3out {
                        width: 75%;
                        background: var(--primary);
                    }

                    .fill-step3in {
                        width: 100%;
                        background: var(--gray-dark);
                    }

                    .location-info {
                        display: flex;
                        flex-direction: column;
                    }

                    .warehouse-name {
                        font-size: 0.75rem;
                        color: #64748b;
                        font-weight: 400;
                    }

                    /* Modal Styles */
                    .modal-content {
                        border-radius: 24px;
                        border: none;
                        box-shadow: 0 25px 70px rgba(0, 0, 0, 0.15);
                        overflow: hidden;
                    }

                    .modal-header {
                        border-bottom: 1px solid #f8fafc;
                        padding: 1.2rem 2rem;
                        background: #fff;
                    }

                    .modal-body {
                        padding: 1.5rem 2rem;
                        background: #fff;
                    }

                    .info-section {
                        background: #fcfdfe;
                        border-radius: 16px;
                        padding: 1.2rem;
                        margin-bottom: 1.25rem;
                        border: 1px solid #edf2f7;
                    }

                    .detail-label {
                        font-size: 0.75rem;
                        text-transform: uppercase;
                        color: #64748b;
                        font-weight: 800;
                        letter-spacing: 0.08em;
                        margin-bottom: 0.5rem;
                        display: block;
                    }

                    .detail-value {
                        font-size: 1.1rem;
                        color: #1e293b;
                        font-weight: 600;
                    }

                    .route-node {
                        display: flex;
                        align-items: center;
                        background: white;
                        border: 1px solid #f1f5f9;
                        padding: 0.8rem 1rem;
                        border-radius: 12px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
                    }

                    .route-line {
                        width: 35px;
                        height: 2px;
                        background: #e2e8f0;
                        margin: 0 10px;
                        position: relative;
                    }

                    .product-banner {
                        background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                        border-left: 5px solid #0ea5e9;
                        padding: 1.2rem;
                        border-radius: 14px;
                        margin-bottom: 1.5rem;
                    }

                    .rounded-xl {
                        border-radius: 10px !important;
                    }

                    .btn-view {
                        background: #f1f5f9;
                        color: #475569;
                        border: 1px solid #e2e8f0;
                    }

                    .btn-view:hover {
                        background: #e2e8f0;
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <%@ include file="sidebar.jsp" %>
                        <div class="content-page">
                            <div class="container-fluid">
                                <div class="page-header">
                                    <div>
                                        <h1 class="font-weight-bold h2">Warehouse Operations</h1>
                                        <p class="text-muted mb-0">Capture Transfer In/Out</p>
                                    </div>
                                    <a href="internal-transfer" class="btn btn-primary"><i class="ri-list-check"></i>
                                        View Requests</a>
                                </div>

                                <c:if test="${not empty sessionScope.msg}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="ri-checkbox-circle-line mr-2"></i> ${sessionScope.msg}
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <% session.removeAttribute("msg"); %>
                                </c:if>

                                <c:if test="${not empty sessionScope.err}">
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <i class="ri-error-warning-line mr-2"></i> ${sessionScope.err}
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <% session.removeAttribute("err"); %>
                                </c:if>

                                <div class="card card-main">
                                    <div class="filter-section">
                                        <form action="warehouse-transfer" method="get" class="row align-items-end">
                                            <div class="col-md-3">
                                                <label
                                                    class="font-weight-bold small text-uppercase text-secondary">Transfer
                                                    Code</label>
                                                <input type="text" name="code" class="form-control"
                                                    placeholder="Search code..." value="${searchCode}">
                                            </div>
                                            <div class="col-md-3">
                                                <label
                                                    class="font-weight-bold small text-uppercase text-secondary">Status</label>
                                                <select name="status" class="form-control">
                                                    <option value="">All Statuses</option>
                                                    <option value="1" ${selectedStatus==1 ? 'selected' : '' }>Approved
                                                    </option>
                                                    <option value="2" ${selectedStatus==2 ? 'selected' : '' }>In-Transit
                                                    </option>
                                                    <option value="3" ${selectedStatus==3 ? 'selected' : '' }>Completed
                                                    </option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label
                                                    class="font-weight-bold small text-uppercase text-secondary">Warehouse</label>
                                                <select name="warehouseId" class="form-control">
                                                    <option value="">All Warehouses</option>
                                                    <c:forEach var="w" items="${warehouses}">
                                                        <option value="${w.id}" ${selectedWarehouse==w.id ? 'selected'
                                                            : '' }>${w.warehouseName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <button type="submit" class="btn btn-filter w-100">
                                                    <i class="ri-filter-3-line mr-1"></i> Apply Filters
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table mb-0">
                                                <thead>
                                                    <tr>
                                                        <th>Transfer Code</th>
                                                        <th>From Location</th>
                                                        <th>To Location</th>
                                                        <th>Status</th>
                                                        <th class="text-right">Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="t" items="${transfers}">
                                                        <tr>
                                                            <td>
                                                                <a href="javascript:void(0)"
                                                                    onclick="viewDetail(${t.id})"
                                                                    class="font-weight-bold text-primary">${t.transferCode}</a>
                                                            </td>
                                                            <td>
                                                                <div class="location-info">
                                                                    <span
                                                                        class="font-weight-bold">${t.fromLocationName}</span>
                                                                    <span
                                                                        class="warehouse-name">${t.fromWarehouseName}</span>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <div class="location-info">
                                                                    <span
                                                                        class="font-weight-bold">${t.toLocationName}</span>
                                                                    <span
                                                                        class="warehouse-name">${t.toWarehouseName}</span>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${t.status == 0}">
                                                                        <span
                                                                            class="badge-status badge-pending">Pending</span>
                                                                        <div class="progress-mini">
                                                                            <div class="progress-bar-fill fill-step1">
                                                                            </div>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${t.status == 1}">
                                                                        <span
                                                                            class="badge-status badge-approved">Approved</span>
                                                                        <div class="progress-mini">
                                                                            <div class="progress-bar-fill fill-step2">
                                                                            </div>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${t.status == 2}">
                                                                        <span
                                                                            class="badge-status badge-intransit">In-Transit</span>
                                                                        <div class="progress-mini">
                                                                            <div
                                                                                class="progress-bar-fill fill-step3out">
                                                                            </div>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${t.status == 3}">
                                                                        <span
                                                                            class="badge-status badge-completed">Completed</span>
                                                                        <div class="progress-mini">
                                                                            <div class="progress-bar-fill fill-step3in">
                                                                            </div>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="badge badge-secondary">Cancelled</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-right">
                                                                <c:if test="${t.status == 1}">
                                                                    <form action="warehouse-transfer" method="post"
                                                                        style="display:inline;">
                                                                        <input type="hidden" name="action"
                                                                            value="transferOut">
                                                                        <input type="hidden" name="transferId"
                                                                            value="${t.id}">
                                                                        <input type="hidden" name="code"
                                                                            value="${searchCode}">
                                                                        <input type="hidden" name="status"
                                                                            value="${selectedStatus}">
                                                                        <input type="hidden" name="warehouseId"
                                                                            value="${selectedWarehouse}">
                                                                        <button type="submit" class="btn-action btn-out"
                                                                            onclick="return confirm('Confirm Export for ${t.transferCode}?')">
                                                                            <i class="ri-logout-box-r-line"></i>
                                                                            Confirm Export
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                                <c:if test="${t.status == 2}">
                                                                    <form action="warehouse-transfer" method="post"
                                                                        style="display:inline;">
                                                                        <input type="hidden" name="action"
                                                                            value="transferIn">
                                                                        <input type="hidden" name="transferId"
                                                                            value="${t.id}">
                                                                        <input type="hidden" name="code"
                                                                            value="${searchCode}">
                                                                        <input type="hidden" name="status"
                                                                            value="${selectedStatus}">
                                                                        <input type="hidden" name="warehouseId"
                                                                            value="${selectedWarehouse}">
                                                                        <button type="submit" class="btn-action btn-in"
                                                                            onclick="return confirm('Confirm transfer IN for ${t.transferCode}?')">
                                                                            <i class="ri-login-box-r-line"></i> Confirm
                                                                            Transfer IN
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                                <c:if test="${t.status == 3}">
                                                                    <span class="text-success font-weight-bold mr-2"><i
                                                                            class="ri-check-double-line"></i>
                                                                        Completed</span>
                                                                </c:if>
                                                                <button class="btn-action btn-view"
                                                                    onclick="viewDetail(${t.id})">
                                                                    <i class="ri-eye-line"></i> View
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty transfers}">
                                                        <tr>
                                                            <td colspan="5" class="text-center py-5">
                                                                <div class="text-secondary">
                                                                    <i class="ri-inbox-line ri-3x mb-3 d-block"></i>
                                                                    <p class="mb-0">No transfers found matching your
                                                                        filters.</p>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                </div>

                <!-- Detail Modal -->
                <div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title font-weight-bold">Detail Transfer</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div id="loadingDetail" class="text-center py-4">
                                    <div class="spinner-border text-primary" role="status"></div>
                                    <p class="mt-2 text-muted">Loading...</p>
                                </div>
                                <div id="detailContent" style="display: none;">
                                    <!-- Header Info -->
                                    <div class="row mb-3">
                                        <div class="col-md-7">
                                            <span class="detail-label text-primary">Transfer Code</span>
                                            <span id="dtCode" class="detail-value h5 font-weight-bold mb-0"></span>
                                        </div>
                                        <div class="col-md-5 text-md-right border-left pl-4">
                                            <span class="detail-label">Total Quantity</span>
                                            <div class="d-flex align-items-baseline justify-content-md-end">
                                                <span id="dtQty" class="text-dark font-weight-bold h3 mb-0"></span>
                                                <span class="text-muted ml-1" style="font-size: 1rem;">pcs</span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <!-- Left Column: Product & Note -->
                                        <div class="col-md-6">
                                            <div class="product-banner mb-3">
                                                <span class="detail-label text-primary">Car / Product</span>
                                                <div id="dtProduct" class="detail-value font-weight-bold truncate-2"
                                                    style="font-size: 1.15rem;"></div>
                                            </div>
                                            <div class="info-section mb-0" style="padding: 1rem;">
                                                <span class="detail-label">Reason / Note</span>
                                                <div class="p-2 border rounded bg-white text-muted"
                                                    style="min-height: 80px;">
                                                    <span id="dtNote"
                                                        style="font-style: italic; line-height: 1.5; display: block; font-size: 0.95rem;"></span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Right Column: Route -->
                                        <div class="col-md-6">
                                            <div class="info-section h-100 mb-0">
                                                <span class="detail-label">Transfer Route</span>
                                                <div class="d-flex flex-column gap-3 mt-2">
                                                    <div class="route-node">
                                                        <i class="ri-map-pin-2-fill text-danger mr-3"
                                                            style="font-size: 1.2rem;"></i>
                                                        <div style="line-height: 1.3;">
                                                            <small class="text-muted d-block"
                                                                style="font-size: 0.75rem;">EXPORT (SOURCE)</small>
                                                            <span id="dtFrom" style="font-size: 1rem;"></span>
                                                        </div>
                                                    </div>
                                                    <div class="text-center my-1">
                                                        <i class="ri-arrow-down-line text-muted h4 mb-0"></i>
                                                    </div>
                                                    <div class="route-node">
                                                        <i class="ri-checkbox-circle-fill text-success mr-3"
                                                            style="font-size: 1.2rem;"></i>
                                                        <div style="line-height: 1.3;">
                                                            <small class="text-muted d-block"
                                                                style="font-size: 0.75rem;">IMPORT (DESTINATION)</small>
                                                            <span id="dtTo" style="font-size: 1rem;"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Actions (Dynamic) -->
                                    <div id="modalActions" class="d-flex justify-content-end mt-4 pt-3 border-top">
                                        <!-- Buttons will be injected by JS -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
                <script>
                    function viewDetail(id) {
                        $('#detailModal').modal('show');
                        $('#loadingDetail').show();
                        $('#detailContent').hide();

                        fetch('${pageContext.request.contextPath}/internal-transfer?action=getDetail&id=' + id)
                            .then(res => res.json())
                            .then(data => {
                                $('#loadingDetail').hide();
                                $('#dtCode').text(data.code);
                                $('#dtFrom').text(data.from);
                                $('#dtTo').text(data.to);
                                $('#dtProduct').text(data.product);
                                $('#dtQty').text(data.qty);
                                $('#dtNote').text(data.note || 'Không có ghi chú');

                                // Build actions
                                let actionsRoot = document.getElementById('modalActions');
                                actionsRoot.innerHTML = '';

                                if (data.status === 1) { // Approved -> Can Transfer Out
                                    actionsRoot.innerHTML = `
                                        <form action="warehouse-transfer" method="post">
                                            <input type="hidden" name="action" value="transferOut">
                                            <input type="hidden" name="transferId" value="${data.id}">
                                            <button type="submit" class="btn btn-outline-warning px-4 rounded-xl font-weight-bold" 
                                                    onclick="return confirm('Confirm Export for ${data.code}?')">
                                                <i class="ri-logout-box-r-line mr-1"></i> Confirm Export
                                            </button>
                                        </form>
                                    `;
                                } else if (data.status === 2) { // In-Transit -> Can Transfer In
                                    actionsRoot.innerHTML = `
                                        <form action="warehouse-transfer" method="post">
                                            <input type="hidden" name="action" value="transferIn">
                                            <input type="hidden" name="transferId" value="${data.id}">
                                            <button type="submit" class="btn btn-success px-5 rounded-xl font-weight-bold shadow-sm" 
                                                    onclick="return confirm('Confirm Import for ${data.code}?')">
                                                <i class="ri-login-box-r-line mr-1"></i> Confirm Import
                                            </button>
                                        </form>
                                    `;
                                } else if (data.status === 3) {
                                    actionsRoot.innerHTML = '<span class="text-success font-weight-bold"><i class="ri-checkbox-circle-fill mr-1"></i> Đã hoàn thành vận chuyển</span>';
                                } else {
                                    actionsRoot.innerHTML = '<button type="button" class="btn btn-secondary px-4 rounded-xl" data-dismiss="modal">Đóng</button>';
                                }

                                $('#detailContent').fadeIn();
                            })
                            .catch(err => {
                                console.error(err);
                                alert('Error loading detail');
                                $('#detailModal').modal('hide');
                            });
                    }
                </script>
            </body>

            </html>