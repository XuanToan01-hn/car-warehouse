<%-- 
    Document   : create-transfer
    Created on : Mar 5, 2026, 6:37:10 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Transfer Request</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .product-row { border-bottom: 1px dashed #dee2e6; padding-bottom: 10px; margin-bottom: 10px; }
    </style>
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Create Stock Transfer Request</h4>
                    </div>
                    <div class="card-body">
                        <form action="transfer" method="post">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">From Location (Source):</label>
                                    <select name="fromLocationId" class="form-select" required>
                                        <option value="">-- Select Source --</option>
                                        <c:forEach items="${locations}" var="l">
                                            <option value="${l.id}">${l.locationName} (${l.locationCode})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold">To Location (Destination):</label>
                                    <select name="toLocationId" class="form-select" required>
                                        <option value="">-- Select Destination --</option>
                                        <c:forEach items="${locations}" var="l">
                                            <option value="${l.id}">${l.locationName} (${l.locationCode})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="mb-0">Product List</h5>
                                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="addProductRow()">+ Add Product</button>
                            </div>

                            <div id="product-container">
                                <div class="row product-row gx-2">
                                    <div class="col-md-8">
                                        <label class="small text-muted">Product Detail ID (Barcode/ID):</label>
                                        <input type="number" name="productDetailId" class="form-control" placeholder="Enter Product Detail ID" required>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="small text-muted">Quantity:</label>
                                        <input type="number" name="quantity" class="form-control" placeholder="Qty" min="1" required>
                                    </div>
                                    <div class="col-md-1 d-flex align-items-end">
                                        <button type="button" class="btn btn-outline-danger w-100" onclick="removeRow(this)">×</button>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4">
                                <label class="form-label fw-bold">Transfer Note:</label>
                                <textarea name="note" class="form-control" rows="2" placeholder="Reason for transfer..."></textarea>
                            </div>

                            <div class="mt-4 d-flex gap-2">
                                <button type="submit" class="btn btn-success px-5">Submit Transfer Request</button>
                                <a href="transfer" class="btn btn-light px-4">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function addProductRow() {
            const container = document.getElementById('product-container');
            const newRow = document.createElement('div');
            newRow.className = 'row product-row gx-2';
            newRow.innerHTML = `
                <div class="col-md-8">
                    <input type="number" name="productDetailId" class="form-control" placeholder="Enter Product Detail ID" required>
                </div>
                <div class="col-md-3">
                    <input type="number" name="quantity" class="form-control" placeholder="Qty" min="1" required>
                </div>
                <div class="col-md-1 d-flex align-items-end">
                    <button type="button" class="btn btn-outline-danger w-100" onclick="removeRow(this)">×</button>
                </div>
            `;
            container.appendChild(newRow);
        }

        function removeRow(btn) {
            const rows = document.getElementsByClassName('product-row');
            if (rows.length > 1) {
                btn.closest('.product-row').remove();
            } else {
                alert("At least one product is required.");
            }
        }
    </script>
</body>
</html>
