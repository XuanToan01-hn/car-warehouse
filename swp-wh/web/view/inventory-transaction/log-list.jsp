<%-- 
    Document   : log-list
    Created on : Mar 3, 2026, 11:10:07 AM
    Author     : Asus
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory Movement Logs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <h3>Inventory Transaction Logs</h3>
    
    <form action="inventory-log" method="GET" class="row g-3 mb-4 bg-white p-3 rounded shadow-sm">
        <div class="col-md-3">
            <select name="type" class="form-select">
                <option value="">-- All Types --</option>
                <option value="ISSUE" ${type == 'ISSUE' ? 'selected' : ''}>ISSUE (Stock Out)</option>
                <option value="RECEIPT" ${type == 'RECEIPT' ? 'selected' : ''}>RECEIPT (Stock In)</option>
                <option value="TRANSFER" ${type == 'TRANSFER' ? 'selected' : ''}>TRANSFER</option>
            </select>
        </div>
        <div class="col-md-6">
            <input type="text" name="search" class="form-control" placeholder="Search by Product Name or Ref Code..." value="${search}">
        </div>
        <div class="col-md-3">
            <button type="submit" class="btn btn-primary w-100">Filter</button>
        </div>
    </form>

    <table class="table table-hover bg-white shadow-sm">
        <thead class="table-dark">
            <tr>
                <th>Date</th>
                <th>Type</th>
                <th>Product</th>
                <th>Location</th>
                <th>Qty</th>
                <th>Ref Code</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${logs}" var="l">
                <tr>
                    <td><fmt:formatDate value="${l.transactionDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                        <span class="badge ${l.transactionType == 'ISSUE' ? 'bg-danger' : 'bg-success'}">
                            ${l.transactionType}
                        </span>
                    </td>
                    <td>${l.product.name} (${l.productDetail.color})</td>
                    <td>${l.location.locationName}</td>
                    <td><strong>${l.transactionType == 'ISSUE' ? '-' : '+'}${l.quantity}</strong></td>
                    <td><small class="text-muted">${l.referenceCode}</small></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <nav>
        <ul class="pagination justify-content-center">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${currentPage == i ? 'active' : ''}">
                    <a class="page-link" href="inventory-log?page=${i}&type=${type}&search=${search}">${i}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</div>
</body>
</html>
