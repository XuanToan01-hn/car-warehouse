<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Detailed Inventory Report | InventoryPro</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>
    
    <style>
        :root { --primary: #0EA5E9; --success: #15803d; --gray-dark: #0f172a; --danger: #ef4444; }
        body { font-family: 'Inter', sans-serif; background-color: #f1f5f9; color: #1e293b; }
        
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; padding: 1.5rem 0; }
        .btn-refresh { background: #f8fafc; color: #64748b; border: 2px solid #e2e8f0; border-radius: 12px; padding: 0.75rem 1.5rem; font-weight: 700; transition: all 0.3s; }
        .btn-refresh:hover { background: #e2e8f0; }

        .btn-pdf { background: var(--danger); color: white; border-radius: 12px; padding: 0.75rem 1.5rem; font-weight: 700; border: none; transition: 0.3s; box-shadow: 0 4px 10px rgba(239, 68, 68, 0.2); }
        .btn-pdf:hover { background: #dc2626; color: white; transform: translateY(-2px); }
        
        .card-main { border-radius: 16px; border: none; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); background: white; overflow: hidden; }
        .table thead th { background: #f8fafc; font-weight: 800; color: #0f172a; text-transform: uppercase; font-size: 0.75rem; padding: 1.25rem 1.5rem; border-bottom: 2px solid #f1f5f9; }
        .table tbody td { padding: 1.1rem 1.5rem; vertical-align: middle; font-weight: 500; }
        
        .badge-loc { background-color: #f0f9ff; color: #0369a1; border: 1px solid #bae6fd; padding: 0.4rem 0.7rem; border-radius: 8px; font-weight: 700; font-size: 0.8rem; }
        .badge-qty { padding: 0.5rem 0.8rem; border-radius: 8px; font-weight: 800; font-size: 0.9rem; }
        
        .filter-section { background: white; padding: 1.25rem; border-radius: 16px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03); margin-bottom: 1.5rem; }
        .form-control-modern { border-radius: 10px; border: 2px solid #e2e8f0; font-weight: 600; height: 45px; transition: all 0.2s; }
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
                        <h1 class="font-weight-bold mb-1">Detailed Inventory Report</h1>
                        <p class="text-secondary">Global stock tracking by Lot Number, Warehouse, and Bin Location</p>
                    </div>
                    <div class="d-flex align-items-center">
                        <button onclick="exportToPDF()" class="btn btn-pdf mr-3">
                            <i class="ri-file-pdf-line mr-1"></i> EXPORT PDF
                        </button>
                        <a href="inventory-report" class="btn btn-refresh">
                            <i class="ri-refresh-line mr-1"></i> Reset Filters
                        </a>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12">
                        <div class="filter-section">
                            <form method="get" action="inventory-report">
                                <div class="row g-2">
                                    <div class="col-md-10">
                                        <input type="text" name="search" class="form-control form-control-modern" 
                                               placeholder="Search by Product Name, Code or Lot Number..." value="${param.search}">
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary btn-block h-100 font-weight-bold" style="border-radius: 10px;">
                                            <i class="ri-search-2-line"></i> Search
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <div class="card card-main">
                            <div class="table-responsive">
                                <table class="table mb-0" id="inventoryTable">
                                    <thead>
                                        <tr>
                                            <th>Product Information</th>
                                            <th>Lot Number</th>
                                            <th>Warehouse</th>
                                            <th>Bin Location</th>
                                            <th class="text-center">Quantity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${pdList}" var="pd">
                                            <tr>
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
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <i class="ri-community-line text-secondary mr-2"></i>
                                                        <span>${pd.location.warehouseName}</span>
                                                    </div>
                                                </td>
                                                <td><span class="badge badge-loc">${pd.location.locationCode}</span></td>
                                                <td class="text-center">
                                                    <span class="badge-qty text-primary bg-light">${pd.quantity}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty pdList}">
                                            <tr>
                                                <td colspan="5" class="text-center py-5 text-secondary">
                                                    No inventory data found.
                                                </td>
                                            </tr>
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
                </div>
            </div>
        </div>
    </div>

    <script>
        function exportToPDF() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF('p', 'mm', 'a4');

            // Document Header
            doc.setFontSize(18);
            doc.setFont("helvetica", "bold");
            doc.text("DETAILED INVENTORY REPORT", 14, 20);
            
            doc.setFontSize(10);
            doc.setFont("helvetica", "normal");
            doc.setTextColor(100);
            doc.text("Generated Date: " + new Date().toLocaleString(), 14, 28);
            doc.text("Source: InventoryPro Management System", 14, 34);

            // Table Generation
            doc.autoTable({
                html: '#inventoryTable',
                startY: 40,
                theme: 'grid',
                headStyles: { fillColor: [15, 23, 42], textColor: [255, 255, 255], fontStyle: 'bold' },
                styles: { fontSize: 9, cellPadding: 3, font: "helvetica" },
                columnStyles: {
                    4: { halign: 'center' } 
                }
            });

            doc.save('Inventory_Report_' + new Date().getTime() + '.pdf');
        }
    </script>

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>