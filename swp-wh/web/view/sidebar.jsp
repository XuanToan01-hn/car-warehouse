<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <div class="iq-sidebar  sidebar-default ">
        <div class="iq-sidebar-logo d-flex align-items-center justify-content-between">
            <a href="index.jsp" class="header-logo">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png"
                    class="img-fluid rounded-normal light-logo" alt="logo">
                <h5 class="logo-title light-logo ml-3">POSDash</h5>
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
                    <c:if test="${user.role.id == 1}">
                        <li class=" ">
                            <a href="dash-board" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/dashboard.png"
                                    alt="image">
                                <span class="ml-4">Dashboards</span>
                            </a>
                        </li>
                        <li class=" ">
                            <a href="inventory-management" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png"
                                    alt="image">
                                <span class="ml-4">Inventory</span>
                            </a>
                        </li>
                        <li class=" ">
                            <a href="list-request-management" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/request.png"
                                    alt="image">
                                <span class="ml-4">Request</span>
                            </a>
                        </li>
                        <li class=" ">
                            <a href="#product" class="collapsed" data-toggle="collapse" aria-expanded="false">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/product.png"
                                    alt="image">
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
                                <img src="${pageContext.request.contextPath}/assets/images/icon/category.png"
                                    alt="image">
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
                                <img src="${pageContext.request.contextPath}/assets/images/icon/location.png"
                                    alt="image">
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
                                <img src="${pageContext.request.contextPath}/assets/images/icon/supplier.png"
                                    alt="image">
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

                    <c:if test="${user.role.id == 1}">
                        <li class=" ">
                            <a href="permissions" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/permissions.png"
                                    alt="image">
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

                    <c:if test="${user.role.id == 4}">
                        <li class=" ">
                            <a href="inventory-report-staff" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png"
                                    alt="image">
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
                            <a href="purchase-orders" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png"
                                    alt="image">
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
                            <a href="goods-issue?action=list" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/export.png" alt="image">
                                <span class="ml-4">Goods Issue</span>
                            </a>
                        </li>
                        <li class=" ">
                            <a href="goods-receipt" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/import.png" alt="image">
                                <span class="ml-4">Goods Receipt</span>
                            </a>
                            
                        </li>
                        <li class=" ">
                            <a href="list-export" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/export.png" alt="image">
                                <span class="ml-4">Export</span>
                            </a>
                        </li>
                    </c:if>

                    <c:if test="${user.role.id == 2}">
                        <li class=" ">
                            <a href="sales-order?action=list" class="svg-icon">
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


                    <c:if test="${user.role.id == 3}">
                        <li class=" ">
                            <a href="#purchase-order" class="collapsed" data-toggle="collapse" aria-expanded="false">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png"
                                    alt="image">
                                <span class="ml-4">Purchase Order</span>
                            </a>
                            <ul id="purchase-order" class="iq-submenu collapse" data-parent="#iq-sidebar-toggle">
                                <li class="">
                                    <a href="purchase-orders">
                                        <i>&bull;</i><span>List Purchase Order</span>
                                    </a>
                                </li>
                                <li class="">
                                    <a href="add-purchase-order">
                                        <i>&bull;</i><span>Add New Purchase Order</span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </div>