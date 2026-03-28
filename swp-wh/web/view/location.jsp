<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Location Management | InventoryPro</title>

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
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            text-decoration: none;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
            color: white;
            text-decoration: none;
        }

        /* Filter + Search bar */
        .filter-bar {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
        }

        .filter-box {
            background: white;
            padding: 0.75rem 1.25rem;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .filter-box i { color: var(--primary); font-size: 1rem; }

        .filter-box select, .filter-box input {
            border: none;
            font-weight: 700;
            color: #1e293b;
            outline: none;
            background: transparent;
        }

        .filter-box select { color: var(--primary); cursor: pointer; }

        .filter-box button {
            border: none;
            background: none;
            color: var(--primary);
            cursor: pointer;
            font-size: 1rem;
            padding: 0;
        }

        /* Table */
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

        .btn-view {
            background: #f0fdf4;
            color: #166534;
            border-color: #bbf7d0;
        }

        .btn-view:hover { background: #dcfce7; color: #166534; text-decoration: none; }

        .btn-edit {
            background: #f0f9ff;
            color: #0369a1;
            border-color: #bae6fd;
        }

        .btn-edit:hover { background: #e0f2fe; color: #0369a1; text-decoration: none; }

        .btn-delete {
            background: #fff1f2;
            color: #be123c;
            border-color: #fecdd3;
        }

        .btn-delete:hover { background: #ffe4e6; }

        /* Inline form card */
        .form-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .form-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #f1f5f9;
        }

        .form-card-header h5 { margin: 0; font-weight: 800; font-size: 1.1rem; }

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

        .btn-cancel:hover { background: #e2e8f0; color: #475569; text-decoration: none; }

        .form-label {
            font-weight: 700;
            color: var(--gray-dark);
            text-transform: uppercase;
            font-size: 0.75rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e2e8f0;
            font-weight: 600;
            padding: 0.6rem 1rem;
            transition: border-color 0.2s;
        }

        .form-control:focus, .form-select:focus {
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
                    <c:choose>
                        <c:when test="${mode == 'add' or mode == 'edit'}">
                            <a href="locations" class="btn-cancel">
                                <i class="ri-arrow-left-line mr-1"></i> Back to List
                            </a>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${sessionScope.user.role.id == 2}">
                                <a href="locations?mode=add" class="btn-add">
                                    <i class="ri-add-line"></i> Add New Location
                                </a>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Flash messages --%>
                <c:if test="${not empty sessionScope.error and empty mode}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert"
                         style="border-radius: 12px; font-weight: 600;">
                        <i class="ri-error-warning-line mr-2"></i> ${sessionScope.error}
                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                    </div>
                </c:if>
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert"
                         style="border-radius: 12px; font-weight: 600;">
                        <i class="ri-checkbox-circle-line mr-2"></i> ${sessionScope.success}
                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>

                <%-- ============================================================
                     INLINE FORM — shown when mode=add or mode=edit
                     ============================================================ --%>
                <c:if test="${mode == 'add' or mode == 'edit'}">
                    <div class="form-card">
                        <div class="form-card-header">
                            <h5>
                                <c:choose>
                                    <c:when test="${mode == 'edit'}">Edit Location</c:when>
                                    <c:otherwise>Add New Location</c:otherwise>
                                </c:choose>
                            </h5>
                        </div>

                        <%-- Error inside form --%>
                        <c:if test="${not empty sessionScope.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert"
                                 style="border-radius: 12px; font-weight: 600; margin-bottom: 1.5rem;">
                                <i class="ri-error-warning-line mr-2"></i> ${sessionScope.error}
                                <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                            </div>
                        </c:if>

                        <form action="locations" method="post">
                            <input type="hidden" name="action"
                                   value="${mode == 'edit' ? 'update' : 'add'}">
                            <c:if test="${mode == 'edit'}">
                                <input type="hidden" name="id" value="${editLocation.id}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Warehouse <span class="text-danger">*</span></label>
                                    <select name="warehouseId" class="form-control" required>
                                        <c:forEach var="w" items="${warehouses}">
                                            <option value="${w.id}"
                                                ${mode == 'edit' && editLocation.warehouseId == w.id ? 'selected' : ''}>
                                                ${w.warehouseName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Location Code <span class="text-danger">*</span></label>
                                    <input type="text" name="locationCode" class="form-control"
                                           required maxlength="50"
                                           value="${mode == 'edit' ? editLocation.locationCode : ''}">
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Location Name <span class="text-danger">*</span></label>
                                    <input type="text" name="locationName" class="form-control"
                                           required maxlength="100"
                                           value="${mode == 'edit' ? editLocation.locationName : ''}">
                                </div>
                                <div class="col-md-6 form-group">
                                    <label class="form-label">Max Capacity</label>
                                    <input type="number" name="maxCapacity" class="form-control" min="0"
                                           value="${mode == 'edit' ? editLocation.maxCapacity : ''}">
                                </div>
                            </div>

                            <div class="text-right mt-2">
                                <a href="locations" class="btn-cancel mr-2">Cancel</a>
                                <button type="submit" class="btn btn-add ml-2 px-4 py-2">Save Location</button>
                            </div>
                        </form>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>
                <c:if test="${empty mode}">
                    <%-- ============================================================
                         FILTER + SEARCH + TABLE — hidden when mode is not empty
                         ============================================================ --%>
                    <form action="locations" method="get" class="filter-bar">
                        <%-- Warehouse filter --%>
                        <div class="filter-box">
                            <i class="ri-filter-2-line"></i>
                            <span class="font-weight-bold">Warehouse:</span>
                            <select name="warehouseId" onchange="this.form.submit()">
                                <option value="0">All Warehouses</option>
                                <c:forEach var="w" items="${warehouses}">
                                    <option value="${w.id}"
                                        ${selectedWarehouseId == w.id ? 'selected' : ''}>
                                        ${w.warehouseCode} - ${w.warehouseName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <%-- Search --%>
                        <div class="filter-box" style="min-width: 300px;">
                            <i class="ri-search-line"></i>
                            <input type="text" name="search" class="search-input"
                                   placeholder="Search by code or name..."
                                   value="${search}">
                            <button type="submit" class="search-btn">
                                <i class="ri-arrow-right-line"></i>
                            </button>
                        </div>
                    </form>

                    <div class="card card-main">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table mb-0">
                                    <thead>
                                        <tr>
                                            <th>Location Code</th>
                                            <th>Name</th>
                                            <th class="text-center">Max Capacity</th>
                                            <th class="text-center">Quantity</th>
                                            <th class="text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="l" items="${locations}">
                                            <tr>
                                                <td><span class="font-weight-bold text-primary">${l.locationCode}</span></td>
                                                <td><span class="font-weight-bold text-dark">${l.locationName}</span></td>
                                                <td class="text-center">
                                                    <span class="badge badge-soft-primary px-3 py-2">${l.maxCapacity}</span>
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge badge-soft-success px-3 py-2">${l.currentStock}</span>
                                                </td>
                                                <td class="text-right">
                                                    <a href="locations?action=viewDetail&id=${l.id}"
                                                       class="btn-action btn-view mr-2">
                                                        <i class="ri-eye-line"></i> View
                                                    </a>
                                                    <c:if test="${sessionScope.user.role.id == 2}">
                                                        <a href="locations?mode=edit&id=${l.id}&warehouseId=${selectedWarehouseId}&search=${search}"
                                                           class="btn-action btn-edit mr-2">
                                                            <i class="ri-pencil-line"></i> Edit
                                                        </a>
                                                        <form action="locations" method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${l.id}">
                                                            <button type="submit" class="btn-action btn-delete"
                                                                    onclick="return confirm('Bạn có chắc chắn muốn xóa vị trí &quot;${l.locationName}&quot; không?')">
                                                                <i class="ri-delete-bin-line"></i> Delete
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty locations}">
                                            <tr>
                                                <td colspan="5" class="text-center text-secondary py-4">
                                                    No locations found.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <%-- Pagination --%>
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" 
                                               href="locations?page=${currentPage - 1}&warehouseId=${selectedWarehouseId}&search=${search}" 
                                               tabindex="-1">Previous</a>
                                        </li>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" 
                                                   href="locations?page=${i}&warehouseId=${selectedWarehouseId}&search=${search}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        
                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" 
                                               href="locations?page=${currentPage + 1}&warehouseId=${selectedWarehouseId}&search=${search}">Next</a>
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
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
</body>

</html>