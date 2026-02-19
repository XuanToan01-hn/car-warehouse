<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Location Management</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        <style>
            #locationModal .modal-dialog {
                max-width: 1100px;
            }

            #locationModal .modal-title {
                font-size: 1.35rem;
                font-weight: 700;
            }

            #locationModal .text-muted.small {
                font-size: 0.95rem;
            }

            #locationModal label {
                font-weight: 600;
                margin-bottom: 8px;
            }

            #locationModal .form-control {
                padding: 12px 14px;
                font-size: 1.05rem;
            }

            #locationModal .btn {
                padding: 10px 16px;
                font-size: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <h2 class="mb-3">Quản lý Location (vị trí kho)</h2>

            <div class="mb-3">
                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#locationModal">
                    <i class="fas fa-plus"></i> Thêm Location mới
                </button>
            </div>

            <div class="modal fade" id="locationModal" tabindex="-1" role="dialog" aria-labelledby="locationModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="locationModalLabel">Add New Location</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p class="text-muted small mb-3">Enter basic information to create a location</p>
                            <form id="locationForm" action="${pageContext.request.contextPath}/locations" method="post">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Warehouse</label>
                                        <select name="warehouseId" id="warehouseId" class="form-control" required>
                                            <option value="">-- Chọn kho --</option>
                                            <c:forEach var="w" items="${warehouses}">
                                                <option value="${w.id}">
                                                    ${w.warehouseCode} - ${w.warehouseName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Location Code</label>
                                        <input type="text" name="locationCode" id="locationCode" class="form-control" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Location Name</label>
                                        <input type="text" name="locationName" class="form-control" required>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label>Parent Location ID (có thể để trống)</label>
                                        <input type="number" name="parentLocationId" class="form-control">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Location Type</label>
                                        <select name="locationType" class="form-control" required>
                                            <option value="ZONE">ZONE</option>
                                            <option value="RACK">RACK</option>
                                            <option value="BIN">BIN</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label>Max Capacity (có thể để trống)</label>
                                        <input type="number" name="maxCapacity" class="form-control" min="0">
                                    </div>
                                </div>
                                <div class="modal-footer" style="border-top: none; padding: 0; margin-top: 20px;">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Save Location</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    Danh sách location
                </div>
                <div class="card-body">
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Warehouse ID</th>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Parent ID</th>
                                <th>Type</th>
                                <th>Max Capacity</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="l" items="${locations}">
                                <tr>
                                    <td>${l.id}</td>
                                    <td>${l.warehouseId}</td>
                                    <td>${l.locationCode}</td>
                                    <td>${l.locationName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${l.parentLocationId != null}">
                                                ${l.parentLocationId}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${l.locationType}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${l.maxCapacity != null}">
                                                ${l.maxCapacity}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/locations?action=delete&id=${l.id}" 
                                           class="btn btn-danger btn-sm" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa location này?')">
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
            $('#locationModal').on('shown.bs.modal', function () {
                $('#warehouseId').focus();
            });
        </script>
    </body>
    </html>

