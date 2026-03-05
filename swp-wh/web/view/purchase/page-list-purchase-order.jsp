<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Purchase Order List | InventoryPro</title>

    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
        .badge-status {
            padding: 0.4rem 0.8rem;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.7rem;
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
                        <p class="text-secondary mb-0">Track and manage inventory procurement from suppliers.</p>
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
                                <label class="small font-weight-bold text-uppercase text-secondary">Search</label>
                                <div class="input-group">
                                    <input type="text" name="search" class="form-control" style="border-radius: 10px;"
                                           placeholder="Order code, supplier..." value="${search}">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="small font-weight-bold text-uppercase text-secondary">Status Filter</label>
                                <select name="status" class="form-control" style="border-radius: 10px;">
                                    <option value="0" ${statusFilter==0 ? 'selected' : ''}>All Statuses</option>
                                    <option value="1" ${statusFilter==1 ? 'selected' : ''}>Draft</option>
                                    <option value="2" ${statusFilter==2 ? 'selected' : ''}>Confirmed</option>
                                    <option value="3" ${statusFilter==3 ? 'selected' : ''}>Received</option>
                                    <option value="4" ${statusFilter==4 ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-4 d-flex gap-2">
                                <button type="submit" class="btn btn-primary flex-grow-1"
                                        style="border-radius: 12px; font-weight: 700; background: var(--primary); border: none; padding: 0.75rem;">
                                    Apply Filters
                                </button>
                                <a href="${pageContext.request.contextPath}/purchase-orders" class="btn btn-light"
                                   style="border-radius: 12px; font-weight: 700; padding: 0.75rem; margin-left: 10px;">
                                    Reset
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="card-main">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Order Code</th>
                                    <th>Supplier</th>
                                    <th>Created Date</th>
                                    <th>Status</th>
                                    <th>Total Amount</th>
                                    <th class="text-right">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="po" items="${poList}" varStatus="st">
                                    <tr>
                                        <td>${(currentPage - 1) * 8 + st.index + 1}</td>
                                        <td><span class="text-primary font-weight-bold">${po.orderCode}</span></td>
                                        <td><span class="font-weight-bold">${po.supplier.name}</span></td>
                                        <td><fmt:formatDate value="${po.createdDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${po.status == 1}"><span class="badge badge-warning badge-status">DRAFT</span></c:when>
                                                <c:when test="${po.status == 2}"><span class="badge badge-primary badge-status">CONFIRMED</span></c:when>
                                                <c:when test="${po.status == 3}"><span class="badge badge-success badge-status">RECEIVED</span></c:when>
                                                <c:when test="${po.status == 4}"><span class="badge badge-danger badge-status">CANCELLED</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td class="font-weight-bold">
                                            <fmt:formatNumber value="${po.totalAmount}" type="number" groupingUsed="true"/> đ
                                        </td>
                                        <td class="text-right">
                                            <a href="${pageContext.request.contextPath}/detail-purchase-order?id=${po.id}"
                                               class="btn btn-sm btn-outline-primary" style="border-radius: 8px;">
                                               <i class="ri-eye-line"></i> View
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty poList}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-5">No purchase orders found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?search=${search}&status=${statusFilter}&page=${currentPage - 1}">&laquo;</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <li class="page-item ${p == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?search=${search}&status=${statusFilter}&page=${p}">${p}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?search=${search}&status=${statusFilter}&page=${currentPage + 1}">&raquo;</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>