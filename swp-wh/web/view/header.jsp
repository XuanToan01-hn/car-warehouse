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

                <div class="badge">${roleName}</div>

                <div style="display:flex;align-items:center;gap:8px">
                    <img class="user-avatar" src="${pageContext.request.contextPath}/assets/images/user/1.png">

                    <div style="font-size:14px; font-weight: 600;">${fullName}</div>
                </div>

                <a class="logout-btn" href="${pageContext.request.contextPath}/logout">
                    Logout
                </a>

            </c:if>

        </div>

    </div>