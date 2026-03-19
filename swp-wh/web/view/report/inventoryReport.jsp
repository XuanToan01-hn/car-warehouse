<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Inventory Drill-down | InventoryPro</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    
    <style>
        :root { --primary: #0EA5E9; --success: #15803d; --warning: #f59e0b; --gray-dark: #0f172a; }
        body { font-family: 'Be Vietnam Pro', sans-serif; background-color: #f1f5f9; color: #1e293b; }
        
        /* Header & Buttons */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; padding: 1.5rem 0; }
        .btn-refresh { background: #f8fafc; color: #64748b; border: 2px solid #e2e8f0; border-radius: 12px; padding: 0.75rem 1.5rem; font-weight: 700; transition: all 0.3s; }
        .btn-refresh:hover { background: #e2e8f0; }
        
        /* Cards & Tables */
        .card-main { border-radius: 16px; border: none; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); background: white; overflow: hidden; }
        .table thead th { background: #f8fafc; font-weight: 800; color: #0f172a; text-transform: uppercase; font-size: 0.8rem; padding: 1.25rem 1.5rem; border-bottom: 2px solid #f1f5f9; }
        .table tbody td { padding: 1.1rem 1.5rem; vertical-align: middle; font-weight: 500; }
        
        /* Drill-down UI */
        .selected-row { background-color: #f0f9ff !important; border-left: 6px solid var(--primary); }
        .drill-down-card { border-radius: 16px; border: none; box-shadow: 0 10px 25px rgba(0,0,0,0.08); }
        .list-group-item { padding: 1rem 1.5rem; border: none; border-bottom: 1px solid #f1f5f9; font-weight: 600; color: #475569; }
        .list-group-item.active { background-color: var(--primary) !important; color: white !important; }
        
        /* Forms */
        .filter-section { background: white; padding: 1.25rem; border-radius: 16px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03); margin-bottom: 1.5rem; }
        .form-control-modern { border-radius: 10px; border: 2px solid #e2e8f0; font-weight: 600; height: 45px; transition: all 0.2s; }
        .form-control-modern:focus { border-color: var(--primary); box-shadow: none; }
        
        .sticky-top { top: 30px; }
        .badge-qty { padding: 0.5rem 0.8rem; border-radius: 8px; font-weight: 800; font-size: 0.9rem; }
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
                        <h1 class="font-weight-bold mb-1">Unified Inventory Report</h1>
                        <p class="text-secondary">Track your global stock down to warehouses and specific bin locations</p>
                    </div>
                    <a href="inventory-report" class="btn btn-refresh">
                        <i class="ri-refresh-line"></i> Reset Filters
                    </a>
                </div>

                <div class="row">
                    
                    <div class="${(not empty warehouses) ? 'col-lg-7' : 'col-lg-12'} transition-all">
                        
                        <div class="filter-section">
                            <form method="get" action="inventory-report">
                                <div class="row g-2">
                                    <div class="col-md-9">
                                        <input type="text" name="search" class="form-control form-control-modern" 
                                               placeholder="Search by Product Name, Code or Lot Number..." value="${param.search}">
                                    </div>
                                    <div class="col-md-3">
                                        <button type="submit" class="btn btn-primary btn-block h-100 font-weight-bold" style="border-radius: 10px;">
                                            <i class="ri-search-2-line"></i> Search
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <div class="card card-main">
                            <div class="table-responsive">
                                <table class="table mb-0">
                                    <thead>
                                        <tr>
                                            <th>Product Info</th>
                                            <th>Lot Number</th>
                                            <th class="text-center">Global Stock</th>
                                            <th class="text-right">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${pdList}" var="pd">
                                            <tr class="${selectedPdId == pd.id ? 'selected-row' : ''}">
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="bg-light p-2 rounded mr-3">
                                                            <i class="ri-box-3-fill text-primary" style="font-size: 1.5rem;"></i>
                                                        </div>
                                                        <div>
                                                            <div class="font-weight-bold text-dark">${pd.product.name}</div>
                                                            <small class="text-primary font-weight-bold">${pd.product.code}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td><span class="badge badge-soft-dark p-2 font-weight-bold">${pd.lotNumber}</span></td>
                                                <td class="text-center">
                                                    <span class="badge-qty text-primary bg-light">${pd.quantity}</span>
                                                </td>
                                                <td class="text-right">
                                                    <a href="?page=${currentPage}&search=${param.search}&pdId=${pd.id}" 
                                                       class="btn-action btn-edit" style="display: inline-block; padding: 8px 15px;">
                                                        View Bins <i class="ri-arrow-right-s-line"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty pdList}">
                                            <tr><td colspan="4" class="text-center py-5 text-secondary">No stock data found matching your filters.</td></tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <div class="card-footer bg-white border-top-0 py-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <p class="text-secondary small mb-0">Showing Page ${currentPage} of ${totalPages}</p>
                                    <c:if test="${totalPages > 1}">
                                        <ul class="pagination pagination-sm mb-0">
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                    <a class="page-link shadow-none" href="?page=${i}&search=${param.search}">${i}</a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>

                    <c:if test="${not empty warehouses}">
                        <div class="col-lg-5">
                            <div class="sticky-top">
                                
                                <div class="card drill-down-card mb-4">
                                    <div class="card-header bg-dark py-3">
                                        <h5 class="mb-0 text-white font-weight-bold"><i class="ri-map-pin-2-line mr-2"></i> Stock by Warehouse</h5>
                                    </div>
                                    <div class="list-group list-group-flush">
                                        <c:forEach items="${warehouses}" var="w">
                                            <a href="?page=${currentPage}&search=${param.search}&pdId=${selectedPdId}&wId=${w.id}" 
                                               class="list-group-item list-group-item-action d-flex justify-content-between align-items-center ${selectedWId == w.id ? 'active' : ''}">
                                                <span><i class="ri-community-line mr-2"></i> ${w.warehouseName}</span>
                                                <span class="badge badge-qty ${selectedWId == w.id ? 'bg-white text-primary' : 'bg-soft-primary text-primary'}">
                                                    ${w.description}
                                                </span>
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>

                                <c:if test="${not empty locations}">
                                    <div class="card drill-down-card border-0 shadow-lg animate__animated animate__fadeInUp">
                                        <div class="card-header bg-warning py-3">
                                            <h5 class="mb-0 text-dark font-weight-bold"><i class="ri-focus-3-line mr-2"></i> Specific Bin Locations</h5>
                                        </div>
                                        <div class="table-responsive">
                                            <table class="table table-sm mb-0">
                                                <thead class="bg-light">
                                                    <tr>
                                                        <th class="py-2">Code</th>
                                                        <th class="py-2">Bin Name</th>
                                                        <th class="py-2 text-center">Qty</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${locations}" var="loc">
                                                        <tr>
                                                            <td class="font-weight-bold text-primary">${loc.locationCode}</td>
                                                            <td>${loc.locationName}</td>
                                                            <td class="text-center">
                                                                <span class="text-success font-weight-bold">${loc.currentStock}</span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${empty locations and not empty selectedWId}">
                                    <div class="alert alert-soft-secondary text-center">
                                        No specific bin data for this selection.
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${empty warehouses}">
                        <div class="col-lg-12 mt-4">
                            <div class="text-center p-5 bg-white rounded-lg shadow-sm">
                                <i class="ri-information-line text-secondary display-4"></i>
                                <h4 class="mt-3 text-secondary">Select a product to drill-down into warehouse and bin details</h4>
                            </div>
                        </div>
                    </c:if>
                    
                </div> </div> </div> </div> <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>