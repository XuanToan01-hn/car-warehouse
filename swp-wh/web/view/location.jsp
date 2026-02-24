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
                    padding: 1.5rem;
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

                .filter-section {
                    background: white;
                    padding: 1rem 1.5rem;
                    border-radius: 12px;
                    display: inline-flex;
                    align-items: center;
                    gap: 1rem;
                    margin-bottom: 1rem;
                    border: 1px solid #e2e8f0;
                }

                .filter-section select {
                    border: none;
                    font-weight: 700;
                    color: var(--primary);
                    outline: none;
                    cursor: pointer;
                }

                .btn-action {
                    padding: 0.4rem 0.8rem;
                    border-radius: 8px;
                    font-weight: 600;
                    font-size: 0.85rem;
                    border: 1px solid transparent;
                    transition: all 0.2s;
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

                .form-control,
                .form-select {
                    border-radius: 10px;
                    border: 2px solid #e2e8f0;
                    font-weight: 600;
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <div class="content-page">
                    <div class="container-fluid">
                        <div class="page-header">
                            <h1 class="font-weight-bold">Location Management</h1>
                            <button class="btn btn-add" data-toggle="modal" data-target="#locationModal"
                                onclick="prepareAdd()">
                                <i class="ri-add-line"></i> Add New Location
                            </button>
                        </div>

                        <div class="filter-section">
                            <span class="font-weight-bold">Warehouse:</span>
                            <select id="wh-filter" onchange="filterLocations()">
                                <c:forEach var="w" items="${warehouses}">
                                    <option value="${w.id}">${w.warehouseCode} - ${w.warehouseName}</option>
                                </c:forEach>
                            </select>
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
                                                        <a href="javascript:void(0)" onclick="viewDetail('${l.id}')"
                                                            class="font-weight-bold text-primary">
                                                            ${l.locationCode}
                                                        </a>
                                                    </td>
                                                    <td><span class="font-weight-bold">${l.locationName}</span></td>
                                                    <td class="text-center"><span
                                                            class="font-weight-bold">${l.maxCapacity}</span></td>
                                                    <td class="text-right">
                                                        <button class="btn-action btn-edit mr-2"
                                                            style="background: #ecfdf5; color: #047857; border-color: #a7f3d0;"
                                                            onclick="viewDetail('${l.id}')">
                                                            <i class="ri-eye-line"></i> Xem chi tiết
                                                        </button>
                                                        <button class="btn-action btn-edit mr-2"
                                                            onclick="prepareEdit('${l.id}')">
                                                            <i class="ri-pencil-line"></i> Sửa
                                                        </button>
                                                        <a href="locations?action=delete&id=${l.id}"
                                                            class="btn-action btn-delete"
                                                            onclick="return confirm('Xóa vị trí này?')">
                                                            <i class="ri-delete-bin-line"></i> Xóa
                                                        </a>
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
                        <div class="modal-body">
                            <form id="locationForm" action="locations" method="post">
                                <input type="hidden" name="action" id="form-action" value="add">
                                <input type="hidden" name="id" id="loc-id">

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label">Warehouse</label>
                                            <select name="warehouseId" id="f-warehouse" class="form-select w-100"
                                                required>
                                                <c:forEach var="w" items="${warehouses}">
                                                    <option value="${w.id}">${w.warehouseCode} - ${w.warehouseName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label">Max Capacity</label>
                                            <input type="number" name="maxCapacity" id="f-capacity" class="form-control"
                                                placeholder="0">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label">Location Code</label>
                                            <input type="text" name="locationCode" id="f-code" class="form-control"
                                                placeholder="e.g. LOC-001" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label">Display Name</label>
                                            <input type="text" name="locationName" id="f-name" class="form-control"
                                                placeholder="e.g. North Area" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="text-right mt-4">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal"
                                        style="border-radius:10px;">Cancel</button>
                                    <button type="submit" class="btn btn-add ml-2">Save Location</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Details Modal -->
            <div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-xl" role="document">
                    <div class="modal-content">
                        <div class="modal-header border-0 pb-0">
                            <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                        </div>
                        <div class="modal-body pt-0" id="detail-content">
                            <!-- Loaded via AJAX -->
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script>
                function filterLocations() {
                    const whId = document.getElementById('wh-filter').value;
                    const rows = document.querySelectorAll('.location-row');
                    rows.forEach(row => {
                        row.style.display = row.getAttribute('data-wh') === whId ? '' : 'none';
                    });
                }

                function prepareAdd() {
                    document.getElementById('form-title').innerText = "Add New Location";
                    document.getElementById('form-action').value = "add";
                    document.getElementById('locationForm').reset();
                    document.getElementById('loc-id').value = "";
                }

                function prepareEdit(id) {
                    fetch('locations?action=getDetailJson&id=' + id)
                        .then(r => r.json())
                        .then(data => {
                            document.getElementById('form-title').innerText = "Edit Location";
                            document.getElementById('form-action').value = "update";
                            document.getElementById('loc-id').value = data.id;
                            document.getElementById('f-warehouse').value = data.whId;
                            document.getElementById('f-code').value = data.code;
                            document.getElementById('f-name').value = data.name;
                            document.getElementById('f-capacity').value = data.capacity;
                            $('#locationModal').modal('show');
                        });
                }

                function viewDetail(id) {
                    fetch('locations?action=getDetail&id=' + id)
                        .then(r => r.text())
                        .then(html => {
                            document.getElementById('detail-content').innerHTML = html;
                            $('#detailModal').modal('show');
                        });
                }

                window.onload = filterLocations;
            </script>
        </body>

        </html>