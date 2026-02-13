<%-- 
    Document   : page-add-category
    Created on : May 20, 2025, 2:45:57 PM
    Author     : Nhat
--%>

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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/vendor/remixicon/fonts/remixicon.css">  </head>
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
                                        <h4 class="card-title">Add category</h4>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <form action="add-category" method="post" data-toggle="validator">
                                        <div class="row">     
                                            <div class="col-md-12">                      
                                                <div class="form-group">
                                                    <label>Category name*</label>
                                                    <input type="text" class="form-control" placeholder="Enter Category Name" required="" name="name">
                                                    <div class="help-block with-errors"></div>
                                                </div>
                                            </div>    
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label>Description *</label>
                                                    <input type="text" class="form-control" placeholder="Enter Description" required="" name="description">
                                                    <div class="help-block with-errors"></div>
                                                </div>
                                            </div>                                 
                                        </div>    
                                        <div class="col-md-12 mt-3">
                                            <button type="submit" class="btn btn-primary mr-2" style="background-color: #17AEDF">Add category</button>
                                            <a href="list-category" class="btn btn-secondary">Cancel</a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Page end  -->
                </div>
            </div>
        </div>
        <!-- Wrapper End-->
        <footer class="iq-footer">
            <div class="container-fluid">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-lg-6">
                                <ul class="list-inline mb-0">
                                    <li class="list-inline-item"><a href="privacy-policy.html">Privacy Policy</a></li>
                                    <li class="list-inline-item"><a href="terms-of-service.html">Terms of Use</a></li>
                                </ul>
                            </div>
                            <div class="col-lg-6 text-right">
                                <span class="mr-1"><script>document.write(new Date().getFullYear())</script>©</span> <a href="#" class="">POS Dash</a>.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
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