<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>POS Dash | Inventory Logs</title>

        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">
        
        <style>
            /* Màu sắc cho nhập/xuất kho */
            .badge-income { background-color: #e5f9f6; color: #00b69b; border: 1px solid #00b69b; padding: 5px 10px; }
            .badge-outcome { background-color: #fff0f0; color: #f35a5a; border: 1px solid #f35a5a; padding: 5px 10px; }
            
            /* Hiển thị số lượng trừ kho cho nổi bật */
            .qty-minus { color: #f35a5a; font-weight: 800; font-size: 1.1rem; }
            .qty-plus { color: #00b69b; font-weight: 800; font-size: 1.1rem; }
            
            .order-info { font-weight: bold; color: #333; }
            .table thead th { vertical-align: middle; background-color: #f8f9fa; }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>
            <jsp:include page="../header.jsp" />

            <div class="content-page">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="card card-block card-stretch card-height">
                                <div class="card-header d-flex justify-content-between">
                                    <div class="header-title">
                                        <h4 class="card-title">Nhật Ký Xuất/Nhập Kho Chi Tiết</h4>
                                        <p class="mb-0 small text-muted">Theo dõi lịch sử trừ tồn kho theo từng đơn hàng Sales Order</p>
                                    </div>
                                    <div class="card-header-toolbar d-flex align-items-center">
                                        <form action="inventory-log" method="get" class="d-flex">
                                            <input type="text" name="searchOrder" value="${searchOrder}" class="form-control form-control-sm mr-2" placeholder="Tìm mã đơn SO...">
                                            <select name="type" onchange="this.form.submit()" class="form-control form-control-sm mr-2">
                                                <option value="0">Tất cả</option>
                                                <option value="2" ${selectedType == 2 ? 'selected' : ''}>Chỉ xem Xuất Kho</option>
                                                <option value="1" ${selectedType == 1 ? 'selected' : ''}>Chỉ xem Nhập Kho</option>
                                            </select>
                                            <button type="submit" class="btn btn-primary btn-sm">Lọc</button>
                                        </form>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered mb-0">
                                            <thead>
                                                <tr class="ligth">
                                                    <th>Ngày Giờ</th>
                                                    <th>Mã Đơn Hàng</th>
                                                    <th>Sản Phẩm & Chi Tiết</th>
                                                    <th>Kho/Vị Trí</th>
                                                    <th class="text-center">Loại</th>
                                                    <th class="text-center">Số Lượng Biến Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="t" items="${transactions}">
                                                    <tr>
                                                        <%-- 1. Ngày giao dịch --%>
                                                        <td>
                                                            <fmt:formatDate value="${t.transactionDate}" pattern="dd/MM/yyyy"/><br/>
                                                            <small class="text-muted"><fmt:formatDate value="${t.transactionDate}" pattern="HH:mm:ss"/></small>
                                                        </td>

                                                        <%-- 2. Mã Đơn Hàng (Hiển thị trực tiếp) --%>
                                                        <td class="order-info">
                                                            <c:choose>
                                                                <c:when test="${not empty t.salesOrder}">
                                                                    <span class="text-primary">${t.salesOrder.orderCode}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">${t.referenceCode}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

  

                                                        <%-- 4. Sản phẩm --%>
                                                        <td>
                                                            <strong>${t.productDetail.product.name}</strong><br/>
                                                            <small>Màu: ${t.productDetail.color} | SKU: ${t.productDetail.product.code}</small>
                                                        </td>

                                                        <%-- 5. Vị trí kho --%>
                                                        <td>
                                                            <span class="badge badge-light">
                                                                <i class="fas fa-box mr-1"></i>${t.location.locationName}
                                                            </span>
                                                        </td>

                                                        <%-- 6. Loại giao dịch (Nhập/Xuất) --%>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${t.transactionType == 1}">
                                                                    <span class="badge badge-income">NHẬP KHO</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-outcome">XUẤT KHO</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>

                                                        <%-- 7. SỐ LƯỢNG (Điểm mấu chốt: trừ bao nhiêu cái) --%>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${t.transactionType == 1}">
                                                                    <span class="qty-plus">+${t.quantity}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="qty-minus">-${t.quantity}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>

                                                <c:if test="${empty transactions}">
                                                    <tr>
                                                        <td colspan="7" class="text-center py-5 text-secondary">
                                                            Không có dữ liệu log xuất nhập kho cho điều kiện tìm kiếm này.
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>

                                    <%-- Pagination --%>
                                    <div class="d-flex justify-content-between align-items-center mt-3">
                                        <div>Hiển thị trang ${currentPage} / ${totalPages}</div>
                                        <nav>
                                            <ul class="pagination mb-0">
                                                <c:if test="${currentPage > 1}">
                                                    <li class="page-item"><a class="page-link" href="inventory-log?page=${currentPage-1}&searchOrder=${searchOrder}&type=${selectedType}">Trước</a></li>
                                                </c:if>
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                        <a class="page-link" href="inventory-log?page=${i}&searchOrder=${searchOrder}&type=${selectedType}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                                <c:if test="${currentPage < totalPages}">
                                                    <li class="page-item"><a class="page-link" href="inventory-log?page=${currentPage+1}&searchOrder=${searchOrder}&type=${selectedType}">Tiếp</a></li>
                                                </c:if>
                                            </ul>
                                        </nav>
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