<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<h2>Phiếu Nhập Kho (Từ Đơn: ${purchaseOrder.orderCode})</h2>

<form action="GoodsReceiptController" method="post">
    <input type="hidden" name="action" value="save">
    <input type="hidden" name="purchaseOrderID" value="${purchaseOrder.purchaseOrderID}">

    <div class="info">
        <label>Kho nhập:</label>
        <select name="locationID">
            <c:forEach var="loc" items="${listLocations}">
                <option value="${loc.locationID}">${loc.name}</option>
            </c:forEach>
        </select>

        <label>Ngày nhập:</label>
        <input type="date" name="receiptDate" value="<%= java.time.LocalDate.now() %>">
    </div>

    <h3>Kiểm đếm hàng hóa</h3>
    <table border="1">
        <thead>
        <tr>
            <th>Sản phẩm</th>
            <th>Số lượng Đặt (Expected)</th>
            <th>Số lượng Thực Nhập (Actual)</th> <th>Số Lô (Lot Number)</th>         </tr>
        </thead>
        <tbody>
        <c:forEach var="detail" items="${purchaseOrderDetails}">
            <tr>
                <td>${detail.productName}</td>

                <input type="hidden" name="productID[]" value="${detail.productID}">

                <td>
                        ${detail.quantity}
                    <input type="hidden" name="expectedQty[]" value="${detail.quantity}">
                </td>

                <td>
                    <input type="number" name="actualQty[]" value="${detail.quantity}" min="0">
                </td>

                <td>
                    <input type="text" name="lotNumber[]" placeholder="Nhập số lô...">
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <br>
    <button type="submit">Xác nhận Nhập kho</button>
</form>