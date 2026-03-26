<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Cảnh Báo Tồn Kho | InventoryPro</title>

    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">
    
    <style>
        .low-stock-row { background-color: #fff8f8; }
        .qty-critical { color: #f35a5a; font-weight: 800; font-size: 1.1rem; }
        .badge-warning-custom { background-color: #fff4e5; color: #ff9800; border: 1px solid #ff9800; }
    </style>
</head>
<body class="color-light">
    <div class="wrapper">
        <%@ include file="../sidebar.jsp" %>
        <jsp:include page="../header.jsp" />

        <div class="content-page">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="alert bg-white alert-danger shadow-sm mb-4" role="alert">
                            <div class="iq-alert-icon">
                                <i class="ri-error-warning-line"></i>
                            </div>
                            <div class="iq-alert-text">
                                <h5 class="alert-heading text-danger">Danh sách sản phẩm sắp hết hàng!</h5>
                                <p class="mb-0">Các sản phẩm dưới đây có số lượng tồn kho thấp hơn ngưỡng định mức <strong>(${threshold})</strong>. Vui lòng kiểm tra và lên kế hoạch nhập hàng.</p>
                            </div>
                        </div>

                        <div class="card card-block card-stretch card-height">
                            <div class="card-header d-flex justify-content-between">
                                <div class="header-title">
                                    <h4 class="card-title">Sản Phẩm Dưới Định Mức</h4>
                                </div>
                                <div class="card-header-toolbar d-flex align-items-center">
                                    <button onclick="window.print()" class="btn btn-light btn-sm mr-2">
                                        <i class="fas fa-print mr-1"></i> In danh sách
                                    </button>
                                    <a href="create-goods-receipt" class="btn btn-primary btn-sm">
                                        <i class="fas fa-plus mr-1"></i> Tạo đơn nhập hàng
                                    </a>
                                </div>
                            </div>
                            
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered mb-0">
                                        <thead>
                                            <tr class="ligth bg-danger text-white">
                                                <th>Mã SP</th>
                                                <th>Thông Tin Sản Phẩm</th>
                                                <th>Số Lô</th>
                                                <th class="text-center">Số Lượng Tồn</th>
                                                <th class="text-center">Trạng Thái</th>
<!--                                                <th class="text-center">Hành Động</th>-->
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${lowStockList}" var="pd">
                                                <tr class="low-stock-row">
                                                    <td class="font-weight-bold">#${pd.product.code}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div>
                                                                <strong>${pd.product.name}</strong>
                                                                <br>
                                                                <small class="text-muted">Phân loại: ${pd.color}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="badge badge-light">
                                                            <i class="fas fa-tag mr-1 text-secondary"></i>${pd.lotNumber}
                                                        </span>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="qty-critical">${pd.quantity}</span>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge badge-warning-custom">
                                                            <i class="fas fa-exclamation-triangle mr-1"></i> Cần nhập thêm
                                                        </span>
                                                    </td>
<!--                                                    <td class="text-center">
                                                        <div class="d-flex align-items-center justify-content-center list-action">
                                                            <a class="badge badge-info mr-2" data-toggle="tooltip" data-placement="top" title="Xem chi tiết" href="product-detail?id=${pd.id}">
                                                                <i class="ri-eye-line mr-0"></i>
                                                            </a>
                                                            <a class="badge bg-success mr-2" data-toggle="tooltip" data-placement="top" title="Nhập hàng" href="purchase?pdId=${pd.id}">
                                                                <i class="ri-add-box-line mr-0"></i>
                                                            </a>
                                                        </div>
                                                    </td>-->
                                                </tr>
                                            </c:forEach>
                                            
                                            <c:if test="${empty lowStockList}">
                                                <tr>
                                                    <td colspan="6" class="text-center py-5">
                                                        <img src="${pageContext.request.contextPath}/assets/images/no-data.png" alt="No data" style="width: 100px; opacity: 0.5;">
                                                        <p class="mt-2 text-muted">Hiện tại không có sản phẩm nào dưới định mức.</p>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
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