<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Location Detail | InventoryPro</title>

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

        .table tbody td {
            padding: 1.25rem 1.5rem;
            vertical-align: middle;
            font-weight: 600;
            border-bottom: 1px solid #f1f5f9;
        }

        .badge-color {
            background: #f1f5f9;
            color: #475569;
            padding: 0.4rem 0.8rem;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
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
            border: 1px solid #e2e8f0;
            color: #64748b;
            font-weight: 600;
            transition: all 0.2s;
            text-decoration: none;
        }

        .page-item.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
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
                    <div>
                        <a href="locations" class="btn-back mb-3">
                            <i class="ri-arrow-left-line"></i> Back to List
                        </a>
                        <h1 class="font-weight-bold h2">Location: <span class="text-primary">${loc.locationCode}</span></h1>
                        <p class="text-secondary mb-0">${loc.locationName} | Max Capacity: <strong>${loc.maxCapacity}</strong></p>
                    </div>
                </div>

                <div class="card card-main">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table mb-0">
                                <thead>
                                    <tr>
                                        <th>Vehicle Name</th>
                                        <th>Code</th>
                                        <th>Color</th>
                                        <th class="text-center">Quantity</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="g" items="${pagedProducts}">
                                        <tr>
                                            <td>
                                                <div class="font-weight-bold text-dark">
                                                    <i class="ri-car-line mr-2 text-primary"></i>
                                                    ${g.product.name}
                                                </div>
                                            </td>
                                            <td><span class="text-secondary small font-weight-bold">${g.product.code}</span></td>
                                            <td>
                                                <span class="badge-color">${g.color}</span>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge badge-soft-info px-3 py-2" style="font-size: 0.85rem; font-weight: 700;">
                                                    ${g.totalQty} units
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty pagedProducts}">
                                        <tr>
                                            <td colspan="4" class="text-center py-5">
                                                <i class="ri-inbox-line display-4 text-muted opacity-25"></i>
                                                <p class="text-secondary mt-3">This location is currently empty.</p>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

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
</body>

</html>