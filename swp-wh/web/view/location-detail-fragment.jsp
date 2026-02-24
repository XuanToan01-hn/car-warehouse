<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <div class="animate-fade-in">
            <div class="row no-gutters">
                <!-- Specs Column -->
                <div class="col-md-5 bg-white p-4 border-right" style="border-right: 1px solid #f1f5f9 !important;">
                    <div class="d-flex align-items-center mb-4">
                        <div class="p-3 rounded-circle mr-3" style="background: rgba(37, 99, 235, 0.05);">
                            <i class="ri-focus-3-line text-primary h4 mb-0"></i>
                        </div>
                        <div>
                            <h6 class="font-weight-bold text-dark mb-0">Technical Specs</h6>
                            <small class="text-secondary">Core location properties</small>
                        </div>
                    </div>

                    <div class="spec-grid">
                        <div class="mb-4">
                            <label class="text-secondary small font-weight-bold text-uppercase d-block"
                                style="letter-spacing: 0.05em; font-size: 0.85rem;">Identifier Code</label>
                            <span class="text-dark font-weight-bold h4">${loc.locationCode}</span>
                        </div>
                        <div class="mb-4">
                            <label class="text-secondary small font-weight-bold text-uppercase d-block"
                                style="letter-spacing: 0.05em; font-size: 0.85rem;">Description Name</label>
                            <span class="text-dark font-weight-medium"
                                style="font-size: 1.2rem;">${loc.locationName}</span>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="text-secondary small font-weight-bold text-uppercase d-block"
                                    style="letter-spacing: 0.05em; font-size: 0.85rem;">Category</label>
                                <span
                                    class="badge ${loc.locationType == 'ZONE' ? 'badge-ZONE' : (loc.locationType == 'RACK' ? 'badge-RACK' : 'badge-BIN')}"
                                    style="font-size: 1rem;">${loc.locationType}</span>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="text-secondary small font-weight-bold text-uppercase d-block"
                                    style="letter-spacing: 0.05em; font-size: 0.85rem;">Capacity (Aggregated)</label>
                                <div class="d-flex align-items-baseline">
                                    <span class="text-dark font-weight-bold h4">${loc.aggregatedCapacity}</span>
                                    <small class="ml-1 text-secondary" style="font-size: 0.9rem;">Units</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 p-3 rounded-lg" style="background: #f8fafc; border: 1px dashed #cbd5e1;">
                        <div class="d-flex align-items-center text-primary">
                            <i class="ri-information-line mr-2"></i>
                            <span class="small font-weight-bold">System Recommendation</span>
                        </div>
                        <p class="small text-secondary mb-0 mt-2">
                            Ensure accurate inventory tracking by scanning items before placement in this
                            ${loc.locationType.toLowerCase()}.
                        </p>
                    </div>
                </div>

                <!-- Stock Column -->
                <div class="col-md-7 p-4 bg-light">
                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <div class="d-flex align-items-center">
                            <div class="p-3 rounded-circle mr-3" style="background: rgba(16, 185, 129, 0.05);">
                                <i class="ri-database-2-line text-success h4 mb-0"></i>
                            </div>
                            <div>
                                <h6 class="font-weight-bold text-dark mb-0">Live Inventory</h6>
                                <small class="text-secondary">Current stock availability</small>
                            </div>
                        </div>
                        <span class="badge badge-pill badge-light px-3 py-2 text-dark font-weight-bold"
                            style="background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                            ${not empty products ? products.size() : 0} Items
                        </span>
                    </div>

                    <div class="table-responsive" style="max-height: 400px;">
                        <table class="table table-borderless table-hover" style="background: transparent;">
                            <thead>
                                <tr style="border-bottom: 2px solid #e2e8f0;">
                                    <th class="font-weight-bold text-uppercase text-secondary px-0"
                                        style="font-size: 0.85rem;">Product Asset</th>
                                    <th class="font-weight-bold text-uppercase text-secondary"
                                        style="font-size: 0.85rem;">ID/Serial</th>
                                    <th class="font-weight-bold text-uppercase text-secondary text-right px-0"
                                        style="font-size: 0.85rem;">Qty</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${products}">
                                    <tr class="align-middle">
                                        <td class="px-0 py-3">
                                            <div class="font-weight-bold text-dark" style="font-size: 1.1rem;">
                                                ${p.product.name}</div>
                                            <small class="text-primary font-weight-bold"
                                                style="font-size: 0.9rem;">${p.product.code}</small>
                                        </td>
                                        <td class="py-3">
                                            <code
                                                style="font-size: 1rem;">${p.productDetail.serialNumber != null ? p.productDetail.serialNumber : 'N/A'}</code>
                                        </td>
                                        <td class="text-right font-weight-bold text-dark px-0 py-3">
                                            <div class="d-flex flex-column align-items-end">
                                                <span style="font-size: 1.1rem;">${p.quantity}</span>
                                                <small class="text-secondary" style="font-size: 0.85rem;">Units</small>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty products}">
                                    <tr>
                                        <td colspan="3" class="text-center py-5">
                                            <i class="ri-inbox-line display-4 text-muted d-block opacity-25"></i>
                                            <p class="text-secondary mt-3">This location is currently vacant.</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>