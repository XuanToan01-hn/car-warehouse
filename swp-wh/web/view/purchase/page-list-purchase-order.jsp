<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Purchase Order List | InventoryPro</title>

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

                    .card-main {
                        border-radius: 16px;
                        border: none;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                        background: white;
                        overflow: hidden;
                    }

                    .filter-section {
                        background: #fff;
                        padding: 1.5rem;
                        border-radius: 16px;
                        margin-bottom: 1.5rem;
                        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.03);
                        border: 1px solid #e2e8f0;
                    }

                    .form-control {
                        border-radius: 10px;
                        border: 2px solid #e2e8f0;
                        font-weight: 600;
                        height: auto;
                        padding: 0.6rem 1rem;
                    }

                    .form-control:focus {
                        border-color: var(--primary);
                        box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
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

                    .po-code {
                        font-weight: 800;
                        color: var(--primary);
                        font-size: 1rem;
                    }

                    .supplier-name {
                        font-weight: 700;
                        color: #1e293b;
                    }

                    .badge-status {
                        padding: 0.5rem 1rem;
                        border-radius: 10px;
                        font-weight: 800;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                        letter-spacing: 0.025em;
                    }

                    .badge-draft {
                        background: #fef3c7;
                        color: #92400e;
                    }

                    .badge-confirmed {
                        background: #e0f2fe;
                        color: #0369a1;
                    }

                    .badge-received {
                        background: #dcfce7;
                        color: #166534;
                    }

                    .badge-cancelled {
                        background: #fee2e2;
                        color: #991b1b;
                    }

                    .total-amount {
                        font-weight: 800;
                        color: #0f172a;
                        font-size: 1rem;
                    }

                    .btn-action {
                        border-radius: 8px;
                        font-weight: 700;
                        padding: 0.5rem 1rem;
                        transition: all 0.2s;
                    }

                    .pagination .page-link {
                        border-radius: 8px;
                        margin: 0 3px;
                        font-weight: 700;
                        color: #64748b;
                        border: none;
                        background: #f1f5f9;
                    }

                    .pagination .page-item.active .page-link {
                        background: var(--primary);
                        color: #fff;
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <jsp:include page="../sidebar.jsp" />
                    <jsp:include page="../header.jsp" />
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header">
                                <div>
                                    <h1 class="font-weight-bold mb-1">Purchase Orders</h1>
                                    <p class="text-secondary mb-0">Track and manage inventory procurement from
                                        suppliers.</p>
                                </div>
                                <c:if test="${not empty sessionScope.user and sessionScope.user.role.id == 3}">
                                    <a href="${pageContext.request.contextPath}/add-purchase-order" class="btn btn-add">
                                        <i class="ri-add-line"></i> Create New PO
                                    </a>
                                </c:if>
                            </div>

                            <div class="filter-section">
                                <form method="get" action="${pageContext.request.contextPath}/purchase-orders">
                                    <div class="row align-items-end">
                                        <div class="col-md-5">
                                            <label
                                                class="small font-weight-bold text-uppercase text-secondary">Search</label>
                                            <div class="input-group">
                                                <div class="input-group-prepend">
                                                    <span class="input-group-text bg-white border-right-0"
                                                        style="border-radius: 10px 0 0 10px; border: 2px solid #e2e8f0;">
                                                        <i class="ri-search-line text-muted"></i>
                                                    </span>
                                                </div>
                                                <input type="text" name="search" class="form-control border-left-0"
                                                    placeholder="Order code, supplier..." value="${search}">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="small font-weight-bold text-uppercase text-secondary">Status
                                                Filter</label>
                                            <select name="status" class="form-control">
                                                <option value="0" ${statusFilter==0 ? 'selected' : '' }>All Statuses
                                                </option>
                                                <option value="1" ${statusFilter==1 ? 'selected' : '' }>Draft</option>
                                                <option value="2" ${statusFilter==2 ? 'selected' : '' }>Confirmed
                                                </option>
                                                <option value="3" ${statusFilter==3 ? 'selected' : '' }>Received
                                                </option>
                                                <option value="4" ${statusFilter==4 ? 'selected' : '' }>Cancelled
                                                </option>
                                            </select>
                                        </div>
                                        <div class="col-md-4 d-flex gap-2">
                                            <button type="submit" class="btn btn-primary flex-grow-1"
                                                style="border-radius: 12px; font-weight: 700; background: var(--primary); border: none; padding: 0.75rem;">
                                                Apply Filters
                                            </button>
                                            <a href="${pageContext.request.contextPath}/purchase-orders"
                                                class="btn btn-light"
                                                style="border-radius: 12px; font-weight: 700; padding: 0.75rem;">
                                                Reset
                                            </a>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <c:if test="${param.success == 'created'}">
                                <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4"
                                    style="border-radius: 12px; background: #dcfce7; color: #166534;" role="alert">
                                    <i class="ri-checkbox-circle-line mr-2"></i> <strong>Success!</strong> Purchase
                                    Order has been created successfully.
                                    <button type="button" class="close"
                                        data-dismiss="alert"><span>&times;</span></button>
                                </div>
                            </c:if>

                            <div class="card card-main">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th width="5%">#</th>
                                                    <th>Order Code</th>
                                                    <th>Supplier</th>
                                                    <th>Created Date</th>
                                                    <th>Status</th>
                                                    <th>Total Amount</th>
                                                    <th class="text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="po" items="${poList}" varStatus="st">
                                                    <tr>
                                                        <td>${(currentPage - 1) * 8 + st.index + 1}</td>
                                                        <td><span class="po-code">${po.orderCode}</span></td>
                                                        <td><span class="supplier-name">${po.supplier.name}</span></td>
                                                        <td>
                                                            <div class="text-secondary small font-weight-600">
                                                                <fmt:formatDate value="${po.createdDate}"
                                                                    pattern="dd/MM/yyyy HH:mm" />
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${po.status == 1}">
                                                                    <span class="badge-status badge-draft">Draft</span>
                                                                </c:when>
                                                                <c:when test="${po.status == 2}">
                                                                    <span
                                                                        class="badge-status badge-confirmed">Confirmed</span>
                                                                </c:when>
                                                                <c:when test="${po.status == 3}">
                                                                    <span
                                                                        class="badge-status badge-received">Received</span>
                                                                </c:when>
                                                                <c:when test="${po.status == 4}">
                                                                    <span
                                                                        class="badge-status badge-cancelled">Cancelled</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="total-amount">
                                                                <fmt:formatNumber value="${po.totalAmount}"
                                                                    type="number" groupingUsed="true" /> đ
                                                            </span>
                                                        </td>
                                                        <td class="text-right">
                                                            <a href="${pageContext.request.contextPath}/detail-purchase-order?id=${po.id}"
                                                                class="btn btn-outline-primary btn-action">
                                                                <i class="ri-eye-line mr-1"></i> Details
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty poList}">
                                                    <tr>
                                                        <td colspan="7" class="text-center py-5">
                                                            <i
                                                                class="ri-inbox-line display-4 text-muted d-block opacity-25"></i>
                                                            <p class="text-secondary mt-3 font-weight-600">No Purchase
                                                                Orders found matching your criteria.</p>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${totalPages > 1}">
                                <nav class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?search=${search}&status=${statusFilter}&page=${currentPage - 1}">
                                                <i class="ri-arrow-left-s-line"></i>
                                            </a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                            <li class="page-item ${p == currentPage ? 'active' : ''}">
                                                <a class="page-link"
                                                    href="?search=${search}&status=${statusFilter}&page=${p}">${p}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                                href="?search=${search}&status=${statusFilter}&page=${currentPage + 1}">
                                                <i class="ri-arrow-right-s-line"></i>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.0.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
            </body>

            </html>