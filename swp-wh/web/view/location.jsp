<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Location Management | InventoryPro</title>

            <!-- External Fonts and Icons -->
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
                    /* Deeper Sky Blue */
                    --primary-dark: #0284c7;
                    --success: #15803d;
                    /* Darker Green */
                    --warning: #f59e0b;
                    --danger: #ef4444;
                    --gray-dark: #0f172a;
                    /* Deep Slate */
                    --gray-medium: #475569;
                    --gray-light: #f8fafc;
                    --skyblue: #0284C7;
                    /* Darker Sky Blue */
                    --light-gray: #f1f5f9;
                }

                body {
                    font-family: 'Be Vietnam Pro', 'Inter', system-ui, -apple-system, sans-serif;
                    background-color: #f1f5f9;
                    color: #1e293b;
                    /* Dark core text */
                    font-size: 17px;
                    line-height: 1.6;
                    font-weight: 500;
                }

                .location-page {
                    max-width: 1400px;
                    margin: 0 auto;
                    padding: 1.5rem;
                }

                .page-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    flex-wrap: wrap;
                    gap: 1rem;
                    margin-bottom: 2rem;
                }

                .page-title {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    font-size: 1.75rem;
                    font-weight: 800;
                    color: var(--gray-dark);
                    margin: 0;
                }


                .toolbar {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                }

                .btn-add-location {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                    padding: 0.75rem 1.5rem;
                    font-weight: 700;
                    border-radius: 12px;
                    border: none;
                    background: linear-gradient(135deg, var(--success) 0%, #5fb87a 100%);
                    color: #fff;
                    box-shadow: 0 4px 12px rgba(120, 192, 145, 0.3);
                    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                }

                .btn-add-location:hover {
                    color: #fff;
                    transform: translateY(-2px);
                    box-shadow: 0 6px 16px rgba(120, 192, 145, 0.4);
                }

                .filter-card {
                    background: #fff;
                    padding: 0.6rem 1.25rem;
                    border-radius: 12px;
                    border: 1px solid #e2e8f0;
                    display: flex;
                    align-items: center;
                    gap: 0.75rem;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
                }

                .filter-card label {
                    margin: 0;
                    font-weight: 800;
                    /* Extra bold */
                    color: #1e293b;
                    /* Darker label */
                    font-size: 0.95rem;
                    /* Larger */
                    text-transform: uppercase;
                }

                .filter-card select {
                    border: none;
                    font-weight: 600;
                    color: var(--skyblue);
                    padding: 0;
                    height: auto;
                    cursor: pointer;
                }

                .card-location {
                    border: none;
                    border-radius: 16px;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                    background: #fff;
                    overflow: hidden;
                }

                .card-location .card-header {
                    background: #fff;
                    border-bottom: 1px solid #f1f5f9;
                    padding: 1.5rem;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .card-location .card-title {
                    font-weight: 800;
                    font-size: 1.1rem;
                    color: var(--gray-dark);
                    margin: 0;
                }

                .table-location thead th {
                    background: #e2e8f0;
                    /* Darker header bg */
                    padding: 1.25rem 1.5rem;
                    font-weight: 800;
                    /* Bolder */
                    font-size: 0.95rem;
                    /* Larger */
                    color: #0f172a;
                    /* Darker text */
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    border-bottom: 2px solid #cbd5e1;
                    white-space: nowrap;
                }

                .table-location tbody td {
                    padding: 1.25rem 1.5rem;
                    vertical-align: middle;
                    border-bottom: 1px solid #e2e8f0;
                    /* Darker border */
                    font-size: 1.05rem;
                    /* Slightly larger */
                    font-weight: 500;
                }

                .table-location tbody tr {
                    transition: background 0.2s;
                }

                .table-location tbody tr:hover {
                    background: #f9fafb;
                    cursor: pointer;
                }

                /* Tree UI Refinements */
                .tree-cell {
                    display: flex;
                    align-items: center;
                }

                .tree-indent {
                    width: 32px;
                    flex-shrink: 0;
                }

                .tree-connector {
                    width: 24px;
                    height: 24px;
                    border-left: 2px solid #e2e8f0;
                    border-bottom: 2px solid #e2e8f0;
                    border-bottom-left-radius: 6px;
                    margin-right: 12px;
                    margin-top: -12px;
                    flex-shrink: 0;
                }

                .loc-icon {
                    width: 40px;
                    height: 40px;
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-right: 14px;
                    font-size: 1.25rem;
                    flex-shrink: 0;
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                }

                .bg-zone {
                    background: #e0f2fe;
                    color: #0369a1;
                }

                .bg-rack {
                    background: #dcfce7;
                    color: #15803d;
                }

                .bg-bin {
                    background: #fef3c7;
                    color: #92400e;
                }


                .loc-code {
                    font-weight: 800;
                    color: var(--gray-dark);
                    display: block;
                    line-height: 1.2;
                    font-size: 1.15rem;
                }

                .loc-name {
                    font-size: 1.05rem;
                    /* Larger */
                    color: #334155;
                    /* Darker */
                    font-weight: 600;
                    /* Bolder */
                }

                .badge-type {
                    padding: 5px 12px;
                    border-radius: 8px;
                    font-weight: 800;
                    font-size: 0.7rem;
                    letter-spacing: 0.04em;
                }

                .badge-ZONE {
                    background: #dbeafe;
                    color: #1e40af;
                }

                .badge-RACK {
                    background: #dcfce7;
                    color: #166534;
                }

                .badge-BIN {
                    background: #fef3c7;
                    color: #92400e;
                }

                /* Premium Action Buttons */
                .btn-premium {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    gap: 0.5rem;
                    padding: 0.5rem 0.25rem;
                    font-size: 0.85rem;
                    font-weight: 700;
                    border-radius: 8px;
                    transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
                    border: 1px solid transparent;
                    cursor: pointer;
                    text-decoration: none !important;
                    white-space: nowrap;
                    width: 100px;
                    /* Fixed width for alignment */
                }

                .btn-premium-edit {
                    background: #f0f9ff;
                    color: #0369a1;
                    border-color: #bae6fd;
                }

                .btn-premium-edit:hover {
                    background: #e0f2fe;
                    border-color: #7dd3fc;
                    transform: translateY(-1px);
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                }

                .btn-premium-add {
                    background: #f0fdf4;
                    color: #15803d;
                    border-color: #bbf7d0;
                }

                .btn-premium-add:hover {
                    background: #dcfce7;
                    border-color: #86efac;
                    transform: translateY(-1px);
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                }

                .btn-premium-delete {
                    background: #fff1f2;
                    color: #be123c;
                    border-color: #fecdd3;
                }

                .btn-premium-delete:hover {
                    background: #ffe4e6;
                    border-color: #fda4af;
                    transform: translateY(-1px);
                    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                }

                .btn-premium i {
                    font-size: 1rem;
                }

                .btn-action.btn-add-child:hover {
                    border-color: var(--success);
                    color: var(--success);
                    background: #f0fdf4;
                }

                .btn-action.btn-delete:hover {
                    border-color: #fca5a5;
                    color: #ef4444;
                    background: #fef2f2;
                }

                /* Premium Modal Styling */
                .modal-content {
                    border: none;
                    border-radius: 28px;
                    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
                    overflow: hidden;
                    background: #ffffff;
                }

                .modal-header {
                    padding: 1.75rem 2.25rem 1.25rem;
                    border-bottom: 1px solid #f1f5f9;
                    background: #fff;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                }

                .modal-title {
                    font-weight: 800;
                    font-size: 1.8rem;
                    color: var(--gray-dark);
                    font-family: 'Be Vietnam Pro', sans-serif;
                    letter-spacing: -0.02em;
                    margin: 0;
                }

                .modal-body {
                    padding: 3rem;
                }

                .form-group {
                    margin-bottom: 1.75rem;
                }

                .form-label {
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                    font-weight: 800;
                    color: #0f172a;
                    /* Deep Slate */
                    margin-bottom: 0.5rem;
                    font-size: 0.9rem;
                    font-family: 'Be Vietnam Pro', sans-serif;
                    text-transform: uppercase;
                    letter-spacing: 0.04em;
                }

                .form-label i {
                    color: var(--primary);
                    font-size: 1rem;
                }

                .form-control,
                .form-select {
                    border-radius: 12px;
                    border: 2px solid #f1f5f9;
                    background-color: #f8fafc;
                    padding: 0.7rem 1rem;
                    font-weight: 700;
                    /* Bolder text in inputs */
                    font-size: 1rem;
                    /* Slightly larger input text */
                    color: #0f172a;
                    /* Deep Slate */
                    font-family: 'Be Vietnam Pro', sans-serif;
                    transition: all 0.2s ease;
                    min-height: 48px;
                    line-height: normal;
                }

                .form-control:focus,
                .form-select:focus {
                    border-color: var(--primary);
                    background-color: #fff;
                    box-shadow: 0 0 0 4px rgba(50, 189, 234, 0.1);
                    outline: none;
                }

                .form-control::placeholder {
                    color: #94a3b8;
                    font-weight: 500;
                }

                .input-group-text {
                    background-color: #f8fafc;
                    border: 2px solid #f1f5f9;
                    border-radius: 14px;
                    padding: 0.8rem 1.2rem;
                }

                .form-control:focus {
                    border-color: var(--skyblue);
                    box-shadow: 0 0 0 4px rgba(21, 141, 247, 0.1);
                }

                .modal-footer {
                    padding: 1.5rem 2.25rem 2rem;
                    border-top: none;
                    gap: 1rem;
                    display: flex;
                    justify-content: flex-end;
                }

                .btn-save {
                    padding: 0.8rem 2.25rem;
                    border-radius: 14px;
                    font-weight: 700;
                    background: linear-gradient(135deg, var(--primary), var(--skyblue));
                    border: none;
                    color: #fff;
                    box-shadow: 0 8px 20px rgba(50, 189, 234, 0.25);
                    transition: all 0.3s ease;
                    font-family: 'Be Vietnam Pro', sans-serif;
                    font-size: 1rem;
                }

                .btn-save:hover {
                    box-shadow: 0 12px 25px rgba(50, 189, 234, 0.35);
                    transform: translateY(-2px);
                    color: #fff;
                    text-decoration: none;
                }

                .btn-cancel {
                    padding: 0.8rem 2rem;
                    border-radius: 14px;
                    font-weight: 700;
                    background: #f1f5f9;
                    border: none;
                    color: #475569;
                    transition: all 0.2s ease;
                    font-family: 'Be Vietnam Pro', sans-serif;
                    font-size: 1rem;
                }

                .btn-cancel:hover {
                    background: #e2e8f0;
                    color: #1e293b;
                    text-decoration: none;
                }
            </style>
        </head>

        <body class="color-light">
            <div class="location-page">
                <header class="page-header">
                    <h1 class="page-title">
                        Quản lý Vị trí kho
                    </h1>
                    <div class="toolbar">
                        <div class="filter-card">
                            <label for="wh-filter">Kho:</label>
                            <select id="wh-filter" class="form-control" onchange="filterLocations()">
                                <c:forEach var="w" items="${warehouses}">
                                    <option value="${w.id}">${w.warehouseCode} - ${w.warehouseName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <button class="btn btn-add-location" data-toggle="modal" data-target="#locationModal"
                            onclick="prepareAdd()">
                            Thêm vị trí mới
                        </button>
                    </div>
                </header>

                <div class="card card-location">
                    <div class="card-header">
                        <h4 class="card-title">Sơ đồ cấu trúc vị trí</h4>
                        <span class="badge badge-primary-light">Zone &gt; Rack &gt; Bin</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-location mb-0">
                                <thead>
                                    <tr>
                                        <th style="width: 40%">Vị trí & Cấu trúc</th>
                                        <th style="width: 15%">Loại</th>
                                        <th style="width: 15%">Mã định danh</th>
                                        <th style="width: 15%" class="text-center">Sức chứa</th>
                                        <th style="width: 210px" class="text-right">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="location-table-body">
                                    <c:forEach var="l" items="${locations}">
                                        <c:if test="${l.parentLocationId == null}">
                                            <tr class="location-row" data-wh="${l.warehouseId}"
                                                onclick="viewDetail('${l.id}')">
                                                <td>
                                                    <div class="tree-cell">
                                                        <div class="loc-icon bg-zone"><i
                                                                class="ri-layout-grid-line"></i></div>
                                                        <div>
                                                            <span class="loc-code">${l.locationCode}</span>
                                                            <span class="loc-name">${l.locationName}</span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><span class="badge-type badge-ZONE">ZONE</span></td>
                                                <td><code>${l.locationCode}</code></td>
                                                <td class="text-center"><span
                                                        class="font-weight-bold text-primary">${l.aggregatedCapacity}</span>
                                                </td>
                                                <td class="text-right" onclick="event.stopPropagation()">
                                                    <div class="d-flex justify-content-end gap-2"
                                                        style="width: 210px; margin-left: auto;">
                                                        <button class="btn-premium btn-premium-edit"
                                                            onclick="prepareEdit('${l.id}')">
                                                            <i class="ri-pencil-line"></i> Sửa
                                                        </button>
                                                        <button class="btn-premium btn-premium-add"
                                                            onclick="prepareAddChild('${l.id}', 'RACK', '${l.warehouseId}')">
                                                            <i class="ri-add-line"></i> + Rack
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                            <c:forEach var="r" items="${locations}">
                                                <c:if test="${r.parentLocationId == l.id}">
                                                    <tr class="location-row" data-wh="${r.warehouseId}"
                                                        onclick="viewDetail('${r.id}')">
                                                        <td>
                                                            <div class="tree-cell">
                                                                <span class="tree-indent"></span>
                                                                <span class="tree-connector"></span>
                                                                <div class="loc-icon bg-rack"><i
                                                                        class="ri-stack-line"></i></div>
                                                                <div>
                                                                    <span class="loc-code">${r.locationCode}</span>
                                                                    <span class="loc-name">${r.locationName}</span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><span class="badge-type badge-RACK">RACK</span></td>
                                                        <td><code>${r.locationCode}</code></td>
                                                        <td class="text-center"><span
                                                                class="font-weight-bold text-success">${r.aggregatedCapacity}</span>
                                                        </td>
                                                        <td class="text-right" onclick="event.stopPropagation()">
                                                            <div class="d-flex justify-content-end gap-2"
                                                                style="width: 210px; margin-left: auto;">
                                                                <button class="btn-premium btn-premium-edit"
                                                                    onclick="prepareEdit('${r.id}')">
                                                                    <i class="ri-pencil-line"></i> Sửa
                                                                </button>
                                                                <button class="btn-premium btn-premium-add"
                                                                    onclick="prepareAddChild('${r.id}', 'BIN', '${r.warehouseId}')">
                                                                    <i class="ri-add-line"></i> + Bin
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <c:forEach var="b" items="${locations}">
                                                        <c:if test="${b.parentLocationId == r.id}">
                                                            <tr class="location-row" data-wh="${b.warehouseId}"
                                                                onclick="viewDetail('${b.id}')">
                                                                <td>
                                                                    <div class="tree-cell">
                                                                        <span class="tree-indent"></span>
                                                                        <span class="tree-indent"></span>
                                                                        <span class="tree-connector"></span>
                                                                        <div class="loc-icon bg-bin"><i
                                                                                class="ri-archive-line"></i></div>
                                                                        <div>
                                                                            <span
                                                                                class="loc-code">${b.locationCode}</span>
                                                                            <span
                                                                                class="loc-name">${b.locationName}</span>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td><span class="badge-type badge-BIN">BIN</span></td>
                                                                <td><code>${b.locationCode}</code></td>
                                                                <td class="text-center"><span
                                                                        class="font-weight-bold text-warning">${b.aggregatedCapacity}</span>
                                                                </td>
                                                                <td class="text-right"
                                                                    onclick="event.stopPropagation()">
                                                                    <div class="d-flex justify-content-end gap-2"
                                                                        style="width: 210px; margin-left: auto;">
                                                                        <button class="btn-premium btn-premium-edit"
                                                                            onclick="prepareEdit('${b.id}')">
                                                                            <i class="ri-pencil-line"></i> Sửa
                                                                        </button>
                                                                        <a href="${pageContext.request.contextPath}/locations?action=delete&id=${b.id}"
                                                                            class="btn-premium btn-premium-delete"
                                                                            onclick="return confirm('Xóa BIN này?')">
                                                                            <i class="ri-delete-bin-line"></i> Xóa
                                                                        </a>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            </div>
            </div>
            </div>

            <!-- Location Form Modal -->
            <!-- Location Form Modal -->
            <div class="modal fade" id="locationModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="form-title">Đăng ký vị trí mới</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form id="locationForm" action="${pageContext.request.contextPath}/locations" method="post">
                                <input type="hidden" name="action" id="form-action" value="add">
                                <input type="hidden" name="id" id="loc-id">

                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="ri-community-line" style="color: var(--primary)"></i>
                                        <span>Kho mục tiêu <span class="text-danger">*</span></span>
                                    </label>
                                    <select name="warehouseId" id="f-warehouse" class="form-select w-100" required
                                        onchange="updateParentOptions()">
                                        <c:forEach var="w" items="${warehouses}">
                                            <option value="${w.id}">${w.warehouseCode} - ${w.warehouseName}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label">
                                                <i class="ri-bubble-chart-line" style="color: var(--primary)"></i>
                                                <span>Loại vị trí <span class="text-danger">*</span></span>
                                            </label>
                                            <select name="locationType" id="f-type" class="form-select w-100" required
                                                onchange="updateParentOptions()">
                                                <option value="ZONE">ZONE</option>
                                                <option value="RACK">RACK</option>
                                                <option value="BIN">BIN</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label class="form-label">
                                                <i class="ri-bar-chart-box-line" style="color: var(--primary)"></i>
                                                <span>Sức chứa (Bin)</span>
                                            </label>
                                            <input type="number" name="capacity" id="f-capacity" class="form-control"
                                                placeholder="0">
                                            <small id="capacity-hint" class="text-muted"></small>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group" id="parent-container">
                                    <label class="form-label">
                                        <i class="ri-git-merge-line" style="color: var(--primary)"></i>
                                        <span>Vị trí cha</span>
                                    </label>
                                    <select name="parentLocationId" id="f-parent" class="form-select w-100">
                                        <option value="">-- Cấp cao nhất --</option>
                                    </select>
                                    <div class="mt-2 text-info small" id="parent-hint"></div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-0">
                                            <label class="form-label">
                                                <span>Mã vị trí <span class="text-danger">*</span></span>
                                            </label>
                                            <input type="text" name="locationCode" id="f-code" class="form-control"
                                                placeholder="VD: Z-A1" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-0">
                                            <label class="form-label">
                                                <span>Tên hiển thị <span class="text-danger">*</span></span>
                                            </label>
                                            <input type="text" name="locationName" id="f-name" class="form-control"
                                                placeholder="VD: Khu vực chờ" required>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn-cancel" data-dismiss="modal">Hủy</button>
                            <button type="button" class="btn-save" onclick="$('#locationForm').submit()">Lưu thay
                                đổi</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Detail Modal -->
            <div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                    <div class="modal-content glass">
                        <div class="modal-header">
                            <div>
                                <h5 class="modal-title">Inventory Insights</h5>
                                <p class="text-secondary small mb-0">Location stock and specifications</p>
                            </div>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body p-0" id="detail-content">
                            <div class="text-center p-5">
                                <div class="spinner-border text-primary" role="status"></div>
                                <p class="mt-3 text-secondary">Retrieving live data...</p>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary px-4" style="border-radius: 10px;"
                                data-dismiss="modal">Close Insights</button>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

            <script>
                // Global Error Catcher
                window.onerror = function (message, source, lineno, colno, error) {
                    alert("Frontend Error: " + message + " at " + source + ":" + lineno);
                    return false;
                };

                // Warehouse Filter
                function filterLocations() {
                    var whId = $('#wh-filter').val();
                    $('.location-row').each(function () {
                        $(this).toggle(String($(this).data('wh')) === String(whId));
                    });
                }

                // AJAX Parent Fetching
                function updateParentOptions(selectedParentId) {
                    var type = $('#f-type').val();
                    var whId = $('#f-warehouse').val();
                    var $parent = $('#f-parent');
                    var $hint = $('#parent-hint');
                    var $cap = $('#f-capacity');
                    var $capHint = $('#capacity-hint');

                    $parent.empty();

                    if (type === 'BIN') {
                        $cap.prop('disabled', false).attr('placeholder', 'e.g. 50');
                        $capHint.text('Set precise capacity for this BIN.');
                    } else {
                        $cap.prop('disabled', true).val('').attr('placeholder', 'Calculated from children');
                        $capHint.text('Capacity for ' + type + ' is calculated from its child locations.');
                    }

                    if (type === 'ZONE') {
                        $parent.append('<option value="">-- No Parent (Root) --</option>');
                        $parent.prop('disabled', true);
                        $hint.html('<i class="ri-information-line mr-1"></i> Zones are top-level containers.');
                    } else {
                        $parent.prop('disabled', false).prop('required', true);
                        $parent.append('<option value="" disabled selected>-- Loading valid parents... --</option>');
                        var parentLabel = (type === 'RACK' ? 'ZONE' : 'RACK');
                        $hint.html('<i class="ri-information-line mr-1"></i> Selection of a parent <b>' + parentLabel + '</b> is required.');

                        $.getJSON(window.location.protocol + "//" + window.location.host + "${pageContext.request.contextPath}/locations", {
                            action: 'getParents',
                            whId: whId,
                            type: type
                        }, function (data) {
                            $parent.empty();
                            $parent.append('<option value="" disabled ' + (!selectedParentId ? 'selected' : '') + '>-- Select a ' + (type === 'RACK' ? 'Zone' : 'Rack') + ' --</option>');

                            if (data && data.length > 0) {
                                for (var i = 0; i < data.length; i++) {
                                    var p = data[i];
                                    var isSelected = selectedParentId && String(p.id) === String(selectedParentId);
                                    $parent.append('<option value="' + p.id + '" ' + (isSelected ? 'selected' : '') + '>' + p.code + ' - ' + p.name + '</option>');
                                }
                            } else {
                                $parent.append('<option value="" disabled>No valid parents found in this warehouse</option>');
                            }
                        }).fail(function () {
                            $parent.empty().append('<option value="" disabled>Error loading parents</option>');
                        });
                    }
                }

                function prepareAdd() {
                    $('#form-title').text('Đăng ký Vị trí mới');
                    $('#form-action').val('add');
                    $('#loc-id').val('');
                    $('#locationForm')[0].reset();
                    updateParentOptions();
                }

                function prepareAddChild(parentId, childType, whId) {
                    prepareAdd();
                    $('#f-warehouse').val(whId);
                    $('#f-type').val(childType);
                    updateParentOptions(parentId);
                    $('#locationModal').modal('show');
                }

                function prepareEdit(id) {
                    $('#form-title').text('Retrieving Data...');
                    $('#locationModal').modal('show');

                    $.getJSON("${pageContext.request.contextPath}/locations", { action: 'getDetailJson', id: id }, function (data) {
                        $('#form-title').text('Cập nhật Vị trí: ' + data.code);
                        $('#form-action').val('update');
                        $('#loc-id').val(data.id);
                        $('#f-warehouse').val(data.whId);
                        $('#f-type').val(data.type);
                        $('#f-code').val(data.code);
                        $('#f-name').val(data.name);
                        $('#f-capacity').val(data.capacity);

                        updateParentOptions(data.parentId);
                    }).fail(function () {
                        alert('Error retrieving location data.');
                        $('#locationModal').modal('hide');
                    });
                }

                function viewDetail(id) {
                    $('#detail-content').html('<div class="text-center p-5"><div class="spinner-border text-primary"></div><p class="mt-3 text-secondary">Retrieving live data...</p></div>');
                    $('#detailModal').modal('show');
                    $.get("${pageContext.request.contextPath}/locations", { action: 'getDetail', id: id }, function (data) {
                        $('#detail-content').html(data);
                    });
                }

                $(document).ready(function () {
                    filterLocations();
                });
            </script>
        </body>

        </html>