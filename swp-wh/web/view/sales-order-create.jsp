<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Create Sales Order | InventoryPro</title>
            
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
                    --gray-dark: #0f172a;
                }

                body {
                    font-family: 'Be Vietnam Pro', sans-serif;
                    background-color: #f8fafc;
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
                    padding: 2rem;
                }

                .form-label {
                    font-weight: 700;
                    color: var(--gray-dark);
                    text-transform: uppercase;
                    font-size: 0.75rem;
                    margin-bottom: 0.5rem;
                    display: block;
                }

                .form-control {
                    border-radius: 10px;
                    border: 2px solid #e2e8f0;
                    font-weight: 600;
                    padding: 0.6rem 1rem;
                    transition: border-color 0.2s;
                }

                .form-control:focus {
                    border-color: var(--primary);
                    box-shadow: none;
                }

                .btn-primary {
                    background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
                    border: none;
                    border-radius: 12px;
                    padding: 0.75rem 1.5rem;
                    font-weight: 700;
                    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                }

                .btn-secondary {
                    background: #f1f5f9;
                    color: #475569;
                    border: none;
                    border-radius: 12px;
                    padding: 0.75rem 1.5rem;
                    font-weight: 700;
                }

                .item-row {
                    background: #f8fafc;
                    border-radius: 12px;
                    padding: 1.5rem;
                    margin-bottom: 1rem;
                    border: 1px solid #e2e8f0;
                }

                .card-header-custom {
                    background: #f1f5f9;
                    padding: 1rem 1.5rem;
                    border-radius: 12px 12px 0 0;
                    border-bottom: 1px solid #e2e8f0;
                    font-weight: 800;
                    color: #475569;
                    text-transform: uppercase;
                    font-size: 0.85rem;
                }
            </style>
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
                            <a href="${pageContext.request.contextPath}/sales-order?action=list" class="btn btn-secondary">
                                <i class="ri-arrow-left-line mr-1"></i> Back to List
                            </a>
                        </div>

                        <div class="card-main">
                            <form action="${pageContext.request.contextPath}/sales-order" method="post" id="orderForm">
                                <input type="hidden" name="action" value="create">

                                <c:if test="${not empty inventoryErrors}">
                                    <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert" style="border-radius: 12px;">
                                        <strong class="d-block mb-2"><i class="ri-error-warning-line mr-1"></i> Inventory Error:</strong>
                                        <ul class="mb-0 pl-3">
                                            <c:forEach items="${inventoryErrors}" var="error">
                                                <li>${error}</li>
                                            </c:forEach>
                                        </ul>
                                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty sessionScope.error}">
                                    <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert" style="border-radius: 12px; font-weight: 600;">
                                        <i class="ri-error-warning-line mr-2"></i> ${sessionScope.error}
                                        <button type="button" class="close" data-dismiss="alert"><span>&times;</span></button>
                                    </div>
                                    <c:remove var="error" scope="session" />
                                </c:if>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label">Customer</label>
                                            <select name="customerId" id="customerId" class="form-control" required>
                                                <option value="">-- Select Customer --</option>
                                                <c:forEach var="c" items="${customers}">
                                                    <option value="${c.id}">${c.name} (${c.customerCode})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label">Warehouse (Ship From)</label>
                                            <select name="warehouseId" id="warehouseId" class="form-control" required onchange="warehouseChanged()">
                                                <option value="">-- Select Warehouse --</option>
                                                <c:forEach var="w" items="${warehouses}">
                                                    <option value="${w.id}">${w.warehouseName} (${w.warehouseCode})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label class="form-label">Note</label>
                                            <textarea name="note" class="form-control" rows="1" placeholder="Additional instructions..."></textarea>
                                        </div>
                                    </div>
                                </div>

                                <div class="mt-4">
                                    <div class="card-header-custom mb-3">
                                        <i class="ri-shopping-cart-2-line mr-2"></i> Order Items
                                    </div>
                                    <div id="items-container">
                                        <!-- Rows added here -->
                                    </div>
                                    <button type="button" class="btn btn-outline-info font-weight-bold" style="border-radius: 10px;" onclick="addItem()">
                                        <i class="ri-add-line mr-1"></i> Add Product
                                    </button>
                                </div>

                                <div class="text-right mt-5 pt-4 border-top">
                                    <a href="${pageContext.request.contextPath}/sales-order?action=list" class="btn btn-secondary mr-2">Cancel</a>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="ri-save-line mr-1"></i> Save Sales Order
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <template id="item-template">
                <div class="item-row">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group mb-0">
                                <label class="form-label">Product (Model)</label>
                                <select class="form-control product-main-select" onchange="loadVariants(this)" required disabled>
                                    <option value="">-- Select Warehouse First --</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group mb-0">
                                <label class="form-label">Variant (Lot / Serial / Color)</label>
                                <select name="productDetailId" class="form-control product-detail-select" onchange="updateRowInfo(this)" required disabled>
                                    <option value="">-- Select Product --</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group mb-0">
                                <label class="form-label">Quantity</label>
                                <input type="number" name="quantity" class="form-control" value="1" min="1" required>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group mb-0">
                                <label class="form-label">Unit Price ($)</label>
                                //có thể tự sửa vì ko có readonly
                                <input type="number" name="price" class="form-control" step="0.01" required>
                            </div>
                        </div>

                        <div class="col-md-1 d-flex align-items-end">
                            <button type="button" class="btn btn-outline-danger btn-block" style="border-radius: 10px; padding: 0.6rem;" onclick="removeItem(this)">
                                <i class="ri-delete-bin-line"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </template>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

            <script>
                function warehouseChanged() {
                    const warehouseId = document.getElementById('warehouseId').value;
                    const itemsContainer = document.getElementById('items-container');
                    
                    if (!warehouseId) {
                        itemsContainer.innerHTML = '';
                        addItem(); // Re-add one empty row if reset
                        return;
                    }

                    // For existing rows, refresh their product lists
                    const mainSelects = document.querySelectorAll('.product-main-select');
                    mainSelects.forEach(select => {
                        fetchProductsForSelect(select, warehouseId);
                    });
                }
