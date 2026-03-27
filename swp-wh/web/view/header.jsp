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

    <style>
        .app-header {
            margin-left: 260px;
            background: #fff;
            border-bottom: 1px solid #e6eef8;
            padding: 12px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 40;
            transition: all 0.3s ease;
        }

        .left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-title {
            font-size: 18px;
            font-weight: 600;
            color: #0f172a;
        }

        .right {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
        }

        .badge {
            background: #eef2ff;
            color: #3730a3;
            padding: 6px 10px;
            border-radius: 12px;
            font-size: 13px;
        }

        .logout-btn {
            background: #ef4444;
            color: white;
            padding: 6px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
        }

        .logout-btn:hover {
            background: #dc2626;
        }
    </style>

    <div class="app-header">

        <div class="left">
            <div class="page-title">Management System</div>
        </div>

        <div class="right">

            <!-- Chỉ hiện khi đã login -->
            <c:if test="${not empty sessionScope.user}">

                <c:if test="${not empty sessionScope.user.warehouse and not empty sessionScope.user.warehouse.warehouseName}">
                    <div class="badge" style="background: #fff7ed; color: #ea580c; display: flex; align-items: center; gap: 6px;">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="currentColor"><path d="M21 19H23V21H1V19H3V4C3 3.44772 3.44772 3 4 3H14C14.5523 3 15 3.44772 15 4V19H17V9H20C20.5523 9 21 9.44772 21 10V19ZM7 11V13H11V11H7ZM7 7V9H11V7H7Z"></path></svg>
                        ${sessionScope.user.warehouse.warehouseName}
                    </div>
                </c:if>

                <div class="badge">${roleName}</div>

                <div style="display:flex;align-items:center;gap:8px">
                    <img class="user-avatar" src="${pageContext.request.contextPath}/assets/images/user/1.png">
                    <div style="font-size:14px; font-weight: 600; color: #334155;">${fullName}</div>
                </div>

                <a class="logout-btn" href="${pageContext.request.contextPath}/logout">
                    Logout
                </a>

            </c:if>

        </div>

    </div>