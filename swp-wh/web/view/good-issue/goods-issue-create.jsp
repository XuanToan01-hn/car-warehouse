<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Tạo Phiếu Xuất Kho | InventoryPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
    <style>
        .table-input { width: 80px; padding: 5px; border: 1px solid #cbd5e1; border-radius: 4px; text-align: center; }
        .stock-badge { font-weight: bold; padding: 4px 8px; border-radius: 4px; }
        .low-stock { background-color: #fee2e2; color: #ef4444; }
        .enough-stock { background-color: #dcfce7; color: #15803d; }
        .color-tag { background: #f1f5f9; padding: 2px 6px; border-radius: 4px; font-size: 0.8rem; border: 1px solid #e2e8f0; }
    </style>
</head>
<body style="padding: 2rem; background: #f1f5f9;">
    <div style="background: white; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
        <h2>Tạo Phiếu Xuất Kho - Đơn ${order.orderCode}</h2>
        
        <c:if test="${not empty errors}">
            <div style="background: #fff1f2; color: #be123c; padding: 1rem; border-radius: 8px; margin-bottom: 1rem; border: 1px solid #fecdd3;">
                <ul style="margin: 0;"><c:forEach items="${errors}" var="e"><li>${e}</li></c:forEach></ul>
            </div>
        </c:if>

        <form action="goods-issue" method="post">
            <input type="hidden" name="soId" value="${order.id}">
            
            <div style="margin-bottom: 1.5rem; display: flex; align-items: center; gap: 1rem;">
                <label style="font-weight: 600;">Vị Trí Xuất:</label>
                <select name="locationId" id="locationSelect" class="form-control" style="width: 250px;" required>
                    <c:forEach items="${locations}" var="l">
                        <option value="${l.id}" ${param.locationId == l.id ? 'selected' : ''}>
                            ${l.locationName}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <table class="table" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                        <th style="padding: 12px; text-align: left;">Sản Phẩm</th>
                        <th style="text-align: center;">Màu</th> <th style="text-align: center;">Đặt</th>
                        <th style="text-align: center;">Đã Giao</th>
                        <th style="text-align: center;">Còn Nợ</th>
                        <th style="text-align: center;">Tồn Kho</th>
                        <th style="text-align: center; width: 120px;">Giao Lần Này</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${uiDetails}" var="row">
                        <c:if test="${row[4] > 0}">
                            <tr style="border-bottom: 1px solid #f1f5f9;">
                                <td style="padding: 12px;">
                                    <span style="font-weight: 600;">${row[0]}</span> <br>
                                    <small style="color: #64748b;">Lô: ${row[1]}</small>
                                    <input type="hidden" name="pdId" value="${row[6]}">
                                </td>
                                <td align="center">
                                    <span class="color-tag">${not empty row[7] ? row[7] : 'N/A'}</span>
                                </td>
                                <td align="center">${row[2]}</td>
                                <td align="center">${row[3]}</td>
                                <td align="center" style="color: #ef4444; font-weight: bold;">${row[4]}</td>
                                <td align="center">
                                    <span class="stock-badge ${row[5] < row[4] ? 'low-stock' : 'enough-stock'}">
                                        ${row[5]}
                                    </span>
                                </td>
                                <td align="center">
                                    <input type="number" name="shipQty" value="" class="table-input" placeholder="0" max="${row[5]}" min="0">
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </tbody>
            </table>

            <div style="margin-top: 1.5rem;">
                <label style="font-weight: 600;">Ghi chú:</label>
                <textarea name="note" class="form-control" rows="2" placeholder="Lý do xuất thiếu, v.v..."></textarea>
            </div>

            <div style="margin-top: 2rem;">
                <button type="submit" class="btn btn-primary" style="padding: 0.6rem 2rem;">Xác Nhận Xuất Kho</button>
                <a href="sales-order?action=warehouse-list" style="margin-left: 1rem; color: #64748b;">Hủy</a>
            </div>
        </form>
    </div>

    <script>
        document.getElementById('locationSelect').addEventListener('change', function() {
            window.location.href = "goods-issue?soId=${order.id}&locationId=" + this.value;
        });
    </script>
</body>
</html>