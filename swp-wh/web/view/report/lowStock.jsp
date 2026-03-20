<%-- 
    Document   : lowStock
    Created on : Mar 20, 2026, 1:24:38 AM
    Author     : Asus
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Cảnh Báo Hàng Tồn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow border-0">
            <div class="card-header bg-danger text-white">
                <h4 class="mb-0">⚠️ Sản Phẩm Dưới Định Mức (Ngưỡng: ${threshold})</h4>
            </div>
            <div class="card-body">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Mã SP</th>
                            <th>Tên Sản Phẩm</th>
                            <th>Số Lô</th>
                            <th>Tồn Hiện Tại</th>
                            <th>Trạng Thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${lowStockList}" var="pd">
                            <tr>
                                <td>${pd.product.code}</td>
                                <td>${pd.product.name}</td>
                                <td>${pd.lotNumber}</td>
                                <td class="text-danger fw-bold">${pd.quantity}</td>
                                <td>
                                    <span class="badge bg-warning text-dark">Cần nhập thêm</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
