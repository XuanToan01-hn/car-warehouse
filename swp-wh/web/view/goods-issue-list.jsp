<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Goods Issue Management | InventoryPro</title>

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
                        --warning: #f59e0b;
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

                    .btn-process {
                        background: #f0f9ff;
                        color: #0369a1;
                        border: 1px solid #bae6fd;
                        border-radius: 10px;
                        padding: 0.5rem 1rem;
                        font-weight: 700;
                        font-size: 0.85rem;
                        transition: all 0.2s;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .btn-process:hover {
                        background: var(--primary);
                        color: white;
                        transform: translateY(-1px);
                        box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
                    }

                    .badge-custom {
                        padding: 0.5rem 0.8rem;
                        border-radius: 8px;
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                        letter-spacing: 0.03em;
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
                                    <h1 class="font-weight-bold mb-1">Goods Issue Management</h1>
                                    <p class="text-secondary mb-0">List of Sales Orders and their warehouse shipment
                                        status.
                                    </p>
                                </div>
                                <div class="d-flex gap-3">
                                    <div class="search-box position-relative">
                                        <i class="ri-search-line position-absolute"
                                            style="left: 1rem; top: 50%; transform: translateY(-50%); color: #64748b;"></i>
                                        <input type="text" id="searchOrders" class="form-control"
                                            style="border-radius: 12px; padding-left: 2.5rem; width: 300px; height: 45px; border: 2px solid #e2e8f0; font-weight: 500;"
                                            placeholder="Search code or customer...">
                                    </div>
                                    <select id="statusFilter" class="form-control"
                                        style="border-radius: 12px; width: 180px; height: 45px; border: 2px solid #e2e8f0; font-weight: 600; color: #1e293b;">
                                        <option value="all">All Statuses</option>
                                        <option value="1">Created</option>
                                        <option value="2">Partial</option>
                                        <option value="3">Completed</option>
                                    </select>
                                </div>
                            </div>

                            <c:if test="${param.msg == 'success'}">
                                <div class="alert alert-success border-0 shadow-sm mb-4"
                                    style="border-radius: 12px; background: #ecfdf5; color: #065f46;">
                                    <div class="d-flex align-items-center">
                                        <i class="ri-checkbox-circle-fill mr-2" style="font-size: 1.25rem;"></i>
                                        <strong>Success!</strong> Goods Issue has been confirmed and stock updated.
                                    </div>
                                </div>
                            </c:if>

                            <div class="card card-main">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0" id="orderTable">
                                            <thead>
                                                <tr>
                                                    <th>Order Code</th>
                                                    <th>Customer</th>
                                                    <th>Date</th>
                                                    <th class="text-center">Ordered</th>
                                                    <th class="text-center">Remaining</th>
                                                    <th class="text-center">Status</th>
                                                    <th class="text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="o" items="${orders}">
                                                    <tr class="order-row" data-code="${o.orderCode.toLowerCase()}"
                                                        data-customer="${o.customer.name.toLowerCase()}"
                                                        data-status="${o.status}">
                                                        <td>
                                                            <div class="font-weight-800 text-primary"
                                                                style="font-size: 1.05rem;">
                                                                ${o.orderCode}
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="font-weight-600 text-dark">${o.customer.name}
                                                            </div>
                                                        </td>
                                                        <td class="text-secondary" style="font-size: 0.9rem;">
                                                            <fmt:formatDate value="${o.createdDate}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td class="text-center font-weight-700">${o.orderedQty}</td>
                                                        <td class="text-center">
                                                            <span class="badge badge-pill px-3 py-2"
                                                                style="background: #f1f5f9; color: var(--primary); font-weight: 800;">
                                                                ${o.orderedQty - o.deliveredQty}
                                                            </span>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${o.status == 1}">
                                                                    <span class="badge-custom"
                                                                        style="background: #e0f2fe; color: #0369a1;">Created</span>
                                                                </c:when>
                                                                <c:when test="${o.status == 2}">
                                                                    <span class="badge-custom"
                                                                        style="background: #fef3c7; color: #92400e;">Partial</span>
                                                                </c:when>
                                                                <c:when test="${o.status == 3}">
                                                                    <span class="badge-custom"
                                                                        style="background: #dcfce7; color: #166534;">Completed</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right">
                                                            <c:if test="${o.status != 3}">
                                                                <a href="goods-issue?action=create&soId=${o.id}"
                                                                    class="btn-process">
                                                                    <i class="ri-truck-line"></i> Process Shipment
                                                                </a>
                                                            </c:if>
                                                            <c:if test="${o.status == 3}">
                                                                <span class="text-muted font-italic"
                                                                    style="font-size: 0.8rem;">Fully Shipped</span>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty orders}">
                                                    <tr>
                                                        <td colspan="7" class="text-center py-5"
                                                            style="background: #f8fafc;">
                                                            <i
                                                                class="ri-inbox-line display-4 text-muted d-block opacity-25"></i>
                                                            <p class="text-secondary mt-3 font-weight-600">No pending
                                                                sales orders found.</p>
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

                <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.0.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
                <script>
                    $(document).ready(function () {
                        const $search = $('#searchOrders');
                        const $filter = $('#statusFilter');
                        const $rows = $('.order-row');

                        function doFilter() {
                            const q = $search.val().toLowerCase().trim();
                            const status = $filter.val();

                            $rows.each(function () {
                                const code = $(this).data('code');
                                const customer = $(this).data('customer');
                                const rowStatus = $(this).data('status').toString();

                                const matchesSearch = !q || code.includes(q) || customer.includes(q);
                                const matchesStatus = status === 'all' || rowStatus === status;

                                $(this).toggle(matchesSearch && matchesStatus);
                            });
                        }

                        $search.on('input', doFilter);
                        $filter.on('change', doFilter);
                    });
                </script>
            </body>

            </html>