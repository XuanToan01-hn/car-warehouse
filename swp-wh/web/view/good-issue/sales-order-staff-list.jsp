<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Warehouse Orders | InventoryPro</title>

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
                        --success: #15803D;
                        --warning: #F59E0B;
                        --danger: #EF4444;
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

                    .badge-status {
                        padding: 0.5rem 0.8rem;
                        border-radius: 8px;
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                        letter-spacing: 0.03em;
                    }

                    .status-1 {
                        background: #e0f2fe;
                        color: #0369a1;
                    }

                    /* Created */
                    .status-2 {
                        background: #fef3c7;
                        color: #92400e;
                    }

                    /* Partial */
                    .status-3 {
                        background: #dcfce7;
                        color: #166534;
                    }

                    /* Completed */
                    .status-4 {
                        background: #fee2e2;
                        color: #991b1b;
                    }

                    /* Cancelled */

                    .btn-action {
                        padding: 0.5rem 1rem;
                        border-radius: 10px;
                        font-weight: 700;
                        font-size: 0.85rem;
                        transition: all 0.2s;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        border: 1px solid transparent;
                    }

                    .btn-view {
                        background: #f8fafc;
                        color: #475569;
                        border-color: #e2e8f0;
                    }

                    .btn-view:hover {
                        background: #e2e8f0;
                        color: #1e293b;
                    }

                    .btn-issue {
                        background: #f0f9ff;
                        color: #0369a1;
                        border-color: #bae6fd;
                    }

                    .btn-issue:hover {
                        background: var(--primary);
                        color: white;
                        box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <jsp:include page="../sidebar.jsp" />
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header">
                                <div>
                                    <h1 class="font-weight-bold mb-1">Warehouse - Order List</h1>
                                    <p class="text-secondary mb-0">Manage pending orders and initiate shipment
                                        processing.</p>
                                </div>
                            </div>

                            <div class="card card-main">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Order Code</th>
                                                    <th>Customer</th>
                                                    <th>Created Date</th>
                                                    <th class="text-center">Qty (Ordered/Delivered)</th>
                                                    <th class="text-center">Status</th>
                                                    <th class="text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="o" items="${orders}">
                                                    <tr>
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
                                                        <td class="text-center">
                                                            <span
                                                                class="text-primary font-weight-800">${o.orderedQty}</span>
                                                            <span class="text-muted mx-1">/</span>
                                                            <span
                                                                class="text-success font-weight-800">${o.deliveredQty}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${o.status == 1}"><span
                                                                        class="badge-status status-1">Created</span>
                                                                </c:when>
                                                                <c:when test="${o.status == 2}"><span
                                                                        class="badge-status status-2">Partial</span>
                                                                </c:when>
                                                                <c:when test="${o.status == 3}"><span
                                                                        class="badge-status status-3">Completed</span>
                                                                </c:when>
                                                                <c:when test="${o.status == 4}"><span
                                                                        class="badge-status status-4">Cancelled</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right">
                                                            <a href="sales-order?action=view&id=${o.id}"
                                                                class="btn-action btn-view mr-2">
                                                                <i class="ri-eye-line"></i> View
                                                            </a>
                                                            <c:if test="${o.status == 1 || o.status == 2}">
                                                                <a href="goods-issue?action=create&soId=${o.id}"
                                                                    class="btn-action btn-issue">
                                                                    <i class="ri-truck-line"></i> Create Issue
                                                                </a>
                                                            </c:if>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
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
            </body>

            </html>