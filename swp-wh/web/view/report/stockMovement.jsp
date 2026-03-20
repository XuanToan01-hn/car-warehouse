<%-- 
    Document   : stockMovement
    Created on : Mar 20, 2026, 1:24:58 AM
    Author     : Asus
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Nhật Ký Kho</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-4">
        <div class="card shadow-sm">
            <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                <span>Nhật Ký Nhập/Xuất Chi Tiết</span>
                <form action="stock-movement" class="d-flex mb-0">
                    <input type="text" name="search" class="form-control form-control-sm me-2" placeholder="Tìm mã phiếu...">
                    <button class="btn btn-sm btn-primary">Tìm</button>
                </form>
            </div>
            <div class="table-responsive">
                <table class="table table-sm table-striped">
                    <thead class="table-light">
                        <tr>
                            <th>Ngày Giờ</th>
                            <th>Loại</th>
                            <th>Sản Phẩm</th>
                            <th>Số Lượng</th>
                            <th>Tham Chiếu</th>
                            <th>Vị Trí</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${movements}" var="m">
                            <tr>
                                <td>${m.transactionDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${m.transactionType == 1}"><span class="text-success">NHẬP</span></c:when>
                                        <c:otherwise><span class="text-danger">XUẤT</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${m.product.name}</td>
                                <td class="fw-bold">${m.quantity}</td>
                                <td><code>${m.referenceCode}</code></td>
                                <td>${m.location.locationCode}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
