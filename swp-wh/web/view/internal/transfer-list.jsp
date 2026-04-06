<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>${isExternal ? 'External' : 'Internal'} Transfers | InventoryPro</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
            <style>
                body {
                    font-family: 'Inter', sans-serif;
                    background-color: #f8fafc;
                    overflow-y: auto;
                }

                .page-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 0.5rem 0;
                    margin-bottom: 0.5rem;
                }

                .content-page {
                    padding-top: 65px !important;
                }

                .container-fluid {
                    padding-top: 0 !important;
                }

                .card-main {
                    border-radius: 16px;
                    border: 1px solid #e2e8f0;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                    background: white;
                    overflow: hidden;
                    margin-bottom: 2rem;
                }

                .filter-section {
                    padding: 1.5rem;
                    background: #fff;
                    border-bottom: 1px solid #f1f5f9;
                }

                .form-control {
                    border-radius: 10px;
                    border: 1px solid #e2e8f0;
                    padding: 0.6rem 1rem;
                    font-size: 0.9rem;
                }

                .form-control:focus {
                    border-color: #0ea5e9;
                    box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
                }

                .btn-filter {
                    background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
                    color: white !important;
                    border-radius: 12px;
                    height: 42px;
                    font-weight: 700;
                    border: none;
                    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                    transition: all 0.3s ease;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                }

                .btn-filter:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
                }

                .btn-reset {
                    background: #f1f5f9;
                    color: #475569 !important;
                    border-radius: 12px;
                    height: 42px;
                    padding: 0 1rem;
                    font-weight: 700;
                    border: 1px solid #e2e8f0;
                    transition: all 0.3s ease;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                }

                .btn-reset:hover {
                    background: #e2e8f0;
                }

                .table thead th {
                    background: #f8fafc;
                    font-weight: 700;
                    color: #64748b;
                    text-transform: uppercase;
                    font-size: 0.75rem;
                    letter-spacing: 0.05em;
                    padding: 1rem 1.25rem;
                    border-bottom: 2px solid #e2e8f0;
                }

                .table tbody td {
                    padding: 1rem 1.25rem;
                    vertical-align: middle;
                    border-bottom: 1px solid #f1f5f9;
                }

                .badge-status {
                    padding: 0.4rem 0.8rem;
                    border-radius: 8px;
                    font-weight: 700;
                    font-size: 0.75rem;
                    text-transform: uppercase;
                    display: inline-block;
                    min-width: 90px;
                    text-align: center;
                }

                .badge-pending {
                    background: #fff7ed;
                    color: #f97316;
                    border: 1px solid #ffedd5;
                }

                .badge-approved {
                    background: #eff6ff;
                    color: #2563eb;
                    border: 1px solid #dbeafe;
                }

                .badge-transit {
                    background: #fdf4ff;
                    color: #a21caf;
                    border: 1px solid #fae8ff;
                }

                .badge-completed {
                    background: #f0fdf4;
                    color: #10b981;
                    border: 1px solid #dcfce7;
                }

                .badge-cancelled {
                    background: #fef2f2;
                    color: #ef4444;
                    border: 1px solid #fee2e2;
                }

                /* Modal Styles - Thân thiện & Chuyên nghiệp hơn */
                .modal-content {
                    border-radius: 24px;
                    border: none;
                    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.15);
                    overflow: hidden;
                }

                .modal-header {
                    border-bottom: 1px solid #f8fafc;
                    padding: 1.2rem 2rem;
                    background: #fff;
                }

                .modal-body {
                    padding: 1.5rem 2rem;
                    background: #fff;
                }

                .info-section {
                    background: #fcfdfe;
                    border-radius: 16px;
                    padding: 1.2rem;
                    margin-bottom: 1.25rem;
                    border: 1px solid #edf2f7;
                }

                .detail-label {
                    font-size: 0.75rem;
                    text-transform: uppercase;
                    color: #64748b;
                    font-weight: 800;
                    letter-spacing: 0.08em;
                    margin-bottom: 0.5rem;
                    display: block;
                }

                .detail-value {
                    font-size: 1.1rem;
                    color: #1e293b;
                    font-weight: 600;
                }

                .route-node {
                    display: flex;
                    align-items: center;
                    background: white;
                    border: 1px solid #f1f5f9;
                    padding: 0.8rem 1rem;
                    border-radius: 12px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
                }

                .route-line {
                    width: 35px;
                    height: 2px;
                    background: #e2e8f0;
                    margin: 0 10px;
                    position: relative;
                }

                .route-line::after {
                    content: '\ea6e';
                    font-family: 'remixicon';
                    font-size: 1.1rem;
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    color: #64748b;
                }

                .product-banner {
                    background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                    border-left: 5px solid #0ea5e9;
                    padding: 1.2rem;
                    border-radius: 14px;
                    margin-bottom: 1.5rem;
                }

                .rounded-xl {
                    border-radius: 10px !important;
                }

                .btn-approve {
                    background: #0ea5e9;
                    border: none;
                    transition: all 0.3s;
                    color: white;
                }

                .btn-approve:hover {
                    background: #0284c7;
                    transform: translateY(-1px);
                    box-shadow: 0 10px 15px -3px rgba(14, 165, 233, 0.3);
                }

                .badge-step {
                    background: #e0f2fe;
                    color: #0369a1;
                    padding: 0.2rem 0.6rem;
                    border-radius: 6px;
                    font-weight: 700;
                    margin-right: 0.5rem;
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <%@ include file="../sidebar.jsp" %>
                    <jsp:include page="../header.jsp" />
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header">
                                <div>
                                    <h1 class="font-weight-bold mb-1">${isExternal ? 'External' : 'Internal'} Transfers
                                        History</h1>
                                    <p class="text-secondary mb-0">Track and manage inventory movements</p>
                                </div>
                                <div>
                                    <a href="${isExternal ? 'external-transfer' : 'internal-transfer'}?action=form"
                                        class="btn btn-success ml-2"><i class="ri-add-line"></i> Create New Request</a>
                                </div>
                            </div>

                            <c:if test="${not empty sessionScope.msg}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="ri-checkbox-circle-line mr-2"></i> ${sessionScope.msg}
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <% session.removeAttribute("msg"); %>
                            </c:if>

                            <div class="card card-main">
                                <div class="filter-section">
                                    <form action="${isExternal ? 'external-transfer' : 'internal-transfer'}"
                                        method="get">
                                        <input type="hidden" name="action" value="view">
                                        <div class="row align-items-end">
                                            <div class="col-md-5">
                                                <label
                                                    class="small font-weight-bold text-uppercase text-secondary">Search</label>
                                                <input type="text" name="code" class="form-control"
                                                    placeholder="Transfer code, product..." value="${code}">
                                            </div>
                                            <div class="col-md-3">
                                                <label
                                                    class="small font-weight-bold text-uppercase text-secondary">Status
                                                    Filter</label>
                                                <select name="status" class="form-control">
                                                    <option value="">All Statuses</option>
                                                    <option value="0" ${status==0 ? 'selected' : '' }>Pending</option>
                                                    <option value="1" ${status==1 ? 'selected' : '' }>Approved</option>
                                                    <option value="2" ${status==2 ? 'selected' : '' }>In Transit
                                                    </option>
                                                    <option value="3" ${status==3 ? 'selected' : '' }>Completed</option>
                                                    <option value="4" ${status==4 ? 'selected' : '' }>Cancelled</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4 d-flex" style="gap: 0.5rem;">
                                                <button type="submit" class="btn btn-filter flex-grow-1">Apply
                                                    Filters</button>
                                                <a href="${isExternal ? 'external-transfer' : 'internal-transfer'}?action=view"
                                                    class="btn btn-reset"><i class="ri-refresh-line"></i> Reset</a>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Order ID</th>
                                                    <th>Route (From -> To)</th>
                                                    <th>Product Detail</th>
                                                    <th>Quantity</th>
                                                    <th>Status</th>
                                                    <th class="text-right px-4">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${pendingList}" var="item">
                                                    <tr>
                                                        <td><span class="font-weight-bold">${item.transferCode}</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <span
                                                                    class="badge badge-light border px-2 py-1">${item.fromLocationName}</span>
                                                                <i class="ri-arrow-right-line mx-2 text-muted"></i>
                                                                <span
                                                                    class="badge badge-light border px-2 py-1">${item.toLocationName}</span>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.productId > 1}">
                                                                    <span class="text-muted"><i
                                                                            class="ri-stack-line"></i> Multiple
                                                                        items</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${item.productName}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="font-weight-bold text-primary">${item.quantity}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.status == 0}"><span
                                                                        class="badge-status badge-pending">Pending</span>
                                                                </c:when>
                                                                <c:when test="${item.status == 1}"><span
                                                                        class="badge-status badge-approved">Approved</span>
                                                                </c:when>
                                                                <c:when test="${item.status == 2}"><span
                                                                        class="badge-status badge-transit">In
                                                                        Transit</span></c:when>
                                                                <c:when test="${item.status == 3}"><span
                                                                        class="badge-status badge-completed">Completed</span>
                                                                </c:when>
                                                                <c:when test="${item.status == 4}"><span
                                                                        class="badge-status badge-cancelled">Cancelled</span>
                                                                </c:when>
                                                                <c:otherwise><span
                                                                        class="badge-status badge-secondary">Unknown</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-right px-4">
                                                            <a href="${isExternal ? 'external-transfer' : 'internal-transfer'}?action=detail&id=${item.id}"
                                                                class="btn btn-sm btn-outline-primary"
                                                                style="border-radius: 8px; font-weight: 700; font-size: 0.8rem; padding: 0.4rem 1.2rem;">
                                                                <i class="ri-eye-line mr-1"></i> View Detail
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty pendingList}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-5">
                                                            <div class="text-muted">
                                                                <i class="ri-history-line ri-3x mb-3 d-block"></i>
                                                                <p>No transfer history found.</p>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <c:if test="${totalPages > 1}">
                                    <div class="card-footer bg-white border-top py-3">
                                        <nav aria-label="Page navigation">
                                            <ul class="pagination justify-content-center mb-0">
                                                <%-- Block Pagination (Groups of 3: 1-3, 4-6, 7-9...) --%>
                                                    <c:set var="startPage"
                                                        value="${currentPage - ((currentPage - 1) % 3)}" />
                                                    <c:set var="endPage" value="${startPage + 2}" />
                                                    <c:if test="${endPage > totalPages}">
                                                        <c:set var="endPage" value="${totalPages}" />
                                                    </c:if>

                                                    <c:set var="baseUrl"
                                                        value="${isExternal ? 'external-transfer' : 'internal-transfer'}" />

                                                    <%-- Previous --%>
                                                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                                            <a class="page-link"
                                                                href="${baseUrl}?action=view&page=${currentPage - 1}&code=${code}&status=${status}&fromLoc=${fromLoc}&toLoc=${toLoc}&productName=${productName}">
                                                                <i class="ri-arrow-left-s-line"></i> Previous
                                                            </a>
                                                        </li>

                                                        <%-- Page numbers --%>
                                                            <c:forEach begin="${startPage}" end="${endPage}" var="p">
                                                                <li
                                                                    class="page-item ${p == currentPage ? 'active' : ''}">
                                                                    <a class="page-link"
                                                                        href="${baseUrl}?action=view&page=${p}&code=${code}&status=${status}&fromLoc=${fromLoc}&toLoc=${toLoc}&productName=${productName}">${p}</a>
                                                                </li>
                                                            </c:forEach>

                                                            <%-- Next --%>
                                                                <li
                                                                    class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                                                    <a class="page-link"
                                                                        href="${baseUrl}?action=view&page=${currentPage + 1}&code=${code}&status=${status}&fromLoc=${fromLoc}&toLoc=${toLoc}&productName=${productName}">
                                                                        Next <i class="ri-arrow-right-s-line"></i>
                                                                    </a>
                                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
            </div>
            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        </body>

        </html>