<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Order Details | InventoryPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
    <style>
        body { font-family: 'Be Vietnam Pro', sans-serif; padding: 2rem; background: #f1f5f9; }
        .card { background: white; border-radius: 16px; padding: 2rem; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); margin-bottom: 2rem; }
        .header { display: flex; justify-content: space-between; margin-bottom: 2rem; border-bottom: 2px solid #f1f5f9; padding-bottom: 1rem; }
        .label { font-weight: 700; color: #64748b; font-size: 0.8rem; text-transform: uppercase; }
        .value { font-weight: 600; color: #0f172a; margin-bottom: 1rem; }
        .table-container { background: white; border-radius: 16px; padding: 1.5rem; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; min-width: 800px; }
        th { text-align: left; padding: 12px; background: #f8fafc; color: #64748b; border-bottom: 2px solid #edf2f7; font-size: 0.85rem; }
        td { padding: 12px; border-bottom: 1px solid #f1f5f9; color: #334155; vertical-align: top; }
        .badge-info { background: #e0f2fe; color: #0369a1; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: 600; }
        .total-row { font-weight: bold; background: #f8fafc; }
    </style>
</head>

<body>
    <div class="card">
        <div class="header">
            <h1>Order ${order.orderCode}</h1>
            <a href="sales-order?action=list" class="btn btn-secondary">Back to List</a>
        </div>
        <div class="row" style="display: flex; gap: 40px;">
            <div class="col">
                <div class="label">Customer</div>
                <div class="value">${order.customer.name}</div>
            </div>
            <div class="col">
                <div class="label">Created Date</div>
                <div class="value">
                    <fmt:formatDate value="${order.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                </div>
            </div>
            <div class="col">
                <div class="label">Total Amount</div>
                <div class="value" style="color: #2563eb; font-size: 1.2rem;">
                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$" />
                </div>
            </div>
        </div>
        <div class="mt-4">
            <div class="label">Note</div>
            <div class="value">${order.note != null && order.note != '' ? order.note : "No note"}</div>
        </div>
    </div>

    <div class="table-container">
        <h2 style="font-size: 1.25rem; margin-bottom: 1rem; color: #1e293b;">Items & Product Specifications</h2>
        <table>
            <thead>
                <tr>
                    <th>Product & ID</th>
                    <th>Specs (Color/Lot/Serial)</th>
                    <th>Mfg. Date</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th style="text-align: right;">Sub-total</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${order.details}" var="d">
                    <tr>
                        <td>
                            <div style="font-weight: 700; color: #1e293b;">${d.productDetail.product.name}</div>
                            <small style="color: #94a3b8;">SKU Detail ID: ${d.productDetail.id}</small>
                        </td>
                        <td>
                            <div style="margin-bottom: 4px;">
                                <span class="label" style="font-size: 0.65rem;">Color:</span> 
                                <span class="badge-info">${d.productDetail.color != null ? d.productDetail.color : 'N/A'}</span>
                            </div>
                            <div style="font-size: 0.8rem;">
                                <strong>Lot:</strong> ${d.productDetail.lotNumber != null ? d.productDetail.lotNumber : '---'} | 
                                <strong>SN:</strong> ${d.productDetail.serialNumber != null ? d.productDetail.serialNumber : '---'}
                            </div>
                        </td>
                        <td>
                            <span style="font-size: 0.85rem;">
                                <c:choose>
                                    <c:when test="${d.productDetail.manufactureDate != null}">
                                        <fmt:formatDate value="${d.productDetail.manufactureDate}" pattern="dd/MM/yyyy" />
                                    </c:when>
                                    <c:otherwise>---</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td style="font-weight: 600;">${d.quantity}</td>
                        <td><fmt:formatNumber value="${d.price}" type="currency" currencySymbol="$" /></td>
                        <td style="text-align: right; font-weight: 700; color: #0f172a;">
                            <fmt:formatNumber value="${d.subTotal}" type="currency" currencySymbol="$" />
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr class="total-row">
                    <td colspan="5" style="text-align: right; padding: 20px;">GRAND TOTAL:</td>
                    <td style="text-align: right; color: #2563eb; font-size: 1.3rem; padding: 20px;">
                        <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$" />
                    </td>
                </tr>
            </tfoot>
        </table>
    </div>
</body>
</html>