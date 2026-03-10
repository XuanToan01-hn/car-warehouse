<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Goods Receipt Order List | InventoryPro</title>

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
                        --partial: #D97706;
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

                    .btn-add {
                        background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
                        color: white !important;
                        border-radius: 12px;
                        padding: 0.75rem 1.5rem;
                        font-weight: 700;
                        border: none;
                        box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                        transition: all 0.3s ease;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .btn-add:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
                    }

                    .filter-section {
                        background: #fff;
                        padding: 1.5rem;
                        border-radius: 16px;
                        margin-bottom: 1.5rem;
                        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.03);
                        border: 1px solid #e2e8f0;
                    }

                    .card-main {
                        background: #fff;
                        border-radius: 16px;
                        border: 1px solid #e2e8f0;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                        padding: 1.5rem;
                    }

                    .table thead th {
                        background: #f8fafc;
                        font-weight: 700;
                        color: #64748b;
                        text-transform: uppercase;
                        font-size: 0.75rem;
                        letter-spacing: 0.05em;
                        padding: 1rem;
                        border-bottom: 2px solid #e2e8f0;
                    }

                    .table tbody td {
                        padding: 0.9rem 1rem;
                        vertical-align: middle;
                        border-bottom: 1px solid #f1f5f9;
                    }

                    .table tbody tr:hover {
                        background-color: #f8fafc;
                    }

                    .badge-status {
                        padding: 0.4rem 0.9rem;
                        border-radius: 8px;
                        font-weight: 700;
                        font-size: 0.7rem;
                        letter-spacing: 0.03em;
                    }

                    .badge-draft {
                        background: #FEF3C7;
                        color: #92400E;
                    }

                    .badge-completed {
                        background: #D1FAE5;
                        color: #065F46;
                    }

                    .badge-cancelled {
                        background: #FEE2E2;
                        color: #991B1B;
                    }

                    .badge-partial {
                        background: #FEF9C3;
                        color: #854D0E;
                        border: 1px solid #FDE047;
                    }

                    .qty-cell {
                        font-weight: 700;
                        white-space: nowrap;
                    }

                    .qty-exp {
                        color: #0EA5E9;
                    }

                    .qty-act {
                        color: #16A34A;
                    }

                    .qty-sep {
                        color: #94a3b8;
                        margin: 0 4px;
                    }

                    .gro-code {
                        color: #0EA5E9;
                        font-weight: 700;
                    }

                    .po-code {
                        color: #94a3b8;
                        font-size: 0.85rem;
                    }

                    .btn-detail {
                        border-radius: 8px;
                        font-weight: 600;
                        font-size: 0.8rem;
                        padding: 0.35rem 0.85rem;
                    }

                    .form-control {
                        border-radius: 10px;
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <div class="content-page">
                            <div class="container-fluid">

                                <!-- Page Header -->
                                <div class="page-header">
                                    <div>
                                        <h1 class="font-weight-bold mb-1">Goods Receipt Orders</h1>
                                        <p class="text-secondary mb-0">Track and manage all goods receipt entries.</p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/create-goods-receipt"
                                        class="btn btn-add">
                                        <i class="ri-add-line"></i> Create New GRO
                                    </a>
                                </div>

                                <!-- Filters -->
                                <div class="filter-section">
                                    <form method="get" action="${pageContext.request.contextPath}/goods-receipt">
                                        <div class="row align-items-end">
                                            <div class="col-md-5">
                                                <label
                                                    class="small font-weight-bold text-uppercase text-secondary">Search</label>
                                                <input type="text" name="keyword" class="form-control"
                                                    placeholder="GRO code, PO code..." value="${keyword}">
                                            </div>
                                            <div class="col-md-3">
                                                <label
                                                    class="small font-weight-bold text-uppercase text-secondary">Status
                                                    Filter</label>
                                                <select name="status" class="form-control">
                                                    <option value="0" ${status==0 ? 'selected' : '' }>All Statuses
                                                    </option>
                                                    <option value="1" ${status==1 ? 'selected' : '' }>Draft</option>
                                                    <option value="2" ${status==2 ? 'selected' : '' }>Completed</option>
                                                    <option value="4" ${status==4 ? 'selected' : '' }>Partially Received
                                                    </option>
                                                    <option value="3" ${status==3 ? 'selected' : '' }>Cancelled</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4 d-flex" style="gap:0.5rem;">
                                                <button type="submit" class="btn btn-primary flex-grow-1"
                                                    style="border-radius:12px;font-weight:700;background:var(--primary);border:none;padding:0.75rem;">
                                                    Apply Filters
                                                </button>
                                                <a href="${pageContext.request.contextPath}/goods-receipt"
                                                    class="btn btn-light"
                                                    style="border-radius:12px;font-weight:700;padding:0.75rem;">
                                                    Reset
                                                </a>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <!-- Table -->
                                <div class="card-main">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>GRO Code</th>
                                                    <th>Purchase Order</th>
                                                    <th>Location</th>
                                                    <th>Entry Date</th>
                                                    <th>Status</th>
                                                    <th class="text-center">QTY (Exp / Act)</th>
                                                    <th class="text-right">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty grList}">
                                                        <tr>
                                                            <td colspan="8" class="text-center text-muted py-5">
                                                                <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                                                                No goods receipt orders found.
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="gr" items="${grList}" varStatus="st">
                                                            <tr>
                                                                <td>${(page-1)*pageSize + st.index + 1}</td>
                                                                <td><span class="gro-code">${gr.receiptCode}</span></td>
                                                                <td><span
                                                                        class="po-code">${gr.purchaseOrder.orderCode}</span>
                                                                </td>
                                                                <td>${gr.location.locationName}</td>
                                                                <td>
                                                                    <fmt:formatDate value="${gr.receiptDate}"
                                                                        pattern="dd/MM/yyyy HH:mm" />
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${gr.status == 1}">
                                                                            <span
                                                                                class="badge-status badge-draft">DRAFT</span>
                                                                        </c:when>
                                                                        <c:when test="${gr.status == 2}">
                                                                            <span
                                                                                class="badge-status badge-completed">COMPLETED</span>
                                                                        </c:when>
                                                                        <c:when test="${gr.status == 3}">
                                                                            <span
                                                                                class="badge-status badge-cancelled">CANCELLED</span>
                                                                        </c:when>
                                                                        <c:when test="${gr.status == 4}">
                                                                            <span
                                                                                class="badge-status badge-partial">PARTIAL</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge-status"
                                                                                style="background:#e2e8f0;color:#64748b;">${gr.status}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-center qty-cell">
                                                                    <span class="qty-exp">${gr.totalExpected}</span>
                                                                    <span class="qty-sep">/</span>
                                                                    <span class="qty-act">${gr.totalActual}</span>
                                                                </td>
                                                                <td class="text-right">
                                                                    <a href="${pageContext.request.contextPath}/detail-goods-receipt?id=${gr.id}"
                                                                        class="btn btn-sm btn-outline-primary btn-detail">
                                                                        <i class="ri-eye-line"></i> View
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 1}">
                                        <nav class="mt-4">
                                            <ul class="pagination justify-content-center">
                                                <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?keyword=${keyword}&status=${status}&page=${page-1}">«</a>
                                                </li>
                                                <c:forEach begin="1" end="${totalPages}" var="p">
                                                    <li class="page-item ${p == page ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="?keyword=${keyword}&status=${status}&page=${p}">${p}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?keyword=${keyword}&status=${status}&page=${page+1}">»</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
                                    <p class="text-muted text-center mt-2 mb-0">Total: <strong>${total}</strong>
                                        receipts</p>
                                </div>

                            </div>
                        </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
            </body>

            </html>