<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Location Detail | InventoryPro</title>

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

                .btn-back {
                    background: white;
                    color: #64748b;
                    border: 1px solid #e2e8f0;
                    border-radius: 12px;
                    padding: 0.6rem 1.2rem;
                    font-weight: 600;
                    transition: all 0.2s;
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .btn-back:hover {
                    background: #f1f5f9;
                    color: var(--gray-dark);
                    transform: translateX(-4px);
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

                .product-row:hover {
                    background: #f1f5f9;
                    cursor: pointer;
                }

                .product-row[aria-expanded="true"] {
                    background: #f8fafc;
                }

                .product-row[aria-expanded="true"] .toggle-icon {
                    transform: rotate(90deg);
                }

                .toggle-icon {
                    transition: transform 0.2s;
                }

                .vin-tag-v {
                    background: white;
                    color: #475569;
                    padding: 0.5rem 1rem;
                    border-radius: 8px;
                    border: 1px solid #e2e8f0;
                    font-size: 0.9rem;
                    font-weight: 500;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
                    display: flex;
                    align-items: center;
                    width: fit-content;
                    margin-bottom: 6px;
                }

                .pagination {
                    display: flex;
                    justify-content: center;
                    gap: 0.5rem;
                    margin-top: 2rem;
                    margin-bottom: 2rem;
                }
                
                .page-item {
                    width: 40px;
                    height: 40px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: 10px;
                    background: white;
                    border: 1px solid #e2e8f0;
                    color: #64748b;
                    font-weight: 600;
                    transition: all 0.2s;
                    text-decoration: none;
                }

                .page-item:hover {
                    background: #f1f5f9;
                    color: var(--primary);
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
                    from { opacity: 0; transform: translateY(10px); }
                    to { opacity: 1; transform: translateY(0); }
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <%@ include file="sidebar.jsp" %>
                <jsp:include page="header.jsp" />
                
                <div class="content-page">
                    <div class="container-fluid animate-fade-in">
                        <div class="page-header">
                            <div>
                                <a href="locations" class="btn-back mb-3">
                                    <i class="ri-arrow-left-line"></i> Back to List
                                </a>
                                <h1 class="font-weight-bold h2">Location: <span class="text-primary">${loc.locationCode}</span></h1>
                                <p class="text-secondary mb-0">${loc.locationName} | Max Capacity: <strong>${loc.maxCapacity}</strong></p>
                            </div>
                        </div>

                        <c:if test="${not empty sessionScope.error}">
                            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert"
                                style="border-radius: 12px; font-weight: 600;">
                                <i class="ri-error-warning-line mr-2"></i> ${sessionScope.error}
                                <button type="button" class="close"
                                    data-dismiss="alert"><span>&times;</span></button>
                            </div>
                            <c:remove var="error" scope="session" />
                        </c:if>
                        <c:if test="${not empty sessionScope.success}">
                            <div class="alert alert-success alert-dismissible fade show mb-4" role="alert"
                                style="border-radius: 12px; font-weight: 600;">
                                <i class="ri-checkbox-circle-line mr-2"></i> ${sessionScope.success}
                                <button type="button" class="close"
                                    data-dismiss="alert"><span>&times;</span></button>
                            </div>
                            <c:remove var="success" scope="session" />
                        </c:if>

                        <div class="search-section mb-4" style="background: white; padding: 1rem 1.5rem; border-radius: 12px; display: flex; align-items: center; gap: 1rem; border: 1px solid #e2e8f0; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02); max-width: 500px;">
                            <i class="ri-search-line text-primary"></i>
                            <input type="text" id="vehicleSearchInput" placeholder="Search vehicles in this location..." style="border: none; font-weight: 600; outline: none; width: 100%;">
                        </div>

                        <div class="card card-main">
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table mb-0">
                                        <thead>
                                            <tr>
                                                <th style="width: 45%;">Vehicle Name</th>
                                                <th style="width: 25%;">Vehicle Code</th>
                                                <th class="text-center">Total Quantity</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="g" items="${pagedProducts}" varStatus="status">
                                                <tr class="product-row" data-toggle="collapse" data-target="#serials-${status.index}">
                                                    <td>
                                                        <div class="font-weight-bold d-flex align-items-center">
                                                            <i class="ri-arrow-right-s-line mr-2 text-primary toggle-icon"></i>
                                                            ${g.product.name}
                                                        </div>
                                                    </td>
                                                    <td><span class="text-primary font-weight-bold">${g.product.code}</span></td>
                                                    <td class="text-center">
                                                        <span class="badge badge-soft-primary px-3 py-2" style="font-size: 0.85rem;">
                                                            ${g.totalQty} vehicles
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr id="serials-${status.index}" class="collapse">
                                                    <td colspan="3" style="background: #f8fafc; border-top: none; padding: 1.5rem;">
                                                        <div class="info-label mb-3" style="font-size: 0.7rem; color: #94a3b8; font-weight: 800; text-transform: uppercase;">Variant Details:</div>
                                                        <div class="row">
                                                            <c:forEach var="s" items="${g.serials}">
                                                                <div class="col-md-3">
                                                                    <div class="vin-tag-v justify-content-between">
                                                                        <div class="d-flex align-items-center">
                                                                            <i class="ri-car-line mr-2 text-muted"></i>
                                                                            <span class="font-weight-bold">${s.serial}</span>
                                                                            <c:if test="${not empty s.color}">
                                                                                <span class="badge ml-2 mr-2" style="background: #e2e8f0; color: #475569; font-size: 0.7rem;">${s.color}</span>
                                                                            </c:if>
                                                                        </div>
                                                                        <span class="text-primary small font-weight-bold">${s.qty} units</span>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                            <c:if test="${empty g.serials}">
                                                                <div class="col-12 text-muted italic">No specific variants found.</div>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty pagedProducts}">
                                                <tr>
                                                    <td colspan="3" class="text-center py-5">
                                                        <div class="py-4">
                                                            <i class="ri-inbox-line display-4 text-muted opacity-25"></i>
                                                            <p class="text-secondary mt-3">This location is currently empty or has no matching records.</p>
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
                                    <a href="locations?action=viewDetail&id=${loc.id}&page=${i}" 
                                       class="page-item ${i == currentPage ? 'active' : ''}">${i}</a>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script>
                document.getElementById('vehicleSearchInput').addEventListener('input', function() {
                    const query = this.value.toLowerCase().trim();
                    const rows = document.querySelectorAll('.product-row');
                    
                    rows.forEach(row => {
                        const text = row.innerText.toLowerCase();
                        const targetId = row.getAttribute('data-target');
                        const detailRow = document.querySelector(targetId);
                        
                        if (text.includes(query)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                            $(detailRow).collapse('hide');
                        }
                    });
                });
            </script>
        </body>

        </html>
