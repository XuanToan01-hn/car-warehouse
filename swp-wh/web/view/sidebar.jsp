<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<div class="iq-sidebar sidebar-default">
    <div class="iq-sidebar-logo d-flex align-items-center justify-content-between">
        <a href="index.jsp" class="header-logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" class="img-fluid rounded-normal light-logo" alt="logo">
            <h5 class="logo-title light-logo ml-3">POSDash</h5>
        </a>
        <div class="iq-menu-bt-sidebar ml-0">
            <a href="javascript:void(0)"><i class="las la-bars wrapper-menu"></i></a>
        </div>
    </div>

    <div class="data-scrollbar" data-scroll="1">
        <nav class="iq-sidebar-menu">
            <ul id="iq-sidebar-toggle" class="iq-menu">
                
                <%-- Sử dụng sessionScope.user để đồng nhất --%>
                <c:set var="u" value="${sessionScope.user}" />

                <%-- SECTION: ADMIN (ID = 1) --%>
                <c:if test="${u.role.id == 1}">
                    <li class="">
                        <a href="dash-board" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/dashboard.png" alt="image">
                            <span class="ml-4">Dashboards</span>
                        </a>
                    </li>
                    <li class="">
                        <a href="#user" class="collapsed" data-toggle="collapse" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/people.png" alt="image">
                            <span class="ml-4">User Management</span>
                        </a>
                        <ul id="user" class="iq-submenu collapse" data-parent="#iq-sidebar-toggle">
                            <li><a href="userlist"><i>&bull;</i><span>List Users</span></a></li>
                            <li><a href="registeruser"><i>&bull;</i><span>Add Users</span></a></li>
                        </ul>
                    </li>
                    <li class="">
                        <a href="permissions" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/permissions.png" alt="image">
                            <span class="ml-4">Permissions</span>
                        </a>
                    </li>
                </c:if>

                <%-- SECTION: SALES (ID = 2) --%>
                <c:if test="${u.role.id == 2}">
                    <li class="">
                        <a href="sales-order?action=list" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/sale.png" alt="image">
                            <span class="ml-4">Sale Order</span>
                        </a>
                    </li>
                </c:if>


                <c:if test="${u.role.id == 2 || u.role.id == 3 ||u.role.id == 5}">
                    <li class="">
                        <a href="purchase-orders" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png" alt="image">
                            <span class="ml-4">Purchase Order</span>
                        </a>
                    </li>
                </c:if>

                <%-- SECTION: INVENTORY STAFF (ID = 4) --%>
                <c:if test="${u.role.id == 4}">
                    <li class="">
                        <a href="inventory-report-staff" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png" alt="image">
                            <span class="ml-4">Inventory Staff</span>
                        </a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </div>
</div>

<div class="iq-top-navbar">
    <div class="iq-navbar-custom">
        <nav class="navbar navbar-expand-lg navbar-light p-0">
            <div class="iq-navbar-logo d-flex align-items-center justify-content-between">
                <i class="ri-menu-line wrapper-menu"></i>
                <a href="index.jsp" class="header-logo">
                    <h5 class="logo-title ml-3">POSDash</h5>
                </a>
            </div>
            <div class="d-flex align-items-center ml-auto">
                <ul class="navbar-nav navbar-list align-items-center">
                    <li class="nav-item">
                        <span class="badge badge-danger p-2 mr-3">${u.role.roleName}</span>
                    </li>
                    <c:if test="${u.role.id == 2 || u.role.id == 4}">
                        <li class="nav-item">
                            <span class="badge badge-warning p-2 mr-3">${u.warehouse.warehouseName}</span>
                        </li>
                    </c:if>
                    <li class="nav-item nav-icon dropdown caption-content">
                        <a href="#" class="search-toggle dropdown-toggle" data-toggle="dropdown">
                            <img src="${pageContext.request.contextPath}/assets/images/user/1.png" class="img-fluid rounded" alt="user">
                        </a>
                        <div class="iq-sub-dropdown dropdown-menu">
                            <div class="card shadow-none m-0">
                                <div class="card-body p-3 text-center">
                                    <h5 class="mb-1">${u.email}</h5>
                                    <a href="logout" class="btn btn-primary mt-3">Sign Out</a>
                                </div>
                            </div>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
</div>