<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!doctype html>
                <html lang="vi">

                <head>
                    <meta charset="utf-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                    <title>Tạo Purchase Order Mới | InventoryPro</title>
                    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">
                    <link
                        href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap"
                        rel="stylesheet">
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
                            margin-bottom: 2rem;
                            padding: 1.5rem 0;
                        }

                        .card-main {
                            border-radius: 16px;
                            border: none;
                            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                            background: white;
                            margin-bottom: 1.5rem;
                        }

                        .step-indicator {
                            display: flex;
                            align-items: center;
                            gap: 1rem;
                            margin-bottom: 1rem;
                        }

                        .step-badge {
                            width: 32px;
                            height: 32px;
                            border-radius: 50%;
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            font-weight: bold;
                            font-size: 14px;
                            color: #fff;
                        }

                        .step-badge.active {
                            background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
                            color: white;
                            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                        }

                        .step-badge.inactive {
                            background: #e2e8f0;
                            color: #94a3b8;
                        }

                        .step-title {
                            font-weight: 800;
                            color: #1e293b;
                            font-size: 1.1rem;
                        }

                        .form-label {
                            font-weight: 700;
                            color: #475569;
                            text-transform: uppercase;
                            font-size: 0.75rem;
                            letter-spacing: 0.05em;
                            margin-bottom: 0.5rem;
                        }

                        .form-control {
                            border-radius: 10px;
                            border: 2px solid #e2e8f0;
                            font-weight: 600;
                            padding: 0.6rem 1rem;
                            height: auto;
                        }

                        .form-control:focus {
                            border-color: var(--primary);
                            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
                        }

                        .product-row {
                            background: #f8fafc;
                            border: 1px solid #e2e8f0;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 1rem;
                            transition: all 0.2s;
                        }

                        .product-row:hover {
                            border-color: var(--primary);
                            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.02);
                        }

                        .total-bar {
                            background: #0f172a;
                            color: white;
                            border-radius: 12px;
                            padding: 1.25rem 2rem;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            font-size: 1.25rem;
                            font-weight: 800;
                            margin-top: 2rem;
                        }

                        .btn-premium {
                            border-radius: 12px;
                            padding: 0.75rem 1.5rem;
                            font-weight: 700;
                            transition: all 0.3s ease;
                            display: inline-flex;
                            align-items: center;
                            gap: 0.5rem;
                            border: none;
                        }

                        .btn-add-item {
                            background: #e0f2fe;
                            color: #0369a1;
                        }

                        .btn-add-item:hover {
                            background: #bae6fd;
                        }

                        .btn-submit {
                            background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
                            color: white;
                            box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                        }

                        .btn-submit:hover:not(:disabled) {
                            transform: translateY(-2px);
                            box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
                        }

                        .btn-submit:disabled {
                            opacity: 0.6;
                            cursor: not-allowed;
                        }

                        .modal-content {
                            border-radius: 20px;
                            border: none;
                            overflow: hidden;
                        }

                        .modal-header {
                            background: #fff;
                            border-bottom: 1px solid #f1f5f9;
                            padding: 1.5rem 2rem;
                        }

                        .modal-body {
                            padding: 2rem;
                        }

                        .modal-footer {
                            border-top: 1px solid #f1f5f9;
                            padding: 1.5rem 2rem;
                        }

                        .section-disabled {
                            opacity: 0.4;
                            pointer-events: none;
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
                                    <h1 class="font-weight-bold mb-1">Create Purchase Order</h1>
                                    <p class="text-secondary mb-0">Select a supplier and add products to generate a new
                                        procurement request.</p>
                                </div>

                                <!-- Thông báo thành công -->
                                <c:if test="${param.success == 'created' || success == 'created'}">
                                    <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4"
                                        style="border-radius:12px; background:#dcfce7; color:#166534;">
                                        <i class="ri-checkbox-circle-line mr-2"></i> <strong>Thành công!</strong>
                                        Purchase Order đã được tạo.
                                        <button type="button" class="close"
                                            data-dismiss="alert"><span>&times;</span></button>
                                    </div>
                                </c:if>

                                <!-- Thông báo lỗi -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4"
                                        style="border-radius:12px; background:#fee2e2; color:#991b1b;">
                                        <i class="ri-error-warning-line mr-2"></i> <strong>Lỗi!</strong> ${error}
                                        <button type="button" class="close"
                                            data-dismiss="alert"><span>&times;</span></button>
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/add-purchase-order" method="post"
                                    id="poForm">

                                    <!-- STEP 1: Supplier Info -->
                                    <div class="card card-main">
                                        <div class="card-header bg-white border-0 pt-4 px-4">
                                            <div class="step-indicator">
                                                <span class="step-badge active">1</span>
                                                <span class="step-title">Order Information &amp; Supplier</span>
                                            </div>
                                        </div>
                                        <div class="card-body px-4 pb-4">
                                            <div class="row">
                                                <div class="col-md-4 mb-3">
                                                    <label class="form-label">Order Code *</label>
                                                    <input type="text" name="orderCode" id="orderCode"
                                                        class="form-control" value="${autoCode}" placeholder="PO-XXXX"
                                                        required>
                                                </div>
                                                <div class="col-md-8 mb-3">
                                                    <label class="form-label">Select Supplier *</label>
                                                    <div class="input-group">
                                                        <select name="supplierId" id="supplierSelect"
                                                            class="form-control" required>
                                                            <option value="">-- Choose a Supplier --</option>
                                                            <c:forEach var="s" items="${supplierList}">
                                                                <option value="${s.id}">
                                                                    ${s.name}<c:if test="${not empty s.phone}"> —
                                                                        ${s.phone}</c:if>
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="input-group-append">
                                                            <button type="button" class="btn btn-outline-primary px-3"
                                                                style="border-radius:0 10px 10px 0; border:2px solid #e2e8f0; border-left:none; font-weight:700;"
                                                                data-toggle="modal" data-target="#modalAddSupplier">
                                                                <i class="ri-add-line"></i> New Supplier
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="supplierInfo"
                                                class="alert alert-info py-2 d-none shadow-sm border-0"
                                                style="border-radius:10px; background:#e0f2fe; color:#0369a1;">
                                                <i class="ri-information-line mr-1"></i> Supplier selected. You can now
                                                add products below.
                                            </div>
                                        </div>
                                    </div>

                                    <!-- STEP 2: Danh sách sản phẩm -->
                                    <div class="card card-main" id="productSection">
                                        <div
                                            class="card-header bg-white border-0 pt-4 px-4 d-flex align-items-center justify-content-between">
                                            <div class="step-indicator mb-0">
                                                <span class="step-badge inactive" id="step2Badge">2</span>
                                                <span class="step-title">Danh Sách Sản Phẩm</span>
                                            </div>
                                            <button type="button" class="btn btn-success btn-premium" id="btnAddRow"
                                                disabled>
                                                <i class="ri-add-line"></i> Thêm Sản Phẩm
                                            </button>
                                        </div>
                                        <div class="card-body px-4 pb-4">
                                            <div id="productRows">
                                                <!-- Rows inserted by JS -->
                                            </div>
                                            <div id="emptyMsg" class="text-center text-muted py-4">
                                                <i class="ri-arrow-up-line ri-2x d-block mb-2"></i>
                                                Chọn Supplier trước, sau đó thêm sản phẩm
                                            </div>
                                            <div class="total-bar">
                                                <span><i class="ri-calculator-line mr-2"></i> Tổng Cộng:</span>
                                                <span id="grandTotal" class="font-weight-bold">0 đ</span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Submit buttons -->
                                    <div class="d-flex justify-content-between mb-4">
                                        <a href="${pageContext.request.contextPath}/purchase-orders"
                                            class="btn btn-secondary btn-lg">
                                            <i class="ri-close-line mr-1"></i> Hủy
                                        </a>
                                        <button type="submit" class="btn btn-primary btn-lg btn-submit" id="btnSubmit"
                                            disabled>
                                            <i class="ri-save-line mr-1"></i> Tạo Purchase Order
                                        </button>
                                    </div>

                                </form><!-- end poForm -->

                                <!-- MODAL: QUICK ADD SUPPLIER -->
                                <div class="modal fade" id="modalAddSupplier" tabindex="-1" role="dialog">
                                    <div class="modal-dialog" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header" style="background:#17AEDF; color:#fff;">
                                                <h5 class="modal-title"><i class="ri-truck-line mr-2"></i>Tạo Supplier
                                                    Mới</h5>
                                                <button type="button" class="close text-white"
                                                    data-dismiss="modal">&times;</button>
                                            </div>
                                            <div class="modal-body">
                                                <div id="supplierFormMsg" class="d-none"></div>
                                                <div class="form-group">
                                                    <label>Tên Supplier *</label>
                                                    <input type="text" id="sup_name" class="form-control"
                                                        placeholder="Nhập tên supplier">
                                                </div>
                                                <div class="form-group">
                                                    <label>Số điện thoại</label>
                                                    <input type="text" id="sup_phone" class="form-control"
                                                        placeholder="0xxxxxxxxx">
                                                </div>
                                                <div class="form-group">
                                                    <label>Email</label>
                                                    <input type="email" id="sup_email" class="form-control"
                                                        placeholder="supplier@email.com">
                                                </div>
                                                <div class="form-group">
                                                    <label>Địa chỉ</label>
                                                    <textarea id="sup_address" class="form-control" rows="2"
                                                        placeholder="Địa chỉ supplier"></textarea>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-dismiss="modal">Hủy</button>
                                                <button type="button" class="btn btn-success" id="btnSaveSupplier">
                                                    <i class="fas fa-save mr-1"></i> Lưu Supplier
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- MODAL: QUICK ADD PRODUCT -->
                                <div class="modal fade" id="modalAddProduct" tabindex="-1" role="dialog">
                                    <div class="modal-dialog" role="document">
                                        <div class="modal-content">
                                            <div class="modal-header" style="background:#28a745; color:#fff;">
                                                <h5 class="modal-title"><i class="fas fa-box mr-2"></i>Tạo Sản Phẩm Mới
                                                </h5>
                                                <button type="button" class="close text-white"
                                                    data-dismiss="modal">&times;</button>
                                            </div>
                                            <div class="modal-body">
                                                <div id="productFormMsg" class="d-none"></div>
                                                <div class="form-group">
                                                    <label>Supplier <span class="badge badge-info">Tự
                                                            động</span></label>
                                                    <input type="text" id="prod_supplierName" class="form-control"
                                                        readonly style="background:#e9ecef;">
                                                    <input type="hidden" id="prod_supplierId">
                                                    <input type="hidden" id="prod_targetRowIndex">
                                                </div>
                                                <div class="form-group">
                                                    <label>Tên sản phẩm *</label>
                                                    <input type="text" id="prod_name" class="form-control"
                                                        placeholder="Nhập tên sản phẩm">
                                                </div>
                                                <div class="form-group">
                                                    <label>Mã sản phẩm *</label>
                                                    <input type="text" id="prod_code" class="form-control"
                                                        placeholder="VD: CAR-001">
                                                </div>
                                                <div class="form-group">
                                                    <label>Giá nhập (đ) *</label>
                                                    <input type="number" id="prod_price" class="form-control"
                                                        placeholder="0" min="0">
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <label>Danh mục</label>
                                                            <select id="prod_categoryId" class="form-control">
                                                                <option value="">-- Chọn danh mục --</option>
                                                                <c:forEach var="cat" items="${categoryList}">
                                                                    <option value="${cat.id}">${cat.name}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-dismiss="modal">Hủy</button>
                                                <button type="button" class="btn btn-success" id="btnSaveProduct">
                                                    <i class="fas fa-save mr-1"></i> Lưu Sản Phẩm
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div><!-- /container-fluid -->
                        </div><!-- /content-page -->
                    </div><!-- /wrapper -->

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
                                            <span class="mr-1">
                                                <script>document.write(new Date().getFullYear())</script>©
                                            </span>
                                            <a href="#">POS Dash</a>.
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </footer>

                    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
                    <script async src="${pageContext.request.contextPath}/assets/js/chart-custom.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

                    <script>
                        /* ============================================================
                           DATA từ server
                        ============================================================ */
                        const allProducts = [
                            <c:forEach var="p" items="${productList}">
                                {id: ${p.id}, name: "${fn:escapeXml(p.name)}", code: "${fn:escapeXml(p.code)}" },
                            </c:forEach>
                        ];

                        const allTaxes = [
                            <c:forEach var="t" items="${taxList}">
                                {id: ${t.id}, name: "${fn:escapeXml(t.taxName)}", rate: ${t.taxRate} },
                            </c:forEach>
                        ];

                        const allColors = [
                            { id: 'Black', name: 'Đen' },
                            { id: 'White', name: 'Trắng' },
                            { id: 'Red', name: 'Đỏ' },
                            { id: 'Blue', name: 'Xanh dương' },
                            { id: 'Silver', name: 'Bạc' }
                        ];

                        const ctx = "${pageContext.request.contextPath}";
                        let rowCounter = 0;
                        let selectedSupplierId = null;
                        let selectedSupplierName = null;
                        let currentSupplierProducts = [];

                        /* ============================================================
                           SUPPLIER SELECT — kích hoạt bước 2
                        ============================================================ */
                        document.getElementById('supplierSelect').addEventListener('change', function () {
                            const hasRows = document.querySelectorAll('.product-row').length > 0;

                            if (hasRows && selectedSupplierId) {
                                const confirmChange = confirm('Thay đổi Nhà cung cấp sẽ xoá toàn bộ sản phẩm đang chọn. Bạn có chắc muốn đổi?');
                                if (!confirmChange) {
                                    this.value = selectedSupplierId;
                                    return;
                                } else {
                                    document.getElementById('productRows').innerHTML = '';
                                    document.getElementById('emptyMsg').style.display = '';
                                    rowCounter = 0;
                                    calcGrandTotal();
                                }
                            }

                            selectedSupplierId = this.value;
                            const opt = this.options[this.selectedIndex];
                            selectedSupplierName = opt.text;

                            if (selectedSupplierId) {
                                fetchSupplierProducts(selectedSupplierId);
                                enableProductSection();
                            } else {
                                disableProductSection();
                            }
                        });

                        /* ============================================================
                           FETCH PRODUCTS BY SUPPLIER (AJAX)
                        ============================================================ */
                        function fetchSupplierProducts(supplierId) {
                            currentSupplierProducts = [];
                            fetch(ctx + '/get-supplier-products?supplierId=' + supplierId)
                                .then(function (r) { return r.json(); })
                                .then(function (products) {
                                    if (Array.isArray(products) && products.length > 0) {
                                        currentSupplierProducts = products;
                                    }
                                    // Cập nhật lại dropdown sản phẩm đang hiển thị
                                    document.querySelectorAll('.product-select').forEach(function (select) {
                                        const currentVal = select.value;
                                        select.innerHTML = buildProductOptions();
                                        if (currentVal) select.value = currentVal;
                                    });
                                })
                                .catch(function (err) { console.error('Lỗi khi tải sản phẩm:', err); });
                        }

                        function enableProductSection() {
                            document.getElementById('btnAddRow').disabled = false;
                            document.getElementById('btnSubmit').disabled = false;
                            document.getElementById('step2Badge').classList.remove('inactive');
                            document.getElementById('step2Badge').classList.add('active');
                            document.getElementById('supplierInfo').classList.remove('d-none');
                        }

                        function disableProductSection() {
                            document.getElementById('btnAddRow').disabled = true;
                            document.getElementById('btnSubmit').disabled = true;
                            document.getElementById('step2Badge').classList.add('inactive');
                            document.getElementById('step2Badge').classList.remove('active');
                            document.getElementById('supplierInfo').classList.add('d-none');
                        }

                        /* ============================================================
                           THÊM HÀNG SẢN PHẨM
                        ============================================================ */
                        document.getElementById('btnAddRow').addEventListener('click', function () {
                            addProductRow();
                        });

                        function buildTaxOptions() {
                            let opts = '<option value="">-- Không --</option>';
                            allTaxes.forEach(function (t) {
                                opts += '<option value="' + t.id + '" data-rate="' + t.rate + '">' + t.name + ' (' + t.rate + '%)</option>';
                            });
                            return opts;
                        }

                        function buildColorOptions() {
                            let opts = '<option value="">-- Chọn --</option>';
                            allColors.forEach(function (c) {
                                opts += '<option value="' + c.id + '">' + c.name + '</option>';
                            });
                            return opts;
                        }

                        function buildProductOptions() {
                            let opts = '<option value="">-- Chọn sản phẩm --</option>';
                            currentSupplierProducts.forEach(function (p) {
                                opts += '<option value="' + p.id + '">' + p.name + ' [' + p.code + ']</option>';
                            });
                            if (currentSupplierProducts.length === 0 && selectedSupplierId) {
                                opts += '<option value="" disabled>Supplier này chưa có sản phẩm</option>';
                            }
                            return opts;
                        }

                        function addProductRow(productToAdd) {
                            const idx = rowCounter++;
                            document.getElementById('emptyMsg').style.display = 'none';

                            const prodOpts = buildProductOptions();
                            const taxOpts = buildTaxOptions();
                            const colorOpts = buildColorOptions();

                            const html =
                                '<div class="product-row" id="row_' + idx + '">' +
                                '<div class="row align-items-end">' +
                                '<div class="col-md-3">' +
                                '<label class="small font-weight-bold">Sản phẩm *</label>' +
                                '<div class="input-group">' +
                                '<select name="productId[]" id="prodSel_' + idx + '" class="form-control product-select" data-row="' + idx + '" required>' +
                                prodOpts +
                                '</select>' +
                                '<div class="input-group-append">' +
                                '<button type="button" class="btn btn-outline-success btn-new-product" data-row="' + idx + '" title="Tạo sản phẩm mới">' +
                                '<i class="fas fa-plus"></i>' +
                                '</button>' +
                                '</div>' +
                                '</div>' +
                                '</div>' +
                                '<div class="col-md-2">' +
                                '<label class="small font-weight-bold">Màu sắc *</label>' +
                                '<select name="colorId[]" id="color_' + idx + '" class="form-control" required>' +
                                colorOpts +
                                '</select>' +
                                '</div>' +
                                '<div class="col-md-1">' +
                                '<label class="small font-weight-bold" title="Số lượng">SL *</label>' +
                                '<input type="number" name="quantity[]" id="qty_' + idx + '" class="form-control qty-input" data-row="' + idx + '" value="1" min="1" required>' +
                                '</div>' +
                                '<div class="col-md-2">' +
                                '<label class="small font-weight-bold">Đơn giá (đ) *</label>' +
                                '<input type="number" name="price[]" id="price_' + idx + '" class="form-control price-input" data-row="' + idx + '" value="0" min="0" step="1000" required>' +
                                '</div>' +
                                '<div class="col-md-2">' +
                                '<label class="small font-weight-bold">Thuế</label>' +
                                '<select name="taxId[]" id="tax_' + idx + '" class="form-control tax-select" data-row="' + idx + '">' +
                                taxOpts +
                                '</select>' +
                                '</div>' +
                                '<div class="col-md-1">' +
                                '<label class="small font-weight-bold" style="font-size:11px;">Thành tiền</label>' +
                                '<input type="number" name="subTotal[]" id="sub_' + idx + '" class="form-control subtotal-field" readonly style="background:#e9ecef; padding-left:5px; padding-right:5px;">' +
                                '</div>' +
                                '<div class="col-md-1 text-center">' +
                                '<button type="button" class="btn btn-danger btn-sm mt-4" onclick="removeRow(' + idx + ')">' +
                                '<i class="fas fa-trash"></i>' +
                                '</button>' +
                                '</div>' +
                                '</div>' +
                                '</div>';

                            document.getElementById('productRows').insertAdjacentHTML('beforeend', html);

                            // Nếu tạo từ modal sản phẩm mới
                            if (productToAdd) {
                                const sel = document.getElementById('prodSel_' + idx);
                                const opt = new Option(productToAdd.name + ' [' + productToAdd.code + ']', productToAdd.id, true, true);
                                opt.dataset.price = productToAdd.price || 0;
                                sel.add(opt);
                                sel.value = productToAdd.id;
                                document.getElementById('price_' + idx).value = productToAdd.price || 0;
                                if (productToAdd.color) document.getElementById('color_' + idx).value = productToAdd.color;
                                calcRow(idx);
                            }

                            // Lắng nghe thay đổi của dropdown sản phẩm
                            document.getElementById('prodSel_' + idx).addEventListener('change', function () {
                                const opt = this.options[this.selectedIndex];
                                if (opt && opt.dataset.price !== undefined && opt.dataset.price !== '') {
                                    document.getElementById('price_' + idx).value = opt.dataset.price;
                                } else {
                                    document.getElementById('price_' + idx).value = 0;
                                }
                                if (opt && opt.dataset.color) {
                                    document.getElementById('color_' + idx).value = opt.dataset.color;
                                }
                                calcRow(idx);
                            });

                            ['qty_' + idx, 'price_' + idx, 'tax_' + idx].forEach(function (id) {
                                document.getElementById(id).addEventListener('input', function () { calcRow(idx); });
                                document.getElementById(id).addEventListener('change', function () { calcRow(idx); });
                            });

                            document.querySelectorAll('.btn-new-product').forEach(function (btn) {
                                btn.onclick = function () { openProductModal(this.dataset.row); };
                            });
                        }

                        function removeRow(idx) {
                            const row = document.getElementById('row_' + idx);
                            if (row) row.remove();
                            calcGrandTotal();
                            if (document.querySelectorAll('.product-row').length === 0) {
                                document.getElementById('emptyMsg').style.display = '';
                            }
                        }

                        /* ============================================================
                           TÍNH TIỀN
                        ============================================================ */
                        function calcRow(idx) {
                            const qty = parseFloat(document.getElementById('qty_' + idx).value) || 0;
                            const price = parseFloat(document.getElementById('price_' + idx).value) || 0;
                            const taxSel = document.getElementById('tax_' + idx);
                            const taxOpt = taxSel ? taxSel.options[taxSel.selectedIndex] : null;
                            const rate = (taxOpt && taxOpt.dataset.rate) ? parseFloat(taxOpt.dataset.rate) : 0;

                            const sub = qty * price * (1 + rate / 100);
                            document.getElementById('sub_' + idx).value = sub.toFixed(0);
                            calcGrandTotal();
                        }

                        function calcGrandTotal() {
                            let total = 0;
                            document.querySelectorAll('.subtotal-field').forEach(function (el) {
                                total += parseFloat(el.value) || 0;
                            });
                            document.getElementById('grandTotal').textContent = numberFormat(total) + ' đ';
                        }

                        function numberFormat(n) {
                            return Math.round(n).toLocaleString('vi-VN');
                        }

                        /* ============================================================
                           MODAL: QUICK ADD SUPPLIER
                        ============================================================ */
                        document.getElementById('btnSaveSupplier').addEventListener('click', function () {
                            const name = document.getElementById('sup_name').value.trim();
                            const phone = document.getElementById('sup_phone').value.trim();
                            const email = document.getElementById('sup_email').value.trim();
                            const address = document.getElementById('sup_address').value.trim();

                            if (!name) { showMsg('supplierFormMsg', 'danger', 'Tên supplier không được trống!'); return; }

                            const btn = this;
                            btn.disabled = true;
                            btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i> Đang lưu...';

                            fetch(ctx + '/quick-add-supplier', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'name=' + encodeURIComponent(name) + '&phone=' + encodeURIComponent(phone) +
                                    '&email=' + encodeURIComponent(email) + '&address=' + encodeURIComponent(address)
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        const sel = document.getElementById('supplierSelect');
                                        const opt = new Option(data.supplierName + (phone ? ' — ' + phone : ''), data.supplierId, true, true);
                                        sel.add(opt);
                                        sel.value = data.supplierId;
                                        selectedSupplierId = data.supplierId;
                                        selectedSupplierName = data.supplierName;
                                        enableProductSection();
                                        ['sup_name', 'sup_phone', 'sup_email', 'sup_address'].forEach(function (id) {
                                            document.getElementById(id).value = '';
                                        });
                                        showMsg('supplierFormMsg', 'success', 'Supplier "' + data.supplierName + '" đã được tạo!');
                                        setTimeout(function () { $('#modalAddSupplier').modal('hide'); hideMsg('supplierFormMsg'); }, 1200);
                                    } else {
                                        showMsg('supplierFormMsg', 'danger', data.message || 'Lỗi không xác định');
                                    }
                                })
                                .catch(function () { showMsg('supplierFormMsg', 'danger', 'Lỗi kết nối server'); })
                                .finally(function () { btn.disabled = false; btn.innerHTML = '<i class="fas fa-save mr-1"></i> Lưu Supplier'; });
                        });

                        /* ============================================================
                           MODAL: QUICK ADD PRODUCT
                        ============================================================ */
                        function openProductModal(rowIdx) {
                            document.getElementById('prod_supplierId').value = selectedSupplierId || '';
                            document.getElementById('prod_supplierName').value = selectedSupplierName || '';
                            document.getElementById('prod_targetRowIndex').value = rowIdx;
                            ['prod_name', 'prod_code', 'prod_price'].forEach(function (id) { document.getElementById(id).value = ''; });
                            document.getElementById('prod_categoryId').selectedIndex = 0;
                            hideMsg('productFormMsg');
                            $('#modalAddProduct').modal('show');
                        }

                        document.getElementById('btnSaveProduct').addEventListener('click', function () {
                            const name = document.getElementById('prod_name').value.trim();
                            const code = document.getElementById('prod_code').value.trim();
                            const price = document.getElementById('prod_price').value.trim();
                            const categoryId = document.getElementById('prod_categoryId').value;
                            const supplierId = document.getElementById('prod_supplierId').value;
                            const rowIdx = document.getElementById('prod_targetRowIndex').value;

                            if (!name || !code) { showMsg('productFormMsg', 'danger', 'Tên và Mã sản phẩm không được trống!'); return; }

                            const btn = this;
                            btn.disabled = true;
                            btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i> Đang lưu...';

                            fetch(ctx + '/quick-add-product', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: 'name=' + encodeURIComponent(name) + '&code=' + encodeURIComponent(code) +
                                    '&price=' + encodeURIComponent(price) + '&categoryId=' + encodeURIComponent(categoryId) +
                                    '&supplierId=' + encodeURIComponent(supplierId)
                            })
                                .then(function (r) { return r.json(); })
                                .then(function (data) {
                                    if (data.success) {
                                        const newProd = { id: data.productId, name: data.productName, code: data.productCode, price: parseFloat(price) || 0 };
                                        allProducts.push(newProd);
                                        currentSupplierProducts.push(newProd);

                                        const sel = document.getElementById('prodSel_' + rowIdx);
                                        if (sel) {
                                            const opt = new Option(data.productName + ' [' + data.productCode + ']', data.productId, true, true);
                                            opt.dataset.price = parseFloat(price) || 0;
                                            sel.add(opt);
                                            sel.value = data.productId;
                                            document.getElementById('price_' + rowIdx).value = parseFloat(price) || 0;
                                            calcRow(rowIdx);
                                        }
                                        showMsg('productFormMsg', 'success', 'Sản phẩm "' + data.productName + '" đã được tạo!');
                                        setTimeout(function () { $('#modalAddProduct').modal('hide'); hideMsg('productFormMsg'); }, 1200);
                                    } else {
                                        showMsg('productFormMsg', 'danger', data.message || 'Lỗi không xác định');
                                    }
                                })
                                .catch(function () { showMsg('productFormMsg', 'danger', 'Lỗi kết nối server'); })
                                .finally(function () { btn.disabled = false; btn.innerHTML = '<i class="fas fa-save mr-1"></i> Lưu Sản Phẩm'; });
                        });

                        /* ============================================================
                           FORM SUBMIT VALIDATION
                        ============================================================ */
                        document.getElementById('poForm').addEventListener('submit', function (e) {
                            const rows = document.querySelectorAll('.product-row');
                            if (rows.length === 0) {
                                e.preventDefault();
                                alert('Vui lòng thêm ít nhất 1 sản phẩm!');
                                return;
                            }
                            let valid = true;
                            rows.forEach(function (row) {
                                const sel = row.querySelector('.product-select');
                                if (!sel || !sel.value) valid = false;
                            });
                            if (!valid) {
                                e.preventDefault();
                                alert('Vui lòng chọn sản phẩm cho tất cả các hàng!');
                            }
                        });

                        /* ============================================================
                           HELPERS
                        ============================================================ */
                        function showMsg(elId, type, msg) {
                            const el = document.getElementById(elId);
                            el.className = 'alert alert-' + type + ' border-0 shadow-sm';
                            el.style.borderRadius = '12px';
                            if (type === 'danger') { el.style.background = '#fee2e2'; el.style.color = '#991b1b'; }
                            if (type === 'success') { el.style.background = '#dcfce7'; el.style.color = '#166534'; }
                            el.innerHTML = (type === 'success' ? '<i class="ri-checkbox-circle-line mr-2"></i>' : '<i class="ri-error-warning-line mr-2"></i>') + msg;
                        }

                        function hideMsg(elId) {
                            const el = document.getElementById(elId);
                            el.className = 'd-none';
                            el.innerHTML = '';
                        }
                    </script>
                </body>

                </html>