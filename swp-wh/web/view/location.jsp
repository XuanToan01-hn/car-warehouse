<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Location Management</title>

        <!-- CSS giống style đang dùng ở trang login -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
    </head>
    <body>
        <div class="container mt-4">
            <h2 class="mb-4">Quản lý Location (vị trí kho)</h2>

            <!-- Form tạo location mới -->
            <div class="card mb-4">
                <div class="card-header">
                    Thêm location mới
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/locations" method="post">
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label>Warehouse</label>
                                <select name="warehouseId" class="form-control" required>
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
                                <input type="text" name="locationCode" class="form-control" required>
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

                        <button type="submit" class="btn btn-primary">Lưu Location</button>
                    </form>
                </div>
            </div>

            <!-- Bảng danh sách location -->
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
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    </body>
    </html>

