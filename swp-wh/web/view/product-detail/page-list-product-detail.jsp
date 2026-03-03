<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>WMS | Product Detail List</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>
            <div class="content-page">
                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4 class="mb-0">Warehouse Inventory Details</h4>
                        <a href="add-product-detail" class="btn btn-success btn-sm">+ Add New Inventory</a>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <a href="add-product-detail" class="btn btn-primary">
                                    <i class="ri-add-line"></i> Add New Detail
                                </a>
                            </div>
                            
                            <form method="get" action="list-product-detail">
                                <div class="row align-items-end">
                                    <div class="col-md-3">
                                        <label>Product</label>
                                        <select name="productId" class="form-control" onchange="this.form.submit()">
                                            <option value="0">-- All Products --</option>
                                            <c:forEach items="${listProduct}" var="pro">
                                                <option value="${pro.id}" ${param.productId == pro.id ? 'selected' : ''}>${pro.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Search Lot/Serial</label>
                                        <input type="text" name="search" class="form-control" placeholder="Lot or Serial..." value="${param.search}">
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary">Filter</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="bg-light text-uppercase">
                                <tr>
                                    <th>Product</th>
                                    <th>Lot Number</th>
                                    <th>Serial Number</th>
                                    <th>Color</th>
                                    <th>Quantity</th>
                                    <th>Mfd Date</th>
                                    <th class="text-right">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${listDetail}" var="pd">
                                    <tr>
                                        <td><strong>${pd.product.name}</strong></td>
                                        <td>${pd.lotNumber}</td>
                                        <td>${pd.serialNumber}</td>
                                        <td><span class="badge badge-info">${pd.color}</span></td>
                                        <td><strong>${pd.quantity}</strong></td>
                                        <td><fmt:formatDate value="${pd.manufactureDate}" pattern="dd/MM/yyyy"/></td>
                                        <td class="text-right">
                                            <a href="edit-product-detail?id=${pd.id}" class="btn btn-sm btn-outline-primary">Edit</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                
                                <c:if test="${empty listDetail}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted">No product detail found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <nav class="mt-3">
                        <ul class="pagination justify-content-end">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="list-product-detail?page=${currentPage - 1}&productId=${param.productId}&search=${param.search}">Previous</a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="list-product-detail?page=${i}&productId=${param.productId}&search=${param.search}">${i}</a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="list-product-detail?page=${currentPage + 1}&productId=${param.productId}&search=${param.search}">Next</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </body>
</html>