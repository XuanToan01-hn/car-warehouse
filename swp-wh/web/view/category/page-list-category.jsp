<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Category Management | InventoryPro</title>

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

                .btn-delete {
                    background: #fff1f2;
                    color: #be123c;
                    border-color: #fecdd3;
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

                .form-control-modern {
                    border-radius: 10px;
                    border: 2px solid #e2e8f0;
                    font-weight: 600;
                    height: 45px;
                }

                .search-container {
                    position: relative;
                    max-width: 400px;
                }

                .search-icon {
                    position: absolute;
                    left: 15px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #64748b;
                }

                #searchInput {
                    padding-left: 45px;
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
                                    <h1 class="font-weight-bold mb-1">Category Management</h1>
                                    <p class="text-secondary">Organize your products into logical categories</p>
                                </div>
                                <button class="btn btn-add" data-toggle="modal" data-target="#categoryModal"
                                    onclick="prepareAdd()">
                                    <i class="ri-add-line"></i> Add New Category
                                </button>
                            </div>

                            <div class="mb-4 d-flex justify-content-between align-items-center">
                                <form action="list-category" method="get" class="search-container flex-grow-1">
                                    <i class="ri-search-line search-icon"></i>
                                    <input type="text" name="search" id="searchInput"
                                        class="form-control form-control-modern" placeholder="Search categories..."
                                        value="${param.search}">
                                </form>
                            </div>

                            <div class="card card-main">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th style="width: 80px;">ID</th>
                                                    <th>Category Name</th>
                                                    <th>Description</th>
                                                    <th class="text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty categoryList}">
                                                        <tr>
                                                            <td colspan="4" class="text-center py-5">
                                                                <i
                                                                    class="ri-inbox-line display-4 text-muted d-block opacity-25"></i>
                                                                <p class="text-secondary mt-3">No categories found.</p>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="c" items="${categoryList}">
                                                            <tr>
                                                                <td><span
                                                                        class="text-secondary font-weight-bold">${c.id}</span>
                                                                </td>
                                                                <td><span
                                                                        class="font-weight-bold text-dark">${c.name}</span>
                                                                </td>
                                                                <td class="text-truncate" style="max-width: 400px;">
                                                                    ${c.description}</td>
                                                                <td class="text-right">
                                                                    <button class="btn-action btn-edit mr-2"
                                                                        onclick="prepareEdit('${c.id}')">
                                                                        <i class="ri-pencil-line"></i> Edit
                                                                    </button>
                                                                    <a href="list-category?action=delete&id=${c.id}"
                                                                        class="btn-action btn-delete"
                                                                        onclick="return confirm('Are you sure you want to delete this category?')">
                                                                        <i class="ri-delete-bin-line"></i> Delete
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="pagination-container d-flex justify-content-between align-items-center mb-5">
                                <p class="text-secondary mb-0">Showing page ${currentPage} of ${totalPages}</p>
                                <c:if test="${totalPages > 1}">
                                    <ul class="pagination mb-0">
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link"
                                                    href="list-category?page=${i}&search=${param.search}">${i}</a>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </c:if>
                            </div>
                        </div>
                    </div>
            </div>

            <!-- Modal -->
            <div class="modal fade" id="categoryModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title font-weight-bold" id="form-title">Add New Category</h5>
                            <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                        </div>
                        <div class="modal-body">
                            <form id="categoryForm" action="list-category" method="post">
                                <input type="hidden" name="action" id="form-action" value="add">
                                <input type="hidden" name="id" id="c-id">

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label">Category Name</label>
                                        <input type="text" name="name" id="f-name"
                                            class="form-control form-control-modern" placeholder="e.g. Spare Parts"
                                            required>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label">Description</label>
                                        <textarea name="description" id="f-description" class="form-control" rows="4"
                                            placeholder="Enter category description..."></textarea>
                                    </div>
                                </div>

                                <div class="text-right mt-4">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal"
                                        style="border-radius:10px;">Cancel</button>
                                    <button type="submit" class="btn btn-add ml-2">Save Category</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script>
                function prepareAdd() {
                    document.getElementById('form-title').innerText = "Add New Category";
                    document.getElementById('form-action').value = "add";
                    document.getElementById('categoryForm').reset();
                    document.getElementById('c-id').value = "";
                }

                function prepareEdit(id) {
                    fetch('list-category?action=getDetailJson&id=' + id)
                        .then(r => r.json())
                        .then(data => {
                            document.getElementById('form-title').innerText = "Edit Category";
                            document.getElementById('form-action').value = "update";
                            document.getElementById('c-id').value = data.id;
                            document.getElementById('f-name').value = data.name || '';
                            document.getElementById('f-description').value = data.description || '';
                            $('#categoryModal').modal('show');
                        });
                }
            </script>
        </body>

        </html>