<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Create Purchase Order</title>
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
        .section-disabled {
            opacity: 0.4;
            pointer-events: none;
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
            background: #17AEDF;
        }

        .step-badge.inactive {
            background: #adb5bd;
        }

        .product-row {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 12px;
            margin-bottom: 10px;
        }

        .total-bar {
            background: #17AEDF;
            color: #fff;
            border-radius: 8px;
            padding: 14px 20px;
            font-size: 18px;
        }
    </style>
</head>

<body>
    <div id="loading">
        <div id="loading-center"></div>
    </div>
    <div class="wrapper">
        <%@ include file="../sidebar.jsp" %>
        <%@ include file="../header.jsp" %>
        <div class="content-page">
            <div class="container-fluid add-form-list">

                <c:if test="${param.success == 'created' || success == 'created'}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Success.</strong> Purchase order has been created.
                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                    </div>
                </c:if>

                <c:if test="${not empty infoMessage}">
                    <div class="alert alert-info alert-dismissible fade show" role="alert">
                        ${infoMessage}
                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Error.</strong> ${error}
                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/add-purchase-order" method="post" id="poForm">

                    <div class="card mb-3">
                        <div class="card-header d-flex align-items-center justify-content-between flex-wrap">
                            <div class="d-flex align-items-center">
                                <span class="step-badge active mr-2">1</span>
                                <h5 class="mb-0">Order Info &amp; Supplier</h5>
                            </div>
                            <a href="${pageContext.request.contextPath}/add-purchase-order?reset=1"
                                class="btn btn-sm btn-outline-secondary">Reset Form</a>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Order Code *</label>
                                        <input type="text" name="orderCode" id="orderCode" class="form-control"
                                            value="${draft.orderCode}" placeholder="Order Code" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Supplier *</label>
                                        <div class="input-group">
                                            <select name="supplierId" id="supplierSelect" class="form-control" required>
                                                <option value="">-- Select Supplier --</option>
                                                <c:forEach var="s" items="${supplierList}">
                                                    <option value="${s.id}"
                                                        <c:if test="${draft.supplierId eq s.id}">selected="selected"</c:if>>
                                                        <c:out value="${s.name}" />
                                                        <c:if test="${not empty s.phone}"> — <c:out value="${s.phone}" /></c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="input-group-append">
                                                <button type="submit" name="setSupplier" value="1"
                                                    class="btn btn-outline-primary" title="Apply selected supplier">
                                                    Apply
                                                </button>
                                                <button type="button" class="btn btn-outline-success"
                                                    data-toggle="modal" data-target="#modalAddSupplier"
                                                    title="Create new supplier">
                                                    New
                                                </button>
                                            </div>
                                        </div>
                                        <small class="text-muted">Select a supplier then click <strong>Apply</strong> to load products / variants.</small>
                                    </div>
                                </div>
                            </div>
                            <c:if test="${draft.supplierId gt 0}">
                                <div class="alert alert-info py-2">
                                    Supplier selected. Add product lines below.
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div class="card mb-3 ${draft.supplierId le 0 ? 'section-disabled' : ''}" id="productSection">
                        <div class="card-header d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center">
                                <span class="step-badge ${draft.supplierId gt 0 ? 'active' : 'inactive'} mr-2"
                                    id="step2Badge">2</span>
                                <h5 class="mb-0">Product Details</h5>
                            </div>
                            <c:if test="${draft.supplierId gt 0}">
                                <button type="submit" name="addLine" value="1" class="btn btn-success">
                                    Add Line
                                </button>
                            </c:if>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${draft.supplierId le 0}">
                                    <p class="text-center text-muted py-4 mb-0">Select a supplier and click <strong>Apply</strong> to add lines.</p>
                                </c:when>
                                <c:when test="${empty detailOptions}">
                                    <p class="text-center text-warning py-3 mb-0">
                                        No variants (details) found for this supplier's products. Create products / details in inventory, or use <strong>Quick Add Product</strong> then add variants.
                                    </p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="line" items="${draft.lines}" varStatus="st">
                                        <div class="product-row">
                                            <div class="row align-items-end">
                                                <div class="col-md-3">
                                                    <label class="small font-weight-bold">Variant *</label>
                                                    <select name="productDetailId" class="form-control variant-select" required
                                                        onchange="onVariantChange(this)">
                                                        <option value="" data-color="">-- Select Variant --</option>
                                                        <c:forEach var="opt" items="${detailOptions}">
                                                            <option value="${opt.id}"
                                                                data-color="${opt.color}"
                                                                data-price="${opt.price}"
                                                                <c:if test="${line.productDetailId eq opt.id}">selected="selected"</c:if>>
                                                                <c:out value="${opt.label}" />
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <label class="small font-weight-bold">Color</label>
                                                    <c:set var="currentColor" value="" />
                                                    <c:forEach var="opt" items="${detailOptions}">
                                                        <c:if test="${line.productDetailId eq opt.id}">
                                                            <c:set var="currentColor" value="${opt.color}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    <input type="text" class="form-control color-display" 
                                                        value="${currentColor}" readonly 
                                                        placeholder="—" style="background-color:#e9ecef;">
                                                </div>
                                                <div class="col-md-2">
                                                    <label class="small font-weight-bold">Unit Price *</label>
                                                    <input type="number" name="price" class="form-control"
                                                        value="${line.price}" min="0" step="any" required
                                                        placeholder="Enter price">
                                                </div>
                                                <div class="col-md-1">
                                                    <label class="small font-weight-bold">Qty *</label>
                                                    <input type="number" name="quantity" class="form-control"
                                                        value="${line.quantity}" min="1" required>
                                                </div>
                                                <div class="col-md-2">
                                                    <label class="small font-weight-bold">Tax</label>
                                                    <select name="taxId" class="form-control">
                                                        <option value="">-- None --</option>
                                                        <c:forEach var="t" items="${taxList}">
                                                            <option value="${t.id}"
                                                                <c:if test="${line.taxId eq t.id}">selected="selected"</c:if>>
                                                                <c:out value="${t.taxName}" /> (<fmt:formatNumber
                                                                    value="${t.taxRate}" maxFractionDigits="2" />%)
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-2 text-right">
                                                    <label class="small font-weight-bold d-block">&nbsp;</label>
                                                    <button type="submit" name="removeLine" value="${st.index}"
                                                        class="btn btn-outline-danger btn-sm"
                                                        title="Remove line">Remove</button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <div class="total-bar mt-3 d-flex justify-content-between align-items-center">
                                        <span>Estimated Subtotal:</span>
                                        <span class="font-weight-bold">
                                            <fmt:formatNumber value="${grandTotal}" type="number" maxFractionDigits="0" /> VND
                                        </span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between mb-4">
                        <a href="${pageContext.request.contextPath}/purchase-orders" class="btn btn-secondary btn-lg">
                            Cancel
                        </a>
                        <c:if test="${draft.supplierId gt 0 and not empty detailOptions}">
                            <button type="submit" name="createPO" value="1" class="btn btn-primary btn-lg"
                                style="background-color:#17AEDF;border-color:#17AEDF">
                                Create Purchase Order
                            </button>
                        </c:if>
                    </div>
                </form>

                <!-- Modal: Create Supplier -->
                <div class="modal fade" id="modalAddSupplier" tabindex="-1" role="dialog">
                    <div class="modal-dialog" role="document">
                        <form class="modal-content" method="post"
                            action="${pageContext.request.contextPath}/quick-add-supplier">
                            <div class="modal-header" style="background:#17AEDF; color:#fff;">
                                <h5 class="modal-title">Create New Supplier</h5>
                                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                            </div>
                            <div class="modal-body">
                                <div class="form-group">
                                    <label>Name *</label>
                                    <input type="text" name="name" class="form-control" required
                                        placeholder="Supplier name">
                                </div>
                                <div class="form-group">
                                    <label>Phone</label>
                                    <input type="text" name="phone" class="form-control" placeholder="0xxxxxxxxx">
                                </div>
                                <div class="form-group">
                                    <label>Email</label>
                                    <input type="email" name="email" class="form-control"
                                        placeholder="email@domain.com">
                                </div>
                                <div class="form-group">
                                    <label>Address</label>
                                    <textarea name="address" class="form-control" rows="2"
                                        placeholder="Address"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-success">Save</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modal: Create Product — only when supplier is selected -->
                <div class="modal fade" id="modalAddProduct" tabindex="-1" role="dialog">
                    <div class="modal-dialog" role="document">
                        <form class="modal-content" method="post"
                            action="${pageContext.request.contextPath}/quick-add-product">
                            <div class="modal-header" style="background:#28a745; color:#fff;">
                                <h5 class="modal-title">Create New Product</h5>
                                <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                            </div>
                            <div class="modal-body">
                                <c:choose>
                                    <c:when test="${draft.supplierId le 0}">
                                        <p class="text-muted mb-0">Select a supplier and click <strong>Apply</strong> first.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="supplierId" value="${draft.supplierId}">
                                        <div class="form-group">
                                            <label>Product Name *</label>
                                            <input type="text" name="name" class="form-control" required
                                                placeholder="Product name">
                                        </div>
                                        <div class="form-group">
                                            <label>Product Code *</label>
                                            <input type="text" name="code" class="form-control" required
                                                placeholder="e.g. PRD-001">
                                        </div>
                                        <div class="form-group">
                                            <label>Category</label>
                                            <select name="categoryId" class="form-control">
                                                <option value="">-- Select --</option>
                                                <c:forEach var="cat" items="${categoryList}">
                                                    <option value="${cat.id}"><c:out value="${cat.name}" /></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                <c:if test="${draft.supplierId gt 0}">
                                    <button type="submit" class="btn btn-success">Save Product</button>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>

                <c:if test="${draft.supplierId gt 0}">
                    <div class="mb-3">
                        <button type="button" class="btn btn-sm btn-outline-success" data-toggle="modal"
                            data-target="#modalAddProduct">
                            + Quick Add Product
                        </button>
                    </div>
                </c:if>

            </div>
        </div>
    </div>
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
        function onVariantChange(selectEl) {
            var row = selectEl.closest('.product-row');
            var selectedOption = selectEl.options[selectEl.selectedIndex];
            var color = selectedOption.getAttribute('data-color') || '';
            var price = selectedOption.getAttribute('data-price') || '';

            // Update color display
            var colorInput = row.querySelector('.color-display');
            if (colorInput) {
                colorInput.value = color;
            }

            // Suggest default price from product detail if price field is empty
            var priceInput = row.querySelector('input[name="price"]');
            if (priceInput && (!priceInput.value || priceInput.value === '0')) {
                priceInput.value = price;
            }
        }
    </script>
</body>

</html>
