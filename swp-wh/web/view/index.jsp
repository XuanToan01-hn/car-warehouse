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
<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0">
    <title>Dream Warehouse - Home</title>

    <!-- Use available CSS from assets/css -->
    <link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/themify-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa3IW2lEnf3lGY6i7IW3twzo9OTNx35Z7H+M3UP7w9BeXoEvWMDecRl2CLvz/TEvQktvgL7GKGF4LSstdw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <style>
        /* Minimal fallback styles in case global styles are different */
        body { margin:0; font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; background:#f8fafc; }
        .main-wrapper { display:flex; min-height:100vh; }
        .page-wrapper { margin-left:240px; width:100%; }
        .content { padding:28px; }
        .welcome-card { display:flex; align-items:center; justify-content:center; height:70vh; }
        .welcome-box { text-align:center; background:#fff; padding:40px 60px; border-radius:12px; box-shadow:0 8px 30px rgba(2,6,23,0.06); }
        .welcome-box h1{ margin:0 0 12px 0; font-size:42px; color:#0f172a; }
        .welcome-box p{ margin:0 0 8px 0; color:#475569; font-size:18px; }
        .role-badge{ display:inline-block; margin-top:12px; background:linear-gradient(90deg,#6366f1,#9333ea); color:#fff; padding:8px 16px; border-radius:20px; font-weight:600 }
        @media (max-width:900px){ .page-wrapper { margin-left:0; } }
    </style>
</head>
<body>
<div class="main-wrapper">

    <!-- SIDEBAR -->
    <jsp:include page="sidebar.jsp" />
    <!-- END SIDEBAR -->

    <div class="page-wrapper">

        <!-- HEADER -->
        <jsp:include page="header.jsp" />
        <!-- END HEADER -->

        <!-- PAGE CONTENT -->
        <div class="content">
            <div class="welcome-card">
                <div class="welcome-box">
                    <h1>Welcome to Dream Warehouse hehehe</h1>
                    <p>Hello, <strong>${fullName}</strong></p>
                    <div class="role-badge">${roleName}</div>
                </div>
            </div>
        </div>
        <!-- END PAGE CONTENT -->

    </div>

</div>

<!-- Scripts: use available JS files -->
<script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/apps.js"></script>
<script>
    // small script to ensure sidebar toggle works with our header
    document.addEventListener('DOMContentLoaded', function(){
        const btn = document.getElementById('sidebarToggle');
        if(btn) btn.addEventListener('click', function(){
            const sb = document.querySelector('.app-sidebar');
            if(!sb) return;
            sb.style.display = (sb.style.display === 'none') ? 'block' : 'none';
            document.querySelector('.app-header').style.marginLeft = (sb.style.display === 'none') ? '12px' : '240px';
        });
    });
</script>
</body>
</html>
