<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <c:set var="roleId" value="${sessionScope.user.role.id}" />

    <div class="iq-sidebar sidebar-default">
        <div class="iq-sidebar-logo d-flex align-items-center justify-content-between">
            <a href="index.jsp" class="header-logo">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png"
                    class="img-fluid rounded-normal light-logo">
                <h5 class="logo-title light-logo ml-3">POSDash</h5>
            </a>
        </div>

        <div class="data-scrollbar" data-scroll="1">
            <nav class="iq-sidebar-menu">
                <ul id="iq-sidebar-toggle" class="iq-menu">

                    <!-- ================= ADMIN ================= -->
                    <c:if test="${roleId == 1}">
                        <li>
                            <a href="inventory-log" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Inventory Log</span>
                            </a>
                        </li>

                        <li>
                            <a href="#user" class="collapsed" data-toggle="collapse">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/people.png">
                                <span class="ml-4">User</span>
                            </a>
                            <ul id="user" class="iq-submenu collapse">
                                <li><a href="userlist"><i>&bull;</i>List Users</a></li>
                                <li><a href="registeruser"><i>&bull;</i>Add User</a></li>
                            </ul>
                        </li>
                    </c:if>


                    <!-- ================= WAREHOUSE MANAGER ================= -->
                    <c:if test="${roleId == 2}">
                        <li>
                            <a href="inventory-log" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/inventory.png">
                                <span class="ml-4">Inventory Log</span>
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
                                <span class="ml-4">Product Detail</span>
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
                            <a href="internal-transfer" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png">
                                <span class="ml-4">Internal Transfer</span>
                            </a>
                        </li>

                        <li>
                            <a href="warehouse-transfer" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/import.png">
                                <span class="ml-4">Warehouse Ops</span>
                            </a>
                        </li>



                        <li>
                            <a href="manage-suppliers" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/people.png">
                                <span class="ml-4">Suppliers</span>
                            </a>
                        </li>
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
                            <a href="internal-transfer" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/purchases.png">
                                <span class="ml-4">Internal Transfer</span>
                            </a>
                        </li>

                        <li>
                            <a href="warehouse-transfer" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/import.png">
                                <span class="ml-4">Warehouse Ops</span>
                            </a>
                        </li>
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

                        <li>
                            <a href="goods-receipt" class="svg-icon">
                                <img src="${pageContext.request.contextPath}/assets/images/icon/import.png">
                                <span class="ml-4">Goods Receipt</span>
                            </a>
                        </li>

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
    </div>