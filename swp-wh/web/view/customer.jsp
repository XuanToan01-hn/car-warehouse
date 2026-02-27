<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Khách Hàng</title>
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
                                    <h4 class="card-title">Danh Sách Khách Hàng</h4>
                                </div>
                                <button class="btn btn-primary" data-toggle="modal" data-target="#customerModal" onclick="prepareAdd()">
                                    <i class="fas fa-plus mr-1"></i> Thêm Khách Hàng Mới
                                </button>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="form-group">
                                        <input type="text" id="searchInput" class="form-control" placeholder="Tìm kiếm theo mã, tên hoặc số điện thoại...">
                                    </div>
                                </div>

                                <div class="table-responsive">
                                    <table class="table table-bordered table-hover">
                                        <thead class="thead-light">
                                            <tr>
                                                <th>#</th>
                                                <th>Mã Khách Hàng</th>
                                                <th>Tên Khách Hàng</th>
                                                <th>Số Điện Thoại</th>
                                                <th>Email</th>
                                                <th>Địa Chỉ</th>
                                                <th class="text-right">Hành Động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${customers}" varStatus="status">
                                                <tr class="customer-row">
                                                    <td>${status.index + 1}</td>
                                                    <td>
                                                        <span class="font-weight-bold text-primary">${c.customerCode}</span>
                                                    </td>
                                                    <td>
                                                        <span class="font-weight-bold">${c.name}</span>
                                                    </td>
                                                    <td>${c.phone}</td>
                                                    <td>${c.email}</td>
                                                    <td>${c.address}</td>
                                                    <td class="text-right">
                                                        <button class="btn btn-sm btn-info mr-2" onclick="prepareEdit('${c.id}')">
<%--                                                            <i class="fas fa-edit mr-1"></i>--%>
                                                            Sửa
                                                        </button>
                                                        <a href="customers?action=delete&id=${c.id}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn xóa khách hàng này?')">
<%--                                                            <i class="fas fa-trash mr-1"></i> --%>
                                                            Xóa
                                                        </a>
                                                    </td>
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
    </div>

    <!-- Modal Add/Edit Customer -->
    <div class="modal fade" id="customerModal" tabindex="-1" role="dialog" aria-labelledby="customerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="form-title">Thêm Khách Hàng Mới</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="customerForm" action="customers" method="post">
                        <input type="hidden" name="action" id="form-action" value="add">
                        <input type="hidden" name="customerId" id="c-id">

                        <div class="form-group">
                            <label class="form-label">Mã Khách Hàng</label>
                            <input type="text" name="customerCode" id="f-code" class="form-control" placeholder="VD: CUST-001" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Tên Khách Hàng</label>
                            <input type="text" name="name" id="f-name" class="form-control" placeholder="Nhập tên khách hàng" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Số Điện Thoại</label>
                            <input type="text" name="phone" id="f-phone" class="form-control" placeholder="Nhập số điện thoại">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" id="f-email" class="form-control" placeholder="example@mail.com">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Địa Chỉ</label>
                            <input type="text" name="address" id="f-address" class="form-control" placeholder="Nhập địa chỉ">
                        </div>

                        <div class="text-right">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary ml-2">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

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
        function prepareAdd() {
            document.getElementById('form-title').innerText = "Thêm Khách Hàng Mới";
            document.getElementById('form-action').value = "add";
            document.getElementById('customerForm').reset();
            document.getElementById('c-id').value = "";
        }

        function prepareEdit(id) {
            fetch('customers?action=getDetailJson&id=' + id)
                .then(r => r.json())
                .then(data => {
                    document.getElementById('form-title').innerText = "Cập Nhật Khách Hàng";
                    document.getElementById('form-action').value = "update";
                    document.getElementById('c-id').value = data.id;
                    document.getElementById('f-code').value = data.customerCode || '';
                    document.getElementById('f-name').value = data.name || '';
                    document.getElementById('f-phone').value = data.phone || '';
                    document.getElementById('f-email').value = data.email || '';
                    document.getElementById('f-address').value = data.address || '';
                    $('#customerModal').modal('show');
                })
                .catch(err => {
                    console.error('Error loading customer:', err);
                    alert('Lỗi khi tải dữ liệu khách hàng');
                });
        }

        // Search logic
        const searchInput = document.getElementById('searchInput');
        const tableRows = document.querySelectorAll('.customer-row');

        searchInput.addEventListener('input', function () {
            const query = this.value.toLowerCase().trim();

            tableRows.forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        });
    </script>
</body>

</html>