//lấy danh sách product theo warehouse
                function fetchProductsForSelect(select, warehouseId) {
                    const contextPath = '${pageContext.request.contextPath}';
                    fetch(contextPath + '/sales-order?action=ajax-get-products&warehouseId=' + warehouseId)
                        .then(response => response.text())
                        .then(html => {
                            select.innerHTML = html;
                            select.disabled = false;
                            // Reset detail select too
                            const row = select.closest('.item-row');
                            const detailSelect = row.querySelector('.product-detail-select');
                            detailSelect.innerHTML = '<option value="">-- Select Product --</option>';
                            detailSelect.disabled = true;
                        });
                }

                function addItem() {
                    const warehouseId = document.getElementById('warehouseId').value;
                    const container = document.getElementById('items-container');
                    const template = document.getElementById('item-template').content.cloneNode(true);
                    
                    const newRow = template.querySelector('.item-row');
                    const mainSelect = newRow.querySelector('.product-main-select');
                    
                    container.appendChild(newRow);
                    
                    if (warehouseId) {
                        fetchProductsForSelect(mainSelect, warehouseId);
                    }
                }

                function removeItem(btn) {
                    btn.closest('.item-row').remove();
                }

                function loadVariants(mainSelect) {
                    const productId = mainSelect.value;
                    const warehouseId = document.getElementById('warehouseId').value;
                    const row = mainSelect.closest('.item-row');
                    const detailSelect = row.querySelector('.product-detail-select');
                    const priceInput = row.querySelector('input[name="price"]');
                    const contextPath = '${pageContext.request.contextPath}';

                    detailSelect.innerHTML = '<option value="">Loading...</option>';
                    detailSelect.disabled = true;
                    priceInput.value = "";

                    if (!productId) {
                        detailSelect.innerHTML = '<option value="">-- Select Product --</option>';
                        return;
                    }

                    fetch(contextPath + '/sales-order?action=ajax-get-details&productId=' + productId + '&warehouseId=' + warehouseId)
                        .then(response => response.text())
                        .then(html => {
                            detailSelect.innerHTML = html;
                            detailSelect.disabled = false;
                        });
                }

                function updateRowInfo(detailSelect) {
                    const selectedValue = detailSelect.value;
                    if (!selectedValue) {
                        const row = detailSelect.closest('.item-row');
                        const priceInput = row.querySelector('input[name="price"]');
                        priceInput.value = "";
                        return;
                    }

                    // Check for duplicates
                    const allDetailSelects = document.querySelectorAll('.product-detail-select');
                    let duplicateFound = false;
                    allDetailSelects.forEach(s => {
                        //Nếu có dòng khác chọn cùng variant thì trùng
                        if (s !== detailSelect && s.value === selectedValue) {
                            duplicateFound = true;
                        }
                    });

                    if (duplicateFound) {
                        if (typeof Swal !== 'undefined') {
                            Swal.fire({
                                icon: 'error',
                                title: 'Duplicate Product',
                                text: 'This product variant has already been selected in another row.',
                                confirmButtonColor: '#0EA5E9'
                            });
                        } else {
                            alert('This product variant has already been selected in another row.');
                        }
                        detailSelect.value = "";
                        const row = detailSelect.closest('.item-row');
                        const priceInput = row.querySelector('input[name="price"]');
                        priceInput.value = "";
                        return;
                    }

                    const selectedOption = detailSelect.options[detailSelect.selectedIndex];
                    const row = detailSelect.closest('.item-row');
                    const priceInput = row.querySelector('input[name="price"]');

                    if (selectedOption.value && selectedOption.getAttribute('data-price')) {
                        const basePrice = parseFloat(selectedOption.getAttribute('data-price'));
                        const sellingPrice = (basePrice * 1.2).toFixed(2);
                        priceInput.value = sellingPrice;
                    } else {
                        priceInput.value = "";
                    }
                }

                window.onload = function () {
                    addItem();
                };
            </script>
        </body>

        </html>