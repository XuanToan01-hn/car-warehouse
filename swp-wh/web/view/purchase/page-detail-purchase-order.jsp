<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Purchase Order Details | InventoryPro</title>

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

                    .card-main {
                        border-radius: 16px;
                        border: none;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                        background: white;
                        margin-bottom: 1.5rem;
                        overflow: hidden;
                    }

                    .card-title-premium {
                        font-weight: 800;
                        color: #1e293b;
                        font-size: 1.1rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .info-label {
                        font-weight: 700;
                        color: #64748b;
                        text-transform: uppercase;
                        font-size: 0.7rem;
                        letter-spacing: 0.05em;
                        margin-bottom: 0.25rem;
                    }

                    .info-value {
                        font-weight: 600;
                        color: #1e293b;
                        font-size: 0.95rem;
                    }

                    .badge-status {
                        padding: 0.5rem 1rem;
                        border-radius: 10px;
                        font-weight: 800;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                        letter-spacing: 0.025em;
                    }

                    .badge-draft {
                        background: #fef3c7;
                        color: #92400e;
                    }

                    .badge-confirmed {
                        background: #e0f2fe;
                        color: #0369a1;
                    }

                    .badge-received {
                        background: #dcfce7;
                        color: #166534;
                    }

                    .badge-cancelled {
                        background: #fee2e2;
                        color: #991b1b;
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

                    .total-highlight {
                        font-size: 1.5rem;
                        font-weight: 800;
                        color: var(--primary);
                    }

                    .btn-action {
                        border-radius: 12px;
                        padding: 0.75rem 1.5rem;
                        font-weight: 700;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        transition: all 0.2s;
                    }

                    .btn-action:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <jsp:include page="../sidebar.jsp" />
                    <jsp:include page="../header.jsp" />
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header">
                                <div>
                                    <h1 class="font-weight-bold mb-1">Order Details: ${po.orderCode}</h1>
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb bg-transparent p-0 mb-0">
                                            <li class="breadcrumb-item"><a
                                                    href="${pageContext.request.contextPath}/purchase-orders">Purchase
                                                    Orders</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">${po.orderCode}</li>
                                        </ol>
                                    </nav>
                                </div>
                                <a href="${pageContext.request.contextPath}/purchase-orders" class="btn btn-light"
                                    style="border-radius: 12px; font-weight: 700;">
                                    <i class="ri-arrow-left-line mr-1"></i> Back to List
                                </a>
                            </div>

                            <div class="row">
                                <!-- Left: Order Summary -->
                                <div class="col-lg-8">
                                    <div class="card card-main">
                                        <div class="card-header bg-white border-0 pt-4 px-4 pb-0">
                                            <h5 class="card-title-premium"><i
                                                    class="ri-information-line text-primary"></i> Order Information</h5>
                                        </div>
                                        <div class="card-body p-4">
                                            <div class="row">
                                                <div class="col-md-4 mb-4">
                                                    <div class="info-label">Order Code</div>
                                                    <div class="info-value text-primary font-weight-bold"
                                                        style="font-size: 1.1rem;">${po.orderCode}</div>
                                                </div>
                                                <div class="col-md-4 mb-4">
                                                    <div class="info-label">Created Date</div>
                                                    <div class="info-value">
                                                        <fmt:formatDate value="${po.createdDate}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                    </div>
                                                </div>
                                                <div class="col-md-4 mb-4">
                                                    <div class="info-label">Status</div>
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${po.status == 1}"><span
                                                                    class="badge-status badge-draft">Draft</span>
                                                            </c:when>
                                                            <c:when test="${po.status == 2}"><span
                                                                    class="badge-status badge-confirmed">Confirmed</span>
                                                            </c:when>
                                                            <c:when test="${po.status == 3}"><span
                                                                    class="badge-status badge-received">Received</span>
                                                            </c:when>
                                                            <c:when test="${po.status == 4}"><span
                                                                    class="badge-status badge-cancelled">Cancelled</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="info-label">Total Order Value</div>
                                                    <div class="total-highlight">
                                                        <fmt:formatNumber value="${po.totalAmount}" type="number"
                                                            groupingUsed="true" /> đ
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Status Actions -->
                                            <c:if test="${po.status != 4}">
                                                <div class="mt-4 pt-4 border-top">
                                                    <div class="row align-items-center">
                                                        <div class="col-md-12">
                                                            <h6 class="font-weight-bold mb-3 text-secondary text-uppercase small"
                                                                style="letter-spacing: 0.1em;">Available Actions</h6>

                                                            <!-- DRAFT (1) -> MANAGER (2) CAN CONFIRM -->
                                                            <c:if
                                                                test="${po.status == 1 && sessionScope.user.role.id == 3}">
                                                                <div class="d-flex gap-2">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/detail-purchase-order"
                                                                        method="post">
                                                                        <input type="hidden" name="id" value="${po.id}">
                                                                        <input type="hidden" name="status" value="2">
                                                                        <button type="submit"
                                                                            class="btn btn-primary btn-action">
                                                                            <i class="ri-checkbox-circle-line"></i>
                                                                            Confirm Order
                                                                        </button>
                                                                    </form>
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/detail-purchase-order"
                                                                        method="post">
                                                                        <input type="hidden" name="id" value="${po.id}">
                                                                        <input type="hidden" name="status" value="4">
                                                                        <button type="submit"
                                                                            class="btn btn-outline-danger btn-action">
                                                                            <i class="ri-close-circle-line"></i> Cancel
                                                                            Order
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </c:if>

                                                            <!-- CONFIRMED (2) -> STAFF (3) CAN MARK RECEIVED -->
                                                            <c:if
                                                                test="${po.status == 2 && sessionScope.user.role.id == 4}">
                                                                <div class="d-flex gap-2">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/detail-purchase-order"
                                                                        method="post">
                                                                        <input type="hidden" name="id" value="${po.id}">
                                                                        <input type="hidden" name="status" value="3">
                                                                        <button type="submit"
                                                                            class="btn btn-success btn-action">
                                                                            <i class="ri-truck-line"></i> Mark as
                                                                            Received
                                                                        </button>
                                                                    </form>
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/detail-purchase-order"
                                                                        method="post">
                                                                        <input type="hidden" name="id" value="${po.id}">
                                                                        <input type="hidden" name="status" value="4">
                                                                        <button type="submit"
                                                                            class="btn btn-outline-danger btn-action">
                                                                            <i class="ri-close-circle-line"></i> Cancel
                                                                            Order
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </c:if>

                                                            <!-- RECEIVED (3) -> WH STAFF (4) CAN CREATE GRO -->
                                                            <c:if
                                                                test="${po.status == 3 && sessionScope.user.role.id == 4}">
                                                                <a href="${pageContext.request.contextPath}/create-goods-receipt?poId=${po.id}"
                                                                    class="btn btn-success btn-action">
                                                                    <i class="ri-add-box-line"></i> Create Goods Receipt
                                                                    (GRO)
                                                                </a>
                                                            </c:if>

                                                            <c:if
                                                                test="${(po.status == 1 && sessionScope.user.role.id != 2) || (po.status == 2 && sessionScope.user.role.id != 3)}">
                                                                <div class="alert alert-light border-0 small m-0 p-3"
                                                                    style="background: #f8fafc; border-radius: 12px; color: #64748b;">
                                                                    <i class="ri-lock-line mr-1"></i> You do not have
                                                                    permission to change the status of this order in its
                                                                    current state.
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right: Supplier Details -->
                                <div class="col-lg-4">
                                    <div class="card card-main">
                                        <div class="card-header bg-white border-0 pt-4 px-4 pb-0">
                                            <h5 class="card-title-premium"><i class="ri-truck-line text-primary"></i>
                                                Supplier Details</h5>
                                        </div>
                                        <div class="card-body p-4">
                                            <div class="mb-4">
                                                <div class="info-label">Supplier Name</div>
                                                <div class="info-value font-weight-bold" style="font-size: 1.1rem;">
                                                    ${po.supplier.name}</div>
                                            </div>
                                            <div class="mb-4">
                                                <div class="info-label">Contact Phone</div>
                                                <div class="info-value">${not empty po.supplier.phone ?
                                                    po.supplier.phone : '—'}</div>
                                            </div>
                                            <div class="mb-4">
                                                <div class="info-label">Email Address</div>
                                                <div class="info-value text-primary">${not empty po.supplier.email ?
                                                    po.supplier.email : '—'}</div>
                                            </div>
                                            <div class="mb-0">
                                                <div class="info-label">Physical Address</div>
                                                <div class="info-value small">${not empty po.supplier.address ?
                                                    po.supplier.address : '—'}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Full Width: Product Table -->
                                <div class="col-12 mt-2">
                                    <div class="card card-main">
                                        <div class="card-header bg-white border-0 pt-4 px-4 pb-0">
                                            <h5 class="card-title-premium"><i class="ri-list-check text-primary"></i>
                                                Multi-Item Breakdown</h5>
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table mb-0">
                                                    <thead>
                                                        <tr>
                                                            <th width="5%">#</th>
                                                            <th>Product</th>
                                                            <th class="text-center">Quantity</th>
                                                            <th class="text-right">Unit Price</th>
                                                            <th class="text-center">Tax Info</th>
                                                            <th class="text-right">Subtotal</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="d" items="${po.details}" varStatus="st">
                                                            <tr>
                                                                <td>${st.index + 1}</td>
                                                                <td>
                                                                    <div class="font-weight-bold color-dark">
                                                                        ${d.product.name}</div>
                                                                    <code
                                                                        class="small text-primary">${d.product.code}</code>
                                                                </td>
                                                                <td class="text-center font-weight-bold text-dark">
                                                                    ${d.quantity}</td>
                                                                <td class="text-right">
                                                                    <fmt:formatNumber value="${d.price}" type="number"
                                                                        groupingUsed="true" /> đ
                                                                </td>
                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${d.tax != null}">
                                                                            <span class="badge badge-light px-2 py-1"
                                                                                style="border-radius: 6px; font-weight: 700;">
                                                                                ${d.tax.taxName} (${d.tax.taxRate}%)
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise><span class="text-muted">—</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-right font-weight-bold text-dark">
                                                                    <fmt:formatNumber value="${d.subTotal}"
                                                                        type="number" groupingUsed="true" /> đ
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                    <tfoot class="bg-light">
                                                        <tr>
                                                            <td colspan="5"
                                                                class="text-right font-weight-bold py-4 text-secondary text-uppercase small">
                                                                Grand Total Amount</td>
                                                            <td class="text-right py-4">
                                                                <span class="total-highlight">
                                                                    <fmt:formatNumber value="${po.totalAmount}"
                                                                        type="number" groupingUsed="true" /> đ
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </tfoot>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.0.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
            </body>

            </html>