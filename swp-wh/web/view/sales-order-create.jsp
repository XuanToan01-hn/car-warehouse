<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Create Sales Order</title>
            <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        </head>

        <body>
            <div id="loading">
                <div id="loading-center"></div>
            </div>
            <div class="wrapper">
                <%@ include file="sidebar.jsp" %>
                    <%@ include file="header.jsp" %>

                        <div class="content-page">
                            <div class="container-fluid">
                                <div class="page-header">
                                    <div>
                                        <h1 class="font-weight-bold mb-1">Create Sales Order</h1>
                                        <p class="text-secondary mb-0">General information and product selection for new orders.</p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/sales-order?action=list"
                                        class="btn btn-secondary">
                                        Back to List
                                    </a>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="card">
                                            <div class="card-body">
                                                <form action="${pageContext.request.contextPath}/sales-order"
                                                    method="post" id="orderForm">
                                                    <input type="hidden" name="action" value="create">

                                                    <c:if test="${not empty inventoryErrors}">
                                                        <div class="alert alert-danger alert-dismissible fade show"
                                                            role="alert">
                                                            <strong>Inventory Error:</strong>
                                                            <ul class="mb-0 mt-2">
                                                                <c:forEach items="${inventoryErrors}" var="error">
                                                                    <li>${error}</li>
                                                                </c:forEach>
                                                            </ul>
                                                            <button type="button" class="close" data-dismiss="alert"
                                                                aria-label="Close">
                                                                <span aria-hidden="true">&times;</span>
                                                            </button>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${not empty sessionScope.error}">
                                                        <div class="alert alert-danger alert-dismissible fade show" role="alert"
                                                            style="border-radius: 12px; font-weight: 600;">
                                                            <i class="ri-error-warning-line mr-2"></i> ${sessionScope.error}
                                                            <button type="button" class="close"
                                                                data-dismiss="alert"><span>&times;</span></button>
                                                        </div>
                                                        <c:remove var="error" scope="session" />
                                                    </c:if>
                                                    <c:if test="${not empty sessionScope.success}">
                                                        <div class="alert alert-success alert-dismissible fade show" role="alert"
                                                            style="border-radius: 12px; font-weight: 600;">
                                                            <i class="ri-checkbox-circle-line mr-2"></i> ${sessionScope.success}
                                                            <button type="button" class="close"
                                                                data-dismiss="alert"><span>&times;</span></button>
                                                        </div>
                                                        <c:remove var="success" scope="session" />
                                                    </c:if>

                                                    <div class="row mb-4">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label
                                                                    class="form-label font-weight-bold">Customer</label>
                                                                <select name="customerId" class="form-control" required>
                                                                    <option value="">-- Select Customer --</option>
                                                                    <c:forEach var="c" items="${customers}">
                                                                        <option value="${c.id}">${c.name}
                                                                            (${c.customerCode})</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label class="form-label font-weight-bold">Note</label>
                                                                <textarea name="note" class="form-control" rows="2"
                                                                    placeholder="Additional instructions..."></textarea>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="card mt-3">
                                                        <div class="card-header bg-light">
                                                            <h5 class="card-title mb-0">Order Items</h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <div id="items-container">
                                                            </div>
                                                            <button type="button" class="btn btn-info mt-3"
                                                                onclick="addItem()">
                                                                Add Product
                                                            </button>
                                                        </div>
                                                    </div>

                                                    <div class="row mt-4">
                                                        <div class="col-12 text-right">
                                                            <hr>
                                                            <a href="${pageContext.request.contextPath}/sales-order?action=list"
                                                                class="btn btn-secondary mr-2">Cancel</a>
                                                            <button type="submit" class="btn btn-primary">
                                                                Save Sales Order
                                                            </button>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
            </div>

            <template id="item-template">
                <div class="row mb-3 border-bottom pb-3 item-row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="form-label small font-weight-bold">Product (Model)</label>
                            <select class="form-control product-main-select" onchange="filterDetails(this)" required>
                                <option value="">-- Select Model --</option>
                                <c:forEach var="p" items="${productList}">
                                    <option value="${p.id}">${p.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label small font-weight-bold">Variant (Lot / Serial / Color)</label>
                            <select name="productDetailId" class="form-control product-detail-select"
                                onchange="updateRowInfo(this)" required disabled>
                                <option value="" data-product="0">-- Select Variant --</option>
                                <c:forEach var="pd" items="${allDetails}">
                                    <option value="${pd.id}" data-product="${pd.product.id}" data-price="${pd.price}"
                                        data-stock="${pd.quantity}" style="display:none;">
                                        Lot: ${pd.lotNumber} | SN: ${pd.serialNumber} | Color: ${pd.color}
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-primary stock-info"></small>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-label small font-weight-bold">Quantity</label>
                            <input type="number" name="quantity" class="form-control" value="1" min="1" required>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="form-group">
                            <label class="form-label small font-weight-bold">Unit Price</label>
                            <input type="number" name="price" class="form-control" step="0.01" required>
                        </div>
                    </div>

                    <div class="col-md-1">
                        <div class="form-group">
                            <label class="form-label small font-weight-bold">&nbsp;</label>
                            <button type="button" class="btn btn-outline-danger btn-block btn-sm"
                                onclick="this.closest('.row').remove()">
                                Xóa
                            </button>
                        </div>
                    </div>
                </div>
            </template>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

            <script>
                // Add a new row to the item container
                function addItem() {
                    const container = document.getElementById('items-container');
                    const template = document.getElementById('item-template').content.cloneNode(true);
                    container.appendChild(template);
                }

                // Filter the Detail dropdown based on selected Main Product
                function filterDetails(mainSelect) {
                    const productId = mainSelect.value;
                    const row = mainSelect.closest('.item-row');
                    const detailSelect = row.querySelector('.product-detail-select');
                    const stockInfo = row.querySelector('.stock-info');
                    const priceInput = row.querySelector('input[name="price"]');
                    const options = detailSelect.options;

                    // Reset secondary fields
                    detailSelect.value = "";
                    detailSelect.disabled = (productId === "");
                    stockInfo.innerText = "";
                    priceInput.value = "";

                    // Loop through all detail options and hide/show based on product ID
                    for (let i = 0; i < options.length; i++) {
                        const opt = options[i];
                        const parentId = opt.getAttribute('data-product');

                        if (parentId === "0") continue; // Keep the placeholder option

                        if (parentId === productId) {
                            opt.style.display = "block";
                            opt.disabled = false;
                        } else {
                            opt.style.display = "none";
                            opt.disabled = true;
                        }
                    }
                }

                // Auto-fill price and stock when a detail is selected
                function updateRowInfo(detailSelect) {
                    const selectedOption = detailSelect.options[detailSelect.selectedIndex];
                    const row = detailSelect.closest('.item-row');

                    const price = selectedOption.getAttribute('data-price');
                    const stock = selectedOption.getAttribute('data-stock');

                    const priceInput = row.querySelector('input[name="price"]');
                    const stockInfo = row.querySelector('.stock-info');

                    if (selectedOption.value) {
                        priceInput.value = price || "";
                        //                stockInfo.innerText = "Available Stock: " + (stock || "0");
                    } else {
                        priceInput.value = "";
                        stockInfo.innerText = "";
                    }
                }

                // Initialize with one empty row on load
                window.onload = function () {
                    addItem();
                };
            </script>
        </body>

        </html>