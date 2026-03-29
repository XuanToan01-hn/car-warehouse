<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <c:set var="roleId" value="${sessionScope.user.role.id}" />
    <link
        href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap"
        rel="stylesheet">


    <div class="iq-sidebar sidebar-default">
        <div class="iq-sidebar-logo d-flex align-items-center justify-content-between">
            <a onclick="toggleSidebar()" class="header-logo">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png"
                    class="img-fluid rounded-normal light-logo">
                <h5 class="logo-title light-logo ml-3">POSDash</h5>
            </a>
            <!-- <div class="iq-menu-bt-sidebar" onclick="toggleSidebar()" style="cursor:pointer; font-size: 20px;">
                <i class="ri-menu-3-line"></i>
            </div> -->
        </div>

        <div class="data-scrollbar" data-scroll="1">
            <nav class="iq-sidebar-menu">
                <ul id="iq-sidebar-toggle" class="iq-menu">

                    <!-- ================= ADMIN ================= -->
                    <c:if test="${roleId == 1}">
<!--                        <li>
                            <a href="inventory-log" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Inventory Log</span>
                            </a>
                        </li>-->

                        <li>
                            <a href="userlist" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">User List</span>
                            </a>
                        </li>

                        <li>
                            <a href="permissions" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Security - permission</span>
                            </a>
                        </li>

