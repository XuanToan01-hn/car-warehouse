<%-- Document : transfer-list Created on : Mar 3, 2026, 1:18:53 AM Author : Asus --%>

    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Danh Sách Yêu Cầu Chuyển Kho</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            </head>

            <body class="bg-light">
                <div class="container mt-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>2. Internal Stock Transfer Notes</h2>
                        <a href="internal-transfer?action=form" class="btn btn-success">+ Tạo yêu cầu mới</a>
                    </div>

                    <c:if test="${not empty sessionScope.msg}">
                        <div class="alert alert-success">${sessionScope.msg}</div>
                        <c:remove var="msg" scope="session" />
                    </c:if>

                    <div class="card shadow border-0">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>Mã Đơn</th>
                                    <th>Lộ trình</th>
                                    <th>Sản phẩm (Detail ID)</th>
                                    <th>Số lượng</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${pendingList}" var="item">
                                    <tr>
                                        <td><strong>${item.transferCode}</strong></td>
                                        <td>Loc ${item.fromLocationId} &rarr; Loc ${item.toLocationId}</td>
                                        <td>${item.productDetailId}</td>
                                        <td class="fw-bold text-primary">${item.quantity}</td>
                                        <td>
                                            <form action="internal-transfer" method="POST">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="transferId" value="${item.id}">
                                                <button type="submit" class="btn btn-primary btn-sm">Xác nhận chuyển
                                                    (Record)</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </body>

            </html>