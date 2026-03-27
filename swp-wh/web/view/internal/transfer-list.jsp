<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Internal Transfer | InventoryPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
    <style>
        .item-row { background: #fff; border: 1px solid #dee2e6; border-radius: 8px; padding: 15px; margin-bottom: 10px; position: relative; transition: 0.3s; }
        .item-row:hover { border-color: #007bff; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .btn-remove { position: absolute; top: 10px; right: 10px; color: #dc3545; cursor: pointer; border: none; background: none; font-size: 1.2rem; }
        .stock-badge { font-size: 0.85rem; padding: 4px 8px; }
        .border-left-danger { border-left: 5px solid #dc3545 !important; }
        .border-left-success { border-left: 5px solid #28a745 !important; }
    </style>
</head>
<body class="bg-light">
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="font-weight-bold text-primary"><i class="ri-arrow-left-right-line"></i> New Internal Transfer</h2>
            <a href="transfer" class="btn btn-outline-secondary btn-sm">Back to List</a>
        </div>

        <c:if test="${not empty inventoryErrors}">
            <div class="alert alert-danger shadow-sm border-left-danger" role="alert">
                <h5 class="alert-heading font-weight-bold"><i class="ri-error-warning-fill"></i> Validation Failed:</h5>
                <ul class="mb-0">
                    <c:forEach items="${inventoryErrors}" var="err">
                        <li>${err}</li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success shadow-sm border-left-success text-center py-3">
                <h5 class="mb-0 font-weight-bold"><i class="ri-checkbox-circle-fill"></i> ${successMsg}</h5>
            </div>
        </c:if>
        <div id="js-flash-msg"></div>

        <form action="transfer-create" method="post" id="transferForm">
            <div class="card mb-4 border-0 shadow-sm">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="font-weight-bold text-dark">From Location (Source)</label>
                            <select name="fromLocationId" id="fromLocationId" class="form-control" required onchange="clearItems()">
                                <option value="">-- Select Source Warehouse --</option>
                                <c:forEach items="${locations}" var="loc">
                                    <option value="${loc.id}">${loc.locationName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="font-weight-bold text-dark">To Location (Destination)</label>
                            <select name="toLocationId" id="toLocationId" class="form-control" required>
                                <option value="">-- Select Destination --</option>
                                <c:forEach items="${locations}" var="loc">
                                    <option value="${loc.id}">${loc.locationName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center py-3">
                    <h5 class="m-0 font-weight-bold text-dark">Transfer Items</h5>
                    <button type="button" class="btn btn-primary btn-sm px-3" onclick="openProductModal()">
                        <i class="ri-add-circle-line"></i> Add Products from Stock
                    </button>
                </div>
                <div class="card-body bg-light" id="itemsContainer">
                    <div id="emptyState" class="text-center py-5 text-muted">
                        <i class="ri-inbox-line ri-3x"></i>
                        <p class="mt-2">No products selected. Click "Add Products" to load stock.</p>
                    </div>
                </div>
                <div class="card-footer bg-white text-right py-3">
                    <button type="submit" class="btn btn-success px-5 font-weight-bold shadow">
                        <i class="ri-save-line"></i> Save Transfer Order
                    </button>
                </div>
            </div>
        </form>
    </div>

    <div class="modal fade" id="productModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Inventory in Selected Warehouse</h5>
                    <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="bg-light">
                                <tr>
                                    <th class="border-0">Product Detail</th>
                                    <th class="border-0 text-center">In Stock</th>
                                    <th class="border-0 text-right">Action</th>
                                </tr>
                            </thead>
                            <tbody id="stockResults">
                                </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script>
        function showFlashMsg(msg) {
            var container = document.getElementById('js-flash-msg');
            container.innerHTML = '<div class="alert alert-danger shadow-sm border-left-danger" role="alert"><h5 class="alert-heading font-weight-bold mb-0"><i class="ri-error-warning-fill mr-2"></i>' + msg + '</h5></div>';
            window.scrollTo(0, 0);
        }

        // Mở Modal và load HTML từ Servlet TransferCreate (doGet với action=get-stock)
        function openProductModal() {
            const locId = document.getElementById('fromLocationId').value;
            if(!locId) {
                showFlashMsg("Please select a Source Location first!");
                return;
            }

            const tbody = document.getElementById('stockResults');
            tbody.innerHTML = '<tr><td colspan="3" class="text-center py-4">Loading stock data...</td></tr>';
            $('#productModal').modal('show');

            // GỌI VỀ CHÍNH SERVLET NÀY VỚI ACTION GET-STOCK
            fetch('transfer-create?action=get-stock&locId=' + locId)
                .then(res => res.text()) // Nhận HTML thay vì JSON
                .then(html => {
                    tbody.innerHTML = html;
                })
                .catch(err => {
                    tbody.innerHTML = '<tr><td colspan="3" class="text-center text-danger">Error connecting to server.</td></tr>';
                });
        }

        // Thêm sản phẩm vào danh sách
        function addItem(id, name, max) {
            document.getElementById('emptyState').style.display = 'none';
            const container = document.getElementById('itemsContainer');
            
            if(document.querySelector(`input[name="productDetailId"][value="${id}"]`)) {
                showFlashMsg("Product already selected!");
                return;
            }

            const div = document.createElement('div');
            div.className = 'item-row';
            div.innerHTML = `
                <button type="button" class="btn-remove" onclick="this.parentElement.remove(); checkEmpty();">&times;</button>
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <span class="d-block font-weight-bold text-dark">${name}</span>
                        <small class="text-primary">Detail ID: ${id} | Current Stock: <strong>${max}</strong></small>
                        <input type="hidden" name="productDetailId" value="${id}">
                    </div>
                    <div class="col-md-4">
                        <div class="input-group shadow-sm">
                            <div class="input-group-prepend"><span class="input-group-text bg-white">Qty</span></div>
                            <input type="number" name="quantity" class="form-control" value="1" min="1" max="${max}" required>
                        </div>
                    </div>
                </div>`;
            container.appendChild(div);
            $('#productModal').modal('hide');
        }

        function checkEmpty() {
            if (document.querySelectorAll('.item-row').length === 0) {
                document.getElementById('emptyState').style.display = 'block';
            }
        }

        function clearItems() {
            const container = document.getElementById('itemsContainer');
            container.innerHTML = `
                <div id="emptyState" class="text-center py-5 text-muted">
                    <i class="ri-inbox-line ri-3x"></i>
                    <p class="mt-2">No products selected. Click "Add Products" to load stock.</p>
                </div>`;
        }

        document.getElementById('transferForm').onsubmit = function(e) {
            const from = document.getElementById('fromLocationId').value;
            const to = document.getElementById('toLocationId').value;
            if(from === to) {
                showFlashMsg("Source and Destination warehouses must be different!");
                e.preventDefault();
                return false;
            }
            if(document.querySelectorAll('.item-row').length === 0) {
                showFlashMsg("Please add at least one product to transfer!");
                e.preventDefault();
                return false;
            }
        };
    </script>
</body>
</html>