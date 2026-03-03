<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Order Details | InventoryPro</title>

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
                        --slate-50: #f8fafc;
                        --slate-100: #f1f5f9;
                        --slate-200: #e2e8f0;
                        --slate-300: #cbd5e1;
                        --slate-600: #475569;
                        --slate-700: #334155;
                        --slate-900: #0f172a;
                    }

                    body {
                        font-family: 'Be Vietnam Pro', sans-serif;
                        background-color: var(--slate-50);
                        color: var(--slate-700);
                    }

                    .page-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 2rem;
                        padding: 1.5rem 0;
                    }

                    .btn-back {
                        background: white;
                        color: var(--slate-600);
                        border: 1px solid var(--slate-200);
                        border-radius: 12px;
                        padding: 0.75rem 1.25rem;
                        font-weight: 600;
                        transition: all 0.2s;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .btn-back:hover {
                        background: var(--slate-100);
                        color: var(--slate-900);
                    }

                    .card-premium {
                        border-radius: 20px;
                        border: none;
                        box-shadow: 0 4px 24px rgba(0, 0, 0, 0.04);
                        background: white;
                        margin-bottom: 2rem;
                    }

                    .card-premium .card-header {
                        background: transparent;
                        border-bottom: 1px solid var(--slate-100);
                        padding: 1.5rem 2rem;
                    }

                    .card-premium .card-title {
                        font-weight: 800;
                        color: var(--slate-900);
                        margin: 0;
                        font-size: 1.25rem;
                    }

                    .info-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 2rem;
                        padding: 1rem;
                    }

                    .info-item label {
                        display: block;
                        font-size: 0.75rem;
                        font-weight: 700;
                        color: var(--slate-600);
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        margin-bottom: 0.5rem;
                    }

                    .info-item .value {
                        font-size: 1rem;
                        font-weight: 600;
                        color: var(--slate-900);
                    }

                    .price-highlight {
                        color: var(--primary);
                        font-size: 1.5rem;
                        font-weight: 800;
                    }

                    .table-premium thead th {
                        background: var(--slate-50);
                        font-weight: 800;
                        color: var(--slate-600);
                        text-transform: uppercase;
                        font-size: 0.75rem;
                        padding: 1.25rem 1.5rem;
                        border: none;
                    }

                    .table-premium tbody td {
                        padding: 1.25rem 1.5rem;
                        vertical-align: middle;
                        border-bottom: 1px solid var(--slate-50);
                        font-weight: 500;
                    }

                    .table-premium tfoot td {
                        padding: 1.5rem;
                        border-top: 2px solid var(--slate-100);
                    }

                    .badge-color {
                        padding: 0.35rem 0.75rem;
                        border-radius: 6px;
                        font-weight: 700;
                        font-size: 0.7rem;
                        background: #e0f2fe;
                        color: #0369a1;
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
                                        <h1 class="font-weight-bold h2 mb-1">Order Details</h1>
                                        <p class="text-secondary mb-0">Order Code: <span
                                                class="text-primary font-weight-bold">#${order.orderCode}</span></p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/sales-order?action=list"
                                        class="btn-back">
                                        <i class="ri-arrow-left-line"></i> Back to List
                                    </a>
                                </div>

                                <!-- Summary Card -->
                                <div class="card card-premium">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <h5 class="card-title">General Information</h5>
                                        <c:choose>
                                            <c:when test="${order.status == 1}"><span
                                                    class="badge badge-primary px-3 py-2">Created</span></c:when>
                                            <c:when test="${order.status == 2}"><span
                                                    class="badge badge-warning px-3 py-2">Partially Delivered</span>
                                            </c:when>
                                            <c:when test="${order.status == 3}"><span
                                                    class="badge badge-success px-3 py-2">Completed</span></c:when>
                                            <c:when test="${order.status == 4}"><span
                                                    class="badge badge-danger px-3 py-2">Cancelled</span></c:when>
                                        </c:choose>
                                    </div>
                                    <div class="card-body">
                                        <div class="info-grid">
                                            <div class="info-item">
                                                <label>Customer Name</label>
                                                <div class="value">${order.customer.name}</div>
                                            </div>
                                            <div class="info-item">
                                                <label>Creation Date</label>
                                                <div class="value">
                                                    <fmt:formatDate value="${order.createdDate}"
                                                        pattern="dd/MM/yyyy HH:mm" />
                                                </div>
                                            </div>
                                            <div class="info-item">
                                                <label>Total Amount</label>
                                                <div class="value price-highlight">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="number"
                                                        groupingUsed="true" /> <small> VND</small>
                                                </div>
                                            </div>
                                            <div class="info-item">
                                                <label>Note</label>
                                                <div class="value text-secondary">${order.note != null && order.note !=
                                                    '' ? order.note : "—"}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Products Table Card -->
                                <div class="card card-premium">
                                    <div class="card-header">
                                        <h5 class="card-title">Product List</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-premium mb-0">
                                                <thead>
                                                    <tr>
                                                        <th width="50">#</th>
                                                        <th>Product Name</th>
                                                        <th>Details (Color/Lot/Serial)</th>
                                                        <th>Mfg Date</th>
                                                        <th class="text-center">Qty</th>
                                                        <th class="text-right">Unit Price</th>
                                                        <th class="text-right">Subtotal</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${order.details}" var="d" varStatus="st">
                                                        <tr>
                                                            <td>${st.index + 1}</td>
                                                            <td>
                                                                <div class="font-weight-bold text-dark">
                                                                    ${d.productDetail.product.name}</div>
                                                            </td>
                                                            <td>
                                                                <div class="d-flex align-items-center gap-2">
                                                                    <span class="badge-color">${d.productDetail.color !=
                                                                        null ? d.productDetail.color : 'N/A'}</span>
                                                                    <small class="text-secondary">Lot:
                                                                        ${d.productDetail.lotNumber != null ?
                                                                        d.productDetail.lotNumber : '—'}</small>
                                                                    <small class="text-secondary ml-2">SN:
                                                                        ${d.productDetail.serialNumber != null ?
                                                                        d.productDetail.serialNumber : '—'}</small>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${d.productDetail.manufactureDate != null}">
                                                                        <fmt:formatDate
                                                                            value="${d.productDetail.manufactureDate}"
                                                                            pattern="dd/MM/yyyy" />
                                                                    </c:when>
                                                                    <c:otherwise>—</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-center">
                                                                <span
                                                                    class="badge badge-pill badge-light font-weight-bold px-3 py-2">${d.quantity}</span>
                                                            </td>
                                                            <td class="text-right text-secondary">
                                                                <fmt:formatNumber value="${d.price}" type="number"
                                                                    groupingUsed="true" />
                                                            </td>
                                                            <td class="text-right font-weight-bold text-dark">
                                                                <fmt:formatNumber value="${d.subTotal}" type="number"
                                                                    groupingUsed="true" />
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <td colspan="6"
                                                            class="text-right font-weight-bold text-uppercase"
                                                            style="letter-spacing: 0.1em;">Grand Total</td>
                                                        <td class="text-right font-weight-bold price-highlight">
                                                            <fmt:formatNumber value="${order.totalAmount}" type="number"
                                                                groupingUsed="true" /> <small>VND</small>
                                                        </td>
                                                    </tr>
                                                </tfoot>
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