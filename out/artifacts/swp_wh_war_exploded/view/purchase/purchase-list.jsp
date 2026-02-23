<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>WMS | Purchase Order List</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">

    <style>
        .data-code {
            font-weight: 600;
            color: #0e5699;
            white-space: nowrap;
        }

        .data-supplier {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 180px;
            display: block;
        }

        .list-action {
            justify-content: flex-start;
            gap: 8px;
        }

        .badge-status-pending { background-color: #ffc107; color: #fff; }
        .badge-status-approved { background-color: #28a745; color: #fff; }
        .badge-status-rejected { background-color: #dc3545; color: #fff; }

        .filter-section {
            padding: 15px;
            background-color: #fff;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <div class="content-page">
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-12">
                    <div class="d-flex flex-wrap align-items-center justify-content-between mb-4">
                        <div>
                            <h4 class="mb-3">Purchase Orders</h4>
                            <p class="mb-0">Manage your purchase orders, track status and approvals.</p>
                        </div>
                        <a style="color: #fff" href="${pageContext.request.contextPath}/createpo" class="btn btn-primary add-list">
                            <i class="las la-plus mr-3"></i>Create Purchase Order
                        </a>
                    </div>
                </div>

                <div class="col-lg-12">
                    <div class="rounded mb-3">
                        <div class="filter-section mb-4 shadow-sm">
                            <form method="get" action="${pageContext.request.contextPath}/list-purchase">
                                <div class="row">
                                    <div class="col-md-2">
                                        <select name="status" class="form-control" onchange="this.form.submit()">
                                            <option value="">All Status</option>
                                            <option value="1" ${param.status == '1' ? 'selected' : ''}>Draft</option>
                                            <option value="2" ${param.status == '2' ? 'selected' : ''}>Confirmed</option>
                                            <option value="3" ${param.status == '3' ? 'selected' : ''}>Received</option>
                                            <option value="4" ${param.status == '4' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                    </div>

                                    <div class="col-md-4">
                                        <div class="input-group">
                                            <input type="text" name="search" class="form-control"
                                                   placeholder="Search by Order Code or Supplier..."
                                                   value="${param.search}">
                                        </div>
                                    </div>

                                    <div class="col-md-1">
                                        <button type="submit" class="btn btn-primary">Search</button>
                                    </div>
                                </div>
                            </form>
                        </div>

                        <div class="card">
                            <div class="card-header">
                                Danh sách Purchase Orders
                            </div>
                            <div class="card-body">
                                <table class="table table-bordered table-striped">
                                    <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Order Code</th>
                                        <th>Supplier</th>
                                        <th>Status</th>
                                        <th>Created Date</th>
                                        <th>Total Amount</th>
                                        <th>Created By</th>
                                        <th>Action</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="po" items="${listPO}">
                                        <tr>
                                            <td>${po.purchaseOrderID}</td>
                                            <td class="data-code">${po.orderCode}</td>
                                            <td>
                                                <span class="data-supplier" title="${po.supplierID}">
                                                        ${po.supplierID}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${po.status == 2}">
                                                        <span class="badge bg-success">Confirmed</span>
                                                    </c:when>
                                                    <c:when test="${po.status == 3}">
                                                        <span class="badge bg-primary">Received</span>
                                                    </c:when>
                                                    <c:when test="${po.status == 4}">
                                                        <span class="badge bg-danger">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning">Draft</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${po.createdDate}</td>
                                            <td class="font-weight-bold">
                                                <fmt:formatNumber value="${po.totalAmount}" type="currency" currencySymbol="$"/>
                                            </td>
                                            <td>${po.createBy}</td>
                                            <td>
                                                <div class="d-flex align-items-center list-action">
                                                    <a class="badge bg-info mr-2" data-toggle="tooltip" data-placement="top"
                                                       title="View Detail" href="${pageContext.request.contextPath}/viewpoindetail?id=${po.purchaseOrderID}">
                                                        <i class="ri-eye-line mr-0"></i> View
                                                    </a>
                                                    <c:if test="${po.status == 1}">
                                                        <a class="badge bg-success mr-2" data-toggle="tooltip" data-placement="top"
                                                           title="Approve Order" href="${pageContext.request.contextPath}/confirm?id=${po.purchaseOrderID}">
                                                            <i class="ri-check-line mr-0"></i> Approve
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                                <c:if test="${empty listPO}">
                                    <div class="text-center p-4">
                                        <p class="text-muted mb-0">No purchase orders found.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>