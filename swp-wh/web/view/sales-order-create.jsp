<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Create Sales Order | InventoryPro</title>

            <link
                href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">

            <style>
                :root {
                    --primary: #0EA5E9;
                    --gray-dark: #0f172a;
                }

                body {
                    font-family: 'Be Vietnam Pro', sans-serif;
                    background-color: #f1f5f9;
                }

                .page-header {
                    margin-bottom: 2rem;
                    padding: 1.5rem;
                }

                .card-form {
                    border-radius: 20px;
                    border: none;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                    padding: 2rem;
                }

                .form-label {
                    font-weight: 700;
                    color: var(--gray-dark);
                    margin-bottom: 0.5rem;
                    text-transform: uppercase;
                    font-size: 0.8rem;
                    letter-spacing: 0.05em;
                }

                .form-control,
                .form-select {
                    border-radius: 12px;
                    border: 2px solid #e2e8f0;
                    padding: 0.75rem 1rem;
                    font-weight: 600;
                    transition: all 0.2s;
                }

                .form-control:focus {
                    border-color: var(--primary);
                    box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.1);
                }

                .btn-submit {
                    background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
                    color: white;
                    border-radius: 12px;
                    padding: 0.75rem 2.5rem;
                    font-weight: 700;
                    border: none;
                    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                }

                .btn-add-item {
                    background: #f0f9ff;
                    color: #0369a1;
                    border: 2px dashed #bae6fd;
                    border-radius: 12px;
                    padding: 0.75rem;
                    font-weight: 700;
                    width: 100%;
                    margin-top: 1rem;
                }

                .item-row {
                    background: #f8fafc;
                    border-radius: 12px;
                    padding: 1.5rem;
                    margin-bottom: 1rem;
                    position: relative;
                    border: 1px solid #e2e8f0;
                }

                .btn-remove {
                    position: absolute;
                    right: -10px;
                    top: -10px;
                    background: #ef4444;
                    color: white;
                    border-radius: 50%;
                    width: 25px;
                    height: 25px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border: none;
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <div class="content-page">
                    <div class="container-fluid">
                        <div class="page-header">
                            <h1 class="font-weight-bold">Create Sales Order</h1>
                        </div>

                        <div class="col-lg-10 mx-auto">
                            <div class="card card-form">
                                <form action="sales-order" method="post" id="orderForm">
                                    <input type="hidden" name="action" value="create">

                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label">Customer</label>
                                                <select name="customerId" class="form-select w-100" required>
                                                    <option value="">Select Customer</option>
                                                    <c:forEach var="c" items="${customers}">
                                                        <option value="${c.id}">${c.name} (${c.customerCode})</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label">Note</label>
                                                <textarea name="note" class="form-control" rows="1"
                                                    placeholder="Optional notes..."></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Order Items</label>
                                        <div id="items-container">
                                            <!-- Dynamic Rows -->
                                        </div>
                                        <button type="button" class="btn-add-item" onclick="addItem()">
                                            <i class="ri-add-line"></i> Add Product
                                        </button>
                                    </div>

                                    <div class="text-right mt-5">
                                        <a href="sales-order?action=list" class="btn btn-secondary mr-3"
                                            style="border-radius: 12px; font-weight: 700;">Cancel</a>
                                        <button type="submit" class="btn btn-submit">Save Order</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Template for JS -->
            <template id="item-template">
                <div class="item-row">
                    <button type="button" class="btn-remove" onclick="this.parentElement.remove()">×</button>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group mb-0">
                                <label class="form-label small">Product Detail</label>
                                <select name="productDetailId" class="form-select w-100" required>
                                    <option value="">Select Product Detail</option>
                                    <c:forEach var="pd" items="${productDetails}">
                                        <option value="${pd.id}" data-price="${pd.product.price}">
                                            ${pd.product.name} - ${pd.lotNumber} / ${pd.serialNumber}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group mb-0">
                                <label class="form-label small">Quantity</label>
                                <input type="number" name="quantity" class="form-control" value="1" min="1" required>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group mb-0">
                                <label class="form-label small">Price (Auto-filled)</label>
                                <input type="number" name="price" class="form-control" step="0.01" required>
                            </div>
                        </div>
                    </div>
                </div>
            </template>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script>
                function addItem() {
                    const container = document.getElementById('items-container');
                    const template = document.getElementById('item-template').content.cloneNode(true);

                    const select = template.querySelector('select');
                    const priceInput = template.querySelector('input[name="price"]');

                    select.addEventListener('change', function () {
                        const selectedOption = this.options[this.selectedIndex];
                        const price = selectedOption.getAttribute('data-price');
                        if (price) priceInput.value = price;
                    });

                    container.appendChild(template);
                }

                // Initialize with one item
                window.onload = addItem;
            </script>
        </body>

        </html>