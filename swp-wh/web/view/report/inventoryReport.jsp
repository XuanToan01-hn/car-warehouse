<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Current Inventory Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .card { border: none; box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); }
        .table-hover tbody tr:hover { background-color: #f1f4f9; }
        .badge-loc { background-color: #e3f2fd; color: #0d47a1; border: 1px solid #bbdefb; }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4 text-primary">? Inventory Stock Report</h2>
    
    <div class="card p-4 mb-4">
        <form action="inventory-report" method="GET" class="row g-3">
            <div class="col-md-3">
                <label class="form-label fw-bold">Product Name</label>
                <input type="text" name="productName" class="form-control" value="${param.productName}" placeholder="Search product...">
            </div>
            
            <div class="col-md-3">
                <label class="form-label fw-bold">Warehouse</label>
                <select name="warehouseName" class="form-select">
                    <option value="">All Warehouses</option>
                    <c:forEach items="${warehouses}" var="w">
                        <option value="${w.warehouseName}" ${param.warehouseName == w.warehouseName ? 'selected' : ''}>${w.warehouseName}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-3">
                <label class="form-label fw-bold">Specific Location</label>
                <select name="locationId" class="form-select">
                    <option value="0">All Locations</option>
                    <c:forEach items="${locations}" var="loc">
                        <option value="${loc.id}" ${param.locationId == loc.id ? 'selected' : ''}>${loc.locationCode} (${loc.locationName})</option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-3 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">? Filter Data</button>
            </div>
        </form>
    </div>

    <div class="card overflow-hidden">
        <table class="table table-hover mb-0">
            <thead class="table-dark">
                <tr>
                    <th>Product Details</th>
                    <th>Warehouse</th>
                    <th>Location Bin</th>
                    <th>Lot Number</th>
                    <th class="text-center">Current Qty</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty stockList}">
                    <tr><td colspan="5" class="text-center py-4 text-muted">No inventory data found.</td></tr>
                </c:if>
                <c:forEach items="${stockList}" var="item">
                    <tr>
                        <td>
                            <span class="fw-bold text-dark">${item.product.name}</span><br>
                            <small class="text-muted text-uppercase">${item.product.code}</small>
                        </td>
                        <td>${item.location.warehouseId}</td> 
                        <td><span class="badge badge-loc px-2 py-1">${item.location.locationCode}</span></td>
                        <td><code class="text-secondary">${item.productDetail.lotNumber}</code></td>
                        <td class="text-center"><span class="fw-bold text-success fs-5">${item.quantity}</span></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <nav class="mt-4">
        <ul class="pagination justify-content-center">
            <c:set var="urlParams" value="&productName=${param.productName}&warehouseName=${param.warehouseName}&locationId=${param.locationId}" />
            
            <c:if test="${currentPage > 1}">
                <li class="page-item"><a class="page-link" href="?page=${currentPage - 1}${urlParams}">Previous</a></li>
            </c:if>
            
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="?page=${i}${urlParams}">${i}</a>
                </li>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <li class="page-item"><a class="page-link" href="?page=${currentPage + 1}${urlParams}">Next</a></li>
            </c:if>
        </ul>
    </nav>
</div>
</body>
</html>