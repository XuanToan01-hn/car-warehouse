<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Warehouse Management</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    </head>
    <body>
        <div class="container mt-4">
            <h2 class="mb-3">Quản lý Warehouse (kho)</h2>

            <!-- Nút thêm mới -->
            <div class="mb-3">
                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#warehouseModal">
                    <i class="fas fa-plus"></i> Thêm Warehouse mới
                </button>
            </div>

            <!-- Modal Warehouse -->
            <div class="modal fade" id="warehouseModal" tabindex="-1" role="dialog" aria-labelledby="warehouseModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-xl" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="warehouseModalLabel">Add New Warehouse</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p class="text-muted small mb-3">Enter basic information to create a warehouse</p>
                            <form id="warehouseForm" action="${pageContext.request.contextPath}/warehouses" method="post">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Warehouse Code</label>
                                        <input type="text" name="warehouseCode" id="warehouseCode" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Warehouse Name</label>
                                        <input type="text" name="warehouseName" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Address</label>
                                        <input type="text" name="address" class="form-control">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label>Description</label>
                                        <textarea name="description" class="form-control" rows="3"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer" style="border-top: none; padding: 0; margin-top: 20px;">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Save Warehouse</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Danh sách warehouse -->
            <div class="card">
                <div class="card-header">
                    Danh sách warehouse
                </div>
                <div class="card-body">
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Address</th>
                                <th>Description</th>
                                <th>Created At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="w" items="${warehouses}">
                                <tr>
                                    <td>${w.id}</td>
                                    <td>${w.warehouseCode}</td>
                                    <td>${w.warehouseName}</td>
                                    <td>${w.address}</td>
                                    <td>${w.description}</td>
                                    <td>${w.createdAt}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/warehouses?action=delete&id=${w.id}" 
                                           class="btn btn-danger btn-sm" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa warehouse này?')">
                                            <i class="fas fa-trash"></i> Delete
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        <script>
            // Focus vào input đầu tiên khi modal mở
            $('#warehouseModal').on('shown.bs.modal', function () {
                $('#warehouseCode').focus();
            });
        </script>
    </body>
    </html>

