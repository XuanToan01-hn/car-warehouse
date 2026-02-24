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
                            <form action="add-product" method="post" enctype="multipart/form-data">
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
                                        <label>Price * <span style="color:red">${ePrice}</span></label>
                                        <input type="number" name="price" value="${uPrice}" class="form-control" required>
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
                                        <label>Quantity * <span style="color:red">${eQuantity}</span></label>
                                        <input type="number" name="quantity" value="${uQuantity}" class="form-control" min="0" required>
                                    </div>
                                    <div class="col-md-12 form-group">
                                        <label>Ảnh sản phẩm (tải từ thiết bị)</label>
                                        <input type="file" name="image" class="form-control" accept="image/*">
                                        <small class="text-muted">Định dạng: JPG, PNG, GIF, WebP. Để trống nếu không đổi ảnh.</small>
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
                        ${showStatus ? 'Thêm thành công!' : 'Lỗi: Vui lòng kiểm tra lại các trường!'}
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>