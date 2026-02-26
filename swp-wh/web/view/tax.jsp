<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Tax Management | InventoryPro</title>

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

                .form-control {
                    border-radius: 10px;
                    border: 2px solid #e2e8f0;
                    font-weight: 600;
                    padding: 0.6rem 1rem;
                }

                .form-control:focus {
                    border-color: var(--primary);
                    box-shadow: none;
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
                    border-radius: 12px;
                }

                .clear-btn {
                    position: absolute;
                    right: 15px;
                    top: 50%;
                    transform: translateY(-50%);
                    cursor: pointer;
                    color: #94a3b8;
                    display: none;
                }

                .tax-rate-badge {
                    background: #ecfdf5;
                    color: #065f46;
                    padding: 0.3rem 0.75rem;
                    border-radius: 8px;
                    font-weight: 700;
                    font-size: 0.9rem;
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <div class="content-page">
                    <div class="container-fluid">
                        <div class="page-header">
                            <div>
                                <h1 class="font-weight-bold mb-1">Tax Management</h1>
                                <p class="text-secondary">Configure and manage tax rates for the system</p>
                            </div>
                            <button class="btn btn-add" data-toggle="modal" data-target="#taxModal"
                                onclick="prepareAdd()">
                                <i class="ri-add-line"></i> Add New Tax
                            </button>
                        </div>

                        <div class="mb-4 d-flex justify-content-between align-items-center">
                            <div class="search-container flex-grow-1">
                                <i class="ri-search-line search-icon"></i>
                                <input type="text" id="searchInput" class="form-control"
                                    placeholder="Search by tax name...">
                                <i class="ri-close-circle-fill clear-btn" id="clearSearch"></i>
                            </div>
                        </div>

                        <div class="card card-main">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table mb-0" id="taxTable">
                                        <thead>
                                            <tr>
                                                <th style="width: 80px;">ID</th>
                                                <th>Tax Name</th>
                                                <th>Rate (%)</th>
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
                                                            <p class="text-secondary mt-3">No tax records found.</p>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="t" items="${taxes}">
                                                        <tr class="tax-row">
                                                            <td><span
                                                                    class="text-secondary font-weight-bold">${t.id}</span>
                                                            </td>
                                                            <td><span
                                                                    class="font-weight-bold text-dark">${t.taxName}</span>
                                                            </td>
                                                            <td><span class="tax-rate-badge">${t.taxRate}%</span></td>
                                                            <td>${t.effectiveFrom != null ? t.effectiveFrom : '--'}</td>
                                                            <td>${t.expiredDate != null ? t.expiredDate : '--'}</td>
                                                            <td class="text-right">
                                                                <button class="btn-action btn-edit mr-2"
                                                                    onclick="prepareEdit('${t.id}')">
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

            <!-- Modal -->
            <div class="modal fade" id="taxModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title font-weight-bold" id="form-title">Add New Tax</h5>
                            <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                        </div>
                        <div class="modal-body">
                            <form id="taxForm" action="taxes" method="post">
                                <input type="hidden" name="action" id="form-action" value="add">
                                <input type="hidden" name="taxId" id="t-id">

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Tax Name</label>
                                        <input type="text" name="taxName" id="f-name" class="form-control"
                                            placeholder="e.g. VAT 10%" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Tax Rate (%)</label>
                                        <input type="number" name="taxRate" id="f-rate" class="form-control"
                                            placeholder="10.00" step="0.01" min="0" required>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Effective From</label>
                                        <input type="date" name="effectiveFrom" id="f-effective" class="form-control">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Expired Date</label>
                                        <input type="date" name="expiredDate" id="f-expired" class="form-control">
                                    </div>
                                </div>

                                <div class="text-right mt-4">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal"
                                        style="border-radius:10px;">Cancel</button>
                                    <button type="submit" class="btn btn-add ml-2">Save Tax</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script>
                function prepareAdd() {
                    document.getElementById('form-title').innerText = "Add New Tax";
                    document.getElementById('form-action').value = "add";
                    document.getElementById('taxForm').reset();
                    document.getElementById('t-id').value = "";
                }

                function prepareEdit(id) {
                    fetch('taxes?action=getDetailJson&id=' + id)
                        .then(r => r.json())
                        .then(data => {
                            document.getElementById('form-title').innerText = "Edit Tax";
                            document.getElementById('form-action').value = "update";
                            document.getElementById('t-id').value = data.id;
                            document.getElementById('f-name').value = data.taxName || '';
                            document.getElementById('f-rate').value = data.taxRate || '';
                            document.getElementById('f-effective').value = data.effectiveFrom || '';
                            document.getElementById('f-expired').value = data.expiredDate || '';
                            $('#taxModal').modal('show');
                        });
                }

                // Search logic
                const searchInput = document.getElementById('searchInput');
                const clearBtn = document.getElementById('clearSearch');
                const tableRows = document.querySelectorAll('.tax-row');

                searchInput.addEventListener('input', function () {
                    const query = this.value.toLowerCase().trim();
                    clearBtn.style.display = query ? 'block' : 'none';

                    tableRows.forEach(row => {
                        const text = row.innerText.toLowerCase();
                        row.style.display = text.includes(query) ? '' : 'none';
                    });
                });

                clearBtn.addEventListener('click', function () {
                    searchInput.value = '';
                    this.style.display = 'none';
                    tableRows.forEach(row => row.style.display = '');
                    searchInput.focus();
                });
            </script>
        </body>

        </html>