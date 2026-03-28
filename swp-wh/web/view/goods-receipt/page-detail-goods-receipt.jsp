<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Goods Receipt Details | InventoryPro</title>

                <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">

                <style>
                    .info-card {
                        background: #fff;
                        border-radius: 12px;
                        border: 1px solid #e2e8f0;
                        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                    }

                    .info-label {
                        font-weight: 700;
                        color: #64748b;
                        font-size: 0.85rem;
                        text-transform: uppercase;
                        width: 140px;
                        display: inline-block;
                    }

                    .info-value {
                        font-weight: 500;
                        font-size: 1rem;
                        color: #1e293b;
                    }

                    .badge-status {
                        padding: 4px 12px;
                        border-radius: 4px;
                        font-weight: 700;
                        font-size: 0.8rem;
                    }

                    .status-completed {
                        background-color: #d1fae5;
                        color: #065f46;
                    }

                    .status-partial {
                        background-color: #fef9c3;
                        color: #854d0e;
                        border: 1px solid #fde047;
                    }

                    .status-draft {
                        background-color: #fef3c7;
                        color: #92400e;
                    }

                    .product-table thead th {
                        background-color: #f8fafc;
                        font-weight: 700;
                        color: #64748b;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                    }

                    .mono {
                        font-family: ui-monospace, monospace;
                        color: #0EA5E9;
                        font-weight: bold;
                    }

                    .header-section {
                        border-bottom: 2px solid #f1f5f9;
                        margin-bottom: 1.5rem;
                        padding-bottom: 1rem;
                    }
                </style>
            </head>

            <body class="color-light">
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <jsp:include page="../header.jsp" />

                        <div class="content-page">
                            <div class="container-fluid">
                                <%-- Success/Error Alerts --%>
                                    <c:if test="${not empty sessionScope.success}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <i class="fas fa-check-circle mr-2"></i> ${sessionScope.success}
                                            <button type="button" class="close" data-dismiss="alert">&times;</button>
                                            <c:remove var="success" scope="session" />
                                        </div>
                                    </c:if>

                                    <div class="card info-card">
                                        <div class="card-body">
                                            <div
                                                class="header-section d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h4 class="mb-1">Receipt: <span
                                                            class="text-primary">${gr.receiptCode}</span></h4>
                                                    <p class="text-muted small mb-0">View-only record of a goods receipt
                                                        transaction.</p>
                                                </div>
                                                <a href="goods-receipt" class="btn btn-light"><i
                                                        class="fas fa-arrow-left mr-1"></i> Back</a>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6 border-right">
                                                    <div class="mb-3">
                                                        <span class="info-label">Receipt Code:</span>
                                                        <span class="info-value mono">${gr.receiptCode}</span>
                                                    </div>
                                                    <div class="mb-3">
                                                        <span class="info-label">Created At:</span>
                                                        <span class="info-value">
                                                            <fmt:formatDate value="${gr.receiptDate}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </span>
                                                    </div>
                                                    <div class="mb-3">
                                                        <span class="info-label">Stock Location:</span>
                                                        <span class="info-value">${gr.location.locationName}
                                                            (${gr.location.locationCode})</span>
                                                    </div>
                                                </div>
                                                <div class="col-md-6 pl-md-4">
                                                    <div class="mb-3">
                                                        <span class="info-label">Status:</span>
                                                        <c:choose>
                                                            <c:when test="${gr.status == 2}">
                                                                <span
                                                                    class="badge-status status-completed">COMPLETED</span>
                                                            </c:when>
                                                            <c:when test="${gr.status == 4}">
                                                                <span class="badge-status status-partial">PARTIALLY
                                                                    RECEIVED</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-status status-draft">DRAFT</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="mb-3">
                                                        <span class="info-label">Purchase Order:</span>
                                                        <span class="info-value mono"
                                                            style="color:#f59e0b">${gr.purchaseOrder.orderCode}</span>
                                                    </div>
                                                    <div class="mb-3">
                                                        <span class="info-label">Created By:</span>
                                                        <span class="info-value">${gr.createBy.fullName}</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <c:if test="${not empty gr.note}">
                                                <div class="mt-2 p-3 bg-light rounded">
                                                    <span
                                                        class="small font-weight-bold text-secondary text-uppercase d-block mb-1">Receipt
                                                        Note:</span>
                                                    <span class="text-dark">${gr.note}</span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="card mt-4 info-card">
                                        <div class="card-header bg-white border-bottom-0 pt-4 px-4">
                                            <h5 class="card-title font-weight-bold"><i
                                                    class="fas fa-box-open mr-2 text-primary"></i> Received Product List
                                            </h5>
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table table-hover product-table mb-0">
                                                    <thead>
                                                        <tr>
                                                            <th style="padding-left: 2rem;">#</th>
                                                            <th>Product Code</th>
                                                            <th>Product Name / Variant</th>
                                                            <th class="text-center">Expected Qty</th>
                                                            <th class="text-center">Actual Received</th>
                                                            <th class="text-center">Remaining in PO</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="item" items="${gr.details}" varStatus="st">
                                                            <tr>
                                                                <td style="padding-left: 2rem;">${st.index + 1}</td>
                                                                <td><span class="mono">${item.product.code}</span></td>
                                                                <td>
                                                                    <div class="font-weight-bold text-dark">
                                                                        ${item.product.name}</div>
                                                                    <div class="small text-muted">
                                                                        Color: ${item.productDetail.color} | Ser:
                                                                        ${item.productDetail.serialNumber}
                                                                    </div>
                                                                </td>
                                                                <td class="text-center font-weight-bold">
                                                                    ${item.quantityExpected}</td>
                                                                <td class="text-center">
                                                                    <span class="badge badge-success px-3 py-2"
                                                                        style="font-size: 0.9rem;">
                                                                        ${item.quantityActual}
                                                                    </span>
                                                                </td>
                                                                <td class="text-center">
                                                                    <span class="font-weight-bold"
                                                                        style="color: ${item.remainingQty <= 0 ? '#10b981' : '#ef4444'}">
                                                                        ${item.remainingQty}
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
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