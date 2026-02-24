<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="animate-fade-in p-2">
            <!-- Header Section matching the main style -->
            <div class="d-flex justify-content-between align-items-center mb-4 px-3">
                <div>
                    <h2 class="font-weight-bold mb-1">Chi tiết Vị trí: <span
                            class="text-primary">${loc.locationCode}</span></h2>
                    <p class="text-secondary mb-0">${loc.locationName} | Sức chứa: <strong>${loc.maxCapacity}</strong>
                    </p>
                </div>
                <div class="badge badge-pill badge-light px-3 py-2 text-dark font-weight-bold"
                    style="background: #e2e8f0; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border-radius: 10px;">
                    ${not empty products ? products.size() : 0} Xe hiện có
                </div>
            </div>

            <!-- Table Section matching the main card-main style -->
            <div class="card"
                style="border-radius: 16px; border: none; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); background: white; overflow: hidden;">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table mb-0">
                            <thead style="background: #e2e8f0;">
                                <tr>
                                    <th
                                        style="font-weight: 800; color: #0f172a; text-transform: uppercase; font-size: 0.85rem; padding: 1.25rem 1.5rem;">
                                        Tên Xe / Mã Xe</th>
                                    <th
                                        style="font-weight: 800; color: #0f172a; text-transform: uppercase; font-size: 0.85rem; padding: 1.25rem 1.5rem;">
                                        Số khung (Serial)</th>
                                    <th class="text-center"
                                        style="font-weight: 800; color: #0f172a; text-transform: uppercase; font-size: 0.85rem; padding: 1.25rem 1.5rem;">
                                        Số lượng</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${products}">
                                    <tr style="border-bottom: 1px solid #f1f5f9;">
                                        <td style="padding: 1.25rem 1.5rem; vertical-align: middle;">
                                            <div class="font-weight-bold text-dark" style="font-size: 1rem;">
                                                ${p.product.name}</div>
                                            <span class="text-primary font-weight-bold"
                                                style="font-size: 0.85rem;">${p.product.code}</span>
                                        </td>
                                        <td style="padding: 1.25rem 1.5rem; vertical-align: middle;">
                                            <code
                                                style="font-size: 0.95rem; color: #475569; background: #f8fafc; padding: 0.2rem 0.5rem; border-radius: 6px; border: 1px solid #e2e8f0;">
                                        ${p.productDetail.serialNumber != null ? p.productDetail.serialNumber : 'N/A'}
                                    </code>
                                        </td>
                                        <td class="text-center"
                                            style="padding: 1.25rem 1.5rem; vertical-align: middle;">
                                            <span class="font-weight-bold text-dark"
                                                style="font-size: 1.1rem;">${p.quantity}</span>
                                            <small class="text-secondary ml-1">Xe</small>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty products}">
                                    <tr>
                                        <td colspan="3" class="text-center py-5" style="background: #f8fafc;">
                                            <i class="ri-inbox-line display-4 text-muted d-block opacity-25"></i>
                                            <p class="text-secondary mt-3 font-weight-bold">Vị trí này hiện đang trống.
                                            </p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="text-right mt-4 px-2">
                <button type="button" class="btn btn-secondary" data-dismiss="modal"
                    style="border-radius: 12px; padding: 0.6rem 1.5rem; font-weight: 600; background: #94a3b8; border: none;">
                    Đóng
                </button>
            </div>
        </div>