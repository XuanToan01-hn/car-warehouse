<%-- 
    Document   : page-list-suppliers
    Created on : May 20, 2025, 8:27:10 PM
    Author     : Nhat
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
﻿
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>POS Dash | Responsive Bootstrap 4 Admin Dashboard Template</title>

        <!-- Favicon -->
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/%40fortawesome/fontawesome-free/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/line-awesome/dist/line-awesome/css/line-awesome.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css"> 
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    </head>
    <body class="  ">
        <!-- loader Start -->
        <div id="loading">
            <div id="loading-center">
            </div>
        </div>
        <!-- loader END -->
        <!-- Wrapper Start -->
        <div class="wrapper">

            <%@ include file="../sidebar.jsp" %>
            
            <div class="content-page">
                <div class="container-fluid add-form-list">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between">
                                    <div class="header-title">
                                        <h4 class="card-title">Edit Category</h4>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/edit-category" method="post">
                                        <input type="hidden" name="id" value="${category.id}"/>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label>Category Name *</label>
                                                    <input type="text" class="form-control" name="name"
                                                           value="${category.name}" required>
                                                </div>
                                            </div>
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label>Description *</label>
                                                    <input type="text" class="form-control" name="description"
                                                           value="${category.description}" required>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-12 d-flex justify-content-start mt-4">
                                            <button type="submit" class="btn btn-primary mr-2">Update</button>
                                            <a href="list-category" class="btn btn-danger" style="background-color: #FE9369;">Cancel</a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Backend Bundle JavaScript -->
            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>

            <!-- Table Treeview JavaScript -->
            <script src="${pageContext.request.contextPath}/assets/js/table-treeview.js"></script>

            <!-- Chart Custom JavaScript -->
            <script src="${pageContext.request.contextPath}/assets/js/customizer.js"></script>

            <!-- Chart Custom JavaScript -->
            <script async="" src="${pageContext.request.contextPath}/assets/js/chart-custom.js"></script>

            <!-- app JavaScript -->
            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
    </body>
</html>