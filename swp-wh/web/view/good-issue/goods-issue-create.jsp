<%-- 
    Document   : goods-issue-create
    Created on : Feb 25, 2026, 10:55:54 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Xuất Kho | InventoryPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
</head>
<body style="padding: 2rem; background: #f1f5f9;">
    <div style="background: white; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
        <h2>Tạo Phiếu Xuất Kho - Đơn ${order.orderCode}</h2>
        
        <c:if test="${not empty errors}">
            <div style="color: red; margin-bottom: 1rem;">
                <ul><c:forEach items="${errors}" var="e"><li>${e}</li></c:forEach></ul>
            </div>
        </c:if>

        <form action="goods-issue" method="post">
            <input type="hidden" name="soId" value="${order.id}">
            <div style="margin-bottom: 1rem;">
                <label>Chọn Vị Trí Xuất Hàng:</label>
                <select name="locationId" class="form-control" required>
                    <c:forEach items="${locations}" var="l">
                        <option value="${l.id}">${l.locationName} (${l.locationCode})</option>
                    </c:forEach>
                </select>
            </div>

            <table class="table" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #f8fafc;">
                        <th style="padding: 10px; text-align: left;">Sản Phẩm</th>
                        <th>Đặt</th>
                        <th>Đã Giao</th>
                        <th>Còn Lại</th>
                        <th>Giao Lần Này</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${order.details}" var="d">
                        <c:set var="rem" value="${d.quantity - d.deliveredQty}" />
                        <c:if test="${rem > 0}">
                            <tr style="border-bottom: 1px solid #eee;">
                                <td style="padding: 10px;">
                                    ${d.productDetail.product.name}
                                    <input type="hidden" name="pdId" value="${d.productDetail.id}">
                                </td>
                                <td align="center">${d.quantity}</td>
                                <td align="center">${d.deliveredQty}</td>
                                <td align="center" style="color: red; font-weight: bold;">${rem}</td>
                                <td align="center">
                                    <input type="number" name="shipQty" value="${rem}" max="${rem}" min="0" style="width: 60px;">
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>
            <div style="margin-top: 2rem;">
                <button type="submit" class="btn btn-primary">Xác Nhận Giao Hàng</button>
                <a href="sales-order?action=view&id=${order.id}" style="margin-left: 1rem;">Hủy</a>
            </div>
        </form>
    </div>
</body>
</html>
