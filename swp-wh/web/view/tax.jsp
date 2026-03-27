<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Tax Management | InventoryPro</title>

    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">

    <style>
        :root {
            --primary: #0EA5E9;
            --success: #15803D;
            --warning: #F59E0B;
            --danger: #EF4444;
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
            color: white !important;
            border-radius: 12px;
            padding: 0.75rem 1.5rem;
            font-weight: 700;
            border: none;
            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
            text-decoration: none;
        }

        /* Search form */
        .search-box {
            position: relative;
            max-width: 400px;
            display: flex;
            align-items: center;
            background: white;
            border-radius: 12px;
            border: 2px solid #e2e8f0;
            padding: 0 1rem;
            gap: 0.5rem;
        }

        .search-box i {
            color: #94a3b8;
            font-size: 1rem;
        }

        .search-box input {
            border: none;
            outline: none;
            font-weight: 600;
            font-size: 0.95rem;
            padding: 0.7rem 0;
            background: transparent;
            width: 100%;
        }

        .search-box button {
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

        .tax-rate-badge {
            background: #ecfdf5;
            color: #065f46;
            padding: 0.4rem 0.8rem;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.85rem;
        }

        .btn-action {
            padding: 0.4rem 0.8rem;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: 1px solid transparent;
            text-decoration: none;
        }

        .btn-edit {
            background: #f0f9ff;
            color: #0369a1;
            border-color: #bae6fd;
        }

        .btn-edit:hover {
            background: var(--primary);
            color: white;
            text-decoration: none;
        }

        .btn-delete {
            background: #fff1f2;
            color: #be123c;
            border-color: #fecdd3;
        }

        .btn-delete:hover {
            background: var(--danger);
            color: white;
        }

        /* Inline form card */
        .form-card {
            background: white;
            border-radius: 16px;
            border: none;
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

        .form-card-header h5 {
            margin: 0;
            font-weight: 800;
            font-size: 1.1rem;
        }

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

        .btn-cancel:hover {
            background: #e2e8f0;
            color: #475569;
            text-decoration: none;
        }

        .form-label {
            font-weight: 700;
            color: #475569;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control {
            border-radius: 12px;
            border: 2px solid #e2e8f0;
            font-weight: 600;
            padding: 0.75rem 1rem;
            height: auto;
            transition: all 0.2s;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.1);
        }
    </style>
</head>

<body>
    <div class="wrapper">
        <jsp:include page="sidebar.jsp" />
        <div class="content-page">
            <div class="container-fluid">

                <div class="page-header">
                    <div>
                        <h1 class="font-weight-bold mb-1">Tax Management</h1>
                        <p class="text-secondary mb-0">Configure and manage tax rates for the system.</p>
                    </div>
                    <c:choose>
                        <c:when test="${mode == 'add' or mode == 'edit'}">
                            <a href="taxes" class="btn-cancel">
                                <i class="ri-arrow-left-line mr-1"></i> Back to List
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="taxes?mode=add" class="btn-add">
                                <i class="ri-add-line"></i> Add New Tax
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Flash messages --%>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert"
                         style="border-radius: 12px; font-weight: 600;">
                        <i class="ri-error-warning-line mr-2"></i> ${sessionScope.error}
                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                    </div>
                    <c:remove var="error" scope="session" />
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
                                    <c:when test="${mode == 'edit'}">Update Tax</c:when>
                                    <c:otherwise>Add New Tax</c:otherwise>
                                </c:choose>
                            </h5>
                        </div>

                        <form action="taxes" method="post">
                            <input type="hidden" name="action"
                                   value="${mode == 'edit' ? 'update' : 'add'}">
                            <c:if test="${mode == 'edit'}">
                                <input type="hidden" name="taxId" value="${editTax.id}">
                            </c:if>

                            <div class="form-group mb-4">
                                <label class="form-label">Tax Name</label>
                                <input type="text" name="taxName" class="form-control"
                                       placeholder="e.g. VAT 10%" required
                                       value="${mode == 'edit' ? editTax.taxName : ''}">
                            </div>

                            <div class="form-group mb-4">
                                <label class="form-label">Tax Rate (%)</label>
                                <input type="number" name="taxRate" class="form-control"
                                       placeholder="10.00" step="0.01" min="0" max="100" required
                                       value="${mode == 'edit' ? editTax.taxRate : ''}">
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group mb-4">
                                        <label class="form-label">Effective From</label>
                                        <input type="date" name="effectiveFrom" class="form-control"
                                               value="${mode == 'edit' ? editTax.effectiveFrom : ''}">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group mb-4">
                                        <label class="form-label">Expired Date</label>
                                        <input type="date" name="expiredDate" class="form-control"
                                               value="${mode == 'edit' ? editTax.expiredDate : ''}">
                                    </div>
                                </div>
                            </div>

                            <div class="text-right mt-2">
                                <a href="taxes" class="btn-cancel mr-2">Cancel</a>
                                <button type="submit" class="btn btn-add ml-2 px-5">Save Tax</button>
                            </div>
                        </form>
                    </div>
                </c:if>

                <%-- ============================================================
                     SEARCH + TABLE — always shown
                     ============================================================ --%>

                <div class="mb-4">
                    <form action="taxes" method="get" class="search-box">
                        <i class="ri-search-line"></i>
                        <input type="text" name="search"
                               placeholder="Search by tax name..."
                               value="${search}">
                        <button type="submit" title="Search">
                            <i class="ri-arrow-right-line"></i>
                        </button>
                        <c:if test="${not empty search}">
                            <a href="taxes" style="color:#94a3b8; font-size:1.1rem;" title="Clear search">
                                <i class="ri-close-line"></i>
                            </a>
                        </c:if>
                    </form>
                </div>

                <div class="card card-main">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table mb-0">
                                <thead>
                                    <tr>
                                        <th style="width: 80px;">#</th>
                                        <th>Tax Name</th>
                                        <th class="text-center">Rate (%)</th>
                                        <th>Effective From</th>
                                        <th>Expired Date</th>
                                        <th class="text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty taxes}">
                                            <tr>
                                                <td colspan="6" class="text-center py-5">
                                                    <i class="ri-inbox-line display-4 text-muted d-block opacity-25"></i>
                                                    <p class="text-secondary mt-3 font-weight-600">No tax records found.</p>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="t" items="${taxes}" varStatus="status">
                                                <tr>
                                                    <td><span class="text-secondary font-weight-bold">${status.index + 1}</span></td>
                                                    <td>
                                                        <div class="font-weight-800 text-dark" style="font-size: 1.05rem;">
                                                            ${t.taxName}
                                                        </div>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="tax-rate-badge">${t.taxRate}%</span>
                                                    </td>
                                                    <td class="text-secondary" style="font-size: 0.9rem;">
                                                        ${t.effectiveFrom != null ? t.effectiveFrom : '—'}
                                                    </td>
                                                    <td class="text-secondary" style="font-size: 0.9rem;">
                                                        ${t.expiredDate != null ? t.expiredDate : '—'}
                                                    </td>
                                                    <td class="text-right">
                                                        <%-- Edit: link với mode=edit&id=... --%>
                                                        <a href="taxes?mode=edit&id=${t.id}" class="btn-action btn-edit mr-2">
                                                            <i class="ri-pencil-line"></i> Edit
                                                        </a>
                                                        <%-- Delete: POST form --%>
                                                        <form action="taxes" method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${t.id}">
                                                            <button type="submit" class="btn-action btn-delete">
                                                                <i class="ri-delete-bin-line"></i> Delete
                                                            </button>
                                                        </form>
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

            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
</body>

</html>