<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>WMS | Create Purchase Order</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">

    <style>
        .table-input input {
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            padding: 5px 10px;
        }
        .table-input input:focus {
            border-color: #0e5699;
            outline: none;
        }
        .total-amount-display {
            font-size: 1.25rem;
            font-weight: 700;
            color: #0e5699;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="content-page">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12">
                    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4">
                        <div>
                            <h4 class="mb-3">Create New Purchase Order</h4>
                        </div>
                    </div>
                </div>

                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/pocontroller" method="POST" id="poForm">
                                <input type="hidden" name="action" value="create">

                                <h5 class="mb-3">General Information</h5>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Supplier <span class="text-danger">*</span></label>
                                            <select name="supplierID" class="form-control" required>
                                                <option value="" disabled selected>Select Supplier</option>
                                                <c:forEach var="sup" items="${listSupplier}">
                                                    <option value="${sup.supplierID}">${sup.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Order Date</label>
                                            <input type="date" name="createdDate" class="form-control" value="<%= java.time.LocalDate.now() %>">
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label>Description / Note</label>
                                            <textarea name="description" class="form-control" rows="2" placeholder="Enter notes here..."></textarea>
                                        </div>
                                    </div>
                                </div>

                                <hr>

                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="mb-0">Order Items</h5>
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="addRow()">
                                        <i class="las la-plus"></i> Add Item
                                    </button>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-bordered table-input" id="itemsTable">
                                        <thead class="bg-light">
                                        <tr>
                                            <th style="width: 40%">Product</th>
                                            <th style="width: 15%">Quantity</th>
                                            <th style="width: 20%">Unit Price ($)</th>
                                            <th style="width: 20%">Amount ($)</th>
                                            <th style="width: 5%">Action</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <tr>
                                            <td>
                                                <select name="productID" class="form-control" required>
                                                    <option value="" disabled selected>Select Product</option>
                                                    <c:forEach var="p" items="${listProduct}">
                                                        <option value="${p.productID}">${p.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="number" name="quantity" class="form-control text-center" min="1" value="1" oninput="calculateRow(this)" required>
                                            </td>
                                            <td>
                                                <input type="number" name="price" class="form-control text-right" min="0" step="0.01" placeholder="0.00" oninput="calculateRow(this)" required>
                                            </td>
                                            <td>
                                                <input type="text" name="amount" class="form-control text-right" value="0.00">
                                            </td>
                                            <td class="text-center">
                                                <button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">
                                                    <i class="las la-trash mr-0"></i> Delete
                                                </button>
                                            </td>
                                        </tr>
                                        </tbody>
                                        <tfoot>
                                        <tr>
                                            <td colspan="3" class="text-right font-weight-bold">Total Amount:</td>
                                            <td colspan="2" class="text-right">
                                                <span id="grandTotal" class="total-amount-display">$0.00</span>
                                            </td>
                                        </tr>
                                        </tfoot>
                                    </table>
                                </div>

                                <div class="text-right mt-4">
                                    <a href="${pageContext.request.contextPath}/polist" class="btn btn-secondary mr-2">Cancel</a>
                                    <button type="submit" class="btn btn-primary">Create Order</button>
                                </div>
                            </form>
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
    function calculateRow(input) {
        var row = input.closest('tr');
        var qty = row.querySelector('input[name="quantity"]').value;
        var price = row.querySelector('input[name="price"]').value;
        var amountField = row.querySelector('input[name="amount"]');

        var amount = (parseFloat(qty) || 0) * (parseFloat(price) || 0);
        amountField.value = amount.toFixed(2);

        calculateGrandTotal();
    }

    function calculateGrandTotal() {
        var amounts = document.querySelectorAll('input[name="amount"]');
        var total = 0;
        amounts.forEach(function(item) {
            total += parseFloat(item.value) || 0;
        });
        document.getElementById('grandTotal').innerText = '$' + total.toFixed(2);
    }

    function addRow() {
        var tableBody = document.querySelector('#itemsTable tbody');
        var firstRow = tableBody.rows[0];
        var newRow = firstRow.cloneNode(true);

        var inputs = newRow.querySelectorAll('input');
        inputs.forEach(function(input) {
            if(input.name === 'quantity') input.value = '1';
            else input.value = '';
        });
        newRow.querySelector('select').value = '';

        tableBody.appendChild(newRow);
    }

    function removeRow(btn) {
        var row = btn.closest('tr');
        var tableBody = document.querySelector('#itemsTable tbody');

        if (tableBody.rows.length > 1) {
            row.remove();
            calculateGrandTotal();
        } else {
            alert("At least one item is required.");
        }
    }
</script>
</body>
</html>