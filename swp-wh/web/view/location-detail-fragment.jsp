<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="animate-fade-in p-2">
            <c:set var="totalQty" value="0" />
            <c:forEach var="g" items="${groupedProducts}">
                <c:set var="totalQty" value="${totalQty + g.totalQty}" />
            </c:forEach>

            <!-- Header Section -->
            <div class="d-flex justify-content-between align-items-center mb-4 px-3">
                <div>
                    <h2 class="font-weight-bold mb-1">Chi tiết Vị trí: <span
                            class="text-primary">${loc.locationCode}</span></h2>
                    <p class="text-secondary mb-0">${loc.locationName} | Sức chứa: <strong>${loc.maxCapacity}</strong>
                    </p>
                </div>
                <div class="badge badge-pill badge-light px-3 py-2 text-dark font-weight-bold"
                    style="background: #e2e8f0; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border-radius: 10px;">
                    ${totalQty} Xe hiện có
                </div>
            </div>

            <!-- Grouped Table -->
            <div class="card"
                style="border-radius: 16px; border: none; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); background: white; overflow: hidden;">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table mb-0" id="stockTable">
                            <thead style="background: #e2e8f0;">
                                <tr>
                                    <th
                                        style="font-weight: 800; color: #0f172a; text-transform: uppercase; font-size: 0.82rem; padding: 1rem 1.5rem;">
                                        Tên Xe</th>
                                    <th
                                        style="font-weight: 800; color: #0f172a; text-transform: uppercase; font-size: 0.82rem; padding: 1rem 1.5rem;">
                                        Mã Xe</th>
                                    <th class="text-center"
                                        style="font-weight: 800; color: #0f172a; text-transform: uppercase; font-size: 0.82rem; padding: 1rem 1.5rem;">
                                        Tổng số</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="g" items="${groupedProducts}" varStatus="status">
                                    <tr class="product-row" data-toggle="collapse"
                                        data-target="#serials-${status.index}"
                                        style="cursor: pointer; transition: background 0.2s;">
                                        <td style="padding: 1.25rem 1.5rem; vertical-align: middle;">
                                            <div class="font-weight-bold text-dark d-flex align-items-center">
                                                <i class="ri-arrow-right-s-line mr-2 text-primary toggle-icon"></i>
                                                ${g.product.name}
                                            </div>
                                        </td>
                                        <td style="padding: 1.25rem 1.5rem; vertical-align: middle;">
                                            <span class="text-primary font-weight-bold">${g.product.code}</span>
                                        </td>
                                        <td class="text-center"
                                            style="padding: 1.25rem 1.5rem; vertical-align: middle;">
                                            <span class="badge badge-primary px-3 py-2"
                                                style="font-size: 0.9rem; border-radius: 8px;">${g.totalQty} xe</span>
                                        </td>
                                    </tr>
                                    <tr id="serials-${status.index}" class="collapse">
                                        <td colspan="3"
                                            style="padding: 0 1.5rem 1.5rem 1.5rem; background: #f8fafc; border-top: none;">
                                            <div class="pt-3">
                                                <div class="info-label mb-3"
                                                    style="font-size: 0.75rem; color: #64748b; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em;">
                                                    Danh sách số khung (VIN):</div>
                                                <div class="d-flex flex-column" style="gap: 4px;">
                                                    <c:forEach var="s" items="${g.serials}">
                                                        <div class="vin-tag-v">
                                                            <i class="ri-car-line mr-2 text-muted"></i> [ ${s} ]
                                                        </div>
                                                    </c:forEach>
                                                    <c:if test="${empty g.serials}">
                                                        <span class="text-muted italic">Không có số khung (Hàng
                                                            lô)</span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty groupedProducts}">
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

            <style>
                .product-row:hover {
                    background: #f1f5f9;
                }

                .product-row[aria-expanded="true"] {
                    background: #f8fafc;
                }

                .product-row[aria-expanded="true"] .toggle-icon {
                    transform: rotate(90deg);
                }

                .toggle-icon {
                    transition: transform 0.2s;
                }

                .vin-tag-v {
                    background: white;
                    color: #475569;
                    padding: 0.5rem 1rem;
                    border-radius: 8px;
                    border: 1px solid #e2e8f0;
                    font-size: 0.95rem;
                    font-weight: 500;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
                    display: flex;
                    align-items: center;
                    width: fit-content;
                    letter-spacing: 0.5px;
                }

                .vin-tag-v:hover {
                    border-color: #0EA5E9;
                    background: #f0f9ff;
                }
            </style>

            <div class="text-right mt-4 px-2">
                <button type="button" class="btn btn-secondary" data-dismiss="modal"
                    style="border-radius: 12px; padding: 0.6rem 1.5rem; font-weight: 600; background: #94a3b8; border: none;">
                    Đóng
                </button>
            </div>
        </div>