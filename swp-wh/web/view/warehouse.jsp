<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Warehouse Management | InventoryPro</title>

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
                }

                .btn-edit {
                    background: #f0f9ff;
                    color: #0369a1;
                    border-color: #bae6fd;
                }

                .btn-edit:hover {
                    background: #e0f2fe;
                }

                .btn-delete {
                    background: #fff1f2;
                    color: #be123c;
                    border-color: #fecdd3;
                }

                .btn-delete:hover {
                    background: #ffe4e6;
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

                .form-control:focus {
                    border-color: var(--primary);
                    box-shadow: none;
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
                                <h1 class="font-weight-bold h2">Warehouse Management</h1>
                                <button class="btn btn-add" data-toggle="modal" data-target="#warehouseModal"
                                    onclick="prepareAdd()">
                                    <i class="ri-add-line"></i> Add New Warehouse
                                </button>
                            </div>

                            <c:if test="${not empty sessionScope.error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert"
                                    style="border-radius: 12px; font-weight: 600;">
                                    <i class="ri-error-warning-line mr-2"></i> ${sessionScope.error}
                                    <button type="button" class="close"
                                        data-dismiss="alert"><span>&times;</span></button>
                                </div>
                                <c:remove var="error" scope="session" />
                            </c:if>
                            <c:if test="${not empty sessionScope.success}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert"
                                    style="border-radius: 12px; font-weight: 600;">
                                    <i class="ri-checkbox-circle-line mr-2"></i> ${sessionScope.success}
                                    <button type="button" class="close"
                                        data-dismiss="alert"><span>&times;</span></button>
                                </div>
                                <c:remove var="success" scope="session" />
                            </c:if>

                            <div class="search-section" style="background: white; padding: 1rem 1.5rem; border-radius: 12px; display: flex; align-items: center; gap: 1rem; margin-bottom: 1.5rem; border: 1px solid #e2e8f0; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02); max-width: 500px;">
                                <i class="ri-search-line" style="color: var(--primary); font-size: 1.2rem;"></i>
                                <input type="text" id="searchInput" placeholder="Search by code, name or address..." style="border: none; font-weight: 600; outline: none; width: 100%; background: transparent;">
                            </div>

                            <div class="card card-main">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Warehouse Code</th>
                                                    <th>Name</th>
                                                    <th>Address</th>
                                                    <th>Description</th>
                                                    <th class="text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="w" items="${warehouses}">
                                                    <tr class="warehouse-row">
                                                        <td><span
                                                                class="font-weight-bold text-primary">${w.warehouseCode}</span>
                                                        </td>
                                                        <td><span
                                                                class="font-weight-bold text-dark">${w.warehouseName}</span>
                                                        </td>
                                                        <td><span class="text-secondary">${w.address}</span></td>
                                                        <td><span class="text-secondary">${w.description}</span>
                                                        </td>
                                                        <td class="text-right">
                                                            <button class="btn-action btn-edit mr-2"
                                                                data-id="${w.id}"
                                                                data-code="${w.warehouseCode}"
                                                                data-name="${w.warehouseName}"
                                                                data-address="${w.address}"
                                                                data-description="${w.description}"
                                                                onclick="prepareEdit(this)">
                                                                <i class="ri-pencil-line"></i> Edit
                                                            </button>
                                                            <form action="warehouses" method="post" style="display:inline;">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="id" value="${w.id}">
                                                                <button type="submit" class="btn-action btn-delete"
                                                                    onclick="return confirm('Delete this warehouse?')">
                                                                    <i class="ri-delete-bin-line"></i> Delete
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
            </div>

            <!-- Modal -->
            <div class="modal fade" id="warehouseModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title font-weight-bold" id="form-title">Add New Warehouse</h5>
                            <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                        </div>
                        <div class="modal-body">
                            <form id="warehouseForm" action="warehouses" method="post">
                                <input type="hidden" name="action" id="form-action" value="add">
                                <input type="hidden" name="id" id="wh-id">

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Warehouse Code</label>
                                        <input type="text" name="warehouseCode" id="f-code" class="form-control"
                                            placeholder="Auto-generated" readonly>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Warehouse Name</label>
                                        <input type="text" name="warehouseName" id="f-name" class="form-control"
                                            placeholder="e.g. Central Warehouse" required>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label">Address</label>
                                        <input type="text" name="address" id="f-address" class="form-control"
                                            placeholder="Enter warehouse address">
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label class="form-label">Description</label>
                                        <textarea name="description" id="f-description" class="form-control" rows="3"
                                            placeholder="Enter description"></textarea>
                                    </div>
                                </div>

                                <div class="text-right mt-4">
                                    <button type="button" class="btn btn-secondary px-4 py-2" data-dismiss="modal"
                                        style="border-radius:10px; font-weight: 600;">Cancel</button>
                                    <button type="submit" class="btn btn-add ml-2 px-4 py-2">Save Warehouse</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script>
                function prepareAdd() {
                    document.getElementById('form-title').innerText = "Add New Warehouse";
                    document.getElementById('form-action').value = "add";
                    document.getElementById('warehouseForm').reset();
                    document.getElementById('wh-id').value = "";
                    document.getElementById('f-code').readOnly = true;
                    document.getElementById('f-code').placeholder = "Auto-generated";
                    document.getElementById('f-code').value = "";
                }

                function prepareEdit(btn) {
                    document.getElementById('form-title').innerText = "Edit Warehouse";
                    document.getElementById('form-action').value = "update";
                    document.getElementById('wh-id').value = btn.getAttribute('data-id');
                    document.getElementById('f-code').value = btn.getAttribute('data-code');
                    document.getElementById('f-code').readOnly = true;
                    document.getElementById('f-name').value = btn.getAttribute('data-name');
                    document.getElementById('f-address').value = btn.getAttribute('data-address') || '';
                    document.getElementById('f-description').value = btn.getAttribute('data-description') || '';
                    $('#warehouseModal').modal('show');
                }

                // Search logic
                const searchInput = document.getElementById('searchInput');
                const tableRows = document.querySelectorAll('.warehouse-row');

                searchInput.addEventListener('input', function () {
                    const query = this.value.toLowerCase().trim();

                    tableRows.forEach(row => {
                        const text = row.innerText.toLowerCase();
                        row.style.display = text.includes(query) ? '' : 'none';
                    });
                });
            </script>
        </body>

        </html>