<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Customer Management | InventoryPro</title>

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
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .btn-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
            color: white;
            text-decoration: none;
        }

        /* Search form */
        .search-section {
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
            border: 1px solid #e2e8f0;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
            max-width: 500px;
        }

        .search-section i {
            color: var(--primary);
            font-size: 1.2rem;
        }

        .search-section input {
            border: none;
            font-weight: 600;
            outline: none;
            width: 100%;
            background: transparent;
        }

        .search-section button {
            border: none;
            background: none;
            color: var(--primary);
            cursor: pointer;
            font-size: 1.1rem;
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

        .btn-edit {
            background: #f0f9ff;
            color: #0369a1;
            border-color: #bae6fd;
        }

        .btn-edit:hover {
            background: #e0f2fe;
            color: #0369a1;
            text-decoration: none;
        }

        .btn-delete {
            background: #fff1f2;
            color: #be123c;
            border-color: #fecdd3;
        }

        .btn-delete:hover {
            background: #ffe4e6;
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
                    <h1 class="font-weight-bold h2">Customer Management</h1>
                    <c:choose>
                        <c:when test="${mode == 'add' or mode == 'edit'}">
                            <%-- When form is open, button navigates back to list --%>
                            <a href="customers" class="btn-cancel">
                                <i class="ri-arrow-left-line mr-1"></i> Back to List
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="customers?mode=add" class="btn-add">
                                <i class="ri-user-add-line"></i> Add New Customer
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
                                    <c:when test="${mode == 'edit'}">Edit Customer</c:when>
                                    <c:otherwise>Add New Customer</c:otherwise>
                                </c:choose>
                            </h5>
                        </div>

                        <form action="customers" method="post">
                            <%-- action field: add or update --%>
                            <input type="hidden" name="action"
                                   value="${mode == 'edit' ? 'update' : 'add'}">
                            <c:if test="${mode == 'edit'}">
                                <input type="hidden" name="customerId" value="${editCustomer.id}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Customer Code</label>
                                    <input type="text" name="customerCode" class="form-control"
                                           placeholder="Auto-generated"
                                           value="${mode == 'edit' ? editCustomer.customerCode : ''}"
                                           readonly>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Customer Name</label>
                                    <input type="text" name="name" class="form-control"
                                           placeholder="Enter full name" required
                                           pattern="^[A-Za-zÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ\s]+$"
                                           title="Tên chỉ được chứa chữ cái và khoảng trắng"
                                           value="${mode == 'edit' ? editCustomer.name : ''}">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phone Number</label>
                                    <input type="text" name="phone" class="form-control"
                                           placeholder="e.g. 0123456789"
                                           pattern="^0\d{9}$"
                                           title="Số điện thoại phải có 10 số và bắt đầu bằng số 0"
                                           value="${mode == 'edit' ? editCustomer.phone : ''}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email Address</label>
                                    <input type="email" name="email" class="form-control"
                                           placeholder="example@mail.com"
                                           value="${mode == 'edit' ? editCustomer.email : ''}">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label class="form-label">Address</label>
                                    <input type="text" name="address" class="form-control"
                                           placeholder="Enter full address"
                                           value="${mode == 'edit' ? editCustomer.address : ''}">
                                </div>
                            </div>

                            <div class="text-right mt-2">
                                <a href="customers" class="btn-cancel mr-2">Cancel</a>
                                <button type="submit" class="btn btn-add ml-2 px-4 py-2">Save Customer</button>
                            </div>
                        </form>
                    </div>
                </c:if>

                <%-- ============================================================
                     SEARCH + TABLE — always shown
                     ============================================================ --%>

                <c:if test="${empty mode}">
                    <%-- ============================================================
                         SEARCH + TABLE — hidden when mode is not empty
                         ============================================================ --%>

                    <%-- Search form (GET) --%>
                    <form action="customers" method="get" class="search-section">
                        <i class="ri-search-line"></i>
                        <input type="text" name="search"
                               placeholder="Search by code, name or phone..."
                               value="${search}">
                        <button type="submit" title="Search">
                            <i class="ri-arrow-right-line"></i>
                        </button>
                        <c:if test="${not empty search}">
                            <a href="customers" style="color:#94a3b8; font-size:1.1rem;" title="Clear search">
                                <i class="ri-close-line"></i>
                            </a>
                        </c:if>
                    </form>

                    <div class="card card-main">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table mb-0">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Code</th>
                                            <th>Name</th>
                                            <th>Contact Info</th>
                                            <th>Address</th>
                                            <th class="text-right">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="c" items="${customers}" varStatus="status">
                                            <tr>
                                                <td><span class="text-secondary">${(currentPage - 1) * 5 + status.index + 1}</span></td>
                                                <td><span class="font-weight-bold text-primary">${c.customerCode}</span></td>
                                                <td><span class="font-weight-bold text-dark">${c.name}</span></td>
                                                <td>
                                                    <div class="d-flex flex-column">
                                                        <span class="font-weight-bold">
                                                            <i class="ri-phone-line mr-1 text-primary"></i>${c.phone}
                                                        </span>
                                                        <small class="text-secondary">
                                                            <i class="ri-mail-line mr-1 text-primary"></i>${c.email}
                                                        </small>
                                                    </div>
                                                </td>
                                                <td><span class="text-secondary">${c.address}</span></td>
                                                <td class="text-right">
                                                    <%-- Edit: link to same page with mode=edit&id=... --%>
                                                    <a href="customers?mode=edit&id=${c.id}" class="btn-action btn-edit mr-2">
                                                        <i class="ri-pencil-line"></i> Edit
                                                    </a>
                                                    <%-- Delete: POST form, no JS confirm --%>
                                                    <form action="customers" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="customerId" value="${c.id}">
                                                        <button type="submit" class="btn-action btn-delete"
                                                                onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng &quot;${c.name}&quot; không?')">
                                                            <i class="ri-delete-bin-line"></i> Delete
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty customers}">
                                            <tr>
                                                <td colspan="6" class="text-center text-secondary py-4">
                                                    No customers found.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <%-- Pagination --%>
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" class="mt-4 pb-4">
                                    <ul class="pagination justify-content-center">
                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="customers?page=${currentPage - 1}&search=${search}"
                                               tabindex="-1">Previous</a>
                                        </li>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link"
                                                   href="customers?page=${i}&search=${search}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link"
                                               href="customers?page=${currentPage + 1}&search=${search}">Next</a>
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

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
</body>

</html>