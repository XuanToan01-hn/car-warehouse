<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Manage Suppliers | InventoryPro</title>
                <link
                    href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">

                <style>
                    body {
                        font-family: 'Be Vietnam Pro', sans-serif;
                        background: #f1f5f9;
                        color: #1e293b;
                        overflow-x: hidden;
                        overflow-y: hidden;
                    }

                    .content-page {
                        padding-top: 2.5rem !important;
                    }

                    .main-container {
                        width: 100%;
                        padding: 0 1.5rem 0 1.5rem;
                    }

                    .page-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 0.4rem 0;
                        margin-bottom: 0.2rem;
                    }

                    .page-header h1 {
                        font-size: 1.7rem;
                        font-weight: 800;
                        margin: 0;
                        color: #0f172a;
                    }

                    .filter-section {
                        background: #fff;
                        padding: 0.6rem 1.25rem;
                        border-radius: 12px;
                        margin-bottom: 0.5rem;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, .02);
                        border: 1px solid #e2e8f0;
                    }

                    .card-main {
                        background: #fff;
                        border-radius: 12px;
                        border: 1px solid #e2e8f0;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, .04);
                        overflow: hidden;
                        margin-bottom: 0.5rem;
                    }

                    .table thead th {
                        background: #f8fafc;
                        font-weight: 700;
                        color: #475569;
                        text-transform: uppercase;
                        font-size: 0.7rem;
                        padding: 0.6rem 1.25rem;
                        border-bottom: 2px solid #f1f5f9;
                        letter-spacing: 0.05em;
                    }

                    .table tbody td {
                        padding: 0.6rem 1.25rem;
                        vertical-align: middle;
                        font-size: 0.95rem;
                        border-bottom: 1px solid #f1f5f9;
                        color: #334155;
                    }

                    .supplier-name {
                        font-weight: 700;
                        color: #0EA5E9;
                        font-size: 1rem;
                    }

                    .btn-action {
                        padding: 0.35rem 0.55rem;
                        font-size: 0.85rem;
                        border-radius: 8px;
                    }

                    .pagination {
                        margin: 0.5rem 0;
                        gap: 6px;
                    }

                    .pagination .page-link {
                        padding: 0.4rem 0.8rem;
                        font-size: 0.9rem;
                        font-weight: 600;
                        border-radius: 8px !important;
                    }

                    .btn-add-lg {
                        border-radius: 10px;
                        font-weight: 700;
                        padding: .4rem 1.1rem;
                        font-size: 0.9rem;
                    }

                    .search-input-lg {
                        border-radius: 9px;
                        padding: 0.7rem 1rem;
                        font-size: 0.95rem;
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <%@ include file="../header.jsp" %>
                            <div class="content-page">
                                <div class="container-fluid">
                                    <div class="main-container">
                                        <div class="page-header">
                                            <h1>Suppliers</h1>
                                            <a href="${pageContext.request.contextPath}/manage-suppliers?action=add"
                                                class="btn btn-primary btn-add-lg">
                                                <i class="ri-add-line mr-1"></i> Add New Supplier
                                            </a>
                                        </div>

                                        <div class="filter-section">
                                            <form method="get"
                                                action="${pageContext.request.contextPath}/manage-suppliers">
                                                <div class="row align-items-center">
                                                    <div class="col-md-9">
                                                        <input type="text" name="keyword"
                                                            class="form-control search-input-lg"
                                                            placeholder="Search by supplier name or contact info..."
                                                            value="${keyword}">
                                                    </div>
                                                    <div class="col-md-3 d-flex" style="gap:.75rem;">
                                                        <button type="submit"
                                                            class="btn btn-primary flex-fill py-2 font-weight-bold">Search</button>
                                                        <a href="${pageContext.request.contextPath}/manage-suppliers"
                                                            class="btn btn-light flex-fill py-2 font-weight-bold">Reset</a>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>

                                        <div class="card-main">
                                            <div class="table-responsive">
                                                <table class="table mb-0">
                                                    <thead>
                                                        <tr>
                                                            <th style="width: 60px;">#</th>
                                                            <th>Supplier Name</th>
                                                            <th>Phone</th>
                                                            <th>Email Address</th>
                                                            <th>Address</th>
                                                            <th class="text-right">Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:choose>
                                                            <c:when test="${empty supplierList}">
                                                                <tr>
                                                                    <td colspan="6" class="text-center text-muted py-5">
                                                                        No suppliers found matching your search.</td>
                                                                </tr>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="s" items="${supplierList}"
                                                                    varStatus="st">
                                                                    <tr>
                                                                        <td class="text-muted font-weight-bold">
                                                                            ${(page-1)*pageSize + st.index + 1}</td>
                                                                        <td><span class="supplier-name">${s.name}</span>
                                                                        </td>
                                                                        <td><i
                                                                                class="fas fa-phone-alt mr-2 text-muted small"></i>${s.phone}
                                                                        </td>
                                                                        <td><i
                                                                                class="fas fa-envelope mr-2 text-muted small"></i>${s.email}
                                                                        </td>
                                                                        <td>${s.address}</td>
                                                                        <td class="text-right">
                                                                            <div class="d-flex justify-content-end"
                                                                                style="gap:8px;">
                                                                                <a href="${pageContext.request.contextPath}/manage-suppliers?action=edit&id=${s.id}"
                                                                                    class="btn btn-outline-primary btn-action"
                                                                                    title="Edit Profile">
                                                                                    <i class="fas fa-edit"></i>
                                                                                </a>
<!--                                                                                <a href="${pageContext.request.contextPath}/manage-suppliers?action=delete&id=${s.id}"
                                                                                    class="btn btn-outline-danger btn-action"
                                                                                    title="Delete Supplier"
                                                                                    onclick="return confirm('Confirm deletion of supplier: ${fn:escapeXml(s.name)}?')">
                                                                                    <i class="fas fa-trash"></i>
                                                                                </a>-->
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <c:if test="${totalPages > 1}">
                                                <nav class="p-3 border-top">
                                                    <ul class="pagination justify-content-center mb-0">
                                                        <li class="page-item ${page <= 1 ? 'disabled' : ''}">
                                                            <a class="page-link"
                                                                href="?keyword=${keyword}&page=${page-1}">« Previous</a>
                                                        </li>
                                                        <c:forEach begin="1" end="${totalPages}" var="p">
                                                            <li class="page-item ${p == page ? 'active' : ''}">
                                                                <a class="page-link"
                                                                    href="?keyword=${keyword}&page=${p}">${p}</a>
                                                            </li>
                                                        </c:forEach>
                                                        <li class="page-item ${page >= totalPages ? 'disabled' : ''}">
                                                            <a class="page-link"
                                                                href="?keyword=${keyword}&page=${page+1}">Next »</a>
                                                        </li>
                                                    </ul>
                                                </nav>
                                            </c:if>
                                            <div class="text-center pb-2"><span class="badge badge-light px-3 py-2"
                                                    style="font-size:0.85rem;">Total: ${total} suppliers</span></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                </div>
                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
            </body>

            </html>