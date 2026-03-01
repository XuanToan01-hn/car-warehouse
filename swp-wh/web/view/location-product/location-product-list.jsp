<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Inventory by Location | InventoryPro</title>

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

                    .badge-spec {
                        background: #f1f5f9;
                        color: #475569;
                        padding: 0.3rem 0.6rem;
                        border-radius: 6px;
                        font-weight: 700;
                        font-size: 0.75rem;
                        border: 1px solid #e2e8f0;
                    }

                    .qty-badge {
                        background: #e0f2fe;
                        color: #0369a1;
                        padding: 0.4rem 0.8rem;
                        border-radius: 8px;
                        font-weight: 800;
                        font-size: 0.95rem;
                    }

                    .location-info {
                        display: flex;
                        flex-direction: column;
                    }

                    .location-name {
                        font-weight: 800;
                        color: #0f172a;
                        font-size: 1rem;
                    }

                    .location-code {
                        font-size: 0.75rem;
                        color: #64748b;
                        text-transform: uppercase;
                        letter-spacing: 0.025em;
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
                        border-radius: 12px;
                        border: 2px solid #e2e8f0;
                        font-weight: 600;
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <jsp:include page="../sidebar.jsp" />
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header">
                                <div>
                                    <h1 class="font-weight-bold mb-1">Stock by Location</h1>
                                    <p class="text-secondary mb-0">Monitor and manage inventory distribution across
                                        warehouse zones.</p>
                                </div>
                                <a href="location-product?action=add" class="btn btn-add">
                                    <i class="ri-add-line"></i> Move Stock to Location
                                </a>
                            </div>

                            <div class="mb-4">
                                <div class="search-box">
                                    <i class="ri-search-line"></i>
                                    <input type="text" id="searchInput" class="form-control shadow-sm"
                                        placeholder="Search by location or product...">
                                </div>
                            </div>

                            <div class="card card-main">
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Location</th>
                                                    <th>Product</th>
                                                    <th>Specifications</th>
                                                    <th class="text-center">Quantity</th>
                                                    <th class="text-right">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty items}">
                                                        <tr>
                                                            <td colspan="5" class="text-center py-5">
                                                                <i
                                                                    class="ri-inbox-line display-4 text-muted d-block opacity-25"></i>
                                                                <p class="text-secondary mt-3 font-weight-600">No stock
                                                                    records found.</p>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach items="${items}" var="item">
                                                            <tr class="stock-row">
                                                                <td>
                                                                    <div class="location-info">
                                                                        <span
                                                                            class="location-name">${item.location.locationName}</span>
                                                                        <span
                                                                            class="location-code">${item.location.locationCode}</span>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="font-weight-700 text-dark">
                                                                        ${item.productDetail.product.name}
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <div class="d-flex flex-wrap gap-2">
                                                                        <span class="badge-spec">COLOR:
                                                                            ${item.productDetail.color}</span>
                                                                        <span class="badge-spec">LOT:
                                                                            ${item.productDetail.lotNumber}</span>
                                                                    </div>
                                                                </td>
                                                                <td class="text-center">
                                                                    <span class="qty-badge">${item.quantity}</span>
                                                                </td>
                                                                <td class="text-right">
                                                                    <a href="location-product?action=delete&locId=${item.location.id}&pdId=${item.productDetail.id}"
                                                                        class="btn btn-outline-danger btn-sm px-3"
                                                                        style="border-radius: 8px; font-weight: 700;"
                                                                        onclick="return confirm('Are you sure you want to remove this stock entry?')">
                                                                        <i class="ri-delete-bin-line mr-1"></i> Remove
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

                <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.0.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

                <script>
                    // Simple search logic
                    const searchInput = document.getElementById('searchInput');
                    const tableRows = document.querySelectorAll('.stock-row');

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