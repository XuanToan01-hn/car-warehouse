<%-- 
    Document   : transfer-list
    Created on : Mar 5, 2026, 6:35:47 PM
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>Stock Transfer Management</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
    <h2>Internal Stock Transfer</h2>
    <hr>
    
    <c:if test="${param.msg == 'success'}">
        <div class="alert alert-success">Transfer recorded successfully! Inventory updated.</div>
    </c:if>

    <table class="table table-bordered">
        <thead class="table-dark">
            <tr>
                <th>Code</th>
                <th>From</th>
                <th>To</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${transfers}" var="t">
                <tr>
                    <td>${t.transferCode}</td>
                    <td>${t.fromLocationName}</td>
                    <td>${t.toLocationName}</td>
                    <td>
                        <span class="badge ${t.status == 3 ? 'bg-success' : 'bg-warning'}">
                            ${t.status == 1 ? 'Requested' : (t.status == 2 ? 'In Note' : 'Recorded')}
                        </span>
                    </td>
                    <td>
                        <c:if test="${t.status < 3}">
                            <a href="transfer?action=record&id=${t.id}" 
                               class="btn btn-sm btn-primary" 
                               onclick="return confirm('Do you want to record this transfer? This will change stock levels.')">
                               Record Transfer
                            </a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>