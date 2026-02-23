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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
        <style>
            body { background-color: var(--light-gray, #f4f5fa); }
            .customer-page { max-width: 1280px; margin: 0 auto; padding: 1.5rem; }
            .page-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                flex-wrap: wrap;
                gap: 1rem;
                margin-bottom: 1.5rem;
            }
            .page-title {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--gray-dark, #01041b);
                margin: 0;
            }
            .page-title .icon-wrap {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                background: linear-gradient(135deg, var(--primary, #32BDEA) 0%, var(--skyblue, #158df7) 100%);
                color: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
            }
            .toolbar {
                display: flex;
                align-items: center;
                gap: 0.75rem;
                flex-wrap: wrap;
            }
            .btn-add-customer {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.6rem 1.25rem;
                font-weight: 600;
                border-radius: 10px;
                border: none;
                background: linear-gradient(135deg, var(--success, #78C091) 0%, #5fb87a 100%);
                color: #fff;
                box-shadow: 0 2px 8px rgba(120, 192, 145, 0.4);
            }
            .btn-add-customer:hover { color: #fff; opacity: 0.95; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(120, 192, 145, 0.45); }
            .search-box {
                position: relative;
                width: 100%;
                max-width: 280px;
            }
            .search-box .form-control {
                padding-left: 2.5rem;
                border-radius: 10px;
                border: 1px solid #e2e6ec;
                height: 42px;
            }
            .search-box .form-control:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(50, 189, 234, 0.15); }
            .search-box .search-icon {
                position: absolute;
                left: 14px;
                top: 50%;
                transform: translateY(-50%);
                color: #9ca3af;
                pointer-events: none;
            }
            .search-box .btn-clear {
                position: absolute;
                right: 8px;
                top: 50%;
                transform: translateY(-50%);
                padding: 4px 8px;
                color: #9ca3af;
                border: none;
                background: none;
            }
            .search-box .btn-clear:hover { color: var(--danger); }
            .card-customer {
                border: none;
                border-radius: 14px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.06);
                overflow: hidden;
            }
            .card-customer .card-header {
                background: #fff;
                border-bottom: 1px solid #eef1f5;
                padding: 1rem 1.25rem;
                font-weight: 700;
                font-size: 1rem;
                color: var(--gray-dark);
            }
            .table-customer {
                margin: 0;
            }
            .table-customer thead th {
                background: #f8f9fc;
                color: #4b5563;
                font-weight: 600;
                font-size: 0.8rem;
                text-transform: uppercase;
                letter-spacing: 0.02em;
                padding: 1rem 1rem;
                border-bottom: 1px solid #eef1f5;
            }
            .table-customer tbody td {
                padding: 1rem;
                vertical-align: middle;
                border-bottom: 1px solid #f0f2f5;
            }
            .table-customer tbody tr:hover { background-color: #fafbfc; }
            .table-customer .col-stt { width: 56px; text-align: center; color: #9ca3af; font-weight: 600; }
            .table-customer .col-code { font-weight: 600; color: var(--gray-dark); }
            .table-customer .col-name { font-weight: 500; }
            .table-customer .col-actions { width: 110px; text-align: center; }
            .btn-action {
                width: 34px;
                height: 34px;
                padding: 0;
                border-radius: 8px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                margin: 0 2px;
                border: 1px solid #e5e7eb;
                background: #fff;
                color: #6b7280;
            }
            .btn-action:hover { background: #f3f4f6; color: var(--primary); border-color: #d1d5db; }
            .btn-action.btn-edit:hover { color: var(--skyblue); }
            .btn-action.btn-delete:hover { color: var(--danger); border-color: #fecaca; background: #fef2f2; }
            .empty-state {
                padding: 3rem 1.5rem;
                text-align: center;
                color: #9ca3af;
            }
            .empty-state .empty-icon { font-size: 3.5rem; margin-bottom: 1rem; opacity: 0.5; }
            .empty-state .empty-text { font-size: 1rem; }
            /* Modal form - giống warehouse & location */
            #customerAddModal .modal-dialog,
            #customerEditModal .modal-dialog {
                max-width: 1100px;
            }
            #customerAddModal .modal-title,
            #customerEditModal .modal-title {
                font-size: 1.35rem;
                font-weight: 700;
            }
            #customerAddModal .text-muted.small,
            #customerEditModal .text-muted.small {
                font-size: 0.95rem;
            }
            #customerAddModal label,
            #customerEditModal label {
                font-weight: 600;
                margin-bottom: 8px;
            }
            #customerAddModal .form-control,
            #customerEditModal .form-control {
                padding: 12px 14px;
                font-size: 1.05rem;
            }
            #customerAddModal textarea.form-control,
            #customerEditModal textarea.form-control {
                min-height: 120px;
            }
            #customerAddModal .btn,
            #customerEditModal .btn {
                padding: 10px 16px;
                font-size: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="customer-page">
            <header class="page-header">
                <h1 class="page-title">
                    <span class="icon-wrap"><i class="fas fa-users"></i></span>
                    Quản lý Khách hàng
                </h1>
                <div class="toolbar">
                    <button type="button" class="btn btn-add-customer" data-toggle="modal" data-target="#customerAddModal">
                        <i class="fas fa-plus"></i> Thêm khách hàng
                    </button>
                    <div class="search-box">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" id="searchCustomer" class="form-control" placeholder="Tìm mã, tên, SĐT, email...">
                        <button type="button" class="btn-clear" id="btnClearSearch" title="Xóa bộ lọc" style="display: none;"><i class="fas fa-times"></i></button>
                    </div>
                </div>
            </header>

            <!-- Modal Thêm khách hàng -->
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

            <!-- Modal Sửa khách hàng -->
            <div class="modal fade" id="customerEditModal" tabindex="-1" role="dialog" aria-labelledby="customerEditModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="customerEditModalLabel">Cập nhật khách hàng</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p class="text-muted small mb-3">Chỉnh sửa thông tin khách hàng</p>
                            <form id="customerEditForm" action="${pageContext.request.contextPath}/customers" method="post">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="customerId" id="editCustomerId">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Mã khách hàng</label>
                                        <input type="text" name="customerCode" id="editCustomerCode" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Họ tên</label>
                                        <input type="text" name="name" id="editName" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Số điện thoại</label>
                                        <input type="text" name="phone" id="editPhone" class="form-control">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Email</label>
                                        <input type="email" name="email" id="editEmail" class="form-control">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label>Địa chỉ</label>
                                        <textarea name="address" id="editAddress" class="form-control" rows="3"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer" style="border-top: none; padding: 0; margin-top: 20px;">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Xóa -->
            <div class="modal fade" id="customerDeleteModal" tabindex="-1" role="dialog">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Xác nhận xóa</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        </div>
                        <div class="modal-body">
                            <p class="mb-0">Bạn có chắc chắn muốn xóa khách hàng <strong id="deleteCustomerCode"></strong>?</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
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
            <div class="card card-customer">
                <div class="card-header">Danh sách khách hàng</div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-customer" id="customerTable">
                            <thead>
                                <tr>
                                    <th class="col-stt">STT</th>
                                    <th>Mã KH</th>
                                    <th>Họ tên</th>
                                    <th>Số điện thoại</th>
                                    <th>Email</th>
                                    <th>Địa chỉ</th>
                                    <th class="col-actions">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty customers}">
                                        <tr>
                                            <td colspan="7">
                                                <div class="empty-state">
                                                    <div class="empty-icon"><i class="fas fa-users"></i></div>
                                                    <div class="empty-text">Chưa có khách hàng nào. Nhấn <strong>Thêm khách hàng</strong> để tạo mới.</div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="c" items="${customers}" varStatus="st">
                                            <tr data-code="${c.customerCode}" data-name="${c.name}" data-phone="${c.phone}" data-email="${c.email}" data-address="${c.address}">
                                                <td class="col-stt">${st.index + 1}</td>
                                                <td class="col-code">${c.customerCode}</td>
                                                <td class="col-name">${c.name}</td>
                                                <td>${c.phone}</td>
                                                <td>${c.email}</td>
                                                <td>${c.address}</td>
                                                <td class="col-actions">
                                                    <button type="button" class="btn btn-action btn-edit" data-id="${c.id}" data-code="${c.customerCode}" data-name="${c.name}" data-phone="${c.phone}" data-email="${c.email}" data-address="${c.address}" title="Sửa"><i class="fas fa-pen"></i></button>
                                                    <button type="button" class="btn btn-action btn-delete" data-id="${c.id}" data-code="${c.customerCode}" title="Xóa"><i class="fas fa-trash-alt"></i></button>
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
                var $btnClear = $('#btnClearSearch');
                var $rows = $('#customerTable tbody tr[data-code]');

                function filterRows() {
                    var q = ($search.val() || '').toLowerCase().trim();
                    $btnClear.toggle(!!q);
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
                $btnClear.on('click', function () {
                    $search.val('');
                    filterRows();
                    $search.focus();
                });

                $('#customerTable').on('click', '.btn-edit', function () {
                    var $t = $(this);
                    $('#editCustomerId').val($t.data('id'));
                    $('#editCustomerCode').val($t.data('code'));
                    $('#editName').val($t.data('name'));
                    $('#editPhone').val($t.data('phone') || '');
                    $('#editEmail').val($t.data('email') || '');
                    $('#editAddress').val($t.data('address') || '');
                    $('#customerEditModal').modal('show');
                });

                $('#customerTable').on('click', '.btn-delete', function () {
                    var $t = $(this);
                    $('#deleteCustomerId').val($t.data('id'));
                    $('#deleteCustomerCode').text($t.data('code'));
                    $('#customerDeleteModal').modal('show');
                });

                $('#customerAddModal').on('shown.bs.modal', function () {
                    $('#addCustomerCode').focus();
                });
            })();
        </script>
    </body>
</html>
