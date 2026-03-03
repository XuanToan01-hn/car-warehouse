<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                <title>Move Stock | InventoryPro</title>

                <link
                    href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">

                <style>
                    :root {
                        --primary: #0EA5E9;
                        --success: #15803D;
                        --warning: #F59E0B;
                        --danger: #EF4444;
                        --gray-dark: #0f172a;
                    }

                    body {
                        font-family: 'Be Vietnam Pro', sans-serif;
                        background-color: #f1f5f9;
                        color: #1e293b;
                    }

                    .form-container {
                        max-width: 800px;
                        margin: 2rem auto;
                    }

                    .card-main {
                        border-radius: 20px;
                        border: none;
                        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.05);
                        background: white;
                        overflow: hidden;
                    }

                    .card-header-premium {
                        background: #fff;
                        border-bottom: 1px solid #f1f5f9;
                        padding: 2rem;
                    }

                    .card-body-premium {
                        padding: 2.5rem;
                    }

                    .form-label {
                        font-weight: 700;
                        color: #475569;
                        text-transform: uppercase;
                        font-size: 0.75rem;
                        letter-spacing: 0.05em;
                        margin-bottom: 0.75rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .form-label i {
                        color: var(--primary);
                        font-size: 1rem;
                    }

                    .form-control {
                        border-radius: 12px;
                        border: 2px solid #e2e8f0;
                        font-weight: 600;
                        padding: 0.75rem 1rem;
                        height: auto;
                        transition: all 0.2s;
                    }

                    .form-control:focus {
                        border-color: var(--primary);
                        box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.1);
                    }

                    .help-text {
                        color: #94a3b8;
                        font-size: 0.8rem;
                        margin-top: 0.5rem;
                        display: block;
                    }

                    .btn-submit {
                        background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
                        color: white !important;
                        border-radius: 12px;
                        padding: 0.85rem 2rem;
                        font-weight: 800;
                        border: none;
                        box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
                        transition: all 0.3s ease;
                        width: 100%;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        gap: 0.75rem;
                        font-size: 1rem;
                    }

                    .btn-submit:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 16px rgba(14, 165, 233, 0.4);
                    }

                    .btn-cancel {
                        background: #f1f5f9;
                        color: #64748b !important;
                        border-radius: 12px;
                        padding: 0.85rem 2rem;
                        font-weight: 700;
                        border: none;
                        width: 100%;
                        text-align: center;
                        transition: all 0.2s;
                        display: block;
                        margin-top: 1rem;
                    }

                    .btn-cancel:hover {
                        background: #e2e8f0;
                        color: #475569 !important;
                    }

                    .section-icon {
                        width: 48px;
                        height: 48px;
                        background: #e0f2fe;
                        color: var(--primary);
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.5rem;
                        margin-bottom: 1.5rem;
                    }
                </style>
            </head>

            <body>
                <div class="wrapper">
                    <jsp:include page="../sidebar.jsp" />
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="form-container">
                                <div class="card card-main">
                                    <div class="card-header-premium">
                                        <div class="section-icon">
                                            <i class="ri-truck-line"></i>
                                        </div>
                                        <h2 class="font-weight-bold mb-1">Move Stock to Location</h2>
                                        <p class="text-secondary mb-0">Assign inventory items to specific storage areas
                                            within the warehouse.</p>
                                    </div>
                                    <div class="card-body-premium">
                                        <form action="location-product" method="post">
                                            <div class="row">
                                                <div class="col-md-12 mb-4">
                                                    <label class="form-label" for="locationId">
                                                        <i class="ri-map-pin-2-line"></i> Storage Location
                                                    </label>
                                                    <select name="locationId" id="locationId" class="form-control"
                                                        required>
                                                        <option value="">-- Choose destination zone --</option>
                                                        <c:forEach items="${locations}" var="l">
                                                            <option value="${l.id}">${l.locationName} (Code:
                                                                ${l.locationCode})</option>
                                                        </c:forEach>
                                                    </select>
                                                    <small class="help-text">Specify exactly where this stock will be
                                                        stored (Zone/Area).</small>
                                                </div>

                                                <div class="col-md-12 mb-4">
                                                    <label class="form-label" for="productDetailId">
                                                        <i class="ri-car-line"></i> Product & Specification
                                                    </label>
                                                    <select name="productDetailId" id="productDetailId"
                                                        class="form-control" required>
                                                        <option value="">-- Select product item --</option>
                                                        <c:forEach items="${details}" var="d">
                                                            <option value="${d.id}">
                                                                ${d.product.name} | COLOR: ${d.color} | LOT:
                                                                ${d.lotNumber}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                    <small class="help-text">Select the unique product identifier
                                                        including attributes.</small>
                                                </div>

                                                <div class="col-md-12 mb-5">
                                                    <label class="form-label" for="quantity">
                                                        <i class="ri-numbers-line"></i> Available Quantity
                                                    </label>
                                                    <input type="number" name="quantity" id="quantity"
                                                        class="form-control" placeholder="Enter stock quantity" min="1"
                                                        required>
                                                    <small class="help-text">Total number of units to be placed at this
                                                        location.</small>
                                                </div>
                                            </div>

                                            <div class="form-actions mt-2">
                                                <button type="submit" class="btn btn-submit">
                                                    <i class="ri-save-3-line"></i> Confirm Stock Entry
                                                </button>
                                                <a href="location-product?action=list" class="btn btn-cancel">
                                                    Return to Inventory List
                                                </a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.0.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
            </body>

            </html>