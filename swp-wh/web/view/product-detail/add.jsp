<%-- 
    Document   : add
    Created on : Mar 5, 2026, 1:31:21 AM
    Author     : Asus
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>WMS | Add Inventory</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
</head>
<body>
    <div class="wrapper">
        <%@ include file="../sidebar.jsp" %>
        <div class="content-page">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between">
                                <h4 class="card-title">Add New Product Inventory</h4>
                            </div>
                            <div class="card-body">
                                <form action="add-product-detail" method="POST">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label>Select Product *</label>
                                            <select name="productId" class="form-control" required>
                                                <c:forEach items="${products}" var="p">
                                                    <option value="${p.id}">${p.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label>Lot Number</label>
                                            <input type="text" name="lotNumber" class="form-control" placeholder="e.g. LOT2024">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label>Serial Number *</label>
                                            <input type="text" name="serialNumber" class="form-control" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label>Color</label>
                                            <input type="text" name="color" class="form-control">
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label>Price *</label>
                                            <input type="number" step="0.01" name="price" class="form-control" required>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label>Quantity *</label>
                                            <input type="number" name="quantity" class="form-control" required>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label>Manufacture Date</label>
                                            <input type="date" name="manufactureDate" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <button type="submit" class="btn btn-primary">Save Inventory</button>
                                        <a href="list-product-detail" class="btn btn-light">Cancel</a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
