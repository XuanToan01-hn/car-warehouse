<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>WMS | Purchase Order Result</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
</head>
<body>
<div class="wrapper">
  <div class="content-page">
    <div class="container-fluid">
      <div class="row">
        <div class="col-lg-12">
          <div class="alert alert-success" role="alert">
            <div class="iq-alert-icon">
              <i class="ri-check-line"></i>
            </div>
            <div class="iq-alert-text">
              <strong>Success!</strong> Đã nhận dữ liệu thành công từ Form!
            </div>
          </div>
        </div>

        <div class="col-lg-4">
          <div class="card card-block card-stretch card-height">
            <div class="card-header d-flex justify-content-between">
              <div class="header-title">
                <h4 class="card-title">General Information</h4>
              </div>
            </div>
            <div class="card-body">
              <ul class="list-group list-group-flush">
                <li class="list-group-item d-flex justify-content-between align-items-center">
                  Supplier ID
                  <span class="badge badge-primary badge-pill">${res_supplierID}</span>
                </li>
                <li class="list-group-item d-flex justify-content-between align-items-center">
                  Created Date
                  <span class="font-weight-bold">${res_createdDate}</span>
                </li>
                <c:if test="${not empty statusofpo}">
                  <li class="list-group-item d-flex justify-content-between align-items-center">
                    Status PO Code
                    <span class="badge badge-warning badge-pill">${statusofpo}</span>
                  </li>
                </c:if>
              </ul>
              <div class="mt-4">
                <a href="${pageContext.request.contextPath}/view/purchase/purchase-create.jsp" class="btn btn-outline-primary btn-block">
                  <i class="las la-arrow-left"></i> Create Another Order
                </a>
                <a href="${pageContext.request.contextPath}/list-purchase" class="btn btn-primary btn-block">
                  <i class="las la-list"></i> Go to List
                </a>
              </div>
            </div>
          </div>
        </div>

        <div class="col-lg-8">
          <div class="card card-block card-stretch card-height">
            <div class="card-header d-flex justify-content-between">
              <div class="header-title">
                <h4 class="card-title">Order Details</h4>
                <p class="mb-0 text-muted">Total items: <strong>${fn:length(res_productIDs)}</strong></p>
              </div>
            </div>
            <div class="card-body p-0">
              <div class="table-responsive">
                <table class="table table-striped mb-0">
                  <thead class="bg-white text-uppercase">
                  <tr class="ligth">
                    <th scope="col">#</th>
                    <th scope="col">Product ID</th>
                    <th scope="col" class="text-center">Quantity</th>
                    <th scope="col" class="text-right">Price</th>
                    <th scope="col" class="text-right">Total</th>
                  </tr>
                  </thead>
                  <tbody>
                  <c:if test="${not empty res_productIDs}">
                    <c:forEach var="pid" items="${res_productIDs}" varStatus="status">
                      <tr>
                        <td>${status.count}</td>
                        <td class="font-weight-bold text-primary">${pid}</td>
                        <td class="text-center">
                          <span class="badge bg-info">${res_quantities[status.index]}</span>
                        </td>
                        <td class="text-right font-weight-bold">
                            ${res_prices[status.index]}
                        </td>
                        <td class="text-right">
                            ${res_quantities[status.index] * res_prices[status.index]}
                        </td>
                      </tr>
                    </c:forEach>
                  </c:if>
                  <c:if test="${empty res_productIDs}">
                    <tr>
                      <td colspan="5" class="text-center text-danger py-4">
                        <i class="las la-exclamation-circle" style="font-size: 24px;"></i><br>
                        No product details received!
                      </td>
                    </tr>
                  </c:if>
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

<script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>