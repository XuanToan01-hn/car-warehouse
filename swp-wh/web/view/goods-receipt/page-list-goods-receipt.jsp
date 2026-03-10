<%--
Document   : page-goods-receipt-list
Created on : 2026
Author     : Updated by Gemini
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>

<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Goods Receipt List</title>

```
<link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">

<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">
```

</head>

<body>

<div id="loading">
    <div id="loading-center"></div>
</div>

<div class="wrapper">

```
<%@ include file="../sidebar.jsp" %>
<jsp:include page="../header.jsp" />

<div class="content-page">
    <div class="container-fluid">

        <div class="row">
            <div class="col-sm-12">

                <div class="card">

                    <div class="card-header d-flex justify-content-between align-items-center">

                        <div class="header-title">
                            <h4 class="card-title">
                                <i class="fas fa-clipboard-check mr-2"></i>
                                Goods Receipt Order List
                            </h4>
                        </div>

                        <a href="${pageContext.request.contextPath}/create-goods-receipt"
                           class="btn btn-primary">
                            <i class="fas fa-plus mr-1"></i>
                            Create New GRO
                        </a>

                    </div>

                    <div class="card-body">

                        <form method="get"
                              action="${pageContext.request.contextPath}/goods-receipt"
                              class="row mb-3">

                            <div class="col-md-5">
                                <input type="text"
                                       name="keyword"
                                       class="form-control"
                                       placeholder="Search by GRO code, PO code..."
                                       value="${keyword}">
                            </div>

                            <div class="col-md-3">
                                <select name="status" class="form-control">

                                    <option value="0" ${status==0 ? 'selected' : '' }>
                                        -- All Status --
                                    </option>

                                    <option value="1" ${status==1 ? 'selected' : '' }>
                                        Draft
                                    </option>

                                    <option value="2" ${status==2 ? 'selected' : '' }>
                                        Completed
                                    </option>

                                    <option value="3" ${status==3 ? 'selected' : '' }>
                                        Cancelled
                                    </option>

                                </select>
                            </div>

                            <div class="col-md-2">

                                <button type="submit" class="btn btn-primary mr-2">
                                    <i class="fas fa-search mr-1"></i>
                                    Search
                                </button>

                                <a href="${pageContext.request.contextPath}/goods-receipt"
                                   class="btn btn-warning">
                                    <i class="fas fa-undo mr-1"></i>
                                    Reset
                                </a>

                            </div>

                        </form>

                        <div class="table-responsive">

                            <table class="table table-bordered table-hover">

                                <thead class="thead-light">

                                <tr>
                                    <th>#</th>
                                    <th>GRO Code</th>
                                    <th>Purchase Order</th>
                                    <th>Location</th>
                                    <th>Received Date</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>

                                </thead>

                                <tbody>

                                <c:choose>

                                    <c:when test="${empty grList}">
                                        <tr>
                                            <td colspan="7"
                                                class="text-center text-muted py-4">
                                                <i class="fas fa-inbox fa-2x mb-2 d-block"></i>
                                                No data available
                                            </td>
                                        </tr>
                                    </c:when>

                                    <c:otherwise>

                                        <c:forEach var="gr"
                                                   items="${grList}"
                                                   varStatus="st">

                                            <tr>

                                                <td>
                                                    ${(page-1)*pageSize + st.index + 1}
                                                </td>

                                                <td>
                                                    <strong class="text-primary">
                                                        ${gr.receiptCode}
                                                    </strong>
                                                </td>

                                                <td>
                                                    <code>
                                                        ${gr.purchaseOrder.orderCode}
                                                    </code>
                                                </td>

                                                <td>
                                                    ${gr.location.locationName}
                                                </td>

                                                <td>
                                                    <fmt:formatDate
                                                            value="${gr.receiptDate}"
                                                            pattern="dd/MM/yyyy HH:mm" />
                                                </td>

                                                <td>

                                                    <c:choose>

                                                        <c:when test="${gr.status == 1}">
                                                            <span class="badge badge-warning">
                                                                Draft
                                                            </span>
                                                        </c:when>

                                                        <c:when test="${gr.status == 2}">
                                                            <span class="badge badge-success">
                                                                Completed
                                                            </span>
                                                        </c:when>

                                                        <c:when test="${gr.status == 3}">
                                                            <span class="badge badge-danger">
                                                                Cancelled
                                                            </span>
                                                        </c:when>

                                                        <c:otherwise>
                                                            <span class="badge badge-secondary">
                                                                ${gr.status}
                                                            </span>
                                                        </c:otherwise>

                                                    </c:choose>

                                                </td>

                                                <td>

                                                    <a href="${pageContext.request.contextPath}/detail-goods-receipt?id=${gr.id}"
                                                       class="btn btn-sm btn-info">

                                                        <i class="fas fa-eye mr-1"></i>
                                                        Details

                                                    </a>

                                                </td>

                                            </tr>

                                        </c:forEach>

                                    </c:otherwise>

                                </c:choose>

                                </tbody>

                            </table>

                        </div>

                        <c:if test="${totalPages > 1}">

                            <nav>

                                <ul class="pagination justify-content-center">

                                    <li class="page-item ${page <= 1 ? 'disabled' : ''}">

                                        <a class="page-link"
                                           href="?keyword=${keyword}&status=${status}&page=${page-1}">
                                            «
                                        </a>

                                    </li>

                                    <c:forEach begin="1" end="${totalPages}" var="p">

                                        <li class="page-item ${p == page ? 'active' : ''}">

                                            <a class="page-link"
                                               href="?keyword=${keyword}&status=${status}&page=${p}">
                                                ${p}
                                            </a>

                                        </li>

                                    </c:forEach>

                                    <li class="page-item ${page >= totalPages ? 'disabled' : ''}">

                                        <a class="page-link"
                                           href="?keyword=${keyword}&status=${status}&page=${page+1}">
                                            »
                                        </a>

                                    </li>

                                </ul>

                            </nav>

                        </c:if>

                        <p class="text-muted text-center">
                            Total: <strong>${total}</strong> receipts
                        </p>

                    </div>

                </div>

            </div>
        </div>

    </div>
</div>
```

</div>

<footer class="iq-footer">

```
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

                    <span>
                        <script>document.write(new Date().getFullYear())</script>©
                    </span>

                    <a href="#">POS Dash</a>.

                </div>

            </div>

        </div>

    </div>

</div>
```

</footer>

<script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>

<script src="${pageContext.request.contextPath}/assets/js/app.js"></script>

</body>

</html>
