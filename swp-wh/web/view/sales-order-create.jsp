<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Tạo Sales Order</title>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">
</head>

<body>
    <div id="loading">
        <div id="loading-center"></div>
    </div>
    <div class="wrapper">
        <%@ include file="sidebar.jsp" %>
        <%@ include file="header.jsp" %>
        <div class="content-page">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <div class="header-title">
                                    <h4 class="card-title">Tạo Sales Order Mới</h4>
                                </div>
                                <a href="${pageContext.request.contextPath}/sales-order?action=list" class="btn btn-secondary">
                                    Quay lại
                                </a>
                            </div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/sales-order" method="post" id="orderForm">
                                    <input type="hidden" name="action" value="create">

                                    <!-- Error Messages -->
                                    <c:if test="${not empty inventoryErrors}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <strong>Lỗi tồn kho:</strong>
                                            <ul class="mb-0 mt-2">
                                                <c:forEach items="${inventoryErrors}" var="error">
                                                    <li>${error}</li>
                                                </c:forEach>
                                            </ul>
                                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                    </c:if>

                                    <!-- Header Information -->
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label font-weight-bold">Khách Hàng</label>
                                                <select name="customerId" class="form-control" required>
                                                    <option value="">-- Chọn Khách Hàng --</option>
                                                    <c:forEach var="c" items="${customers}">
                                                        <option value="${c.id}">${c.name} (${c.customerCode})</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label class="form-label font-weight-bold">Ghi Chú</label>
                                                <textarea name="note" class="form-control" rows="2" placeholder="Ghi chú bổ sung..."></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Products Section -->
                                    <div class="card mt-3">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">
<%--                                                <i class="fas fa-box mr-2"></i>--%>
                                                Sản Phẩm
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div id="items-container"></div>
                                            <button type="button" class="btn btn-info mt-3" onclick="addItem()">
<%--                                                <i class="fas fa-plus mr-2"></i>--%>
                                                Thêm Sản Phẩm
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="row mt-4">
                                        <div class="col-12">
                                            <button type="submit" class="btn btn-primary">
<%--                                                <i class="fas fa-save mr-2"></i>--%>
                                                Lưu Đơn Hàng
                                            </button>
                                            <a href="${pageContext.request.contextPath}/sales-order?action=list" class="btn btn-secondary ml-2">
<%--                                                <i class="fas fa-times mr-2"></i>--%>
                                                Hủy
                                            </a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Template for Product Items -->
    <template id="item-template">
        <div class="row mb-3">
            <div class="col-md-5">
                <div class="form-group">
                    <label class="form-label small font-weight-bold">Sản Phẩm</label>
                    <select name="productDetailId" class="form-control product-select" required>
                        <option value="">-- Chọn Sản Phẩm --</option>
                        <c:forEach var="pd" items="${productDetails}">
                            <option value="${pd.id}" data-price="${pd.product.price}">
                                ${pd.product.name} - Lot: ${pd.lotNumber} / SN: ${pd.serialNumber}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label class="form-label small font-weight-bold">Số Lượng</label>
                    <input type="number" name="quantity" class="form-control" value="1" min="1" required>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <label class="form-label small font-weight-bold">Đơn Giá</label>
                    <input type="number" name="price" class="form-control" step="0.01" required>
                </div>
            </div>
            <div class="col-md-3">
                <div class="form-group">
                    <label class="form-label small font-weight-bold">&nbsp;</label>
                    <button type="button" class="btn btn-danger btn-block btn-sm" onclick="this.closest('.row').remove()">
                        <i class="fas fa-trash mr-1"></i>Xóa
                    </button>
                </div>
            </div>
        </div>
    </template>

    <footer class="iq-footer">
        <div class="container-fluid">
            <div class="card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-6">
                            <ul class="list-inline mb-0">
                                <li class="list-inline-item"><a href="#">Privacy Policy</a></li>
                                <li class="list-inline-item"><a href="#">Terms of Use</a></li>
                            </ul>
                        </div>
                        <div class="col-lg-6 text-right">
                            <span class="mr-1">
                                <script>document.write(new Date().getFullYear())</script>©
                            </span>
                            <a href="#">POS Dash</a>.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>
    <script async src="${pageContext.request.contextPath}/assets/js/chart-custom.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    <script>
        function addItem() {
            const container = document.getElementById('items-container');
            const template = document.getElementById('item-template').content.cloneNode(true);

            const select = template.querySelector('.product-select');
            const priceInput = template.querySelector('input[name="price"]');

            select.addEventListener('change', function() {
                const selectedOption = this.options[this.selectedIndex];
                const price = selectedOption.getAttribute('data-price');
                if (price) {
                    priceInput.value = price;
                }
            });

            container.appendChild(template);
        }

        // Initialize with one empty item
        window.addEventListener('load', function() {
            addItem();
        });
    </script>
</body>

</html>