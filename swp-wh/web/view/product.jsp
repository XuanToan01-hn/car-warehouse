<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Product Management | InventoryPro</title>

    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">

    <style>
        :root {
            --primary: #0EA5E9;
            --success: #10b981;
            --danger: #ef4444;
            --warning: #f59e0b;
            --gray-dark: #0f172a;
        }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background-color: #f8fafc;
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
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
            color: white;
            text-decoration: none;
        }

        .search-section {
            background: white;
            padding: 1.5rem;
            border-radius: 16px;
            margin-bottom: 2rem;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
        }

        .card-main {
            border-radius: 16px;
            border: none;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            background: white;
            overflow: hidden;
        }

        .table thead th {
            background: #f1f5f9;
            font-weight: 800;
            color: #475569;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .table tbody td {
            padding: 1.25rem 1.5rem;
            vertical-align: middle;
            font-weight: 500;
            border-bottom: 1px solid #f1f5f9;
        }

        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
            border: 1px solid transparent;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-edit { background: #f0f9ff; color: #0369a1; border-color: #bae6fd; }
        .btn-edit:hover { background: #e0f2fe; color: #0369a1; text-decoration: none; }
        .btn-delete { background: #fff1f2; color: #be123c; border-color: #fecdd3; }
        .btn-delete:hover { background: #ffe4e6; }
        .btn-variants { background: #f0fdf4; color: #15803d; border-color: #bbf7d0; }
        .btn-variants:hover { background: #dcfce7; }

        .form-card {
            background: white;
            border-radius: 16px;
            border: none;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .form-label {
            font-weight: 700;
            color: var(--gray-dark);
            text-transform: uppercase;
            font-size: 0.75rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control {
            border-radius: 10px;
            border: 2px solid #e2e8f0;
            font-weight: 600;
            padding: 0.6rem 1rem;
            transition: border-color 0.2s;
        }

        .form-control:focus { border-color: var(--primary); box-shadow: none; }
        
        .btn-cancel {
            background: #f1f5f9;
            color: #64748b;
            border-radius: 10px;
            padding: 0.5rem 1.25rem;
            font-weight: 600;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
    </style>
</head>

<body>
    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>
        <jsp:include page="header.jsp" />

        <div class="content-page">
            <div class="container-fluid">

                <div class="page-header">
                    <h1 class="font-weight-bold h2">Product Management</h1>
                    <c:choose>
                        <c:when test="${mode == 'add' or mode == 'edit'}">
                            <a href="list-product" class="btn-cancel">
                                <i class="ri-arrow-left-line mr-1"></i> Back to List
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="list-product?mode=add" class="btn-add">
                                <i class="ri-add-line"></i> Add New Product
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Flash messages --%>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert" style="border-radius: 12px; font-weight: 600;">
                        <i class="ri-error-warning-line mr-2"></i> ${sessionScope.error}
                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                    </div>
                    <% session.removeAttribute("error"); %>
                </c:if>
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px; font-weight: 600;">
                        <i class="ri-checkbox-circle-line mr-2"></i> ${sessionScope.success}
                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                    </div>
                    <% session.removeAttribute("success"); %>
                </c:if>

                <%-- Forms section --%>
                <c:if test="${mode == 'add' or mode == 'edit'}">
                    <div class="form-card">
                        <h5 class="mb-4 font-weight-bold">${mode == 'edit' ? 'Edit Product' : 'Add New Product'}</h5>
                        <form action="list-product" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="${mode == 'edit' ? 'update' : 'add'}">
                            <c:if test="${mode == 'edit'}">
                                <input type="hidden" name="id" value="${editProduct.id}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Product Code</label>
                                    <input type="text" name="code" class="form-control" placeholder="e.g. PROD-001" required
                                           value="${mode == 'edit' ? editProduct.code : ''}">
                                </div>
                                <div class="col-md-8 mb-3">
                                    <label class="form-label">Product Name</label>
                                    <input type="text" name="name" class="form-control" placeholder="Enter product name" required
                                           value="${mode == 'edit' ? editProduct.name : ''}">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Category</label>
                                    <select name="categoryId" class="form-control" required>
                                        <option value="">Select Category</option>
                                        <c:forEach var="c" items="${categories}">
                                            <option value="${c.id}" ${editProduct.category.id == c.id ? 'selected' : ''}>${c.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Unit</label>
                                    <select name="unitId" class="form-control" required>
                                        <option value="">Select Unit</option>
                                        <c:forEach var="u" items="${units}">
                                            <option value="${u.id}" ${editProduct.unit.id == u.id ? 'selected' : ''}>${u.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Supplier</label>
                                    <select name="supplierId" class="form-control" required>
                                        <option value="">Select Supplier</option>
                                        <c:forEach var="s" items="${suppliers}">
                                            <option value="${s.id}" ${editProduct.supplier.id == s.id ? 'selected' : ''}>${s.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Product Image</label>
                                <input type="file" name="image" class="form-control" accept="image/*">
                                <c:if test="${mode == 'edit' and not empty editProduct.image}">
                                    <small class="text-muted d-block mt-1">Current image: ${editProduct.image}</small>
                                </c:if>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" rows="3" placeholder="Enter product description">${mode == 'edit' ? editProduct.description : ''}</textarea>
                            </div>

                            <div class="text-right">
                                <a href="list-product" class="btn-cancel mr-2">Cancel</a>
                                <button type="submit" class="btn btn-add ml-2">Save Product</button>
                            </div>
                        </form>
                    </div>
                </c:if>

                <%-- List section --%>
                <c:if test="${empty mode}">
                    <div class="search-section">
                        <form action="list-product" method="get" class="row align-items-end">
                            <div class="col-md-4">
                                <label class="form-label">Keyword</label>
                                <input type="text" name="search" class="form-control" placeholder="Search by code or name..." value="${search}">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Category</label>
                                <select name="categoryId" class="form-control">
                                    <option value="0">All Categories</option>
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.id}" ${categoryId == c.id ? 'selected' : ''}>${c.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Supplier</label>
                                <select name="supplierId" class="form-control">
                                    <option value="0">All Suppliers</option>
                                    <c:forEach var="s" items="${suppliers}">
                                        <option value="${s.id}" ${supplierId == s.id ? 'selected' : ''}>${s.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary btn-block py-2" style="border-radius: 10px; font-weight: 700;">
                                    <i class="ri-search-line mr-1"></i> Filter
                                </button>
                            </div>
                        </form>
                    </div>

                    <div class="card card-main">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 80px;">Image</th>
                                            <th>Code</th>
                                            <th>Product Name</th>
                                            <th>Category</th>
                                            <th>Supplier</th>
                                            <th>Unit</th>
                                            <th class="text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${products}">
                                            <tr>
                                                <td>
                                                    <img src="${pageContext.request.contextPath}/assets/images/product/${p.image}" 
                                                         alt="${p.name}" 
                                                         style="width: 50px; height: 50px; object-fit: cover; border-radius: 8px; border: 1px solid #e2e8f0;">
                                                </td>
                                                <td><span class="font-weight-bold text-primary">${p.code}</span></td>
                                                <td><span class="font-weight-bold text-dark">${p.name}</span></td>
                                                <td>${p.category.name}</td>
                                                <td>${p.supplier.name}</td>
                                                <td><span class="badge badge-info py-1 px-2" style="border-radius: 6px;">${p.unit.name}</span></td>
                                                <td class="text-right">
                                                    <a href="list-product?mode=edit&id=${p.id}" class="btn-action btn-edit mr-2">
                                                        <i class="ri-pencil-line"></i> Edit
                                                    </a>
                                                    <form action="list-product" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${p.id}">
                                                        <button type="submit" class="btn-action btn-delete" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này không?')">
                                                            <i class="ri-delete-bin-line"></i> Delete
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty products}">
                                            <tr><td colspan="6" class="text-center py-5 text-secondary">No products found.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <%-- Pagination --%>
                            <c:if test="${totalPages > 1}">
                                <nav class="mt-4 pb-4">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="list-product?page=${currentPage - 1}&search=${search}&categoryId=${categoryId}&supplierId=${supplierId}">Previous</a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="list-product?page=${i}&search=${search}&categoryId=${categoryId}&supplierId=${supplierId}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="list-product?page=${currentPage + 1}&search=${search}&categoryId=${categoryId}&supplierId=${supplierId}">Next</a>
                                        </li>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
</body>
</html>
