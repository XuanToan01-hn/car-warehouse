<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Tax Management</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        <style>
            #taxModal .modal-dialog {
                max-width: 1100px;
            }

            #taxModal .modal-title {
                font-size: 1.35rem;
                font-weight: 700;
            }

            #taxModal .text-muted.small {
                font-size: 0.95rem;
            }

            #taxModal label {
                font-weight: 600;
                margin-bottom: 8px;
            }

            #taxModal .form-control {
                padding: 12px 14px;
                font-size: 1.05rem;
            }

            #taxModal .btn {
                padding: 10px 16px;
                font-size: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <h2 class="mb-3">Quản lý Tax (thuế)</h2>

            <div class="mb-3">
                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#taxModal">
                    <i class="fas fa-plus"></i> Thêm Tax mới
                </button>
            </div>

            <!-- Add Tax Modal -->
            <div class="modal fade" id="taxModal" tabindex="-1" role="dialog" aria-labelledby="taxModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="taxModalLabel">Add New Tax</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p class="text-muted small mb-3">Enter basic information to create a tax</p>
                            <form id="taxForm" action="${pageContext.request.contextPath}/taxes" method="post">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Tax Name</label>
                                        <input type="text" name="taxName" id="taxName" class="form-control" required placeholder="VD: VAT 10%">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Tax Rate (%)</label>
                                        <input type="number" name="taxRate" class="form-control" required step="0.01" min="0" placeholder="VD: 10">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Effective From</label>
                                        <input type="date" name="effectiveFrom" class="form-control">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Expired Date</label>
                                        <input type="date" name="expiredDate" class="form-control">
                                    </div>
                                </div>
                                <div class="modal-footer" style="border-top: none; padding: 0; margin-top: 20px;">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Save Tax</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tax table -->
            <div class="card">
                <div class="card-header">
                    Danh sách tax
                </div>
                <div class="card-body">
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tax Name</th>
                                <th>Tax Rate (%)</th>
                                <th>Effective From</th>
                                <th>Expired Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty taxes}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">Chưa có dữ liệu tax.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="t" items="${taxes}">
                                        <tr>
                                            <td>${t.id}</td>
                                            <td>${t.taxName}</td>
                                            <td>${t.taxRate}</td>
                                            <td>${t.effectiveFrom}</td>
                                            <td>${t.expiredDate}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/taxes?action=delete&id=${t.id}"
                                                   class="btn btn-danger btn-sm"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa tax này?')">
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
            $('#taxModal').on('shown.bs.modal', function () {
                $('#taxName').focus();
            });
        </script>
    </body>
    </html>

