<%-- 
    Document   : page-list-product-detail.jsp
    Created on : Feb 24, 2026, 11:15:20 AM
    Author     : Asus
--%>

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
                    <div class="row">
                        <div class="col-lg-12">
                            <h4 class="mb-3">Inventory Details (Lots/Serials)</h4>
                            
                            <div class="filter-section mb-4">
                                <form method="get" action="list-product-detail">
                                    <div class="row">
                                        <div class="col-md-3">
                                            <select name="productId" class="form-control" onchange="this.form.submit()">
                                                <option value="0">-- All Products --</option>
                                                <c:forEach items="${listProduct}" var="pro">
                                                    <option value="${pro.id}" ${param.productId == pro.id ? 'selected' : ''}>${pro.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="text" name="search" class="form-control" placeholder="Search Lot or Serial..." value="${param.search}">
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-primary">Filter</button>
                                        </div>
                                    </div>
                                </form>
                            </div>

                            <table class="table mb-0">
                                <thead class="bg-white text-uppercase">
                                    <tr class="ligth">
                                        <th>Product Name</th>
                                        <th>Lot Number</th>
                                        <th>Serial Number</th>
                                        <th>Manufacture Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${listDetail}" var="pd">
                                        <tr>
                                            <td>${pd.product.name} <br><small>${pd.product.code}</small></td>
                                            <td>${pd.lotNumber}</td>
                                            <td>${pd.serialNumber}</td>
                                            <td><fmt:formatDate value="${pd.manufactureDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <a class="badge bg-warning" href="javascript:void(0)" onclick="openDeleteForm(${pd.id})">Delete</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <div class="mt-3">
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-primary'}" 
                                       href="list-product-detail?page=${i}&productId=${param.productId}&search=${param.search}">${i}</a>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
