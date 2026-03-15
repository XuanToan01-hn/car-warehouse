<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!doctype html>
            <html lang="vi">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Xuất Kho | InventoryPro</title>
                <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">
                <style>
                    .gi-info-box {
                        background: #fdf2f2;
                        border-left: 4px solid #ef4444;
                        padding: 12px 16px;
                        border-radius: 4px;
                        margin-bottom: 16px;
                    }

                    .product-table thead th {
                        background: #343a40;
                        color: #fff;
                    }

                    .qty-actual-input {
                        border: 2px solid #3b82f6;
                        font-weight: bold;
                        transition: all 0.2s;
                    }

                    .qty-actual-input:focus {
                        box-shadow: 0 0 0 0.2rem rgba(59, 130, 246, .25);
                        border-color: #3b82f6;
                    }

                    .qty-invalid {
                        border-color: #ef4444 !important;
                        background-color: #fef2f2 !important;
                    }

                    .error-feedback {
                        color: #ef4444;
                        font-size: 0.75rem;
                        margin-top: 4px;
                        display: none;
                    }

                    .stock-badge {
                        font-weight: bold;
                        padding: 4px 8px;
                        border-radius: 6px;
                        font-size: 0.85rem;
                    }

                    .low-stock {
                        background-color: #fee2e2;
                        color: #ef4444;
                        border: 1px solid #fca5a5;
                    }

                    .enough-stock {
                        background-color: #dcfce7;
                        color: #15803d;
                        border: 1px solid #86efac;
                    }

                    .debt-text {
                        color: #ef4444;
                        font-weight: bold;
                    }
                </style>
            </head>

            <body>
                <div id="loading">
                    <div id="loading-center"></div>
                </div>
                <div class="wrapper">
                    <%@ include file="../sidebar.jsp" %>
                        <jsp:include page="../header.jsp" />
                        <div class="content-page">
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <!-- Header card -->
                                        <div class="card">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <div class="header-title">
                                                    <h4 class="card-title">
                                                        <i class="fas fa-sign-out-alt mr-2 text-primary"></i>
                                                        Good Issue: ${order.orderCode}
                                                    </h4>
                                                </div>
                                                <a href="sales-order?action=warehouse-list" class="btn btn-secondary">
                                                    <i class="fas fa-arrow-left mr-1"></i> Trở về
                                                </a>
                                            </div>
                                            <div class="card-body">
                                                <!-- Error messages from server -->
                                                <c:if test="${not empty errors}">
                                                    <div class="alert alert-danger shadow-sm">
                                                        <div class="font-weight-bold mb-1"><i
                                                                class="fas fa-exclamation-circle mr-2"></i>Lỗi xử lý:
                                                        </div>
                                                        <ul class="mb-0 pl-4">
                                                            <c:forEach items="${errors}" var="e">
                                                                <li>${e}</li>
                                                            </c:forEach>
                                                        </ul>
                                                    </div>
                                                </c:if>

                                                <form id="giForm" action="goods-issue" method="post">
                                                    <input type="hidden" name="soId" value="${order.id}">

                                                    <div class="row">
                                                        <!-- Customer Info -->
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label
                                                                    class="font-weight-bold text-muted small text-uppercase">Khách
                                                                    hàng</label>
                                                                <div
                                                                    class="form-control-plaintext font-weight-bold text-dark h5">
                                                                    ${order.customer.name}
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Pickup Location -->
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label
                                                                    class="font-weight-bold text-muted small text-uppercase">
                                                                    <i
                                                                        class="fas fa-map-marker-alt mr-1 text-danger"></i>
                                                                    Pickup Location <span class="text-danger">*</span>
                                                                </label>
                                                                <select name="locationId" id="locationSelect"
                                                                    class="form-control font-weight-bold" required>
                                                                    <c:forEach items="${locations}" var="l">
                                                                        <option value="${l.id}" ${param.locationId==l.id
                                                                            || selectedLocId==l.id ? 'selected' : '' }>
                                                                            ${l.locationName} (${l.locationCode})
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                                <small class="text-muted mt-1 d-block italic">Hệ thống
                                                                    sẽ tải lại tồn kho tương ứng với vị trí đã
                                                                    chọn.</small>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <hr>

                                                    <!-- Table -->
                                                    <div class="table-responsive mt-4">
                                                        <table class="product-table table table-bordered table-hover">
                                                            <thead>
                                                                <tr>
                                                                    <th>Sản phẩm</th>
                                                                    <th class="text-right">Price</th>
                                                                    <th class="text-center">Order</th>
                                                                    <th class="text-center">Delivered</th>
                                                                    <th class="text-center">Still in debt</th>
                                                                    <th class="text-center">Inventory</th>
                                                                    <th class="text-center" style="width: 150px;">This
                                                                        shipment</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${uiDetails}" var="row">
                                                                    <c:if test="${row[4] > 0}"> <%-- Chỉ hiện những cái
                                                                            còn nợ --%>
                                                                            <tr>
                                                                                <td>
                                                                                    <div
                                                                                        class="d-flex align-items-center">
                                                                                        <div>
                                                                                            <div
                                                                                                class="font-weight-bold text-dark">
                                                                                                ${row[0]}</div>
                                                                                            <div
                                                                                                class="small text-muted">
                                                                                                ID: ${row[6]}
                                                                                                <c:if
                                                                                                    test="${not empty row[7]}">
                                                                                                    | Màu: <span
                                                                                                        class="badge badge-light border">${row[7]}</span>
                                                                                                </c:if>
                                                                                                <c:if
                                                                                                    test="${not empty row[1]}">
                                                                                                    | Lot/Serial:
                                                                                                    <code>${row[1]}</code>
                                                                                                </c:if>
                                                                                            </div>
                                                                                            <input type="hidden"
                                                                                                name="pdId"
                                                                                                value="${row[6]}">
                                                                                        </div>
                                                                                    </div>
                                                                                </td>
                                                                                <td
                                                                                    class="text-right font-weight-bold text-primary">
                                                                                    <fmt:formatNumber value="${row[8]}"
                                                                                        type="currency"
                                                                                        currencySymbol="₫" />
                                                                                </td>
                                                                                <td
                                                                                    class="text-center font-weight-bold">
                                                                                    ${row[2]}</td>
                                                                                <td
                                                                                    class="text-center font-weight-bold text-success">
                                                                                    ${row[3]}</td>
                                                                                <td class="text-center debt-text">
                                                                                    ${row[4]}</td>
                                                                                <td class="text-center">
                                                                                    <span
                                                                                        class="stock-badge ${row[5] < row[4] ? 'low-stock' : 'enough-stock'}">
                                                                                        ${row[5]}
                                                                                    </span>
                                                                                    <input type="hidden"
                                                                                        class="stock-val"
                                                                                        value="${row[5]}">
                                                                                    <input type="hidden"
                                                                                        class="debt-val"
                                                                                        value="${row[4]}">
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <input type="number" name="shipQty"
                                                                                        class="form-control qty-actual-input text-center mx-auto"
                                                                                        min="0" placeholder="0"
                                                                                        style="width: 100px;">
                                                                                    <div class="error-feedback">Vượt quá
                                                                                        tồn/nợ</div>
                                                                                </td>
                                                                            </tr>
                                                                    </c:if>
                                                                </c:forEach>
                                                                <c:if test="${empty uiDetails}">
                                                                    <tr>
                                                                        <td colspan="7"
                                                                            class="text-center py-5 text-muted">
                                                                            <i
                                                                                class="fas fa-box-open fa-3x mb-3 d-block opacity-25"></i>
                                                                            Không có sản phẩm nào cần xuất hoặc kho đã
                                                                            được giao hết.
                                                                        </td>
                                                                    </tr>
                                                                </c:if>
                                                            </tbody>
                                                        </table>
                                                    </div>

                                                    <div class="d-flex justify-content-end mt-4">
                                                        <a href="sales-order?action=warehouse-list"
                                                            class="btn btn-light btn-lg mr-3">Cancel</a>
                                                        <button type="submit" class="btn btn-primary btn-lg shadow"
                                                            id="submitBtn">
                                                            <i class="fas fa-check-circle mr-2"></i> Export Confirmation
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                </div>

                <!-- Footer -->
                <footer class="iq-footer">
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-lg-6">
                                        <ul class="list-inline mb-0">
                                            <li class="list-inline-item"><a href="#">Privacy Policy</a></li>
                                            <li class="list-inline-item"><a href="#">Terms of Use</a></li>
                                        </ul>
                                    </div>
                                    <div class="col-lg-6 text-right">
                                        <span>
                                            <script>document.write(new Date().getFullYear())</script>©
                                        </span>
                                        <a href="#">InventoryPro</a>.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </footer>

                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

                <script>
                    // Tải lại trang khi đổi vị trí kho để cập nhật tồn kho
                    document.getElementById('locationSelect').addEventListener('change', function () {
                        const soId = "${order.id}";
                        window.location.href = "goods-issue?soId=" + soId + "&locationId=" + this.value;
                    });

                    // Validation logic
                    const inputs = document.querySelectorAll('.qty-actual-input');
                    const submitBtn = document.getElementById('submitBtn');

                    function validateInputs() {
                        let total = 0;
                        let hasError = false;

                        inputs.forEach(input => {
                            const row = input.closest('tr');
                            const val = parseInt(input.value) || 0;
                            const stock = parseInt(row.querySelector('.stock-val').value);
                            const debt = parseInt(row.querySelector('.debt-val').value);
                            const feedback = row.querySelector('.error-feedback');

                            input.classList.remove('qty-invalid');
                            feedback.style.display = 'none';

                            if (val < 0) {
                                input.classList.add('qty-invalid');
                                hasError = true;
                            } else if (val > stock) {
                                input.classList.add('qty-invalid');
                                feedback.textContent = "Không đủ tồn kho (" + stock + ")";
                                feedback.style.display = 'block';
                                hasError = true;
                            } else if (val > debt) {
                                input.classList.add('qty-invalid');
                                feedback.textContent = "Vượt quá số nợ (" + debt + ")";
                                feedback.style.display = 'block';
                                hasError = true;
                            }

                            total += val;
                        });

                        submitBtn.disabled = hasError || total <= 0;
                    }

                    inputs.forEach(input => {
                        input.addEventListener('input', validateInputs);
                        input.addEventListener('change', validateInputs);
                    });

                    document.getElementById('giForm').addEventListener('submit', function (e) {
                        if (!confirm('Xác nhận xuất kho? Tồn kho sẽ được cập nhật ngay lập tức.')) {
                            e.preventDefault();
                        }
                    });

                    // Khởi tạo trạng thái nút bấm
                    validateInputs();
                </script>
            </body>

            </html>