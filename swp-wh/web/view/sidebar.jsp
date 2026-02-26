<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
    <c:when test="${not empty requestScope.roleId}">
        <c:set var="roleId" value="${requestScope.roleId}" />
    </c:when>
    <c:otherwise>
        <c:set var="roleId" value="${sessionScope.user.role.id}" />
    </c:otherwise>
</c:choose>
<c:choose>
    <c:when test="${not empty requestScope.fullName}">
        <c:set var="fullName" value="${requestScope.fullName}" />
    </c:when>
    <c:otherwise>
        <c:set var="fullName" value="${sessionScope.user.fullName}" />
    </c:otherwise>
</c:choose>
<c:choose>
    <c:when test="${not empty requestScope.roleName}">
        <c:set var="roleName" value="${requestScope.roleName}" />
    </c:when>
    <c:otherwise>
        <c:set var="roleName" value="${sessionScope.user.role.roleName}" />
    </c:otherwise>
</c:choose>
<!-- Simplified Sidebar - self-contained styles to avoid dependency on external broken CSS -->
<style>
    .app-sidebar {
        width: 240px;
        background: #0f172a; /* dark slate */
        color: #e6eef8;
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        padding: 18px 12px;
        box-shadow: 2px 0 6px rgba(2,6,23,0.15);
        overflow-y: auto;
        z-index: 50;
        font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }
    .app-sidebar .logo {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 18px;
    }
    .app-sidebar .logo img { width: 36px; height: 36px; object-fit: cover; }
    .app-sidebar h4 { margin: 0; font-size: 16px; color: #fff; }
    .app-sidebar nav ul { list-style: none; padding: 0; margin: 12px 0 40px 0; }
    .app-sidebar nav li { margin: 8px 0; }
    .app-sidebar a.menu-link {
        display: flex; align-items: center; gap: 10px;
        color: #cbd5e1; text-decoration: none; padding: 8px 10px; border-radius: 6px;
    }
    .app-sidebar a.menu-link:hover { background: rgba(255,255,255,0.03); color: #fff; }
    .app-sidebar .menu-icon { width: 20px; height: 20px; opacity: 0.9; }
    .app-sidebar .section-title { color: #94a3b8; font-size: 12px; margin: 14px 6px 6px; }
    .app-sidebar .user-info { margin-top: 18px; font-size: 13px; color: #cbd5e1; }
</style>

<div class="app-sidebar">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/home" style="display:flex; align-items:center; text-decoration:none; color:inherit;">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="logo"/>
            <h4>Dream Warehouse</h4>
        </a>
    </div>

    <nav>
        <ul>
            <!-- Admin / Super (id == 5) -->
            <c:if test="${roleId == 5}">
                <li><a class="menu-link" href="${pageContext.request.contextPath}/dash-board"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/dashboard.png" alt="">Dashboards</a></li>
                <li><a class="menu-link" href="${pageContext.request.contextPath}/inventory-management"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/inventory.png" alt="">Inventory</a></li>
                <li><a class="menu-link" href="${pageContext.request.contextPath}/list-request-management"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/request.png" alt="">Request</a></li>
                <li><a class="menu-link" href="${pageContext.request.contextPath}/list-product"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/product.png" alt="">Products</a></li>
                <li><a class="menu-link" href="${pageContext.request.contextPath}/list-category"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/category.png" alt="">Categories</a></li>
            </c:if>

            <!-- Role 1: permissions / user management -->
            <c:if test="${roleId == 1}">
                <li class="section-title">Administration</li>
                <li><a class="menu-link" href="${pageContext.request.contextPath}/permissions"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/permissions.png" alt="">Permissions</a></li>
                <li><a class="menu-link" href="${pageContext.request.contextPath}/userlist"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/people.png" alt="">Users</a></li>
            </c:if>

            <!-- Role 4: staff -->
            <c:if test="${roleId == 4}">
                <li><a class="menu-link" href="${pageContext.request.contextPath}/inventory-report-staff"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/inventory.png" alt="">Inventory Staff</a></li>
                <li><a class="menu-link" href="${pageContext.request.contextPath}/list-sale-order"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/sale.png" alt="">Sale</a></li>
                <li><a class="menu-link" href="${pageContext.request.contextPath}/list-purchase-orders-ready"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/purchases.png" alt="">Purchase</a></li>
            </c:if>

            <!-- Role 2: sales -->
            <c:if test="${roleId == 2}">
                <li><a class="menu-link" href="${pageContext.request.contextPath}/sales-order?action=list"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/sale.png" alt="">Sale Orders</a></li>
                <li><a class="menu-link" href="${pageContext.request.contextPath}/list-customer"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/people.png" alt="">Customers</a></li>
            </c:if>

            <!-- Role 3: purchase -->
            <c:if test="${roleId == 3}">
                <li><a class="menu-link" href="${pageContext.request.contextPath}/purchase-orders"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/purchases.png" alt="">Purchase Orders</a></li>
            </c:if>

            <!-- Common links -->
            <li class="section-title">Common</li>
            <li><a class="menu-link" href="${pageContext.request.contextPath}/profile"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/people.png" alt="">Profile</a></li>
            <li><a class="menu-link" href="${pageContext.request.contextPath}/logout"><img class="menu-icon" src="${pageContext.request.contextPath}/assets/images/icon/back.png" alt="">Logout</a></li>
        </ul>
    </nav>

    <div class="user-info">
        Logged in as: <strong>${fullName}</strong><br/>
        Role: <strong>${roleName}</strong>
    </div>
</div>
