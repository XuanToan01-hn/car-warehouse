<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Add New Supplier | InventoryPro</title>

            <link
                href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

            <style>
                body {
                    font-family: 'Be Vietnam Pro', sans-serif;
                    background: #f1f5f9;
                    color: #1e293b;
                    overflow-y: hidden;
                }

                .form-card {
                    background: #fff;
                    border-radius: 20px;
                    border: 1px solid #e2e8f0;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, .04);
                    max-width: 1000px;
                    margin: 1rem auto;
                    padding: 2.5rem 2rem;
                }

                .form-header {
                    margin-bottom: 1rem;
                    border-bottom: 1px solid #f1f5f9;
                    padding-bottom: 0.5rem;
                }

                .form-header h1 {
                    font-size: 1.7rem;
                    font-weight: 800;
                    margin: 0;
                    color: #0EA5E9;
                }

                .form-label {
                    font-weight: 700;
                    font-size: 0.85rem;
                    color: #334151;
                    margin-bottom: .3rem;
                    display: block;
                }

                .form-control-custom {
                    border-radius: 10px;
                    border: 1.8px solid #e2e8f0;
                    padding: .6rem 1rem;
                    width: 100%;
                    font-size: 0.95rem;
                    transition: all .2s;
                    outline: none;
                }

                .form-control-custom:focus {
                    border-color: #0EA5E9;
                    box-shadow: 0 0 0 4px rgba(14, 165, 233, .1);
                }

                .form-group {
                    margin-bottom: 0.75rem;
                }

                .btn-submit-lg {
                    background: #0EA5E9;
                    color: #fff;
                    border: none;
                    border-radius: 12px;
                    padding: .7rem 2rem;
                    font-weight: 800;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    gap: .6rem;
                    font-size: 0.95rem;
                    box-shadow: 0 4px 12px rgba(14, 165, 233, 0.2);
                }

                .btn-submit-lg:hover {
                    background: #0284c7;
                    transform: translateY(-1px);
                }

                .btn-back {
                    color: #64748b;
                    font-weight: 700;
                    text-decoration: none;
                    display: flex;
                    align-items: center;
                    gap: .5rem;
                    margin-bottom: 0.5rem;
                    font-size: 0.95rem;
                }

                .btn-back:hover {
                    color: #0f172a;
                }

                .content-page {
                    padding-top: 1.5rem !important;
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <%@ include file="../sidebar.jsp" %>
                    <%@ include file="../header.jsp" %>
                        <div class="content-page">
                            <div class="container-fluid">
                                <a href="${pageContext.request.contextPath}/manage-suppliers" class="btn-back">
                                    <i class="fas fa-arrow-left"></i> Return to Main List
                                </a>
                                <div class="form-card">
                                    <div class="form-header">
                                        <h1>Register Supplier</h1>
                                        <p class="text-muted" style="font-size:1rem; margin-bottom: 0;">Create a new
                                            supplier profile within the system.</p>
                                    </div>
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger mb-3 py-2 px-3"
                                            style="border-radius:10px; font-weight:600; font-size:0.9rem;">
                                            <i class="fas fa-exclamation-circle mr-2"></i> ${error}
                                        </div>
                                    </c:if>
                                    <form method="post" action="${pageContext.request.contextPath}/manage-suppliers">
                                        <input type="hidden" name="action" value="add">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Company/Supplier Name <span
                                                            class="text-danger">*</span></label>
                                                    <input type="text" name="name" class="form-control-custom" required
                                                        value="${supplier.name}" placeholder="Enter full name">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label class="form-label">Primary Contact Number <span
                                                            class="text-danger">*</span></label>
                                                    <input type="text" name="phone" class="form-control-custom"
                                                        pattern="[\d\s\-\.\(\)]{10,20}" required
                                                        value="${supplier.phone}" placeholder="Provide phone number">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Official Email Address <span
                                                    class="text-danger">*</span></label>
                                            <input type="email" name="email" class="form-control-custom" required
                                                value="${supplier.email}" placeholder="example@business.com">
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Business Location / Address</label>
                                            <textarea name="address" class="form-control-custom" rows="2"
                                                placeholder="Enter physical or office address">${supplier.address}</textarea>
                                        </div>
                                        <div class="d-flex justify-content-end mt-3">
                                            <button type="submit" class="btn-submit-lg">
                                                <i class="fas fa-plus"></i> Create Profile
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
            </div>
            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
        </body>

        </html>