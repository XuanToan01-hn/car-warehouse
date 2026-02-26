<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="iq-top-navbar">
    <div class="iq-navbar-custom">
        <nav class="navbar navbar-expand-lg navbar-light p-0">
            <div class="iq-navbar-logo d-flex align-items-center justify-content-between">
                <i class="ri-menu-line wrapper-menu"></i>
                <a href="index.html" class="header-logo">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png"
                         class="img-fluid rounded-normal" alt="logo">
                    <h5 class="logo-title ml-3">POSDash</h5>
                </a>
            </div>
            <div class="iq-search-bar device-search">
            </div>
            <div class="d-flex align-items-center">
                <button class="navbar-toggler" type="button" data-toggle="collapse"
                        data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                        aria-label="Toggle navigation">
                    <i class="ri-menu-3-line"></i>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav ml-auto navbar-list align-items-center">
                        <input type="text"
                               class="w-50 text-center border-radio-10px  badge-danger mr-3"
                               value="${sessionScope.user.role.roleName}" readonly="">
                        <c:if test="${sessionScope.user.role.roleId == 2 || sessionScope.user.role.roleId == 4}">
                            <input type="text"
                                   class="w-35 text-center border-radio-10px  badge-orange mr-3"
                                   value="${sessionScope.user.location.name}" readonly="">
                        </c:if>

                        <li class="nav-item nav-icon dropdown caption-content">
                            <a href="#" class="search-toggle dropdown-toggle" id="dropdownMenuButton4"
                               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <img src="${pageContext.request.contextPath}/assets/images/user/1.png"
                                     class="img-fluid rounded" alt="user">
                            </a>
                            <div class="iq-sub-dropdown dropdown-menu" aria-labelledby="dropdownMenuButton">
                                <div class="card shadow-none m-0">
                                    <div class="card-body p-0 text-center">
                                        <div class="media-body profile-detail text-center">
                                            <img src="${pageContext.request.contextPath}/assets/images/page-img/profile-bg.jpg"
                                                 alt="profile-bg" class="rounded-top img-fluid mb-4">
                                            <img src="${pageContext.request.contextPath}/assets/images/user/1.png"
                                                 alt="profile-img"
                                                 class="rounded profile-img img-fluid avatar-70">
                                        </div>
                                        <div class="p-3">
                                            <h5 class="mb-1">${sessionScope.user.email}</h5>
                                            <div class="d-flex align-items-center justify-content-center mt-3">
                                                <%-- <a href="${pageContext.request.contextPath}/app/user-profile.html" class="btn border mr-2">Profile</a> --%>
                                                <a href="logout" class="btn border">Sign Out</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </div>
</div>

