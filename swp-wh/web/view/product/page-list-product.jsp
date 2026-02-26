<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Product List | InventoryPro</title>

                <link
                    href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">

                <style>
                    :root {
                        --primary: #0EA5E9;
                        --success: #15803d;
                        --danger: #ef4444;
                        --gray-dark: #0f172a;
                    }

                    body {
                        font-family: 'Be Vietnam Pro', sans-serif;
                        background-color: #f1f5f9;
                        color: #1e293b;
                    }

                    .page-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 2rem;
                        padding: 1.5rem 0;
                    }

                    .btn-add {
                        background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
                        color: white;
                        border-radius: 12px;
                        padding: 0.75rem 1.5rem;
                        font-weight: 700;
                        border: none;
                        box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                        transition: all 0.3s ease;
                    }

                    .btn-add:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
                        color: white;
                    }

                    .card-main {
                        border-radius: 16px;
                        border: none;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                        background: white;
                        overflow: hidden;
                        margin-bottom: 2rem;
                    }

                    .table thead th {
                        background: #e2e8f0;
                        font-weight: 800;
                        color: #0f172a;
                        text-transform: uppercase;
                        font-size: 0.85rem;
                        padding: 1.25rem 1.5rem;
                    }

                    .table tbody td {
                        padding: 1.25rem 1.5rem;
                        vertical-align: middle;
                        font-weight: 500;
                    }

                    .btn-action {
                        padding: 0.4rem 0.8rem;
                        border-radius: 8px;
                        font-weight: 600;
                        font-size: 0.85rem;
                        border: 1px solid transparent;
                        transition: all 0.2s;
                        text-decoration: none !important;
                    }

                    .btn-edit {
                        background: #f0f9ff;
                        color: #0369a1;
                        border-color: #bae6fd;
                    }

                    .btn-detail {
                        background: #fdf2f8;
                        color: #9d174d;
                        border-color: #fce7f3;
                    }

                    .btn-delete {
                        background: #fff1f2;
                        color: #be123c;
                        border-color: #fecdd3;
                    }

                    .filter-section {
                        background: white;
                        padding: 1.5rem;
                        border-radius: 12px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
                        margin-bottom: 1.5rem;
                    }

                    .form-control-modern {
                        border-radius: 10px;
                        border: 2px solid #e2e8f0;
                        font-weight: 600;
                        height: 45px;
                    }

                    .product-img {
                        width: 50px;
                        height: 50px;
                        object-fit: cover;
                        border-radius: 10px;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                    }

                    /* Modal Style */
                    .modal-content {
                        border-radius: 20px;
                        border: none;
                        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    }

                    .modal-header {
                        border-bottom: 1px solid #f1f5f9;
                        padding: 1.5rem 2rem;
                    }

                    .modal-body {
                        padding: 2rem;
                    }

                    .form-label {
                        font-weight: 700;
                        color: var(--gray-dark);
                        text-transform: uppercase;
                        font-size: 0.8rem;
                    }

                    .pagination-container .page-link {
                        border-radius: 8px;
                        margin: 0 3px;
                        font-weight: 700;
                        color: #475569;
                        border: 1px solid #e2e8f0;
                    }

                    .pagination-container .page-item.active .page-link {
                        background-color: var(--primary);
                        border-color: var(--primary);
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <div class="content-page">
                            <div class="container-fluid">
                                <div class="page-header">
                                    <div>
                                        <h1 class="font-weight-bold mb-1">Product List</h1>
                                        <p class="text-secondary">Manage your inventory products and categories</p>
                                    </div>
                                    <a href="add-product" class="btn btn-add">
                                        <i class="ri-add-box-line"></i> Add New Product
                                    </a>
                                </div>

                                <div class="filter-section">
                                    <form method="get" action="list-product" id="filterForm">
                                        <div class="row align-items-end">
                                            <div class="col-md-3 mb-3 mb-md-0">
                                                <label class="form-label">Search</label>
                                                <input type="text" name="search"
                                                    class="form-control form-control-modern"
                                                    placeholder="Name or code..." value="${param.search}">
                                            </div>
                                            <div class="col-md-2 mb-3 mb-md-0">
                                                <label class="form-label">Category</label>
                                                <select name="categoryId" class="form-control form-control-modern"
                                                    onchange="this.form.submit()">
                                                    <option value="">All Categories</option>
                                                    <c:forEach items="${listCategory}" var="cat">
                                                        <option value="${cat.id}" ${param.categoryId==cat.id
                                                            ? 'selected' : '' }>${cat.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-2 mb-3 mb-md-0">
                                                <label class="form-label">Price Sort</label>
                                                <select name="sortPrice" class="form-control form-control-modern"
                                                    onchange="this.form.submit()">
                                                    <option value="">No Sorting</option>
                                                    <option value="asc" ${param.sortPrice=='asc' ? 'selected' : '' }>Low
                                                        to High</option>
                                                    <option value="desc" ${param.sortPrice=='desc' ? 'selected' : '' }>
                                                        High to Low</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <button type="submit" class="btn btn-primary btn-block"
                                                    style="height: 45px; border-radius: 10px;">
                                                    <i class="ri-filter-line"></i> Filter
                                                </button>
                                            </div>
                                            <div class="col-md-1">
                                                <a href="list-product" class="btn btn-light btn-block"
                                                    style="height: 45px; border-radius: 10px; display: flex; align-items: center; justify-content: center;">
                                                    <i class="ri-refresh-line"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <div class="card card-main">
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table mb-0">
                                                <thead>
                                                    <tr>
                                                        <th>Product Info</th>
                                                        <th>Price</th>
                                                        <th>Category</th>
                                                        <th>Unit</th>
                                                        <th class="text-right">Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${listProduct}" var="p">
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-center">
                                                                    <img src="${pageContext.request.contextPath}/assets/images/table/product/${p.image}"
                                                                        class="product-img mr-3"
                                                                        onerror="this.src='${pageContext.request.contextPath}/assets/images/user/1.png'">
                                                                    <div>
                                                                        <div class="font-weight-bold text-dark">
                                                                            ${p.name}</div>
                                                                        <small
                                                                            class="text-primary font-weight-bold">${p.code}</small>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <span class="font-weight-bold">
                                                                    <fmt:formatNumber value="${p.price}"
                                                                        pattern="#,##0" />
                                                                </span>
                                                            </td>
                                                            <td><span
                                                                    class="badge badge-light p-2">${p.category.name}</span>
                                                            </td>
                                                            <td>${p.unit.name}</td>
                                                            <td class="text-right">
                                                                <div class="d-flex justify-content-end">
                                                                    <a href="list-product-detail?productId=${p.id}"
                                                                        class="btn-action btn-detail mr-2">
                                                                        <i class="ri-eye-line"></i> Detail
                                                                    </a>
                                                                    <button class="btn-action btn-edit mr-2"
                                                                        onclick="prepareEdit('${p.id}')">
                                                                        <i class="ri-pencil-line"></i> Edit
                                                                    </button>
                                                                    <button class="btn-action btn-delete"
                                                                        onclick="prepareDelete('${p.id}', '${p.name}')">
                                                                        <i class="ri-delete-bin-line"></i> Delete
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <div
                                    class="pagination-container d-flex justify-content-between align-items-center mb-5">
                                    <p class="text-secondary mb-0">Page ${currentPage} of ${totalPages}</p>
                                    <c:if test="${totalPages > 1}">
                                        <ul class="pagination mb-0">
                                            <c:if test="${hasPrevious}">
                                                <li class="page-item"><a class="page-link"
                                                        href="list-product?page=${currentPage - 1}&search=${param.search}&sortPrice=${param.sortPrice}&categoryId=${param.categoryId}">Previous</a>
                                                </li>
                                            </c:if>
                                            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="list-product?page=${i}&search=${param.search}&sortPrice=${param.sortPrice}&categoryId=${param.categoryId}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            <c:if test="${hasNext}">
                                                <li class="page-item"><a class="page-link"
                                                        href="list-product?page=${currentPage + 1}&search=${param.search}&sortPrice=${param.sortPrice}&categoryId=${param.categoryId}">Next</a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                </div>

                <!-- Edit Modal -->
                <div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title font-weight-bold">Update Product</h5>
                                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                            </div>
                            <div class="modal-body">
                                <form action="update-product" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="id" id="product-id">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Product Name</label>
                                            <input type="text" name="name" id="product-name" class="form-control"
                                                required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Product Code</label>
                                            <input type="text" name="code" id="product-code" class="form-control"
                                                required>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 mb-3">
                                            <label class="form-label">Price</label>
                                            <input type="number" name="price" id="product-price" class="form-control"
                                                required>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label class="form-label">Category</label>
                                            <select name="category" id="category-select" class="form-control" required>
                                                <c:forEach items="${listCategory}" var="cat">
                                                    <option value="${cat.id}">${cat.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <label class="form-label">Unit</label>
                                            <select name="unit" id="unit-select" class="form-control" required>
                                                <c:forEach items="${listUnit}" var="unit">
                                                    <option value="${unit.id}">${unit.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12 mb-3">
                                            <label class="form-label">Product Image</label>
                                            <div class="custom-file">
                                                <input type="hidden" name="oldimage" id="product-image-old">
                                                <input type="file" name="image" class="custom-file-input"
                                                    id="product-image">
                                                <label class="custom-file-label" id="file-image-label">Choose
                                                    file</label>
                                            </div>
                                            <small class="text-secondary">Leave blank to keep current image</small>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12 mb-3">
                                            <label class="form-label">Description</label>
                                            <textarea name="description" id="product-des" class="form-control"
                                                rows="3"></textarea>
                                        </div>
                                    </div>
                                    <div class="text-right mt-4">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal"
                                            style="border-radius:10px;">Cancel</button>
                                        <button type="submit" class="btn btn-primary"
                                            style="padding: 0.75rem 2rem; border-radius: 12px; font-weight: 700;">Update
                                            Product</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Delete Modal -->
                <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title font-weight-bold text-danger">Confirm Delete</h5>
                                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                            </div>
                            <div class="modal-body text-center">
                                <i class="ri-error-warning-line display-3 text-warning mb-3 d-block"></i>
                                <p class="h5">Are you sure you want to delete this product?</p>
                                <p class="text-danger font-weight-bold" id="deleteProductName"></p>
                                <form action="delete-product" method="post" class="mt-4">
                                    <input type="hidden" name="id" id="deleteProductId">
                                    <button type="button" class="btn btn-secondary mr-2"
                                        data-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-danger" style="padding: 0.5rem 2rem;">Delete
                                        Permanently</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script>
                    function prepareEdit(id) {
                        fetch('list-product?action=getDetailJson&id=' + id)
                            .then(r => r.json())
                            .then(data => {
                                document.getElementById('product-id').value = data.id;
                                document.getElementById('product-name').value = data.name;
                                document.getElementById('product-code').value = data.code;
                                document.getElementById('product-price').value = data.price;
                                document.getElementById('category-select').value = data.categoryId;
                                document.getElementById('unit-select').value = data.unitId;
                                document.getElementById('product-des').value = data.description || '';
                                document.getElementById('product-image-old').value = data.image || '';
                                document.getElementById('file-image-label').innerText = data.image || 'Choose file';
                                $('#updateModal').modal('show');
                            });
                    }

                    function prepareDelete(id, name) {
                        document.getElementById('deleteProductId').value = id;
                        document.getElementById('deleteProductName').innerText = name;
                        $('#deleteModal').modal('show');
                    }

                    // File input label update
                    document.getElementById('product-image').addEventListener('change', function (e) {
                        var fileName = e.target.files[0].name;
                        document.getElementById('file-image-label').innerText = fileName;
                    });
                </script>
            </body>

            </html>