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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/customerManagement.css">
        <style>
            #customerAddModal .modal-dialog,
            #customerEditModal .modal-dialog {
                max-width: 640px;
            }
            #customerAddModal .modal-title,
            #customerEditModal .modal-title {
                font-size: 1.35rem;
                font-weight: 700;
            }
            #customerAddModal label,
            #customerEditModal label {
                font-weight: 600;
                margin-bottom: 8px;
            }
            #customerAddModal .form-control,
            #customerEditModal .form-control {
                padding: 10px 12px;
            }
            #customerAddModal textarea.form-control,
            #customerEditModal textarea.form-control {
                min-height: 80px;
            }
            .table-actions .btn { margin-right: 4px; }
            .search-wrap { max-width: 400px; }
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <h2 class="mb-3">Quản lý Khách hàng</h2>

            <div class="d-flex flex-wrap align-items-center justify-content-between mb-3 gap-2">
                <div class="d-flex align-items-center gap-2">
                    <button type="button" class="btn btn-success" data-toggle="modal" data-target="#customerAddModal">
                        <i class="fas fa-plus"></i> Thêm khách hàng
                    </button>
                    <div class="input-group search-wrap">
                        <input type="text" id="searchCustomer" class="form-control" placeholder="Tìm theo mã, tên, SĐT, email...">
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary" type="button" id="btnClearSearch" title="Xóa bộ lọc">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Thêm khách hàng -->
            <div class="modal fade" id="customerAddModal" tabindex="-1" role="dialog" aria-labelledby="customerAddModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
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
                                <div class="form-group">
                                    <label for="addCustomerCode">Mã khách hàng <span class="text-danger">*</span></label>
                                    <input type="text" name="customerCode" id="addCustomerCode" class="form-control" required placeholder="VD: KH001">
                                </div>
                                <div class="form-group">
                                    <label for="addName">Họ tên <span class="text-danger">*</span></label>
                                    <input type="text" name="name" id="addName" class="form-control" required>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="addPhone">Số điện thoại</label>
                                        <input type="text" name="phone" id="addPhone" class="form-control" placeholder="VD: 0901234567">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="addEmail">Email</label>
                                        <input type="email" name="email" id="addEmail" class="form-control" placeholder="email@example.com">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="addAddress">Địa chỉ</label>
                                    <textarea name="address" id="addAddress" class="form-control" rows="2" placeholder="Địa chỉ liên hệ"></textarea>
                                </div>
                                <div class="modal-footer border-top pt-3 mt-3 px-0 pb-0">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Lưu</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Sửa khách hàng -->
            <div class="modal fade" id="customerEditModal" tabindex="-1" role="dialog" aria-labelledby="customerEditModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="customerEditModalLabel">Cập nhật khách hàng</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form id="customerEditForm" action="${pageContext.request.contextPath}/customers" method="post">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="customerId" id="editCustomerId">
                                <div class="form-group">
                                    <label for="editCustomerCode">Mã khách hàng <span class="text-danger">*</span></label>
                                    <input type="text" name="customerCode" id="editCustomerCode" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label for="editName">Họ tên <span class="text-danger">*</span></label>
                                    <input type="text" name="name" id="editName" class="form-control" required>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="editPhone">Số điện thoại</label>
                                        <input type="text" name="phone" id="editPhone" class="form-control">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="editEmail">Email</label>
                                        <input type="email" name="email" id="editEmail" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="editAddress">Địa chỉ</label>
                                    <textarea name="address" id="editAddress" class="form-control" rows="2"></textarea>
                                </div>
                                <div class="modal-footer border-top pt-3 mt-3 px-0 pb-0">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Xóa -->
            <div class="modal fade" id="customerDeleteModal" tabindex="-1" role="dialog" aria-labelledby="customerDeleteModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header border-0 pb-0">
                            <h5 class="modal-title" id="customerDeleteModalLabel">Xác nhận xóa</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body pt-0">
                            <p class="mb-2">Bạn có chắc chắn muốn xóa khách hàng <strong id="deleteCustomerCode"></strong>?</p>
                            <p class="text-muted small mb-0">Thao tác này không thể hoàn tác.</p>
                        </div>
                        <div class="modal-footer border-top">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                            <form id="customerDeleteForm" action="${pageContext.request.contextPath}/customers" method="post" class="d-inline">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="customerId" id="deleteCustomerId">
                                <button type="submit" class="btn btn-danger">Xóa</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bảng danh sách -->
            <div class="card">
                <div class="card-header">
                    Danh sách khách hàng
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover table-striped mb-0" id="customerTable">
                            <thead class="thead-light">
                                <tr>
                                    <th style="width: 50px;">STT</th>
                                    <th>Mã KH</th>
                                    <th>Họ tên</th>
                                    <th>Số điện thoại</th>
                                    <th>Email</th>
                                    <th>Địa chỉ</th>
                                    <th style="width: 140px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty customers}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">Chưa có dữ liệu khách hàng.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="c" items="${customers}" varStatus="st">
                                            <tr data-code="${c.customerCode}" data-name="${c.name}" data-phone="${c.phone}" data-email="${c.email}" data-address="${c.address}">
                                                <td>${st.index + 1}</td>
                                                <td>${c.customerCode}</td>
                                                <td>${c.name}</td>
                                                <td>${c.phone}</td>
                                                <td>${c.email}</td>
                                                <td>${c.address}</td>
                                                <td class="table-actions">
                                                    <button type="button" class="btn btn-sm btn-outline-primary btn-edit" data-id="${c.id}" data-code="${c.customerCode}" data-name="${c.name}" data-phone="${c.phone}" data-email="${c.email}" data-address="${c.address}" title="Sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-sm btn-outline-danger btn-delete" data-id="${c.id}" data-code="${c.customerCode}" title="Xóa">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
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
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        <script>
            (function () {
                var $search = $('#searchCustomer');
                var $tbody = $('#customerTable tbody');
                var $rows = $('#customerTable tbody tr[data-code]');

                function filterRows() {
                    var q = ($search.val() || '').toLowerCase().trim();
                    var stt = 0;
                    $rows.each(function () {
                        if (!q) {
                            $(this).show();
                            $(this).find('td:first').text(++stt);
                            return;
                        }
                        var code = ($(this).data('code') || '').toLowerCase();
                        var name = ($(this).data('name') || '').toLowerCase();
                        var phone = ($(this).data('phone') || '').toLowerCase();
                        var email = ($(this).data('email') || '').toLowerCase();
                        var match = code.indexOf(q) >= 0 || name.indexOf(q) >= 0 || phone.indexOf(q) >= 0 || email.indexOf(q) >= 0;
                        $(this).toggle(match);
                        if (match) $(this).find('td:first').text(++stt);
                    });
                }

                $search.on('input', filterRows);
                $('#btnClearSearch').on('click', function () {
                    $search.val('');
                    filterRows();
                    $search.focus();
                });

                $('#customerTable').on('click', '.btn-edit', function () {
                    var id = $(this).data('id'), code = $(this).data('code'), name = $(this).data('name');
                    var phone = $(this).data('phone') || '', email = $(this).data('email') || '', address = $(this).data('address') || '';
                    $('#editCustomerId').val(id);
                    $('#editCustomerCode').val(code);
                    $('#editName').val(name);
                    $('#editPhone').val(phone);
                    $('#editEmail').val(email);
                    $('#editAddress').val(address);
                    $('#customerEditModal').modal('show');
                });

                $('#customerTable').on('click', '.btn-delete', function () {
                    $('#deleteCustomerId').val($(this).data('id'));
                    $('#deleteCustomerCode').text($(this).data('code'));
                    $('#customerDeleteModal').modal('show');
                });

                $('#customerAddModal').on('shown.bs.modal', function () {
                    $('#addCustomerCode').focus();
                });
            })();
        </script>
    </body>
</html>
