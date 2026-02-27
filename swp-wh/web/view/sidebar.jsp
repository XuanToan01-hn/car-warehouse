<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="iq-sidebar sidebar-default ">
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
                
                <%-- SECTION: ADMIN & MANAGER (ID = 1) --%>
                <c:if test="${user.role.id == 1}">
                    <li class=" ">
                        <a href="dash-board" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/dashboard.png" alt="image">
                            <span class="ml-4">Dashboards</span>
                        </a>
                    </li>
                    <li class=" ">
                        <a href="inventory-management" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png" alt="image">
                            <span class="ml-4">Inventory</span>
                        </a>
                    </li>
                    <li class=" ">
                        <a href="permissions" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/permissions.png" alt="image">
                            <span class="ml-4">Permissions</span>
                        </a>
                    </li>
                    <li class=" ">
                        <a href="#user" class="collapsed" data-toggle="collapse" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/people.png" alt="image">
                            <span class="ml-4">User</span>
                        </a>
                        <ul id="user" class="iq-submenu collapse" data-parent="#iq-sidebar-toggle">
                            <li><a href="userlist"><i>&bull;</i><span>List Users</span></a></li>
                            <li><a href="registeruser"><i>&bull;</i><span>Add Users</span></a></li>
                        </ul>
                    </li>
                </c:if>

                <%-- SECTION: INVENTORY STAFF (ID = 4) --%>
                <c:if test="${user.role.id == 4}">
                    <li class=" ">
                        <a href="inventory-report-staff" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png" alt="image">
                            <span class="ml-4">Inventory Staff</span>
                        </a>
                    </li>
                    </c:if>

                <%-- SECTION: SALES (ID = 2) --%>
                <c:if test="${user.role.id == 2}">
                    <li class=" ">
                        <a href="sales-order?action=list" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/sale.png" alt="image">
                            <span class="ml-4">Sale Order</span>
                        </a>
                    </li>
                </c:if>

                <%-- SECTION: PURCHASE (ID = 3) --%>
                <c:if test="${user.role.id == 3}">
                    <li class=" ">
                        <a href="purchase-orders" class="svg-icon">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png" alt="image">
                            <span class="ml-4">Purchase Order</span>
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
            <div class="d-flex align-items-center">
                <ul class="navbar-nav ml-auto navbar-list align-items-center">
                    <%-- Hi?n th? tên Role --%>
                    <input type="text" class="w-50 text-center border-radio-10px badge-danger mr-3"
                           value="${sessionScope.user.role.roleName}" readonly="">
                    
                    <%-- Ki?m tra hi?n th? Location cho Sales(2) ho?c Staff(4) --%>
                    <c:if test="${sessionScope.user.role.id == 2 || sessionScope.user.role.id == 4}">
                        <input type="text" class="w-35 text-center border-radio-10px badge-orange mr-3"
                               value="${sessionScope.user.location.name}" readonly="">
                    </c:if>
                    
                    <li class="nav-item nav-icon dropdown caption-content">
                        <h5 class="mb-1">${sessionScope.user.email}</h5>
                        <a href="logout" class="btn border">Sign Out</a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
</div>