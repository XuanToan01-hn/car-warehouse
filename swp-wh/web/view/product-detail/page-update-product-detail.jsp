<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <title>WMS | Update Product Detail</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
            </head>

            <body>
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <div class="content-page">
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header d-flex justify-content-between">
                                        <h4 class="card-title">Update Inventory Item</h4>
                                    </div>
                                    <div class="card-body">
                                        <form action="edit-product-detail" method="post">
                                            <input type="hidden" name="id" value="${pd.id}">
                                            <div class="row">
                                                <div class="col-md-12 form-group">
                                                    <label>Product *</label>
                                                    <select name="productId" class="form-control" required>
                                                        <c:forEach items="${listProduct}" var="p">
                                                            <option value="${p.id}" ${pd.product.id==p.id ? 'selected'
                                                                : '' }>${p.name} (${p.code})</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-6 form-group">
                                                    <label>Lot Number</label>
                                                    <input type="text" name="lotNumber" class="form-control"
                                                        value="${pd.lotNumber}" placeholder="Enter Lot Number">
                                                </div>
                                                <div class="col-md-6 form-group">
                                                    <label>Serial Number</label>
                                                    <input type="text" name="serialNumber" class="form-control"
                                                        value="${pd.serialNumber}" placeholder="Enter Serial Number">
                                                </div>
                                                <div class="col-md-4 form-group">
                                                    <label>Price * (Updated via Purchase)</label>
                                                    <input type="number" step="0.01" name="price" class="form-control"
                                                        value="${pd.price}" min="0" readonly required>
                                                </div>
                                                <div class="col-md-4 form-group">
                                                    <label>Color</label>
                                                    <input type="text" name="color" class="form-control"
                                                        value="${pd.color}" placeholder="e.g. Red, Blue">
                                                </div>
                                                <div class="col-md-4 form-group">
                                                    <label>Manufacture Date *</label>
                                                    <input type="date" name="mfdDate" class="form-control"
                                                        value="<fmt:formatDate value='${pd.manufactureDate}' pattern='yyyy-MM-dd'/>"
                                                        required>
                                                </div>
                                            </div>
                                            <hr>
                                            <button type="submit" class="btn btn-primary">Update Item</button>
                                            <a href="list-product-detail" class="btn btn-light">Back to List</a>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                </div>
            </body>

            </html>