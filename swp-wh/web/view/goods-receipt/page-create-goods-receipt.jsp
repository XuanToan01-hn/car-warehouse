<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Confirm Goods Receipt | InventoryPro</title>

                <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">

                <style>
                    .table-input {
                        width: 85px;
                        padding: 5px;
                        border: 1px solid #ced4da;
                        border-radius: 4px;
                        text-align: center;
                    }

                    .stock-badge {
                        font-weight: 600;
                        padding: 4px 10px;
                        border-radius: 4px;
                        font-size: 0.85rem;
                    }

                    .enough-space {
                        background-color: #e5f9f6;
                        color: #00b69b;
                        border: 1px solid #00b69b;
                    }

                    .pending-qty {
                        color: #f35a5a;
                        font-weight: bold;
                    }

                    .select-label {
                        font-weight: bold;
                        color: #555;
                    }

                    .capacity-label {
                        font-size: 0.8rem;
                        padding: 2px 8px;
                        border-radius: 20px;
                        margin-left: 10px;
                        font-weight: bold;
                    }

                    .capacity-ok {
                        background-color: #d1f7e8;
                        color: #117a55;
                    }

                    .capacity-warning {
                        background-color: #fff3cd;
                        color: #856404;
                    }

                    .capacity-danger {
                        background-color: #f8d7da;
                        color: #721c24;
                    }
                </style>
            </head>

            <body class="color-light">
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <jsp:include page="../header.jsp" />

                        <div class="content-page">
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-lg-12">
                                        <%-- Success/Error Messages --%>
                                            <c:if test="${not empty sessionScope.error}">
                                                <div class="alert alert-danger alert-dismissible fade show"
                                                    role="alert">
                                                    <div class="iq-alert-icon"><i class="ri-information-line"></i></div>
                                                    <div class="iq-alert-text">${sessionScope.error}</div>
                                                    <button type="button" class="close" data-dismiss="alert"
                                                        aria-label="Close">
                                                        <i class="ri-close-line"></i>
                                                    </button>
                                                    <c:remove var="error" scope="session" />
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty sessionScope.success}">
                                                <div class="alert alert-success alert-dismissible fade show"
                                                    role="alert">
                                                    <div class="iq-alert-icon"><i class="ri-check-line"></i></div>
                                                    <div class="iq-alert-text">${sessionScope.success}</div>
                                                    <button type="button" class="close" data-dismiss="alert"
                                                        aria-label="Close">
                                                        <i class="ri-close-line"></i>
                                                    </button>
                                                    <c:remove var="success" scope="session" />
                                                </div>
                                            </c:if>

                                            <div class="card card-block card-stretch card-height">
                                                <div class="card-header d-flex justify-content-between">
                                                    <div class="header-title">
                                                        <h4 class="card-title">Confirm Goods Receipt: <span
                                                                class="text-primary">${order.orderCode}</span></h4>
                                                        <p class="mb-0 small text-muted">Select warehouse, location, and
                                                            input actual received quantity for each product.</p>
                                                    </div>
                                                    <div class="card-header-toolbar d-flex align-items-center">
                                                        <a href="goods-receipt" class="btn btn-light">
                                                            <i class="fas fa-arrow-left mr-1"></i>Back
                                                        </a>
                                                    </div>
                                                </div>

                                                <div class="card-body">
                                                    <c:choose>
                                                        <c:when test="${not empty order}">
                                                            <%-- EXISTING FORM --%>
                                                                <form action="create-goods-receipt" method="post"
                                                                    id="groForm">
                                                                    <input type="hidden" name="poId"
                                                                        value="${order.id}">

                                                                    <%-- TWO-TIER SELECTION: WAREHOUSE & LOCATION --%>
                                                                        <div
                                                                            class="row mb-4 p-3 bg-light rounded align-items-end">
                                                                            <div class="col-md-5">
                                                                                <div class="form-group mb-0">
                                                                                    <label class="select-label">
                                                                                        <i
                                                                                            class="fas fa-warehouse mr-1"></i>
                                                                                        Select Warehouse:
                                                                                    </label>
                                                                                    <select name="warehouseId"
                                                                                        id="warehouseSelect"
                                                                                        class="form-control mt-1"
                                                                                        ${isWhLocked ? 'disabled' : '' }
                                                                                        style="${isWhLocked ? 'background-color: #f8fafc; cursor: not-allowed; border-color: #e2e8f0;' : ''}">
                                                                                        <c:forEach items="${warehouses}"
                                                                                            var="w">
                                                                                            <option value="${w.id}"
                                                                                                ${selectedWhId==w.id
                                                                                                ? 'selected' : '' }>
                                                                                                ${w.warehouseName}
                                                                                                (${w.warehouseCode})
                                                                                            </option>
                                                                                        </c:forEach>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                            <div class="col-md-5">
                                                                                <div class="form-group mb-0">
                                                                                    <label class="select-label">
                                                                                        <i
                                                                                            class="fas fa-map-marker-alt mr-1"></i>
                                                                                        Receiving Location (Bin):
                                                                                        <c:forEach items="${locations}"
                                                                                            var="l">
                                                                                            <c:if
                                                                                                test="${l.id == selectedLocId}">
                                                                                                <c:set var="selLoc"
                                                                                                    value="${l}" />
                                                                                            </c:if>
                                                                                        </c:forEach>
                                                                                        <c:if
                                                                                            test="${not empty selLoc}">
                                                                                            <span
                                                                                                class="capacity-label ${selLoc.currentStock >= selLoc.maxCapacity ? 'capacity-danger' : (selLoc.currentStock > selLoc.maxCapacity * 0.8 ? 'capacity-warning' : 'capacity-ok')}">
                                                                                                Space:
                                                                                                ${selLoc.currentStock} /
                                                                                                ${selLoc.maxCapacity > 0
                                                                                                ? selLoc.maxCapacity :
                                                                                                '∞'}
                                                                                            </span>
                                                                                        </c:if>
                                                                                    </label>
                                                                                    <select name="locationId"
                                                                                        id="locationSelect"
                                                                                        class="form-control mt-1">
                                                                                        <c:if test="${empty locations}">
                                                                                            <option value="">-- No
                                                                                                locations available in
                                                                                                this warehouse --
                                                                                            </option>
                                                                                        </c:if>
                                                                                        <c:forEach items="${locations}"
                                                                                            var="l">
                                                                                            <option value="${l.id}"
                                                                                                ${selectedLocId==l.id
                                                                                                ? 'selected' : '' }>
                                                                                                ${l.locationName}
                                                                                                (${l.locationCode})
                                                                                            </option>
                                                                                        </c:forEach>
                                                                                    </select>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <%-- PRODUCT LIST --%>
                                                                            <div class="table-responsive">
                                                                                <table
                                                                                    class="table table-hover table-bordered mb-0">
                                                                                    <thead
                                                                                        class="bg-primary text-white">
                                                                                        <tr>
                                                                                            <th>Product & Variant</th>
                                                                                            <th class="text-center">
                                                                                                Ordered</th>
                                                                                            <th class="text-center">
                                                                                                Delivered</th>
                                                                                            <th class="text-center">
                                                                                                Pending</th>
                                                                                            <th class="text-center">
                                                                                                Stock at Loc</th>
                                                                                            <th class="text-center"
                                                                                                style="width: 160px;">
                                                                                                Actual Received</th>
                                                                                        </tr>
                                                                                    </thead>
                                                                                    <tbody>
                                                                                        <c:set var="hasItems"
                                                                                            value="false" />
                                                                                        <c:forEach items="${uiDetails}"
                                                                                            var="row">
                                                                                            <c:if
                                                                                                test="${row[4] > 0 or true}">
                                                                                                <c:set var="hasItems"
                                                                                                    value="${hasItems or (row[4] > 0)}" />
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <div
                                                                                                            class="font-weight-bold">
                                                                                                            ${row[0]}
                                                                                                        </div>
                                                                                                        <div
                                                                                                            class="small text-muted">
                                                                                                            Color:
                                                                                                            ${row[7]} |
                                                                                                            ${row[1]}
                                                                                                        </div>
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="productDetailId[]"
                                                                                                            value="${row[6]}">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="productId[]"
                                                                                                            value="${row[8]}">
                                                                                                    </td>
                                                                                                    <td
                                                                                                        class="text-center font-weight-bold">
                                                                                                        ${row[2]}</td>
                                                                                                    <td
                                                                                                        class="text-center text-primary">
                                                                                                        ${row[3]}</td>
                                                                                                    <td
                                                                                                        class="text-center">
                                                                                                        <span
                                                                                                            class="pending-qty">${row[4]}</span>
                                                                                                    </td>
                                                                                                    <td
                                                                                                        class="text-center">
                                                                                                        <span
                                                                                                            class="stock-badge enough-space">${row[5]}</span>
                                                                                                    </td>
                                                                                                    <td
                                                                                                        class="text-center">
                                                                                                        <input
                                                                                                            type="number"
                                                                                                            name="qtyActual[]"
                                                                                                            class="table-input"
                                                                                                            min="0"
                                                                                                            max="${row[4]}"
                                                                                                            value="${row[4]}"
                                                                                                            onfocus="if(this.value=='0') this.value='';"
                                                                                                            onblur="if(this.value=='') this.value='0';">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="qtyExpected[]"
                                                                                                            value="${row[2]}">
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </c:if>
                                                                                        </c:forEach>
                                                                                        <c:if test="${!hasItems}">
                                                                                            <tr>
                                                                                                <td colspan="6"
                                                                                                    class="text-center p-4">
                                                                                                    <i
                                                                                                        class="fas fa-check-double text-success fa-2x mb-2"></i>
                                                                                                    <p class="mb-0">All
                                                                                                        items in this PO
                                                                                                        have been fully
                                                                                                        received.</p>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </c:if>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>

                                                                            <div class="form-group mt-3">
                                                                                <label
                                                                                    class="font-weight-bold">Note:</label>
                                                                                <textarea name="note"
                                                                                    class="form-control" rows="2"
                                                                                    placeholder="Receive note..."></textarea>
                                                                            </div>

                                                                            <div
                                                                                class="mt-4 border-top pt-3 text-right">
                                                                                <button type="submit"
                                                                                    class="btn btn-primary btn-lg ${!hasItems ? 'disabled' : ''}"
                                                                                    ${!hasItems ? 'disabled' : '' }>
                                                                                    <i class="fas fa-save mr-1"></i>
                                                                                    Complete Receipt
                                                                                </button>
                                                                            </div>
                                                                </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <%-- SELECTION LIST --%>
                                                                <div class="text-center py-5">
                                                                    <i class="ri-truck-line text-primary"
                                                                        style="font-size: 4rem;"></i>
                                                                    <h3 class="mt-3">Start New Receipt</h3>
                                                                    <p class="text-muted">Select a confirmed Purchase
                                                                        Order to proceed with receiving.</p>

                                                                    <div class="mx-auto mt-4" style="max-width: 500px;">
                                                                        <div class="form-group">
                                                                            <label class="font-weight-bold">Select
                                                                                PO:</label>
                                                                            <select id="poSelect"
                                                                                class="form-control form-control-lg">
                                                                                <option value="">-- Choose Purchase
                                                                                    Order --</option>
                                                                                <c:forEach items="${pendingPOs}"
                                                                                    var="p">
                                                                                    <option value="${p.id}">
                                                                                        ${p.orderCode} -
                                                                                        ${p.supplier.name}
                                                                                        (${p.createdDate})</option>
                                                                                </c:forEach>
                                                                            </select>
                                                                        </div>
                                                                        <c:if test="${empty pendingPOs}">
                                                                            <div class="alert alert-warning">
                                                                                <i
                                                                                    class="ri-error-warning-line mr-1"></i>
                                                                                No confirmed or pending purchase orders
                                                                                found.
                                                                            </div>
                                                                        </c:if>
                                                                        <button onclick="proceedWithPO()"
                                                                            class="btn btn-primary btn-lg btn-block mt-3"
                                                                            ${empty pendingPOs ? 'disabled' : '' }>
                                                                            Proceed to Receive <i
                                                                                class="ri-arrow-right-line ml-1"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                                <script>
                                                                    function proceedWithPO() {
                                                                        const poId = document.getElementById('poSelect').value;
                                                                        if (poId) {
                                                                            window.location.href = 'create-goods-receipt?poId=' + poId;
                                                                        } else {
                                                                            alert('Please select a Purchase Order first.');
                                                                        }
                                                                    }
                                                                </script>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

                <script>
                    <c:if test="${not isWhLocked}">
                        document.getElementById('warehouseSelect').addEventListener('change', function () {
                            window.location.href = "create-goods-receipt?poId=${order.id}&warehouseId=" + this.value;
        });
                    </c:if>

                    document.getElementById('locationSelect').addEventListener('change', function () {
                        const whSelect = document.getElementById('warehouseSelect');
                        const whId = whSelect.value || '${selectedWhId}';
                        window.location.href = "create-goods-receipt?poId=${order.id}&warehouseId=" + whId + "&locationId=" + this.value;
                    });
                </script>
            </body>

            </html>