<%-- 
    Document   : location-product-form
    Created on : Feb 25, 2026, 10:23:07 AM
    Author     : Asus
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Add/Update Stock Location | InventoryPro</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css">
    
    <style>
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            padding: 2rem;
            background: #f1f5f9;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
        }
        .card {
            background: white;
            border-radius: 16px;
            padding: 2.5rem;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
        }
        .header {
            margin-bottom: 2rem;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 1rem;
        }
        .header h1 {
            font-size: 1.5rem;
            color: #0f172a;
            margin: 0;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .label {
            display: block;
            font-weight: 700;
            color: #64748b;
            font-size: 0.8rem;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-family: inherit;
            font-size: 1rem;
            color: #1e293b;
            box-sizing: border-box;
        }
        .form-control:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        .btn-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            border: none;
            transition: all 0.2s;
        }
        .btn-primary {
            background: #2563eb;
            color: white;
            flex: 2;
        }
        .btn-primary:hover {
            background: #1d4ed8;
        }
        .btn-secondary {
            background: #f1f5f9;
            color: #64748b;
            flex: 1;
        }
        .btn-secondary:hover {
            background: #e2e8f0;
        }
        small.help-text {
            color: #94a3b8;
            font-size: 0.75rem;
            display: block;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="card">
            <div class="header">
                <h1>Move Stock to Location</h1>
                <p style="color: #64748b; font-size: 0.9rem;">Assign products to a specific storage area.</p>
            </div>

            <form action="location-product" method="post">
                <div class="form-group">
                    <label class="label" for="locationId">Storage Location</label>
                    <select name="locationId" id="locationId" class="form-control" required>
                        <option value="">-- Select a Location --</option>
                        <c:forEach items="${locations}" var="l">
                            <option value="${l.id}">${l.locationName} (Code: ${l.locationCode})</option>
                        </c:forEach>
                    </select>
                    <small class="help-text">Where the stock will be stored.</small>
                </div>

                <div class="form-group">
                    <label class="label" for="productDetailId">Product Item & Specification</label>
                    <select name="productDetailId" id="productDetailId" class="form-control" required>
                        <option value="">-- Select Product Detail --</option>
                        <c:forEach items="${details}" var="d">
                            <option value="${d.id}">
                                ${d.product.name} | Color: ${d.color} | Lot: ${d.lotNumber}
                            </option>
                        </c:forEach>
                    </select>
                    <small class="help-text">Specific item including color and lot info.</small>
                </div>

                <div class="form-group">
                    <label class="label" for="quantity">Actual Quantity</label>
                    <input type="number" 
                           name="quantity" 
                           id="quantity" 
                           class="form-control" 
                           placeholder="Enter quantity" 
                           min="1" 
                           required>
                    <small class="help-text">The total amount available at this location.</small>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">Save Stock Entry</button>
                    <a href="location-product?action=list" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
