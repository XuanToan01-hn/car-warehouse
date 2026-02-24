<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>WMS | Warehouse Management System</title>
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">       
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/pagination.css">  
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/productManagement.css">  
    </head>
    <body class="  ">
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>  

            <div class="content-page">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4">
                                <div>
                                    <h4 class="mb-3">Product List</h4>
                                    <p class="mb-0">The product list effectively dictates product presentation...</p>
                                </div>
                                <a style="color: #fff" href="add-product" class="btn btn-primary add-list">Add Product</a>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <div class="rounded mb-3">
                                <div class="filter-section mb-4">
                                    <form method="get" action="list-product">
                                        <div class="row">
                                            <div class="col-md-2">
                                                <select name="sortPrice" class="form-control" onchange="this.form.submit()">
                                                    <option value="">Sort by Price</option>
                                                    <option value="asc" ${param.sortPrice == 'asc' ? 'selected' : ''}>Price: Low to High</option>
                                                    <option value="desc" ${param.sortPrice == 'desc' ? 'selected' : ''}>Price: High to Low</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <select name="categoryId" class="form-control" onchange="this.form.submit()">
                                                    <option value="">All Categories</option>
                                                    <c:forEach items="${listCategory}" var="category">
                                                        <option value="${category.id}" ${param.categoryId == category.id ? 'selected' : ''}>${category.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <input type="text" name="search" class="form-control" placeholder="Search by product name or code" value="${param.search}">
                                            </div>
                                            <div class="col-md-1">
                                                <button type="submit" class="btn btn-primary">Filter</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <table class="table mb-0">
                                    <thead class="bg-white text-uppercase">
                                        <tr class="ligth ligth-data">
                                            <th>Product</th>
                                            <th>Price</th>
                                            <th>Description</th>
                                            <th>Category</th>
                                            <th>Quantity</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody class="ligth-body">
                                        <c:forEach items="${listProduct}" var="p">
                                            <tr>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/list-product-detail?productId=${p.id}" class="d-flex align-items-center" style="text-decoration: none; color: inherit;">
                                                        <c:choose>
                                                            <c:when test="${not empty p.image}">
                                                                <img src="${pageContext.request.contextPath}/assets/images/table/product/${p.image}" class="img-fluid rounded avatar-50 mr-3" alt="image">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="rounded avatar-50 mr-3 bg-light d-flex align-items-center justify-content-center text-muted" style="width: 50px; height: 50px; font-size: 0.7rem;">No img</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div class="data-name">
                                                            ${p.name}
                                                            <p class="mb-0" style="justify-self: baseline"><small>${p.code}</small></p>
                                                        </div>
                                                    </a>
                                                </td>
                                                <td><fmt:formatNumber value="${p.price}"/></td>
                                                <td class="data-des">${p.description}</td>
                                                <td>${p.category.name}</td>
                                                <td>${p.minStock}</td>
                                                <td>
                                                    <div class="d-flex align-items-center list-action">
                                                        <%-- CHỖ NÀY QUAN TRỌNG: Sửa productId thành id, categoryId thành id --%>
                                                        <a class="badge bg-info mr-2" href="${pageContext.request.contextPath}/list-product-detail?productId=${p.id}">Detail</a>
                                                        <a class="badge bg-success mr-2" href="javascript:void(0)" 
                                                           onclick="openUpdateForm(${p.id}, '${p.name}', '${p.code}', '${p.description}', ${p.price}, '${p.image}', ${p.category.id}, ${p.minStock})">Edit</a>
                                                        <a class="badge bg-warning mr-2" href="javascript:void(0)" 
                                                           onclick="openDeleteForm(${p.id}, '${p.name}')">Delete</a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <%-- Giữ nguyên phần Pagination của bạn --%>
                                <div class="pagination mt-3 justify-content-end mr-5">
                                    <c:if test="${totalPages > 1}">
                                        <ul class="pagination justify-content-center">
                                            <c:if test="${hasPrevious}">
                                                <li class="page-item"><a class="page-link" href="list-product?page=${currentPage - 1}&search=${param.search}&sortPrice=${param.sortPrice}&categoryId=${param.categoryId}&pageSize=${param.pageSize}">Previous</a></li>
                                            </c:if>
                                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="list-product?page=${i}&search=${param.search}&sortPrice=${param.sortPrice}&categoryId=${param.categoryId}&pageSize=${param.pageSize}">${i}</a></li>
                                            </c:forEach>
                                            <c:if test="${hasNext}">
                                                <li class="page-item"><a class="page-link" href="list-product?page=${currentPage + 1}&search=${param.search}&sortPrice=${param.sortPrice}&categoryId=${param.categoryId}&pageSize=${param.pageSize}">Next</a></li>
                                            </c:if>
                                        </ul>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Update Modal - Giữ nguyên toàn bộ ID và Name --%>
                <div id="updateModal" class="modal modal-product">
                    <div class="modal-product-detail">
                        <div class="alert alert-primary">
                            <div class="media-body ms-3"><h3 style="margin-bottom: 0; color: #0e5699;">Update Product</h3></div>
                        </div>
                        <form id="updateForm" action="update-product" method="post">
                            <div class="card-body">
                                <input type="hidden" name="id" value="${uId}" id="product-id">
                                <div class="form-group">
                                    <label for="product-name">Name * <span style="color: red;" id="error1">${eName}</span></label>
                                    <input type="text" value="${uName}" style="${not empty eName ? 'border: 1px solid red;' : ''}" name="name" class="form-control" id="product-name" required="">
                                </div>
                                <div class="form-group">
                                    <label for="product-code">Code * <span style="color: red;" id="error2">${eCode}</span></label>
                                    <input type="text" value="${uCode}" style="${not empty eCode ? 'border: 1px solid red;' : ''}" name="code" class="form-control" id="product-code" required="">
                                </div>
                                <div class="form-group">
                                    <label for="product-price">Price * <span style="color: red;" id="error3">${ePrice}</span></label>
                                    <input type="number" value="${uPrice}" style="${not empty ePrice ? 'border: 1px solid red;' : ''}" name="price" class="form-control" id="product-price" required="">
                                </div>
                                <div class="form-group">
                                    <label>Category *</label>
                                    <select class="form-control mb-3" name="category" id="category-select">
                                        <c:forEach items="${listCategory}" var="c">
                                            <%-- Sửa c.categoryId thành c.id --%>
                                            <option ${uCategory == c.id ? 'selected' : ''} value="${c.id}">${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="product-quantity">Quantity * <span style="color: red;" id="error5">${eQuantity}</span></label>
                                    <input type="number" value="${uQuantity}" style="${not empty eQuantity ? 'border: 1px solid red;' : ''}" name="quantity" class="form-control" id="product-quantity" min="0" required="">
                                </div>
                                <div class="form-group">
                                    <label>Image *</label>
                                    <div class="custom-file">
                                        <input type="hidden" name="oldimage" value="${uImage}" id="product-image-old">
                                        <input type="file" name="image" class="custom-file-input" id="product-image" accept=".jpg, .jpeg, .png">
                                        <label class="custom-file-label" for="product-image" id="file-image">${not empty uImage ? uImage : 'Choose file'}</label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="product-des">Description* <span style="color: red;" id="error4">${eDesc}</span></label>
                                    <textarea class="form-control" style="${not empty eDesc ? 'border: 1px solid red;' : ''}" name="description" id="product-des" rows="3">${uDes}</textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">Submit</button>
                                <button type="button" onclick="closeUpdateForm()" class="btn bg-danger">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- Delete Modal - Giữ nguyên --%>
                <div id="deleteModal" class="modal modal-product">
                    <div class="card modal-product-detail text-center">
                        <div class="card-body">
                            <form action="delete-product" method="post">
                                <h2 class="card-title">Delete Confirmation</h2>
                                <input type="hidden" name="id" id="deleteProductId">
                                <p class="card-text">Are you sure you want to delete Product: <span id="deleteProductName"></span></p>
                                <div class="confim-modal">
                                    <button type="submit" class="btn btn-primary btn-block">Delete</button>
                                    <a href="javascript:void(0)" onclick="closeDeleteForm()" class="btn bg-danger btn-block">Close</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%-- Scripts của bạn --%>
        <script type="text/javascript" src="${pageContext.request.contextPath}/assets/js/productManagement.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
        <script async="" src="${pageContext.request.contextPath}/assets/js/chart-custom.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

        <c:if test="${showUpdateModal}">
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    document.getElementById('updateModal').style.display = 'block';
                });
            </script>
        </c:if>
    </body>
</html>