<!--                        <li>
                            <a href="inventory-report" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Inventory Report</span>
                            </a>
                        </li>
                        <li>
                            <a href="low-stock" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Report low stock</span>
                            </a>
                        </li>-->
                    </c:if>



                    <!-- ================= WAREHOUSE MANAGER ================= -->
                    <c:if test="${roleId == 2}">
                          <li>
                            <a href="inventory-report" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Inventory Report</span>
                            </a>
                        </li>
                        <li>
                            <a href="inventory-log" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Inventory Log</span>
                            </a>
                        </li>
                        <li>
                            <a href="list-category" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Category</span>
                            </a>
                        </li>
                        <li>
                            <a href="list-product" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/product.png">
                                <span class="ml-4">Products</span>
                            </a>
                        </li>
                        <li>
                            <a href="list-product-detail" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/product.png">
                                <span class="ml-4">Products Detail</span>
                            </a>
                        </li>


                        <li>
                            <a href="purchase-orders" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png">
                                <span class="ml-4">Purchase Orders</span>
                            </a>
                        </li>

                        <li>
                            <a href="warehouses" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/location.png">
                                <span class="ml-4">Warehouses</span>
                            </a>
                        </li>

                        <li>
                            <a href="locations" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/location.png">
                                <span class="ml-4">Locations</span>
                            </a>
                        </li>
                        <li>
                            <a href="location-product" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Stock by Location</span>
                            </a>
                        </li>


                        <!--                        <li>
                            <a href="external-transfer" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png">
                                <span class="ml-4">External Transfer</span>
                            </a>
                        </li>-->

                        <!--                        <a href="warehouse-transfer" class="svg-icon">
                                                     <li>
                               <img src="${pageContext.request.contextPath}/assets/images/icon/import.png">
                                <span class="ml-4">Warehouse Ops</span>
                            </a>
                        </li>-->

                    </c:if>


                    <!-- ================= INVENTORY STAFF ================= -->
                    <c:if test="${roleId == 3}">
                        <li>
                            <a href="purchase-orders" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png">
                                <span class="ml-4">Purchase Orders</span>
                            </a>
                        </li>

                        <li>
                            <a href="goods-receipt" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/import.png">
                                <span class="ml-4">Goods Receipt</span>
                            </a>
                        </li>
                        <li>
                            <a href="goods-issue" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/import.png">
                                <span class="ml-4">Goods Issue</span>
                            </a>
                        </li>

                        <li>
                            <a href="locations" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/location.png">
                                <span class="ml-4">Locations</span>
                            </a>
                        </li>
                        <li>
                            <a href="location-product" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Product Location</span>
                            </a>
                        </li>


                        <!--                        <li>
                            <a href="external-transfer" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png">
                                <span class="ml-4">External Transfer</span>
                            </a>
                        </li>-->
                        <li>
                            <a href="internal-transfer" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png">
                                <span class="ml-4">Internal Transfer</span>
                            </a>
                        </li>

                        <!--                        <li>
                            <a href="warehouse-transfer" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/import.png">
                                <span class="ml-4">Warehouse Ops</span>
                            </a>
                        </li>-->
                    </c:if>


                    <!-- ================= SALE STAFF ================= -->
                    <c:if test="${roleId == 4}">
                        <li>
                            <a href="customers" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/people.png">
                                <span class="ml-4">Customers</span>
                            </a>
                        </li>

                        <li>
                            <a href="sales-order" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/sale.png">
                                <span class="ml-4">Sales Order</span>
                            </a>
                        </li>

                    </c:if>


                    <!-- ================= PURCHASING STAFF ================= -->
                    <c:if test="${roleId == 5}">
                        <li>
                            <a href="purchase-orders" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png">
                                <span class="ml-4">Purchase Orders</span>
                            </a>
                        </li>

                        <!--                        <li>
                            <a href="goods-receipt" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/import.png">
                                <span class="ml-4">Goods Receipt</span>
                            </a>
                        </li>-->

                        <li>
                            <a href="manage-suppliers" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/people.png">
                                <span class="ml-4">Suppliers</span>
                            </a>
                        </li>
                    </c:if>

                </ul>
            </nav>
        </div>

        <!-- Toggle Script and Styles for Mini Sidebar -->
        <style>
            /* Mini Sidebar Styles */
            body.mini-sidebar .iq-sidebar {
                width: 80px !important;
            }

            body.mini-sidebar .iq-sidebar .logo-title,
            body.mini-sidebar .iq-sidebar .iq-sidebar-menu span,
            body.mini-sidebar .iq-sidebar .iq-submenu,
            body.mini-sidebar .iq-sidebar .iq-menu-bt-sidebar {
                display: none !important;
            }

            /* Show a centered toggle button in mini mode if needed, or just rely on logo */
            body.mini-sidebar .iq-sidebar .iq-sidebar-logo {
                padding: 15px 0 !important;
                justify-content: center !important;
            }

            body.mini-sidebar .iq-sidebar .iq-sidebar-logo a {
                margin: 0 !important;
                display: flex;
                justify-content: center;
            }

            body.mini-sidebar .iq-sidebar .iq-sidebar-logo a img {
                margin: 0 !important;
                height: 30px;
            }

            body.mini-sidebar .iq-sidebar .iq-menu li a {
                display: flex !important;
                justify-content: center !important;
                padding: 15px 0 !important;
            }

            body.mini-sidebar .iq-sidebar .iq-menu li a img {
                margin: 0 !important;
            }

            /* Transition handling */
            .iq-sidebar,
            .app-header,
            .content-page {
                transition: all 0.3s ease-in-out !important;
            }

            /* Uniform Sidebar Font Styles */
            .iq-sidebar-menu .iq-menu li a span {
                font-family: 'Be Vietnam Pro', sans-serif !important;
                font-size: 15px !important;
                font-weight: 500 !important;
                color: #475569 !important;
            }

            .iq-sidebar-menu .iq-menu li a i {
                font-size: 18px !important;
            }

            .iq-sidebar-menu .iq-menu li a img {
                width: 20px !important;
                height: 20px !important;
            }
        </style>

        <script>
            function toggleSidebar() {
                const body = document.body;
                const isMini = body.classList.contains('mini-sidebar');
                const header = document.querySelector('.app-header');
                const content = document.querySelector('.content-page');

                if (isMini) {
                    body.classList.remove('mini-sidebar');
                    if (header) header.style.marginLeft = '260px';
                    if (content) content.style.marginLeft = '260px';
                } else {
                    body.classList.add('mini-sidebar');
                    if (header) header.style.marginLeft = '80px';
                    if (content) content.style.marginLeft = '80px';
                }
            }
        </script>
    </div>