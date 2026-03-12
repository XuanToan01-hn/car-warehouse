<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Manage Suppliers | InventoryPro</title>

    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">

    <style>
        body { font-family: 'Be Vietnam Pro', sans-serif; background: #f1f5f9; color: #1e293b; }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 0;
            margin-bottom: 1.5rem;
        }
        .page-header h1 { font-size: 1.75rem; font-weight: 800; margin: 0; }
        .page-header p  { color: #64748b; margin: 0; font-size: 0.9rem; }

        .filter-section {
            background: #fff;
            padding: 1.25rem 1.5rem;
            border-radius: 16px;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 12px rgba(0,0,0,.03);
            border: 1px solid #e2e8f0;
        }

        .card-main {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 20px rgba(0,0,0,.05);
            overflow: hidden;
        }

        /* ---- Table ---- */
        .table thead th {
            background: #f8fafc;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            font-size: 0.72rem;
            letter-spacing: .05em;
            padding: 0.9rem 1rem;
            border-bottom: 2px solid #e2e8f0;
        }
        .table tbody td { padding: 0.85rem 1rem; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
        .table tbody tr:last-child td { border-bottom: none; }
        .table tbody tr:hover { background: #f8fafc; }

        .supplier-name { font-weight: 700; color: #0EA5E9; }
        .supplier-id   { font-family: ui-monospace, monospace; font-size: 0.78rem; color: #94a3b8; }

        /* ---- Modal / Slide Panel ---- */
        .modal-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(15,23,42,.45);
            z-index: 1050;
            justify-content: center;
            align-items: center;
        }
        .modal-overlay.open { display: flex; }

        .modal-box {
            background: #fff;
            border-radius: 20px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 20px 60px rgba(0,0,0,.18);
            animation: slideIn .2s ease;
            overflow: hidden;
        }
        @keyframes slideIn {
            from { transform: translateY(30px); opacity: 0; }
            to   { transform: translateY(0);    opacity: 1; }
        }

        .modal-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-header h5 { font-weight: 700; font-size: 1.05rem; margin: 0; }
        .modal-body  { padding: 1.5rem; }
        .modal-footer { padding: 1rem 1.5rem; border-top: 1px solid #f1f5f9; display: flex; justify-content: flex-end; gap: .5rem; }

        .form-label { font-weight: 600; font-size: 0.83rem; color: #374151; margin-bottom: .3rem; display: block; }
        .form-control-sm { border-radius: 10px; border: 1.5px solid #e2e8f0; padding: .45rem .75rem; width: 100%; font-size: .9rem; transition: border-color .2s; }
        .form-control-sm:focus { outline: none; border-color: #0EA5E9; box-shadow: 0 0 0 3px rgba(14,165,233,.15); }
        .form-group { margin-bottom: 1rem; }

        textarea.form-control-sm { resize: vertical; min-height: 80px; }

        .btn-close-modal {
            background: none; border: none; cursor: pointer;
            color: #94a3b8; font-size: 1.2rem; line-height: 1;
        }
        .btn-close-modal:hover { color: #1e293b; }

        .btn-primary-custom {
            background: #0EA5E9; color: #fff; border: none;
            border-radius: 10px; padding: .55rem 1.2rem; font-weight: 700; cursor: pointer;
        }
        .btn-primary-custom:hover { background: #0284c7; }

        .form-control { border-radius: 10px; }

        .alert-flash { border-radius: 12px; }

        .pagination .page-link { border-radius: 8px !important; margin: 0 2px; }
        .pagination .page-item.active .page-link { background: #0EA5E9; border-color: #0EA5E9; }
    </style>
</head>

<body>
<div class="wrapper">
    <%@ include file="../sidebar.jsp" %>
    <div class="content-page">
        <div class="container-fluid">

            <!-- Page Header -->
            <div class="page-header">
                <div>
                    <h1>Suppliers</h1>
                    <p>Manage all supplier information.</p>
                </div>
                <button class="btn btn-primary" style="border-radius:12px;font-weight:700;"
                        onclick="openModal('add')">
                    <i class="ri-add-line mr-1"></i> Add Supplier
                </button>
            </div>

            <!-- Flash messages -->
            <c:if test="${param.success == 'added'}">
                <div class="alert alert-success alert-flash alert-dismissible">
                    <i class="fas fa-check-circle mr-2"></i>Supplier added successfully.
                    <button type="button" class="close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>
            <c:if test="${param.success == 'updated'}">
                <div class="alert alert-success alert-flash alert-dismissible">
                    <i class="fas fa-check-circle mr-2"></i>Supplier updated successfully.
                    <button type="button" class="close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>
            <c:if test="${param.success == 'deleted'}">
                <div class="alert alert-warning alert-flash alert-dismissible">
                    <i class="fas fa-trash mr-2"></i>Supplier deleted.
                    <button type="button" class="close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-flash alert-dismissible">
                    <i class="fas fa-exclamation-triangle mr-2"></i>
                    <c:choose>
                        <c:when test="${param.error == 'delete_failed'}">Cannot delete supplier (may be in use).</c:when>
                        <c:otherwise>An error occurred. Please try again.</c:otherwise>
                    </c:choose>
                    <button type="button" class="close" onclick="this.parentElement.remove()">&times;</button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-flash">${error}</div>
            </c:if>

            <!-- Filter -->
            <div class="filter-section">
                <form method="get" action="${pageContext.request.contextPath}/manage-suppliers">
                    <div class="row align-items-end">
                        <div class="col-md-6">
                            <label class="small font-weight-bold text-uppercase text-secondary">Search</label>
                            <input type="text" name="keyword" class="form-control"
                                   style="border-radius:10px;" placeholder="Search by supplier name..."
                                   value="${keyword}">
                        </div>
                        <div class="col-md-6 d-flex" style="gap:.5rem;">
                            <button type="submit" class="btn btn-primary"
                                    style="border-radius:12px;font-weight:700;padding:.6rem 1.4rem;">
                                <i class="fas fa-search mr-1"></i> Search
                            </button>
                            <a href="${pageContext.request.contextPath}/manage-suppliers"
                               class="btn btn-light"
                               style="border-radius:12px;font-weight:700;padding:.6rem 1.2rem;">
                                Reset
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Table -->
            <div class="card-main">
                <div class="table-responsive">
                    <table class="table mb-0">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Supplier Name</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th>Address</th>
                            <th class="text-right">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty supplierList}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-5">
                                        <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                                        No suppliers found.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="s" items="${supplierList}" varStatus="st">
                                    <tr>
                                        <td class="supplier-id">${(page-1)*pageSize + st.index + 1}</td>
                                        <td><span class="supplier-name">${s.name}</span></td>
                                        <td>${not empty s.phone ? s.phone : '<span class="text-muted">—</span>'}</td>
                                        <td>${not empty s.email ? s.email : '<span class="text-muted">—</span>'}</td>
                                        <td>${not empty s.address ? s.address : '<span class="text-muted">—</span>'}</td>
                                        <td class="text-right" style="white-space:nowrap;">
                                            <button class="btn btn-sm btn-outline-primary"
                                                    style="border-radius:8px;"
                                                    onclick="openEditModal(${s.id},'${fn:escapeXml(s.name)}','${fn:escapeXml(s.phone)}','${fn:escapeXml(s.email)}','${fn:escapeXml(s.address)}')">
                                                <i class="fas fa-edit"></i> Edit
                                            </button>
                                            <a href="${pageContext.request.contextPath}/manage-suppliers?action=delete&id=${s.id}"
                                               class="btn btn-sm btn-outline-danger" style="border-radius:8px;"
                                               onclick="return confirm('Delete supplier \'${fn:escapeXml(s.name)}\'?')">
                                                <i class="fas fa-trash"></i> Delete
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="p-3">
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?keyword=${keyword}&page=${page-1}">«</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <li class="page-item ${p == page ? 'active' : ''}">
                                    <a class="page-link" href="?keyword=${keyword}&page=${p}">${p}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?keyword=${keyword}&page=${page+1}">»</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
                <p class="text-muted text-center pb-3 mb-0">
                    Total: <strong>${total}</strong> supplier(s)
                </p>
            </div>

        </div>
    </div>
</div>

<!-- ===== ADD MODAL ===== -->
<div class="modal-overlay" id="addModal" onclick="closeOnBackdrop(event,'addModal')">
    <div class="modal-box">
        <div class="modal-header">
            <h5><i class="fas fa-plus-circle mr-2 text-primary"></i>Add New Supplier</h5>
            <button class="btn-close-modal" onclick="closeModal('addModal')">✕</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/manage-suppliers">
            <input type="hidden" name="action" value="add">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Supplier Name <span class="text-danger">*</span></label>
                    <input type="text" name="name" class="form-control-sm" placeholder="Enter supplier name" required
                           value="${formName}">
                </div>
                <div class="form-group">
                    <label class="form-label">Phone Number</label>
                    <input type="text" name="phone" class="form-control-sm" placeholder="0xxxxxxxxx"
                           value="${formPhone}">
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control-sm" placeholder="supplier@email.com"
                           value="${formEmail}">
                </div>
                <div class="form-group">
                    <label class="form-label">Address</label>
                    <textarea name="address" class="form-control-sm" placeholder="Supplier address">${formAddress}</textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" style="border-radius:10px;" onclick="closeModal('addModal')">Cancel</button>
                <button type="submit" class="btn-primary-custom">
                    <i class="fas fa-save mr-1"></i> Save
                </button>
            </div>
        </form>
    </div>
</div>

<!-- ===== EDIT MODAL ===== -->
<div class="modal-overlay" id="editModal" onclick="closeOnBackdrop(event,'editModal')">
    <div class="modal-box">
        <div class="modal-header">
            <h5><i class="fas fa-edit mr-2 text-warning"></i>Edit Supplier</h5>
            <button class="btn-close-modal" onclick="closeModal('editModal')">✕</button>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/manage-suppliers">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">
            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label">Supplier Name <span class="text-danger">*</span></label>
                    <input type="text" name="name" id="editName" class="form-control-sm" required>
                </div>
                <div class="form-group">
                    <label class="form-label">Phone Number</label>
                    <input type="text" name="phone" id="editPhone" class="form-control-sm">
                </div>
                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" id="editEmail" class="form-control-sm">
                </div>
                <div class="form-group">
                    <label class="form-label">Address</label>
                    <textarea name="address" id="editAddress" class="form-control-sm"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" style="border-radius:10px;" onclick="closeModal('editModal')">Cancel</button>
                <button type="submit" class="btn-primary-custom">
                    <i class="fas fa-save mr-1"></i> Update
                </button>
            </div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
<script>
    function openModal(type) {
        document.getElementById(type + 'Modal').classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove('open');
        document.body.style.overflow = '';
    }

    function closeOnBackdrop(e, id) {
        if (e.target.id === id) closeModal(id);
    }

    function openEditModal(id, name, phone, email, address) {
        document.getElementById('editId').value      = id;
        document.getElementById('editName').value    = name;
        document.getElementById('editPhone').value   = phone;
        document.getElementById('editEmail').value   = email;
        document.getElementById('editAddress').value = address;
        openModal('edit');
    }

    // Auto-open add modal if there was a validation error coming back from POST /add
    <c:if test="${not empty error}">
    window.addEventListener('DOMContentLoaded', function () { openModal('add'); });
    </c:if>

    // Auto-dismiss flash messages after 4 s
    window.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.alert-flash').forEach(function (el) {
            setTimeout(function () {
                el.style.transition = 'opacity .5s';
                el.style.opacity    = '0';
                setTimeout(function () { el.remove(); }, 500);
            }, 4000);
        });
    });
</script>
</body>
</html>
