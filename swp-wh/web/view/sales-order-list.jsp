<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Sales Orders | InventoryPro</title>

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
                        --success: #15803d;
                        --warning: #f59e0b;
                        --danger: #ef4444;
                        --gray-dark: #0f172a;
                        --gray-light: #f8fafc;
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
                        padding: 1.5rem;
                    }

                    .btn-add {
                        background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
                        color: white;
                        border-radius: 12px;
                        padding: 0.75rem 1.5rem;
                        font-weight: 700;
                        border: none;
                        box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                        transition: all 0.3s ease;
                    }

                    .btn-add:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
                        color: white;
                    }

                    .card-order {
                        border-radius: 16px;
                        border: none;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                        background: white;
                        overflow: hidden;
                    }

                    .table thead th {
                        background: #e2e8f0;
                        font-weight: 800;
                        color: #0f172a;
                        text-transform: uppercase;
                        font-size: 0.85rem;
                        padding: 1.25rem 1.5rem;
                    }

                    .table tbody td {
                        padding: 1.25rem 1.5rem;
                        vertical-align: middle;
                        font-weight: 500;
                    }

                    .badge-status {
                        padding: 6px 12px;
                        border-radius: 8px;
                        font-weight: 700;
                        font-size: 0.75rem;
                    }

                    .status-1 {
                        background: #dbeafe;
                        color: #1e40af;
                    }

                    /* Created */
                    .status-2 {
                        background: #fef3c7;
                        color: #92400e;
                    }

                    /* Partially Delivered */
                    .status-3 {
                        background: #dcfce7;
                        color: #15803d;
                    }

                    /* Completed */
                    .status-4 {
                        background: #fee2e2;
                        color: #991b1b;
                    }

                    /* Cancelled */

                    .btn-action {
                        padding: 0.4rem 0.8rem;
                        border-radius: 8px;
                        font-weight: 600;
                        font-size: 0.85rem;
                        border: 1px solid transparent;
                        transition: all 0.2s;
                    }

                    .btn-view {
                        background: #f0f9ff;
                        color: #0369a1;
                        border-color: #bae6fd;
                    }

                    .btn-cancel {
                        background: #fff1f2;
                        color: #be123c;
                        border-color: #fecdd3;
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header">
                                <h1 class="font-weight-bold">Sales Order Management</h1>
                                <a href="sales-order?action=create" class="btn btn-add">
                                    <i class="ri-add-line"></i> Create New Order
                                </a>
                            </div>

                            <div class="card card-order">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Order Code</th>
                                                    <th>Customer</th>
                                                    <th>Created Date</th>
                                                    <th>Qty (Ordered/Delivered)</th>
                                                    <th>Status</th>
                                                    <th class="text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="o" items="${orders}">
                                                    <tr>
                                                        <td><span
                                                                class="font-weight-bold text-primary">${o.orderCode}</span>
                                                        </td>
                                                        <td><span class="font-weight-bold">${o.customer.name}</span>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${o.createdDate}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td>
                                                            <span
                                                                class="text-primary font-weight-bold">${o.orderedQty}</span>
                                                            /
                                                            <span
                                                                class="text-success font-weight-bold">${o.deliveredQty}</span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${o.status == 1}"><span
                                                                        class="badge-status status-1">Created</span>
                                                                </c:when>
                                                                <c:when test="${o.status == 2}"><span
                                                                        class="badge-status status-2">Partially
                                                                        Delivered</span></c:when>
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
                                                            <c:if test="${o.status == 1}">
                                                                <form action="sales-order" method="post"
                                                                    style="display:inline-block">
                                                                    <input type="hidden" name="action" value="cancel">
                                                                    <input type="hidden" name="id" value="${o.id}">
                                                                    <button type="submit" class="btn-action btn-cancel"
                                                                        onclick="return confirm('Cancel this order?')">
                                                                        <i class="ri-close-line"></i> Cancel
                                                                    </button>
                                                                </form>
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
                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
            </body>

            </html>