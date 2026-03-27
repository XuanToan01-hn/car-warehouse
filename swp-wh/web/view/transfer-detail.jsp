<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Transfer Detail | InventoryPro</title>
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
        }
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background-color: #f8fafc;
        }
        .page-header {
            margin-bottom: 2rem;
            padding: 1.5rem 0;
        }
        .card-detail {
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            background: white;
            overflow: hidden;
        }
        .info-section {
            background: #fcfdfe;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
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
            font-size: 1.15rem;
            color: #1e293b;
            font-weight: 600;
        }
        .route-node {
            display: flex;
            align-items: center;
            background: white;
            border: 1px solid #f1f5f9;
            padding: 1rem 1.25rem;
            border-radius: 14px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        .product-banner {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            border-left: 5px solid var(--primary);
            padding: 1.5rem;
            border-radius: 16px;
        }
        .status-badge {
            padding: 0.5rem 1.2rem;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
            text-transform: uppercase;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>
        <jsp:include page="header.jsp" />
        <div class="content-page">
            <div class="container-fluid">
                <div class="page-header d-flex justify-content-between align-items-center">
                    <div>
                        <a href="javascript:history.back()" class="text-primary font-weight-bold mb-2 d-inline-block">
                            <i class="ri-arrow-left-line"></i> Back to List
                        </a>
                        <h1 class="font-weight-bold h2">Transfer Detail</h1>
                    </div>
                    <div id="statusArea">
                        <c:choose>
                            <c:when test="${t.status == 0}"><span class="status-badge badge-warning">Pending</span></c:when>
                            <c:when test="${t.status == 1}"><span class="status-badge badge-info">Approved</span></c:when>
                            <c:when test="${t.status == 2}"><span class="status-badge badge-primary">In-Transit</span></c:when>
                            <c:when test="${t.status == 3}"><span class="status-badge badge-success">Completed</span></c:when>
                            <c:otherwise><span class="status-badge badge-secondary">Cancelled</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card card-detail">
                    <div class="card-body p-4 p-lg-5">
                        <div class="row align-items-center mb-5">
                            <div class="col-md-7">
                                <span class="detail-label text-primary">Transfer Code</span>
                                <span class="detail-value h3 font-weight-bold mb-0">${t.transferCode}</span>
                            </div>
                            <div class="col-md-5 text-md-right border-left-md pl-md-5">
                                <span class="detail-label">Total Quantity</span>
                                <div class="d-flex align-items-baseline justify-content-md-end">
                                    <span class="text-dark font-weight-bold h2 mb-0">${totalQuantity}</span>
                                    <span class="text-muted ml-2" style="font-size: 1.2rem;">pcs</span>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-lg-6">
                                <div class="product-banner mb-4" style="background: none; border: 1px solid #e2e8f0; padding: 0; overflow: hidden;">
                                    <div class="bg-primary text-white px-3 py-2">
                                        <span class="detail-label text-white mb-0" style="font-size: 0.7rem;">Car / Product List</span>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0" style="font-size: 0.9rem;">
                                            <thead class="bg-light">
                                                <tr>
                                                    <th class="py-2">Item Detail</th>
                                                    <th class="py-2 text-center" style="width: 80px;">Qty</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${productList}">
                                                    <tr>
                                                        <td class="py-2 font-weight-bold">${item.name}</td>
                                                        <td class="py-2 text-center">${item.qty}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="info-section">
                                    <span class="detail-label">Reason / Note</span>
                                    <div class="mt-2 p-3 border rounded bg-white text-muted" style="min-height: 120px; line-height: 1.6;">
                                        ${empty t.note ? '<i>No note provided.</i>' : t.note}
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-6">
                                <div class="info-section h-100">
                                    <span class="detail-label mb-4">Transfer Route</span>
                                    <div class="d-flex flex-column gap-4">
                                        <div class="route-node">
                                            <div class="bg-light-danger rounded-circle p-3 mr-3">
                                                <i class="ri-map-pin-2-fill text-danger h4 mb-0"></i>
                                            </div>
                                            <div style="line-height: 1.4;">
                                                <small class="text-muted d-block text-uppercase font-weight-bold" style="font-size: 0.7rem;">Source Location</small>
                                                <span class="detail-value">${t.fromLocationName}</span>
                                                <small class="text-muted d-block">${t.fromWarehouseName}</small>
                                            </div>
                                        </div>
                                        
                                        <div class="text-center my-2">
                                            <i class="ri-arrow-down-line text-muted h2 mb-0"></i>
                                        </div>

                                        <div class="route-node">
                                            <div class="bg-light-success rounded-circle p-3 mr-3">
                                                <i class="ri-checkbox-circle-fill text-success h4 mb-0"></i>
                                            </div>
                                            <div style="line-height: 1.4;">
                                                <small class="text-muted d-block text-uppercase font-weight-bold" style="font-size: 0.7rem;">Destination Location</small>
                                                <span class="detail-value">${t.toLocationName}</span>
                                                <small class="text-muted d-block">${t.toWarehouseName}</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="action-footer d-flex justify-content-end mt-5 pt-4 border-top">
                            <c:choose>
                                <c:when test="${t.status == 0}">
                                    <!-- Pending -> Can Approve/Cancel (For Managers) -->
                                    <form action="internal-transfer" method="POST" class="mr-3">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="transferId" value="${t.id}">
                                        <button type="submit" class="btn btn-outline-danger px-4 font-weight-bold rounded-pill" onclick="return confirm('Cancel this request?')">Cancel Request</button>
                                    </form>
                                    <form action="internal-transfer" method="POST">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="transferId" value="${t.id}">
                                        <button type="submit" class="btn btn-primary px-5 font-weight-bold rounded-pill shadow-sm" onclick="return confirm('Approve this request?')">Approve Request</button>
                                    </form>
                                </c:when>
                                <c:when test="${t.status == 1}">
                                    <form action="warehouse-transfer" method="POST">
                                        <input type="hidden" name="action" value="transferOut">
                                        <input type="hidden" name="transferId" value="${t.id}">
                                        <button type="submit" class="btn btn-warning px-5 font-weight-bold rounded-pill shadow-sm" onclick="return confirm('Confirm Export?')">Confirm Export</button>
                                    </form>
                                </c:when>
                                <c:when test="${t.status == 2}">
                                    <form action="warehouse-transfer" method="POST">
                                        <input type="hidden" name="action" value="transferIn">
                                        <input type="hidden" name="transferId" value="${t.id}">
                                        <button type="submit" class="btn btn-success px-5 font-weight-bold rounded-pill shadow-sm" onclick="return confirm('Confirm Import?')">Confirm Import</button>
                                    </form>
                                </c:when>
                            </c:choose>
                            <button class="btn btn-secondary px-4 ml-3 rounded-pill" onclick="history.back()">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>
