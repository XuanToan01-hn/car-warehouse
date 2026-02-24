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
    <body>
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>  

            <div class="content-page">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4">
                                <div>
                                    <h4 class="mb-3">Product List</h4>
                                    <p class="mb-0">Manage your warehouse products effectively.</p>
                                </div>
                                <a style="color: #fff" href="add-product" class="btn btn-primary add-list">Add Product</a>
                            </div>
                        </div>
                        <div class="col-lg-12">
                            <div class="filter-section mb-4">
                                <form method="get" action="list-product">
                                    <div class="row">
                                        <div class="col-md-2">
                                            <select name="sortPrice" class="form-control" onchange="this.form.submit()">
                                                <option value="">Sort by Price</option>
                                                <option value="asc" ${param.sortPrice == 'asc' ? 'selected' : ''}>Low to High</option>
                                                <option value="desc" ${param.sortPrice == 'desc' ? 'selected' : ''}>High to Low</option>
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
                                            <input type="text" name="search" class="form-control" placeholder="Search by name or code" value="${param.search}">
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
                                        <th>Unit</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody class="ligth-body">
                                    <c:forEach items="${listProduct}" var="p">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}/assets/images/table/product/${p.image}" class="img-fluid rounded avatar-50 mr-3" alt="image">
                                                    <div>
                                                        ${p.name}
                                                        <p class="mb-0"><small>${p.code}</small></p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><fmt:formatNumber value="${p.price}" pattern="#,###"/></td>
                                            <td>${p.description}</td>
                                            <td>${p.category.name}</td>
                                            <td>${p.unit.name}</td>
                                            <td>
                                                <div class="d-flex align-items-center list-action">
                                                    <%-- SỬA productId -> id và categoryId -> id --%>
                                                    <a class="badge bg-success mr-2" href="javascript:void(0)" 
                                                       onclick="openUpdateForm(${p.id}, '${p.name}', '${p.code}', '${p.description}', ${p.price}, '${p.image}', ${p.category.id}, ${p.unit.id})">Edit</a>
                                                    <a class="badge bg-warning mr-2" href="javascript:void(0)" 
                                                       onclick="openDeleteForm(${p.id}, '${p.name}')">Delete</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <%-- Pagination --%>
                            <div class="pagination mt-3 justify-content-end">
                                <c:if test="${totalPages > 1}">
                                    <ul class="pagination">
                                        <c:if test="${hasPrevious}">
                                            <li class="page-item"><a class="page-link" href="list-product?page=${currentPage - 1}&search=${param.search}&sortPrice=${param.sortPrice}&categoryId=${param.categoryId}&pageSize=${pageSize}">Previous</a></li>
                                        </c:if>
                                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}"><a class="page-link" href="list-product?page=${i}">${i}</a></li>
                                        </c:forEach>
                                        <c:if test="${hasNext}">
                                            <li class="page-item"><a class="page-link" href="list-product?page=${currentPage + 1}">Next</a></li>
                                        </c:if>
                                    </ul>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Update Modal --%>
                <div id="updateModal" class="modal modal-product">
                    <div class="modal-product-detail">
                        <div class="alert alert-primary"><h3>Update Product</h3></div>
                        <form id="updateForm" action="update-product" method="post" enctype="multipart/form-data">
                            <div class="card-body">
                                <input type="hidden" name="id" value="${uId}" id="product-id">
                                <div class="form-group">
                                    <label>Name * <span style="color: red;">${eName}</span></label>
                                    <input type="text" value="${uName}" name="name" class="form-control" id="product-name" required>
                                </div>
                                <div class="form-group">
                                    <label>Price * <span style="color: red;">${ePrice}</span></label>
                                    <input type="number" value="${uPrice}" name="price" class="form-control" id="product-price" required>
                                </div>
                                <div class="form-group">
                                    <label>Category *</label>
                                    <select class="form-control" name="category" id="category-select">
                                        <c:forEach items="${listCategory}" var="c">
                                            <option ${uCategory == c.id ? 'selected' : ''} value="${c.id}">${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Unit *</label>
                                    <select name="unit" id="unit-select" class="form-control">
                                        <c:forEach items="${listUnit}" var="unit">
                                            <option ${unitS == unit.id ? 'selected' : ''} value="${unit.id}">${unit.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary">Submit</button>
                                <button type="button" onclick="closeUpdateForm()" class="btn bg-danger">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/assets/js/productManagement.js"></script>
    </body>
</html>