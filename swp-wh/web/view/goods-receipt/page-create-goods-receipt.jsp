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

                    /* Pagination Styles */
                    .pagination {
                        margin-top: 1rem;
                    }

                    .page-item .page-link {
                        border-radius: 8px;
                        margin: 0 2px;
                        font-weight: 600;
                        color: #0ea5e9;
                        border-color: #dee2e6;
                        cursor: pointer;
                    }

                    .page-item.active .page-link {
                        background: #0ea5e9;
                        border-color: #0ea5e9;
                        color: white;
                    }

                    .page-item.disabled .page-link {
                        opacity: 0.5;
                        cursor: not-allowed;
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
                                                </div>
                                                <% session.removeAttribute("error"); %>
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
                                                </div>
                                                <% session.removeAttribute("success"); %>
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
                                                        <a href="${pageContext.request.contextPath}/create-goods-receipt?act=unlock&poId=${order.id}"
                                                            class="btn btn-secondary">
                                                            <i class="ri-arrow-go-back-line mr-1"></i> Back
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
                                                                                        Warehouse:
                                                                                    </label>
                                                                                    <input type="hidden"
                                                                                        name="warehouseId"
                                                                                        value="${selectedWhId}">
                                                                                    <div class="form-control mt-1"
                                                                                        style="background-color: #f8fafc; border-color: #e2e8f0; cursor: default;">
                                                                                        <c:forEach items="${warehouses}"
                                                                                            var="w">
                                                                                            <c:if
                                                                                                test="${w.id == selectedWhId}">
                                                                                                ${w.warehouseName}
                                                                                                (${w.warehouseCode})
                                                                                            </c:if>
                                                                                        </c:forEach>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="col-md-5">
                                                                                <div class="form-group mb-0">
                                                                                    <label class="select-label">

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
                                                                                    class="table table-hover table-bordered mb-0"
                                                                                    id="productTable">
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
                                                                                        <%-- Pagination setup --%>
                                                                                            <c:set var="pgSize"
                                                                                                value="3" />
                                                                                            <c:set var="hasItems"
                                                                                                value="false" />
                                                                                            <c:set var="itemCount"
                                                                                                value="0" />
                                                                                            <c:forEach
                                                                                                items="${uiDetails}"
                                                                                                var="r">
                                                                                                <c:set var="itemCount"
                                                                                                    value="${itemCount + 1}" />
                                                                                            </c:forEach>
                                                                                            <c:set var="pgTotal"
                                                                                                value="${(itemCount + pgSize - 1) / pgSize}" />
                                                                                            <%-- Fix pgTotal to integer
                                                                                                --%>
                                                                                                <fmt:formatNumber
                                                                                                    var="pgTotal"
                                                                                                    value="${pgTotal - (pgTotal % 1)}"
                                                                                                    pattern="#" />
                                                                                                <c:if
                                                                                                    test="${pgTotal < 1}">
                                                                                                    <c:set var="pgTotal"
                                                                                                        value="1" />
                                                                                                </c:if>

                                                                                                <c:forEach
                                                                                                    items="${uiDetails}"
                                                                                                    var="row"
                                                                                                    varStatus="st">
                                                                                                    <c:if
                                                                                                        test="${row[4] > 0 or true}">
                                                                                                        <c:set
                                                                                                            var="hasItems"
                                                                                                            value="${hasItems or (row[4] > 0)}" />
                                                                                                        <%-- Calculate
                                                                                                            which page
                                                                                                            this row
                                                                                                            belongs to
                                                                                                            --%>
                                                                                                            <fmt:formatNumber
                                                                                                                var="rowPage"
                                                                                                                value="${((st.index) / pgSize) + 1 - (((st.index) / pgSize) % 1)}"
                                                                                                                pattern="#" />
                                                                                                            <tr data-page="${rowPage}"
                                                                                                                style="${rowPage != 1 ? 'display:none' : ''}">
                                                                                                                <td>
                                                                                                                    <div
                                                                                                                        class="font-weight-bold">
                                                                                                                        ${row[0]}
                                                                                                                    </div>
                                                                                                                    <div
                                                                                                                        class="small text-muted">
                                                                                                                        Color:
                                                                                                                        ${row[7]}
                                                                                                                        |
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
                                                                                                                    ${row[2]}
                                                                                                                </td>
                                                                                                                <td
                                                                                                                    class="text-center text-primary">
                                                                                                                    ${row[3]}
                                                                                                                </td>
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
                                                                                                <c:if
                                                                                                    test="${!hasItems}">
                                                                                                    <tr>
                                                                                                        <td colspan="6"
                                                                                                            class="text-center p-4">
                                                                                                            <i
                                                                                                                class="fas fa-check-double text-success fa-2x mb-2"></i>
                                                                                                            <p
                                                                                                                class="mb-0">
                                                                                                                All
                                                                                                                items in
                                                                                                                this PO
                                                                                                                have
                                                                                                                been
                                                                                                                fully
                                                                                                                received.
                                                                                                            </p>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </c:if>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>

                                                                            <%-- Block Pagination Controls (JSTL -
                                                                                identical to list-goods-receipt) --%>
                                                                                <c:if test="${pgTotal > 1}">
                                                                                    <nav class="mt-3">
                                                                                        <ul class="pagination justify-content-center"
                                                                                            id="paginationNav">
                                                                                            <c:set var="startPage"
                                                                                                value="${1 - ((1 - 1) % 3)}" />
                                                                                            <c:set var="endPage"
                                                                                                value="${startPage + 2}" />
                                                                                            <c:if
                                                                                                test="${endPage > pgTotal}">
                                                                                                <c:set var="endPage"
                                                                                                    value="${pgTotal}" />
                                                                                            </c:if>

                                                                                            <%-- Previous --%>
                                                                                                <li class="page-item disabled"
                                                                                                    id="pgPrev">
                                                                                                    <a class="page-link"
                                                                                                        href="#"
                                                                                                        onclick="goPage(currentPg-1);return false;">
                                                                                                        <i
                                                                                                            class="ri-arrow-left-s-line"></i>
                                                                                                        Previous
                                                                                                    </a>
                                                                                                </li>

                                                                                                <%-- Page numbers --%>
                                                                                                    <c:forEach
                                                                                                        begin="${startPage}"
                                                                                                        end="${endPage}"
                                                                                                        var="p">
                                                                                                        <li class="page-item ${p == 1 ? 'active' : ''}"
                                                                                                            data-pnum="${p}">
                                                                                                            <a class="page-link"
                                                                                                                href="#"
                                                                                                                onclick="goPage(${p});return false;">${p}</a>
                                                                                                        </li>
                                                                                                    </c:forEach>

                                                                                                    <%-- Next --%>
                                                                                                        <li class="page-item ${pgTotal <= 1 ? 'disabled' : ''}"
                                                                                                            id="pgNext">
                                                                                                            <a class="page-link"
                                                                                                                href="#"
                                                                                                                onclick="goPage(currentPg+1);return false;">
                                                                                                                Next <i
                                                                                                                    class="ri-arrow-right-s-line"></i>
                                                                                                            </a>
                                                                                                        </li>
                                                                                        </ul>
                                                                                    </nav>
                                                                                </c:if>

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
                                                                                    <c:set var="isLocked"
                                                                                        value="${not empty p.lockedBy && p.lockedBy.id != sessionScope.user.id}" />
                                                                                    <option value="${p.id}" ${isLocked
                                                                                        ? 'data-locked="true" style="color:#856404;"'
                                                                                        : '' }>
                                                                                        ${p.orderCode} -
                                                                                        ${p.supplier.name}
                                                                                        (${p.createdDate})${isLocked ? '
                                                                                        🔒 Đang xử lý bởi
                                                                                        '.concat(p.lockedBy.fullName) :
                                                                                        ''}
                                                                                    </option>
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
                                                                        if (!poId) {
                                                                            alert('Please select a Purchase Order first.');
                                                                            return;
                                                                        }
                                                                        // Check xem PO có bị khóa không (từ data attribute)
                                                                        const opt = document.getElementById('poSelect').selectedOptions[0];
                                                                        if (opt && opt.dataset.locked === 'true') {
                                                                            alert('⚠ This purchase order is being processed by another staff member. Please select a different purchase order.');
                                                                            return;
                                                                        }
                                                                        window.location.href = 'create-goods-receipt?poId=' + poId;
                                                                    }
                                                                </script>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                    </div>
                                </div>
                            </div>
                            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

                            <script>

                                document.getElementById('locationSelect').addEventListener('change', function () {
                                    const whId = '${selectedWhId}';
                                    window.location.href = "create-goods-receipt?poId=${order.id}&warehouseId=" + whId + "&locationId=" + this.value;
                                });

                                // Minimal pagination: show/hide rows by data-page, update JSTL-rendered nav
                                var currentPg = 1;
                                var totalPg = parseInt('${pgTotal}') || 1;

                                function goPage(p) {
                                    if (p < 1 || p > totalPg) return;
                                    currentPg = p;

                                    // Show/hide rows (no reload, preserves timer + inputs)
                                    var rows = document.querySelectorAll('#productTable tbody tr[data-page]');
                                    for (var i = 0; i < rows.length; i++) {
                                        rows[i].style.display = (rows[i].getAttribute('data-page') == p) ? '' : 'none';
                                    }

                                    // Update Previous/Next buttons
                                    var prev = document.getElementById('pgPrev');
                                    var next = document.getElementById('pgNext');
                                    if (prev) prev.className = 'page-item' + (p <= 1 ? ' disabled' : '');
                                    if (next) next.className = 'page-item' + (p >= totalPg ? ' disabled' : '');

                                    // Rebuild page number buttons (Block of 3)
                                    var startPg = p - ((p - 1) % 3);
                                    var endPg = Math.min(startPg + 2, totalPg);
                                    var nav = document.getElementById('paginationNav');
                                    if (!nav) return;

                                    // Remove old page-number items
                                    var old = nav.querySelectorAll('li[data-pnum]');
                                    for (var j = 0; j < old.length; j++) old[j].remove();

                                    // Insert new page-number items before Next button
                                    var nextLi = document.getElementById('pgNext');
                                    for (var k = startPg; k <= endPg; k++) {
                                        var li = document.createElement('li');
                                        li.className = 'page-item' + (k === p ? ' active' : '');
                                        li.setAttribute('data-pnum', k);
                                        var a = document.createElement('a');
                                        a.className = 'page-link';
                                        a.href = '#';
                                        a.innerText = k;
                                        a.setAttribute('data-pg', k);
                                        a.onclick = function (e) { e.preventDefault(); goPage(parseInt(this.getAttribute('data-pg'))); };
                                        li.appendChild(a);
                                        nav.insertBefore(li, nextLi);
                                    }
                                }

                                // [TIMER-KICKOUT] Tự động đếm ngược 60 giây
                                let timeLeft = 60;
                                const timerDisplay = document.createElement('span');
                                timerDisplay.className = 'badge badge-danger ml-2';
                                document.querySelector('h4') ? document.querySelector('h4').appendChild(timerDisplay) : null;

                                const timerId = setInterval(() => {
                                    timeLeft--;
                                    if (timerDisplay) timerDisplay.innerText = timeLeft + 's';
                                    if (timeLeft <= 0) {
                                        clearInterval(timerId);
                                        alert("Your session has expired. The system will return to the list page.");
                                        window.location.href = "${pageContext.request.contextPath}/purchase-orders";
                                    }
                                }, 1000);
                            </script>
            </body>

            </html>