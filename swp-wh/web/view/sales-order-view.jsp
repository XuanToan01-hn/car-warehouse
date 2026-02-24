<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!doctype html>
            <html lang="en">

            <head>
                <meta charset="utf-8">
                <title>Order Details | InventoryPro</title>
                <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
                <style>
                    body {
                        font-family: 'Be Vietnam Pro', sans-serif;
                        padding: 2rem;
                        background: #f1f5f9;
                    }

                    .card {
                        background: white;
                        border-radius: 16px;
                        padding: 2rem;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                    }

                    .header {
                        display: flex;
                        justify-content: space-between;
                        margin-bottom: 2rem;
                        border-bottom: 2px solid #f1f5f9;
                        padding-bottom: 1rem;
                    }

                    .label {
                        font-weight: 700;
                        color: #64748b;
                        font-size: 0.8rem;
                        text-transform: uppercase;
                    }

                    .value {
                        font-weight: 600;
                        color: #0f172a;
                        margin-bottom: 1rem;
                    }
                </style>
            </head>

            <body>
                <div class="card">
                    <div class="header">
                        <h1>Order ${order.orderCode}</h1>
                        <a href="sales-order?action=list" class="btn btn-secondary">Back to List</a>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="label">Customer</div>
                            <div class="value">${order.customer.name}</div>
                        </div>
                        <div class="col-md-4">
                            <div class="label">Created Date</div>
                            <div class="value">
                                <fmt:formatDate value="${order.createdDate}" pattern="dd/MM/yyyy HH:mm" />
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="label">Total Amount</div>
                            <div class="value">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$" />
                            </div>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="label">Note</div>
                        <div class="value">${order.note}</div>
                    </div>
                </div>
            </body>

            </html>