<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Stock by Location | InventoryPro</title>

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
                    --secondary: #64748b;
                    --success: #10b981;
                    --danger: #ef4444;
                    --warning: #f59e0b;
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
                    gap: 0.5rem;
                    text-decoration: none !important;
                }

                .btn-add:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
                    color: white;
                }

                .card-main {
                    border: none;
                    border-radius: 20px;
                    box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
                    overflow: hidden;
                    background: white;
                }

                .table thead th {
                    background-color: #f1f5f9;
                    text-transform: uppercase;
                    font-size: 0.75rem;
                    font-weight: 800;
                    color: #64748b;
                    letter-spacing: 0.05em;
                    padding: 1.25rem 1.5rem;
                    border: none;
                }

                .table tbody td {
                    padding: 1.25rem 1.5rem;
                    vertical-align: middle;
                    border-bottom: 1px solid #f1f5f9;
                    font-size: 0.9rem;
                }

                .product-row {
                    cursor: pointer;
                    transition: background 0.2s;
                }

                .product-row:hover {
                    background-color: #f8fafc;
                }

                .toggle-icon {
                    transition: transform 0.3s ease;
                }

                .product-row[aria-expanded="true"] .toggle-icon {
                    transform: rotate(90deg);
                }

                .vin-variant-card {
                    background: #ffffff;
                    border: 1px solid #edf2f7;
                    border-radius: 14px;
                    padding: 0.9rem 1.1rem;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
                    margin-bottom: 0.6rem;
                    position: relative;
                    overflow: hidden;
                    border-left: 4px solid #e2e8f0;
                }

                .vin-variant-card:hover {
                    border-color: var(--primary);
                    border-left-color: var(--primary);
                    transform: translateY(-2px);
                    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.12);
                }

                .vin-icon-circle {
                    width: 36px;
                    height: 36px;
                    background: #f0f9ff;
                    color: var(--primary);
                    border-radius: 10px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.1rem;
                    margin-right: 0.85rem;
                }

                .qty-badge-v {
                    background: #f8fafc;
                    border: 1px solid #f1f5f9;
                    color: #475569;
                    padding: 0.25rem 0.65rem;
                    border-radius: 8px;
                    font-size: 0.75rem;
                    font-weight: 800;
                    letter-spacing: 0.02em;
                }

                .badge-soft-primary {
                    background-color: #e0f2fe;
                    color: #0369a1;
                    font-weight: 700;
                }

                .pagination {
                    display: flex;
                    justify-content: center;
                    gap: 0.5rem;
                    margin-top: 2rem;
                }

                .page-item {
                    width: 40px;
                    height: 40px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: 10px;
                    background: white;
                    color: #64748b;
                    font-weight: 600;
                    text-decoration: none !important;
                    border: 1px solid #e2e8f0;
                    transition: all 0.2s;
                }

                .page-item.active {
                    background: var(--primary);
                    color: white;
                    border-color: var(--primary);
                    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                }

                .animate-fade-in {
                    animation: fadeIn 0.4s ease-out;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(10px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <%@ include file="../sidebar.jsp" %>
                    <jsp:include page="../header.jsp" />

                    <div class="content-page">
                        <div class="container-fluid animate-fade-in">
                            <div class="page-header">
                                <div>
                                    <h1 class="font-weight-bold h2 mb-1">Product Location</h1>
                                    <p class="text-secondary mb-0">Manage stock movement between locations</p>
                                </div>
                                <!-- <div class="text-right">
                                    <a href="location-product?action=add" class="btn-add">
                                        <i class="ri-add-line"></i> Move Stock to Location
                                    </a>
                                </div> -->
                            </div>

                            <!-- Global Search Box -->
                            <div class="mb-4">
                                <form action="location-product" method="get" class="d-flex" style="max-width: 500px;">
                                    <input type="hidden" name="action" value="list">
                                    <div class="input-group shadow-sm"
                                        style="border-radius: 12px; overflow: hidden; border: 1px solid #e2e8f0;">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text bg-white border-0"><i
                                                    class="ri-search-line text-muted"></i></span>
                                        </div>
                                        <input type="text" name="search" class="form-control border-0 px-2"
                                            placeholder="Search location, vehicle name or code..." value="${search}"
                                            style="height: 48px; font-weight: 500;">
                                        <div class="input-group-append">
                                            <button class="btn btn-primary px-4" type="submit"
                                                style="background: var(--primary); border: none;">Search</button>
                                        </div>
                                    </div>
                                    <c:if test="${not empty search}">
                                        <a href="location-product"
                                            class="btn btn-link text-secondary d-flex align-items-center ml-2"
                                            style="text-decoration: none;">
                                            <i class="ri-refresh-line mr-1"></i> Reset
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
                                                    <th style="width: 25%;">Location</th>
                                                    <th style="width: 35%;">Vehicle Name</th>
                                                    <th style="width: 20%;">Vehicle Code</th>
                                                    <th class="text-center">Total Quantity</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="g" items="${items}" varStatus="status">
                                                    <tr class="product-row" data-toggle="collapse"
                                                        data-target="#serials-${status.index}">
                                                        <td>
                                                            <div class="font-weight-bold text-primary">
                                                                <i class="ri-map-pin-line mr-1"></i>
                                                                ${g.location.locationCode}
                                                            </div>
                                                            <small class="text-muted">${g.location.locationName}</small>
                                                        </td>
                                                        <td>
                                                            <div class="font-weight-bold d-flex align-items-center">
                                                                <i
                                                                    class="ri-arrow-right-s-line mr-2 text-primary toggle-icon"></i>
                                                                ${g.product.name}
                                                            </div>
                                                        </td>
                                                        <td><span
                                                                class="text-secondary font-weight-bold">${g.product.code}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="badge badge-soft-primary px-3 py-2"
                                                                style="font-size: 0.85rem;">
                                                                ${g.totalQty} vehicles
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr id="serials-${status.index}" class="collapse">
                                                        <td colspan="4"
                                                            style="background: #f8fafc; border-top: none; padding: 1.5rem;">
                                                            <div class="info-label mb-3"
                                                                style="font-size: 0.7rem; color: #94a3b8; font-weight: 800; text-transform: uppercase;">
                                                                VIN Variant Details:</div>
                                                            <div class="row">
                                                                <c:forEach var="s" items="${g.serials}">
                                                                    <div class="col-md-4 mb-3 px-2">
                                                                        <div class="vin-variant-card">
                                                                            <div class="d-flex align-items-center">
                                                                                <div class="vin-icon-circle">
                                                                                    <i class="ri-barcode-line"></i>
                                                                                </div>
                                                                                <div>
                                                                                    <div class="font-weight-bold"
                                                                                        style="font-size: 0.9rem; color: #1e293b; letter-spacing: 0.01em;">
                                                                                        ${s.serial}
                                                                                    </div>
                                                                                    <div class="text-secondary small font-weight-500"
                                                                                        style="font-size: 0.75rem; opacity: 0.85;">
                                                                                        Color: <span
                                                                                            class="text-primary font-weight-700">${s.color}</span>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="text-right">
                                                                                <div class="qty-badge-v">
                                                                                    ${s.qty} Units
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty items}">
                                                    <tr>
                                                        <td colspan="4" class="text-center py-5">
                                                            <div class="py-5">
                                                                <i
                                                                    class="ri-inbox-line display-4 text-muted opacity-25"></i>
                                                                <p class="text-secondary mt-3">No stock records found
                                                                    matching your current view or search.</p>
                                                                <c:if test="${not empty search}">
                                                                    <a href="location-product"
                                                                        class="btn btn-outline-primary mt-2">Clear
                                                                        search and show all</a>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div class="pagination">
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <a href="location-product?action=list&page=${i}&search=${search}"
                                            class="page-item ${i == currentPage ? 'active' : ''}">${i}</a>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>
            </div>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        </body>

        </html>