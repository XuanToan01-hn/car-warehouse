<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>

<html>
<head>
    <title>Goods Issue | InventoryPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
    <style>
        .table-input { width: 70px; padding: 4px; border: 1px solid #cbd5e1; border-radius: 4px; text-align: center; }
        .stock-badge { font-weight: bold; padding: 2px 6px; border-radius: 4px; font-size: 0.85rem; }
        .low-stock { background-color: #fee2e2; color: #ef4444; }
        .enough-stock { background-color: #dcfce7; color: #15803d; }
    </style>
</head>
<body style="padding: 1.5rem; background: #f8fafc;">
    <div style="background: white; padding: 1.5rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">

```
    <h3 style="margin-bottom: 1rem;">Goods Issue: ${order.orderCode}</h3>

    <%-- Error Messages --%>
    <c:if test="${not empty errors}">
        <div style="color: #ef4444; background: #fef2f2; padding: 0.75rem; border-radius: 6px; margin-bottom: 1rem; font-size: 0.9rem;">
            <c:forEach items="${errors}" var="e">
                <div>• ${e}</div>
            </c:forEach>
        </div>
    </c:if>

    <form action="goods-issue" method="post">
        <input type="hidden" name="soId" value="${order.id}">

        <div style="margin-bottom: 1rem;">
            <label>Pickup Location:</label>
            <select name="locationId" id="locationSelect" class="form-control" style="width: 200px; display: inline-block;">
                <c:forEach items="${locations}" var="l">
                    <option value="${l.id}" ${param.locationId == l.id ? 'selected' : ''}>
                        ${l.locationName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <table class="table" style="width: 100%; font-size: 0.9rem;">
            <thead>
                <tr style="background: #f1f5f9;">
                    <th style="text-align: left; padding: 10px;">Product</th>
                    <th>Ordered</th>
                    <th>Shipped</th>
                    <th>Pending</th>
                    <th>Stock</th>
                    <th style="width: 120px;">Issue Qty</th>
                </tr>
            </thead>
            <tbody>

                <c:forEach items="${uiDetails}" var="row">

                    <%-- Show only items with pending quantity --%>
                    <c:if test="${row[4] > 0}">
                        <tr>
                            <td style="padding: 10px;">
                                <strong>${row[0]}</strong><br>
                                <small class="text-muted">ID: ${row[6]}</small>
                                <input type="hidden" name="pdId" value="${row[6]}">
                            </td>

                            <td align="center">${row[2]}</td>
                            <td align="center">${row[3]}</td>

                            <td align="center" style="color: #ef4444;">
                                ${row[4]}
                            </td>

                            <td align="center">
                                <span class="stock-badge ${row[5] < row[4] ? 'low-stock' : 'enough-stock'}">
                                    ${row[5]}
                                </span>
                            </td>

                            <td align="center">
                                <input
                                    type="number"
                                    name="shipQty"
                                    class="table-input"
                                    min="0"
                                    max="${row[5]}"
                                    placeholder="0">
                            </td>
                        </tr>
                    </c:if>

                </c:forEach>

            </tbody>
        </table>

        <div style="margin-top: 1.5rem; border-top: 1px solid #e2e8f0; padding-top: 1rem;">
            <button type="submit" class="btn btn-primary">
                Confirm Issue
            </button>

            <a href="sales-order?action=warehouse-list"
               style="margin-left: 1rem; color: #64748b; text-decoration: none;">
                Back
            </a>
        </div>

    </form>
</div>

<script>
    // Refresh page when changing location
    document.getElementById('locationSelect').addEventListener('change', function () {
        window.location.href = "goods-issue?soId=${order.id}&locationId=" + this.value;
    });
</script>
```

</body>
</html>
