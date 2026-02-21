<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Quản lý Khách hàng</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        <style>
            #customerAddModal .modal-dialog {
                max-width: 1100px;
            }
            #customerAddModal .modal-title {
                font-size: 1.35rem;
                font-weight: 700;
            }
            #customerAddModal .text-muted.small {
                font-size: 0.95rem;
            }
            #customerAddModal label {
                font-weight: 600;
                margin-bottom: 8px;
            }
            #customerAddModal .form-control {
                padding: 12px 14px;
                font-size: 1.05rem;
            }
            #customerAddModal textarea.form-control {
                min-height: 120px;
            }
            #customerAddModal .btn {
                padding: 10px 16px;
                font-size: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <h2 class="mb-3">Quản lý Khách hàng (Customer)</h2>

            <div class="mb-3">
                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#customerAddModal">
                    <i class="fas fa-plus"></i> Thêm Customer mới
                </button>
            </div>

            <div class="modal fade" id="customerAddModal" tabindex="-1" role="dialog" aria-labelledby="customerAddModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="customerAddModalLabel">Thêm khách hàng</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p class="text-muted small mb-3">Nhập thông tin khách hàng mới</p>
                            <form id="customerAddForm" action="${pageContext.request.contextPath}/customers" method="post">
                                <input type="hidden" name="action" value="add">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Mã khách hàng</label>
                                        <input type="text" name="customerCode" id="addCustomerCode" class="form-control" required placeholder="VD: KH001">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Họ tên</label>
                                        <input type="text" name="name" id="addName" class="form-control" required placeholder="Nguyễn Văn A">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Số điện thoại</label>
                                        <input type="text" name="phone" id="addPhone" class="form-control" placeholder="0901234567">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Email</label>
                                        <input type="email" name="email" id="addEmail" class="form-control" placeholder="email@example.com">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label>Địa chỉ</label>
                                        <textarea name="address" id="addAddress" class="form-control" rows="3" placeholder="Địa chỉ liên hệ"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer" style="border-top: none; padding: 0; margin-top: 20px;">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Lưu</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    Danh sách customer
                </div>
                <div class="card-body">
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Mã KH</th>
                                <th>Họ tên</th>
                                <th>Số điện thoại</th>
                                <th>Email</th>
                                <th>Địa chỉ</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty customers}">
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-3">Chưa có dữ liệu khách hàng.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="c" items="${customers}">
                                        <tr>
                                            <td>${c.id}</td>
                                            <td>${c.customerCode}</td>
                                            <td>${c.name}</td>
                                            <td>${c.phone}</td>
                                            <td>${c.email}</td>
                                            <td>${c.address}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/customers?action=delete&id=${c.id}"
                                                   class="btn btn-danger btn-sm"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này?')">
                                                    <i class="fas fa-trash"></i> Delete
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        <script>
            $('#customerAddModal').on('shown.bs.modal', function () {
                $('#addCustomerCode').focus();
            });
        </script>
    </body>
</html>
