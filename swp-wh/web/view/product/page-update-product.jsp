<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>WMS | Update Product</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>
            <div class="content-page">
                <div class="container-fluid">
                    <div class="card">
                        <div class="card-header"><h4>Update Product: ${p.name}</h4></div>
                        <div class="card-body">
                            <form action="update-product" method="post">
                                <input type="hidden" name="id" value="${p.id}">

                                <div class="row">
                                    <div class="col-md-12 form-group">
                                        <label>Product Name * <span style="color:red">${eName}</span></label>
                                        <input type="text" name="name" value="${p.name}" class="form-control" required>
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label>Product Code * <span style="color:red">${eCode}</span></label>
                                        <input type="text" name="code" value="${p.code}" class="form-control" required>
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label>Supplier</label>
                                        <select name="supplier" class="form-control">
                                            <c:forEach items="${listSupplier}" var="s">
                                                <option ${p.supplier.id == s.id ? 'selected' : ''} value="${s.id}">${s.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label>Category</label>
                                        <select name="category" class="form-control">
                                            <c:forEach items="${listCategory}" var="c">
                                                <option ${p.category.id == c.id ? 'selected' : ''} value="${c.id}">${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label>Unit</label>
                                        <select name="unit" class="form-control">
                                            <c:forEach items="${listUnit}" var="unit">
                                                <option ${p.unit.id == unit.id ? 'selected' : ''} value="${unit.id}">${unit.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-12 form-group">
                                        <label>Image URL *</label>
                                        <input type="text" name="image" value="${p.image}" class="form-control" placeholder="Link ảnh">
                                        <c:if test="${not empty p.image}">
                                            <div class="mt-2">
                                                <img src="${p.image}" alt="preview" style="height: 100px; border-radius: 5px;">
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="col-md-12 form-group">
                                        <label>Description</label>
                                        <textarea name="description" class="form-control" rows="3">${p.description}</textarea>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary">Save Changes</button>
                                <a href="list-product" class="btn btn-danger">Cancel</a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>