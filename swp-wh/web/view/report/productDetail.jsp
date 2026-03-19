<%-- 
    Document   : productDetail
    Created on : Mar 17, 2026, 11:38:43 PM
    Author     : Asus
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Product Stock Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <a href="inventory-report" class="btn btn-secondary mb-3">? Back to Report</a>
    
    <div class="card mb-4">
        <div class="card-body">
            <h3 class="text-primary">${product.name}</h3>
            <p class="text-muted">Product Code: <strong>${product.code}</strong></p>
            <div class="alert alert-info d-inline-block">
                <h4 class="mb-0">Total On-Hand: <span class="badge bg-primary">${totalQty}</span></h4>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-dark text-white">Stock Breakdown by Location</div>
        <table class="table table-striped mb-0">
            <thead>
                <tr>
                    <th>Warehouse</th>
                    <th>Location / Bin</th>
                    <th>Lot Number</th>
                    <th class="text-center">Quantity</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${details}" var="d">
                    <tr>
                        <td>${d.location.warehouseName}</td>
                        <td><span class="badge bg-light text-dark border">${d.location.locationCode}</span></td>
                        <td><code>${d.productDetail.lotNumber}</code></td>
                        <td class="text-center fw-bold text-success">${d.quantity}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
