<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>POS Dash | Inventory History</title>

        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">
        
        <style>
            .badge-income { background-color: #e5f9f6; color: #00b69b; }
            .badge-outcome { background-color: #fff0f0; color: #f35a5a; }
            .text-qty-in { color: #00b69b; font-weight: bold; }
            .text-qty-out { color: #f35a5a; font-weight: bold; }
            .pagination a { min-width: 40px; text-align: center; }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="../sidebar.jsp" %>
        <jsp:include page="../header.jsp" />

            <div class="content-page">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="d-flex flex-wrap align-items-center justify-content-between mb-4">
                                <div>
                                    <h4 class="mb-3">Inventory Transactions</h4>
                                    <form action="inventory-log" method="get" class="searchbox-custom">
                                        <div class="d-flex align-items-center">
                                            <div class="mr-2">
                                                <input type="text" name="search" value="${search}" class="form-control" placeholder="Reference Code...">
                                            </div>
                                            <div class="mr-2">
                                                <select name="type" onchange="this.form.submit()" class="form-control">
                                                    <option value="0">-- All Types --</option>
                                                    <option value="1" ${selectedType == 1 ? 'selected' : ''}>Good Receipt (Nhập)</option>
                                                    <option value="2" ${selectedType == 2 ? 'selected' : ''}>Goods Issue (Xuất)</option>
                                                </select>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Search</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-12">
                            <div class="table-responsive rounded mb-3">
                                <table class="table mb-0">
                                    <thead class="bg-white text-uppercase">
                                        <tr class="ligth">
                                            <th>Date</th>
                                            <th>Reference</th>
                                            <th>Product Name</th>
                                            <th>Color</th>
                                            <th>Location</th>
                                            <th>Type</th>
                                            <th>Quantity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="t" items="${transactions}">
                                            <tr>
                                                <td><fmt:formatDate value="${t.transactionDate}" pattern="dd-MM-yyyy HH:mm"/></td>
                                                <td><span class="badge badge-primary">${t.referenceCode}</span></td>
                                                <td>${t.productDetail.product.name}</td>
                                                <td>${t.productDetail.color}</td>
                                                <td>${t.location.locationName}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${t.transactionType == 1}">
                                                            <span class="badge badge-income">Nhập Kho</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-outcome">Xuất Kho</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${t.transactionType == 1}">
                                                            <span class="text-qty-in">+${t.quantity}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-qty-out">-${t.quantity}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty transactions}">
                                            <tr>
                                                <td colspan="7" class="text-center text-danger">No transactions found for "${search}".</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <%-- Pagination - SỬA LINK TẠI ĐÂY --%>
                            <div class="pagination mt-3 d-flex justify-content-end">
                                <c:if test="${currentPage > 1}">
                                    <a href="inventory-log?page=${currentPage - 1}&search=${search}&type=${selectedType}" class="btn btn-outline-primary mx-1">&lt;</a>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <a href="inventory-log?page=${i}&search=${search}&type=${selectedType}" 
                                       class="${i == currentPage ? 'btn btn-primary' : 'btn btn-outline-primary'} mx-1">${i}</a>
                                </c:forEach>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="inventory-log?page=${currentPage + 1}&search=${search}&type=${selectedType}" class="btn btn-outline-primary mx-1">&gt;</a>
                                </c:if>
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