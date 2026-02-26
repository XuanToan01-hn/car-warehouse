<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
<head>
    <title>Warehouse Management | InventoryPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
    <style>
        .btn-issue { background: #f0fdf4; color: #16a34a; border: 1px solid #bbf7d0; padding: 0.4rem 0.8rem; border-radius: 8px; font-weight: 600; font-size: 0.85rem; }
        .btn-issue:hover { background: #16a34a; color: white; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="page-header" style="padding: 1.5rem; display: flex; justify-content: space-between;">
            <h1 class="font-weight-bold">Warehouse - Order List</h1>
            </div>

        <div class="card card-order">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                            <tr style="background: #e2e8f0;">
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
                                    <td><span class="font-weight-bold text-primary">${o.orderCode}</span></td>
                                    <td>${o.customer.name}</td>
                                    <td><fmt:formatDate value="${o.createdDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                    
                                    <td>
                                        <span class="text-primary font-weight-bold">${o.orderedQty}</span> / 
                                        <span class="text-success font-weight-bold">${o.deliveredQty}</span>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status == 1}"><span class="badge-status status-1">Created</span></c:when>
                                            <c:when test="${o.status == 2}"><span class="badge-status status-2">Partially Delivered</span></c:when>
                                            <c:when test="${o.status == 3}"><span class="badge-status status-3">Completed</span></c:when>
                                            <c:when test="${o.status == 4}"><span class="badge-status status-4">Cancelled</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-right">
                                        <a href="sales-order?action=view&id=${o.id}" class="btn-action btn-view mr-2">
                                            <i class="ri-eye-line"></i> View
                                        </a>

                                        <c:if test="${o.status == 1 || o.status == 2}">
                                            <a href="goods-issue?soId=${o.id}" class="btn-issue">
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
</body>
</html>