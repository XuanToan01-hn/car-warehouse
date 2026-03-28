<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Xác nhận xuất kho | InventoryPro</title>

    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">
    
    <style>
        .table-input { 
            width: 85px; 
            padding: 5px; 
            border: 1px solid #ced4da; 
            border-radius: 4px; 
            text-align: center; 
        }
        .stock-badge { 
            font-weight: 600; 
            padding: 4px 10px; 
            border-radius: 4px; 
            font-size: 0.85rem; 
        }
        .low-stock { background-color: #fff0f0; color: #f35a5a; border: 1px solid #f35a5a; }
        .enough-stock { background-color: #e5f9f6; color: #00b69b; border: 1px solid #00b69b; }
        .pending-qty { color: #f35a5a; font-weight: bold; }
        .select-label { font-weight: bold; color: #555; }
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
                        <c:if test="${not empty errors}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <div class="iq-alert-icon"><i class="ri-information-line"></i></div>
                                <div class="iq-alert-text">
                                    <c:forEach items="${errors}" var="e">
                                        <div>• ${e}</div>
                                    </c:forEach>
                                </div>
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                    <i class="ri-close-line"></i>
                                </button>
                            </div>
                        </c:if>

                        <div class="card card-block card-stretch card-height">
                            <div class="card-header d-flex justify-content-between">
                                <div class="header-title">
                                    <h4 class="card-title">Xác Nhận Xuất Kho: <span class="text-primary">${order.orderCode}</span></h4>
                                    <p class="mb-0 small text-muted">Chọn nhà kho, vị trí và nhập số lượng thực xuất cho từng sản phẩm.</p>
                                </div>
                                <div class="card-header-toolbar d-flex align-items-center">
                                    <a href="goods-issue" class="btn btn-light">
                                        <i class="fas fa-arrow-left mr-1"></i>Quay lại
                                    </a>
                                </div>
                            </div>
                            
                            <div class="card-body">
                                <form action="goods-issue" method="post">
                                    <%-- Hidden ID để Submit --%>
                                    <input type="hidden" name="soId" value="${order.id}">

                                    <%-- BỘ CHỌN: KHO CỐ ĐỊNH & VỊ TRÍ --%>
                                    <div class="row mb-4 p-3 bg-light rounded">
                                        <div class="col-md-5">
                                            <div class="form-group mb-0">
                                                <label class="select-label"><i class="fas fa-warehouse mr-1"></i> Nhà Kho (Cố định từ Đơn hàng):</label>
                                                <input type="text" class="form-control mt-1" value="${order.getWarehouse().getWarehouseName()} (${order.getWarehouse().getWarehouseCode()})" readonly>
                                                <input type="hidden" name="warehouseId" id="warehouseSelect" value="${order.warehouse.id}">
                                            </div>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="form-group mb-0">
                                                <label class="select-label"><i class="fas fa-map-marker-alt mr-1"></i> Vị Trí Lấy Hàng (Bin/Location):</label>
                                                <select name="locationId" id="locationSelect" class="form-control mt-1">
                                                    <c:if test="${empty locations}">
                                                        <option value="">-- Kho này chưa có dữ liệu vị trí --</option>
                                                    </c:if>
                                                    <c:forEach items="${locations}" var="l">
                                                        <option value="${l.id}" ${selectedLocId == l.id ? 'selected' : ''}>
                                                            ${l.locationName} (${l.locationCode})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- DANH SÁCH SẢN PHẨM --%>
                                    <div class="table-responsive">
                                        <table class="table table-hover table-bordered mb-0">
                                            <thead class="bg-primary text-white">
                                                <tr>
                                                    <th>Sản Phẩm & Phân Loại</th>
                                                    <th class="text-center">Số Lượng Đặt</th>
                                                    <th class="text-center">Đã Giao</th>
                                                    <th class="text-center">Còn Nợ</th>
                                                    <th class="text-center">Tồn Tại Vị Trí</th>
                                                    <th class="text-center" style="width: 160px;">Số Lượng Xuất</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:set var="hasItems" value="false" />
                                                <c:forEach items="${uiDetails}" var="row">
                                                    <c:if test="${row[4] > 0}"> <%-- Chỉ hiện nếu Còn Nợ > 0 --%>
                                                        <c:set var="hasItems" value="true" />
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-center">
                                                                    <div>
                                                                        <div class="font-weight-bold">${row[0]}</div>
                                                                        <div class="small text-muted">
                                                                            Màu: ${row[7]} | Lot/Serial: <span class="badge badge-info">${row[1]}</span>
                                                                        </div>
                                                                        <input type="hidden" name="pdId" value="${row[6]}">
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td class="text-center font-weight-bold">${row[2]}</td>
                                                            <td class="text-center text-primary">${row[3]}</td>
                                                            <td class="text-center"><span class="pending-qty">${row[4]}</span></td>
                                                            <td class="text-center">
                                                                <span class="stock-badge ${row[5] < row[4] ? 'low-stock' : 'enough-stock'}">
                                                                    ${row[5]}
                                                                </span>
                                                            </td>
                                                            <td class="text-center">
                                                                <input type="number" 
                                                                       name="shipQty" 
                                                                       class="table-input" 
                                                                       min="0" 
                                                                       max="${row[5] < row[4] ? row[5] : row[4]}" 
                                                                       value="0"
                                                                       onfocus="if(this.value=='0') this.value='';"
                                                                       onblur="if(this.value=='') this.value='0';">
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${!hasItems}">
                                                    <tr>
                                                        <td colspan="6" class="text-center p-4">
                                                            <i class="fas fa-check-double text-success fa-2x mb-2"></i>
                                                            <p class="mb-0">Đơn hàng này đã hoàn thành xuất kho hoặc không còn sản phẩm nào cần giao.</p>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>

                                    <%-- NÚT XÁC NHẬN --%>
                                    <div class="mt-4 border-top pt-3 text-right">
                                        <button type="submit" class="btn btn-primary btn-lg ${!hasItems ? 'disabled' : ''}" ${!hasItems ? 'disabled' : ''}>
                                            <i class="fas fa-shipplane mr-1"></i> Hoàn Tất Phiếu Xuất
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    
    <script>
        // Khi thay đổi VỊ TRÍ -> Load lại trang để cập nhật Tồn kho (Stock) tại vị trí đó
        document.getElementById('locationSelect').addEventListener('change', function () {
            const locId = this.value;
            window.location.href = "goods-issue?action=create&soId=${order.id}&locationId=" + locId;
        });
    </script>
</body>
</html>