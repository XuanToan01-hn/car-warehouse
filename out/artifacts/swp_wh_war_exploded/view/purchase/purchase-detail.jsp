<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>WMS | Purchase Order Detail</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">

    <style>
        .detail-label {
            font-weight: 600;
            color: #676E8A;
        }
        .detail-value {
            font-size: 1.1rem;
        }
        .item-table th {
            background-color: #f4f5fa;
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
                            <h4 class="mb-3">Purchase Order Detail</h4>
                            <p class="mb-0">View details of the selected purchase order.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/list-purchase" class="btn btn-secondary">
                            <i class="las la-arrow-left mr-3"></i>Back to List
                        </a>
                    </div>
                </div>

                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-header">
                            Order Information
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><span class="detail-label">Order Code:</span> <span class="detail-value">${po.orderCode}</span></p>
                                    <p><span class="detail-label">Supplier:</span> <span class="detail-value">${po.supplierID}</span></p>
                                    <p><span class="detail-label">Created By:</span> <span class="detail-value">${po.createBy}</span></p>
                                </div>
                                <div class="col-md-6">
                                    <p><span class="detail-label">Status:</span>
                                        <c:choose>
                                            <c:when test="${po.status == 2}"><span class="badge bg-success">Confirmed</span></c:when>
                                            <c:when test="${po.status == 3}"><span class="badge bg-primary">Received</span></c:when>
                                            <c:when test="${po.status == 4}"><span class="badge bg-danger">Cancelled</span></c:when>
                                            <c:otherwise><span class="badge bg-warning">Draft</span></c:otherwise>
                                        </c:choose>
                                    </p>
                                    <p><span class="detail-label">Created Date:</span> <span class="detail-value">${po.createdDate}</span></p>
                                    <p><span class="detail-label">Total Amount:</span> <span class="detail-value font-weight-bold"><fmt:formatNumber value="${po.totalAmount}" type="currency" currencySymbol="$"/></span></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card mt-4">
                        <div class="card-header">
                            Order Items
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered table-striped item-table">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Product ID</th>
                                    <th>Quantity</th>
                                    <th>Price</th>
                                    <th>Total</th>
                                </tr>
                                </thead>
                                <tbody>
                                <!-- Giả sử có list items, thay bằng dữ liệu thực tế -->
                                <c:forEach var="item" items="${po.items}" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td>${item.productID}</td>
                                        <td>${item.quantity}</td>
                                        <td>${item.price}</td>
                                        <td>${item.quantity * item.price}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>