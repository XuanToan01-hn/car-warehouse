<%-- 
    Document   : location-product-list.jsp
    Created on : Feb 25, 2026, 10:20:02 AM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory by Location | InventoryPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
    <style>
        body { font-family: 'Be Vietnam Pro', sans-serif; padding: 2rem; background: #f1f5f9; }
        .card { background: white; border-radius: 16px; padding: 2rem; box-shadow: 0 4px 20px rgba(0,0,0,0.05); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 12px; background: #f8fafc; color: #64748b; border-bottom: 2px solid #edf2f7; }
        td { padding: 12px; border-bottom: 1px solid #f1f5f9; }
        .btn-add { background: #2563eb; color: white; padding: 8px 16px; border-radius: 8px; text-decoration: none; font-weight: 600; }
        .badge { background: #dcfce7; color: #166534; padding: 4px 8px; border-radius: 6px; font-size: 0.85rem; }
    </style>
</head>
<body>
    <div class="card">
        <div class="header">
            <h1>Stock by Location</h1>
            <a href="location-product?action=add" class="btn-add">+ Add Stock to Location</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Location</th>
                    <th>Product</th>
                    <th>Specs (Color/Lot)</th>
                    <th>Quantity</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${items}" var="item">
                    <tr>
                        <td><strong>${item.location.locationName}</strong><br><small>${item.location.locationCode}</small></td>
                        <td>${item.productDetail.product.name}</td>
                        <td>
                            <span class="badge">${item.productDetail.color}</span>
                            <small>Lot: ${item.productDetail.lotNumber}</small>
                        </td>
                        <td style="font-weight: 700; color: #2563eb;">${item.quantity}</td>
                        <td>
                            <a href="location-product?action=delete&locId=${item.location.id}&pdId=${item.productDetail.id}" 
                               style="color: #ef4444;" onclick="return confirm('Remove stock from this location?')">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
