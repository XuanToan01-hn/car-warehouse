<%-- Document : page-add-product-detail Created on : Mar 2, 2026, 11:20:54 PM Author : Asus --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <title>WMS | Add Product Detail</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
            </head>

            <body>
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <div class="content-page">
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header d-flex justify-content-between">
                                        <h4 class="card-title">Add New Inventory Item</h4>
                                    </div>
                                    <div class="card-body">
                                        <form action="add-product-detail" method="post">
                                            <div class="row">
                                                <div class="col-md-12 form-group">
                                                    <label>Product *</label>
                                                    <select name="productId" class="form-control" required>
                                                        <option value="">-- Select Product --</option>
                                                        <c:forEach items="${listProduct}" var="p">
                                                            <option value="${p.id}">${p.name} (${p.code})</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-6 form-group">
                                                    <label>Lot Number</label>
                                                    <input type="text" name="lotNumber" class="form-control"
                                                        placeholder="Enter Lot Number">
                                                </div>
                                                <div class="col-md-6 form-group">
                                                    <label>Serial Number</label>
                                                    <input type="text" name="serialNumber" class="form-control"
                                                        placeholder="Enter Serial Number">
                                                </div>
                                                <input type="hidden" name="price" value="0">
                                                <div class="col-md-6 form-group">
                                                    <label>Color</label>
                                                    <input type="text" name="color" class="form-control"
                                                        placeholder="e.g. Red, Blue">
                                                </div>
                                                <div class="col-md-6 form-group">
                                                    <label>Manufacture Date *</label>
                                                    <input type="date" name="mfdDate" class="form-control" required>
                                                </div>
                                            </div>
                                            <hr>
                                            <button type="submit" class="btn btn-primary">Save Item</button>
                                            <a href="list-product-detail" class="btn btn-light">Back to List</a>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                </div>
            </body>

            </html>