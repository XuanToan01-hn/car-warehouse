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
                        padding: 0.4rem 0.8rem;
                        border-radius: 8px;
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                        letter-spacing: 0.02em;
                    }

                    .badge-approved {
                        background: #eff6ff;
                        color: #1e40af;
                    }

                    .badge-intransit {
                        background: #fffbeb;
                        color: #92400e;
                    }

                    .badge-completed {
                        background: #ecfdf5;
                        color: #065f46;
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
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <%@ include file="sidebar.jsp" %>
                        <div class="content-page">
                            <div class="container-fluid">
                                <div class="page-header">
                                    <h1 class="font-weight-bold h2">Warehouse Transfers</h1>
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
                                                                <span
                                                                    class="font-weight-bold text-primary">${t.transferCode}</span>
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
                                                                    <c:when test="${t.status == 1}">
                                                                        <span
                                                                            class="badge-status badge-approved">Approved</span>
                                                                    </c:when>
                                                                    <c:when test="${t.status == 2}">
                                                                        <span
                                                                            class="badge-status badge-intransit">In-Transit</span>
                                                                    </c:when>
                                                                    <c:when test="${t.status == 3}">
                                                                        <span
                                                                            class="badge-status badge-completed">Completed</span>
                                                                    </c:when>
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
                                                                            onclick="return confirm('Confirm Transfer Out for ${t.transferCode}?')">
                                                                            <i class="ri-logout-box-r-line"></i>
                                                                            Transfer Out
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
                                                                            onclick="return confirm('Confirm Transfer In for ${t.transferCode}?')">
                                                                            <i class="ri-login-box-r-line"></i> Transfer
                                                                            In
                                                                        </button>
                                                                    </form>
                                                                </c:if>
                                                                <c:if test="${t.status == 3}">
                                                                    <span class="text-success font-weight-bold"><i
                                                                            class="ri-check-double-line"></i>
                                                                        Completed</span>
                                                                </c:if>
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

                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
            </body>

            </html>