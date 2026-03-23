<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Location Management | InventoryPro</title>

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

                .filter-section {
                    background: white;
                    padding: 1rem 1.5rem;
                    border-radius: 12px;
                    display: inline-flex;
                    align-items: center;
                    gap: 1rem;
                    margin-bottom: 1.5rem;
                    border: 1px solid #e2e8f0;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
                }

                .filter-section select {
                    border: none;
                    font-weight: 700;
                    color: var(--primary);
                    outline: none;
                    cursor: pointer;
                    padding-right: 1rem;
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

                .btn-view {
                    background: #f0fdf4;
                    color: #166534;
                    border-color: #bbf7d0;
                }

                .btn-view:hover {
                    background: #dcfce7;
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

                .form-control,
                .form-select {
                    border-radius: 10px;
                    border: 2px solid #e2e8f0;
                    font-weight: 600;
                    padding: 0.6rem 1rem;
                    transition: border-color 0.2s;
                }

                .form-control:focus,
                .form-select:focus {
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
                                <h1 class="font-weight-bold h2">Location Management</h1>
                                <c:if test="${sessionScope.user.role.id == 2}">
                                    <button class="btn btn-add" data-toggle="modal" data-target="#locationModal"
                                        onclick="prepareAdd()">
                                        <i class="ri-add-line"></i> Add New Location
                                    </button>
                                </c:if>
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

                            <div class="filter-section">
                                <i class="ri-filter-2-line text-primary"></i>
                                <span class="font-weight-bold">Warehouse:</span>
                                <select id="wh-filter" onchange="filterLocations()">
                                    <c:forEach var="w" items="${warehouses}">
                                        <option value="${w.id}">${w.warehouseCode} - ${w.warehouseName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="search-section mb-4" style="background: white; padding: 1rem 1.5rem; border-radius: 12px; display: inline-flex; align-items: center; gap: 1rem; border: 1px solid #e2e8f0; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02); min-width: 350px; margin-left: 1rem;">
                                <i class="ri-search-line text-primary"></i>
                                <input type="text" id="locSearchInput" placeholder="Quick search in current results..." style="border: none; font-weight: 600; outline: none; width: 100%;">
                            </div>

                            <div class="card card-main">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Location Code</th>
                                                    <th>Name</th>
                                                    <th class="text-center">Max Capacity</th>
                                                    <th class="text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody id="location-table-body">
                                                <c:forEach var="l" items="${locations}">
                                                    <tr class="location-row" data-wh="${l.warehouseId}">
                                                        <td>
                                                            <a href="locations?action=viewDetail&id=${l.id}"
                                                                class="font-weight-bold text-primary">
                                                                ${l.locationCode}
                                                            </a>
                                                        </td>
                                                        <td><span
                                                                class="font-weight-bold text-dark">${l.locationName}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <span
                                                                class="badge badge-soft-primary px-3 py-2">${l.maxCapacity}</span>
                                                        </td>
                                                        <td class="text-right">
                                                            <a href="locations?action=viewDetail&id=${l.id}"
                                                               class="btn-action btn-view mr-2">
                                                                <i class="ri-eye-line"></i> View
                                                            </a>
                                                            <c:if test="${sessionScope.user.role.id == 2}">
                                                                <button class="btn-action btn-edit mr-2"
                                                                    data-id="${l.id}"
                                                                    data-whid="${l.warehouseId}"
                                                                    data-code="${l.locationCode}"
                                                                    data-name="${l.locationName}"
                                                                    data-capacity="${l.maxCapacity}"
                                                                    onclick="prepareEdit(this)">
                                                                    <i class="ri-pencil-line"></i> Edit
                                                                </button>
                                                                <a href="locations?action=delete&id=${l.id}"
                                                                    class="btn-action btn-delete"
                                                                    onclick="return confirm('Delete this location?')">
                                                                    <i class="ri-delete-bin-line"></i> Delete
                                                                </a>
                                                            </c:if>
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
            <div class="modal fade" id="locationModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title font-weight-bold" id="form-title">Add New Location</h5>
                            <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                        </div>
                        <form id="location-form" action="locations" method="post">
                            <input type="hidden" name="action" id="form-action" value="add">
                            <input type="hidden" name="id" id="location-id">
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label class="font-weight-bold">Warehouse <span class="text-danger">*</span></label>
                                        <select name="warehouseId" id="warehouseId" class="form-control" required>
                                            <c:forEach var="w" items="${warehouses}">
                                                <option value="${w.id}">${w.warehouseName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label class="font-weight-bold">Location Code <span class="text-danger">*</span></label>
                                        <input type="text" name="locationCode" id="locationCode" class="form-control" required maxlength="50">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label class="font-weight-bold">Location Name <span class="text-danger">*</span></label>
                                        <input type="text" name="locationName" id="locationName" class="form-control" required maxlength="100">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label class="font-weight-bold">Max Capacity</label>
                                        <input type="number" name="maxCapacity" id="maxCapacity" class="form-control" min="0">
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary px-4">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>



            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script>
                function filterLocations() {
                    const whId = document.getElementById('wh-filter').value;
                    const query = document.getElementById('locSearchInput').value.toLowerCase().trim();
                    const rows = document.querySelectorAll('.location-row');
                    
                    rows.forEach(row => {
                        const isWhMatch = row.getAttribute('data-wh') === whId;
                        const text = row.innerText.toLowerCase();
                        const isSearchMatch = text.includes(query);
                        
                        row.style.display = (isWhMatch && isSearchMatch) ? '' : 'none';
                    });
                }

                document.getElementById('locSearchInput').addEventListener('input', filterLocations);

                function prepareAdd() {
                    document.getElementById('form-title').innerText = "Add New Location";
                    document.getElementById('form-action').value = "add";
                    document.getElementById('location-id').value = "";
                    document.getElementById('locationCode').value = "";
                    document.getElementById('locationName').value = "";
                    document.getElementById('maxCapacity').value = "";
                    $('#locationModal').modal('show');
                }

                function prepareEdit(btn) {
                    document.getElementById('form-title').innerText = "Edit Location";
                    document.getElementById('form-action').value = "update";
                    document.getElementById('location-id').value = btn.getAttribute('data-id');
                    document.getElementById('warehouseId').value = btn.getAttribute('data-whid');
                    document.getElementById('locationCode').value = btn.getAttribute('data-code');
                    document.getElementById('locationName').value = btn.getAttribute('data-name');
                    document.getElementById('maxCapacity').value = btn.getAttribute('data-capacity');
                    $('#locationModal').modal('show');
                }



                window.onload = filterLocations;
            </script>
        </body>

        </html>