    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="iq-sidebar  sidebar-default ">
    <div class="iq-sidebar-logo d-flex align-items-center justify-content-between">
        <a href="index.jsp" class="header-logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" class="img-fluid rounded-normal light-logo" alt="logo"><h5 class="logo-title light-logo ml-3">POSDash</h5>
        </a>
        <div class="iq-menu-bt-sidebar ml-0">
            <a href="javascript:void(0)">
                <i class="las la-bars wrapper-menu"></i>
            </a>

        </div>
    </div>
    <div class="data-scrollbar" data-scroll="1">
        <nav class="iq-sidebar-menu">
            <ul id="iq-sidebar-toggle" class="iq-menu">
                <c:if test="${user.role.roleId == 5}">
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
                        <a href="list-request-management" class="svg-icon">                        
                            <img src="${pageContext.request.contextPath}/assets/images/icon/request.png" alt="image">
                            <span class="ml-4">Request</span>
                        </a>
                    </li>
                    <li class=" ">
                        <a href="#product" class="collapsed" data-toggle="collapse" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/product.png" alt="image">
                            <span class="ml-4">Product</span>
                        </a>
                        <ul id="product" class="iq-submenu collapse" data-parent="#iq-sidebar-toggle">
                            <li class="">
                                <a href="list-product">
                                    <i>&bull;</i><span>List Product</span>
                                </a>
                            </li>
                            <li class="">
                                <a href="add-product">
                                    <i>&bull;</i><span>Add Product</span>
                                </a>
                            </li>
                            <li class="">
                                <a href="list-product-pricing">
                                    <i>&bull;</i><span>List Product Pricing</span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class=" ">
                        <a href="#category" class="collapsed" data-toggle="collapse" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/category.png" alt="image">
                            <span class="ml-4">Categories</span>
                        </a>
                        <ul id="category" class="iq-submenu collapse" data-parent="#iq-sidebar-toggle">
                            <li class="">
                                <a href="list-category">
                                    <i>&bull;</i><span>List Category</span>
                                </a>
                            </li>
                            <li class="">
                                <a href="add-category">
                                    <i>&bull;</i><span>Add Category</span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class=" ">
                        <a href="#location" class="collapsed" data-toggle="collapse" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/location.png" alt="image">
                            <span class="ml-4">Location</span>
                        </a>
                        <ul id="location" class="iq-submenu collapse" data-parent="#iq-sidebar-toggle">
                            <li class="">
                                <a href="ListLocation">
                                    <i>&bull;</i><span>List Location</span>
                                </a>
                            </li>
                            <li class="">
                                <a href="AddLocation">
                                    <i>&bull;</i><span>Add Location</span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class=" ">
                        <a href="#tax" class="collapsed" data-toggle="collapse" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/tax.png" alt="image">
                            <span class="ml-4">Tax</span>
                        </a>
                        <ul id="tax" class="iq-submenu collapse" data-parent="#iq-sidebar-toggle">
                            <li class="">
                                <a href="list-tax">
                                    <i>&bull;</i><span>List Tax</span>
                                </a>
                            </li>
                            <li class="">
                                <a href="add-tax">
                                    <i>&bull;</i><span>Add Tax</span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class=" ">
                        <a href="#supplier" class="collapsed" data-toggle="collapse" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/supplier.png" alt="image">
                            <span class="ml-4">Supplier</span>
                        </a>
                        <ul id="supplier" class="iq-submenu collapse" data-parent="#iq-sidebar-toggle">
                            <li class="">
                                <a href="supplierlist">
                                    <i>&bull;</i><span>List Supplier</span>
                                </a>
                            </li>
                            <li class="">
                                <a href="addsupplier">
                                    <i>&bull;</i><span>Add Supplier</span>
                                </a>
                            </li>
                            <li class="">
                                <a href="list-supplier-product">
                                    <i>&bull;</i><span>Supplier Product</span>
                                </a>
                            </li>
                        </ul>
                    </li>
                </c:if>

                <c:if test="${user.role.roleId == 1}">
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
                        <li class="">
                            <a href="userlist">
                                <i>&bull;</i><span>List Users</span>
                            </a>
                        </li>
                        <li class="">
                            <a href="registeruser">
                                <i>&bull;</i><span>Add Users</span>
                            </a>
                        </li>
                    </ul>
                </li>
                </c:if>

                <c:if test="${user.role.roleId == 4}">
                    <li class=" ">
                        <a href="inventory-report-staff" class="svg-icon">                        
                            <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png" alt="image">
                            <span class="ml-4">Inventory Staff</span>
                        </a>
                    </li>
                    <li class=" ">
                        <a href="list-sale-order" class="svg-icon">                        
                            <img src="${pageContext.request.contextPath}/assets/images/icon/sale.png" alt="image">
                            <span class="ml-4">Sale</span>
                        </a>
                    </li>
                    <li class=" ">
                        <a href="list-purchase-orders-ready" class="svg-icon">                        
                            <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png" alt="image">
                            <span class="ml-4">Purchase</span>
                        </a>
                    </li>
                    <li class=" ">
                        <a href="#return" class="collapsed" data-toggle="collapse" aria-expanded="false">
                            <img src="${pageContext.request.contextPath}/assets/images/icon/import.png" alt="image">
                            <span class="ml-4">Import Order</span>
                        </a>
                        <ul id="return" class="iq-submenu collapse" data-parent="#iq-sidebar-toggle">
                            <li class="">
                                <a href="list-import-orders">
                                    <i>&bull;</i><span>List Import Order</span>
                                </a>
                            </li>
                            <li class="">
                                <a href="internal-transfer-imports">
                                    <i>&bull;</i><span>List Import Internal</span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class=" ">
                        <a href="list-export" class="svg-icon">                        
                            <img src="${pageContext.request.contextPath}/assets/images/icon/export.png" alt="image">
                            <span class="ml-4">Export</span>
                        </a>
                    </li>
                </c:if>

                <c:if test="${user.role.roleId == 2}">
                    <li class=" ">
                        <a href="list-sales-order" class="svg-icon">                        
                            <img src="${pageContext.request.contextPath}/assets/images/icon/sale.png" alt="image">
                            <span class="ml-4">Sale Order</span>
                        </a>
                    </li>

                    <li class=" ">
                        <a href="list-customer" class="svg-icon">                        
                            <img src="${pageContext.request.contextPath}/assets/images/icon/people.png" alt="image">
                            <span class="ml-4">Customer</span>
                        </a>
                    </li>
                </c:if>


                <c:if test="${user.role.roleId == 3}">
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
            <div class="iq-navbar-logo d-flex align-items-center justify-content-between">
                <i class="ri-menu-line wrapper-menu"></i>
                <a href="index.html" class="header-logo">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png" class="img-fluid rounded-normal" alt="logo">
                    <h5 class="logo-title ml-3">POSDash</h5>

                </a>
            </div>
            <div class="iq-search-bar device-search">

            </div>
            <div class="d-flex align-items-center">
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-label="Toggle navigation">
                    <i class="ri-menu-3-line"></i>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav ml-auto navbar-list align-items-center">
                        <input type="text" class="w-50 text-center border-radio-10px  badge-danger mr-3" value="${sessionScope.user.role.roleName}" readonly="">
                        <c:if test="${sessionScope.user.role.roleId == 2 || sessionScope.user.role.roleId == 4}">
                            <input type="text" class="w-35 text-center border-radio-10px  badge-orange mr-3" value="${sessionScope.user.location.name}" readonly="">
                        </c:if>

                        <li class="nav-item nav-icon dropdown caption-content">
                            <a href="#" class="search-toggle dropdown-toggle" id="dropdownMenuButton4" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <img src="${pageContext.request.contextPath}/assets/images/user/1.png" class="img-fluid rounded" alt="user">
                            </a>
                            <div class="iq-sub-dropdown dropdown-menu" aria-labelledby="dropdownMenuButton">
                                <div class="card shadow-none m-0">
                                    <div class="card-body p-0 text-center">
                                        <div class="media-body profile-detail text-center">
                                            <img src="${pageContext.request.contextPath}/assets/images/page-img/profile-bg.jpg" alt="profile-bg" class="rounded-top img-fluid mb-4">
                                            <img src="${pageContext.request.contextPath}/assets/images/user/1.png" alt="profile-img" class="rounded profile-img img-fluid avatar-70">
                                        </div>
                                        <div class="p-3">
                                            <h5 class="mb-1">${sessionScope.user.email}</h5>
                                            <div class="d-flex align-items-center justify-content-center mt-3">
<!--                                                            <a href="${pageContext.request.contextPath}/app/user-profile.html" class="btn border mr-2">Profile</a>-->
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

