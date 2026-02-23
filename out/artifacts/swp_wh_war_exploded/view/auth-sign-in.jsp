
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
    <body class=" ">
        <!-- loader Start -->
        <div id="loading">
            <div id="loading-center">
            </div>
        </div>
        <!-- loader END -->

        <div class="wrapper">
            <section class="login-content">
                <div class="container">
                    <div class="row align-items-center justify-content-center height-self-center">
                        <div class="col-lg-8">
                            <div class="card auth-card">
                                <div class="card-body p-0">
                                    <div class="d-flex align-items-center auth-content">
                                        <div class="col-lg-7 align-self-center">
                                            <div class="p-3">
                                                <h2 class="mb-2">Sign In</h2>
                                                <c:if test="${not empty error}">
                                                    <div class="alert alert-danger" role="alert">
                                                        ${error}
                                                    </div>
                                                </c:if>
                                                <p>Login to stay connected.</p>
                                                <%
                                                String email = "", password = "", remember = "";
                                                Cookie[] cookies = request.getCookies();
                                                if(cookies != null){
                                                     for(Cookie cookie : cookies){
                                                       switch(cookie.getName()){
                                                       case "email": email = cookie.getValue(); 
                                                       break;
                                                       case "password": password = cookie.getValue(); 
                                                       break;
                                                       case "remember": remember = cookie.getValue(); 
                                                       break;
                                                    }
                                                    }
                                                    }
                                                %>
                                                <form action="login" method="post">
                                                    <div class="row">
                                                        <div class="col-lg-12">
                                                            <div class="floating-label form-group">
                                                                <input class="floating-input form-control" name="email" type="email" value="<%= email%>" placeholder=" ">
                                                                <label>Email</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-12">
                                                            <div class="floating-label form-group">
                                                                <input class="floating-input form-control" name ="password" type="password" value="<%= password %>" placeholder=" ">
                                                                <label>Password</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6">
                                                            <div class="custom-control custom-checkbox mb-3">
                                                                <input type="checkbox" class="custom-control-input" id="customCheck1" name="remember" <%= "on".equals(remember)?"checked" : "" %>>
                                                                <label class="custom-control-label control-label-1" for="customCheck1">Remember Me</label>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-6">
                                                            <a href="forgotpassword" class="text-primary float-right">Forgot Password?</a>
                                                        </div>
                                                    </div>
                                                    <button type="submit" class="btn btn-primary">Sign In</button>

                                                </form>
                                            </div>
                                        </div>
                                        <div class="col-lg-5 content-right">
                                            <img src="${pageContext.request.contextPath}/assets/images/login/01.png" class="img-fluid image-right" alt="">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
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