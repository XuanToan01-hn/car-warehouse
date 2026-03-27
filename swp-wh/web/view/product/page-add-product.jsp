<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>WMS | Add Product</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>
            <div class="content-page">
                <div class="container-fluid">
                    <div class="card">
                        <div class="card-header"><h4>Add New Product</h4></div>
                        <div class="card-body">
                            <form action="add-product" method="post">
                                <div class="row">
                                    <div class="col-md-12 form-group">
                                        <label>Product Name * <span style="color:red">${eName}</span></label>
                                        <input type="text" name="name" value="${uName}" class="form-control" required>
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label>Product Code * <span style="color:red">${eCode}</span></label>
                                        <input type="text" name="code" value="${uCode}" class="form-control" required>
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label>Supplier</label>
                                        <select name="supplier" class="form-control">
                                            <c:forEach items="${listSupplier}" var="s">
                                                <option ${uSupplier == s.id ? 'selected' : ''} value="${s.id}">${s.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label>Category</label>
                                        <select name="category" class="form-control">
                                            <c:forEach items="${listCategory}" var="c">
                                                <option ${uCategory == c.id ? 'selected' : ''} value="${c.id}">${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label>Unit</label>
                                        <select name="unit" class="form-control">
                                            <c:forEach items="${listUnit}" var="unit">
                                                <option ${unitS == unit.id ? 'selected' : ''} value="${unit.id}">${unit.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-12 form-group">
                                        <label>Image URL *</label>
                                        <input type="text" name="image" value="${uImage}" class="form-control" placeholder="Paste image link here">
                                    </div>
                                    <div class="col-md-12 form-group">
                                        <label>Description</label>
                                        <textarea name="description" class="form-control" rows="3">${uDes}</textarea>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">Add Product</button>
                                <a href="list-product" class="btn btn-danger">Cancel</a>
                            </form>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty showStatus}">
                    <div class="alert ${showStatus ? 'alert-success' : 'alert-danger'}" style="position: fixed; top: 20px; right: 20px; z-index: 9999;">
                        ${showStatus ? 'Add successfully!' : 'Error,please check data!'}
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>