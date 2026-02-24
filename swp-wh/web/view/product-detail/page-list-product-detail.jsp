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
                    <h4 class="mb-3">Warehouse Inventory Details</h4>
                    
                    <div class="card mb-4">
                        <div class="card-body">
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

                    <table class="table">
                        <thead class="bg-white text-uppercase">
                            <tr>
                                <th>Product</th>
                                <th>Lot / Serial</th>
                                <th>Mfd Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${listDetail}" var="pd">
                                <tr>
                                    <td><strong>${pd.product.name}</strong></td>
                                    <td>
                                        <small>Lot: ${pd.lotNumber}</small><br>
                                        <small>S/N: ${pd.serialNumber}</small>
                                    </td>
                                    <td><fmt:formatDate value="${pd.manufactureDate}" pattern="dd/MM/yyyy"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <nav class="mt-3">
                        <ul class="pagination justify-content-end">
                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="list-product-detail?page=${i}&productId=${param.productId}&search=${param.search}">${i}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </body>
</html>