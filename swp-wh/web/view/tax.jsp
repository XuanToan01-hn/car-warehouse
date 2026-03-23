<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Tax Management | InventoryPro</title>

                <link
                    href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
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
                    }

                    .btn-add:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
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
                    }

                    .btn-edit {
                        background: #f0f9ff;
                        color: #0369a1;
                        border-color: #bae6fd;
                    }

                    .btn-edit:hover {
                        background: var(--primary);
                        color: white;
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

                    /* Modal Customization */
                    .modal-content {
                        border-radius: 20px;
                        border: none;
                        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                    }

                    .modal-header {
                        border-bottom: 1px solid #f1f5f9;
                        padding: 1.5rem 2rem;
                    }

                    .modal-title {
                        font-weight: 800;
                        color: #0f172a;
                    }

                    .modal-body {
                        padding: 2rem;
                    }

                    .form-label {
                        font-weight: 700;
                        color: #475569;
                        text-transform: uppercase;
                        font-size: 0.75rem;
                        letter-spacing: 0.05em;
                        margin-bottom: 0.5rem;
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

                    .search-box {
                        position: relative;
                        max-width: 400px;
                    }

                    .search-box i {
                        position: absolute;
                        left: 1rem;
                        top: 50%;
                        transform: translateY(-50%);
                        color: #94a3b8;
                    }

                    .search-box .form-control {
                        padding-left: 2.75rem;
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
                                <button class="btn btn-add" data-toggle="modal" data-target="#taxModal"
                                    onclick="prepareAdd()">
                                    <i class="ri-add-line"></i> Add New Tax
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

                            <div class="mb-4">
                                <div class="search-box">
                                    <i class="ri-search-line"></i>
                                    <input type="text" id="searchInput" class="form-control shadow-sm"
                                        placeholder="Search by tax name...">
                                </div>
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
                                                                <i
                                                                    class="ri-inbox-line display-4 text-muted d-block opacity-25"></i>
                                                                <p class="text-secondary mt-3 font-weight-600">No tax
                                                                    records found.</p>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="t" items="${taxes}" varStatus="status">
                                                            <tr class="tax-row">
                                                                <td><span
                                                                        class="text-secondary font-weight-bold">${status.index
                                                                        + 1}</span></td>
                                                                <td>
                                                                    <div class="font-weight-800 text-dark"
                                                                        style="font-size: 1.05rem;">
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
                                                                    <button class="btn-action btn-edit mr-2"
                                                                        data-id="${t.id}"
                                                                        data-name="${t.taxName}"
                                                                        data-rate="${t.taxRate}"
                                                                        data-effective="${t.effectiveFrom}"
                                                                        data-expired="${t.expiredDate}"
                                                                        onclick="prepareEdit(this)">
                                                                        <i class="ri-pencil-line"></i> Edit
                                                                    </button>
                                                                    <a href="taxes?action=delete&id=${t.id}"
                                                                        class="btn-action btn-delete"
                                                                        onclick="return confirm('Are you sure you want to delete this tax?')">
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
                        </div>
                    </div>
                </div>

                <!-- Modal Add/Edit Tax -->
                <div class="modal fade" id="taxModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="form-title">Add New Tax</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <form id="taxForm" action="taxes" method="post">
                                    <input type="hidden" name="action" id="form-action" value="add">
                                    <input type="hidden" name="taxId" id="t-id">

                                    <div class="form-group mb-4">
                                        <label class="form-label">Tax Name</label>
                                        <input type="text" name="taxName" id="f-name" class="form-control"
                                            placeholder="e.g. VAT 10%" required>
                                    </div>

                                    <div class="form-group mb-4">
                                        <label class="form-label">Tax Rate (%)</label>
                                        <input type="number" name="taxRate" id="f-rate" class="form-control"
                                            placeholder="10.00" step="0.01" min="0" required>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group mb-4">
                                                <label class="form-label">Effective From</label>
                                                <input type="date" name="effectiveFrom" id="f-effective"
                                                    class="form-control">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group mb-4">
                                                <label class="form-label">Expired Date</label>
                                                <input type="date" name="expiredDate" id="f-expired"
                                                    class="form-control">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="text-right mt-4">
                                        <button type="button" class="btn btn-light font-weight-700 px-4 mr-2"
                                            data-dismiss="modal" style="border-radius: 12px;">Cancel</button>
                                        <button type="submit" class="btn btn-add px-5">Save Tax</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.0.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

                <script>
                    function prepareAdd() {
                        document.getElementById('form-title').innerText = "Add New Tax";
                        document.getElementById('form-action').value = "add";
                        document.getElementById('taxForm').reset();
                        document.getElementById('t-id').value = "";
                    }

                    function prepareEdit(btn) {
                        document.getElementById('form-title').innerText = "Update Tax";
                        document.getElementById('form-action').value = "update";
                        
                        document.getElementById('t-id').value = btn.getAttribute('data-id');
                        document.getElementById('f-name').value = btn.getAttribute('data-name');
                        document.getElementById('f-rate').value = btn.getAttribute('data-rate');
                        document.getElementById('f-effective').value = btn.getAttribute('data-effective') || '';
                        document.getElementById('f-expired').value = btn.getAttribute('data-expired') || '';
                        
                        $('#taxModal').modal('show');
                    }

                    // Search logic
                    const searchInput = document.getElementById('searchInput');
                    const tableRows = document.querySelectorAll('.tax-row');

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