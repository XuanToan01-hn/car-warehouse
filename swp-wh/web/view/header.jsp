<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:choose>
    <c:when test="${not empty requestScope.roleName}">
        <c:set var="roleName" value="${requestScope.roleName}" />
    </c:when>
    <c:otherwise>
        <c:set var="roleName" value="${sessionScope.user.role.roleName}" />
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
<!-- Simplified Header -->
<style>
    .app-header {
        margin-left: 240px; /* match sidebar width */
        background: #fff;
        border-bottom: 1px solid #e6eef8;
        padding: 12px 18px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: sticky;
        top: 0;
        z-index: 40;
        font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }
    .app-header .left { display:flex; align-items:center; gap:12px; }
    .app-header .page-title { font-size:18px; font-weight:600; color:#0f172a; }
    .app-header .right { display:flex; align-items:center; gap:12px; }
    .app-header .user-avatar { width:36px; height:36px; border-radius:50%; object-fit:cover; }
    .app-header .badge { background:#eef2ff; color:#3730a3; padding:6px 10px; border-radius:12px; font-size:13px; }
</style>

<div class="app-header">
    <div class="left">
        <button id="sidebarToggle" onclick="toggleSidebar()" style="background:transparent;border:0;cursor:pointer;padding:6px 8px; font-size:16px; color:#0f172a;"></button>
        <div class="page-title">Dashboard</div>
    </div>

    <div class="right">
        <div class="badge">${roleName}</div>
        <div style="display:flex; align-items:center; gap:8px">
            <img class="user-avatar" src="${pageContext.request.contextPath}/assets/images/user/1.png" alt="avatar"/>
            <div style="font-size:14px">${fullName}</div>
        </div>
    </div>
</div>

<script>
    function toggleSidebar(){
        const sb = document.querySelector('.app-sidebar');
        if(!sb) return;
        if(sb.style.display === 'none'){
            sb.style.display = 'block';
            document.querySelector('.app-header').style.marginLeft = '240px';
        } else {
            sb.style.display = 'none';
            document.querySelector('.app-header').style.marginLeft = '12px';
        }
    }
</script>
