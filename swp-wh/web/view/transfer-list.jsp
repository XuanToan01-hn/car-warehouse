<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!doctype html>
        <html lang="en">

        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <title>Internal Transfers | InventoryPro</title>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@2.5.0/fonts/remixicon.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend-plugin.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/backend.css?v=1.0.0">
            <style>
                body {
                    font-family: 'Inter', sans-serif;
                    background-color: #f8fafc;
                }

                .page-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 1.5rem 0;
                    margin-bottom: 1rem;
                }

                .card-main {
                    border-radius: 16px;
                    border: none;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
                    background: white;
                    overflow: hidden;
                }

                .badge-pending {
                    background: #fffbeb;
                    color: #92400e;
                    padding: 0.4rem 0.8rem;
                    border-radius: 8px;
                    font-weight: 700;
                    font-size: 0.75rem;
                    text-transform: uppercase;
                }

                .table thead th {
                    background: #f1f5f9;
                    font-weight: 800;
                    color: #475569;
                    text-transform: uppercase;
                    font-size: 0.75rem;
                    padding: 1.25rem 1.5rem;
                    border-bottom: 1px solid #e2e8f0;
                }

                .table tbody td {
                    padding: 1.25rem 1.5rem;
                    vertical-align: middle;
                    border-bottom: 1px solid #f1f5f9;
                }

                /* Modal Styles - Thân thiện & Chuyên nghiệp hơn */
                .modal-content {
                    border-radius: 24px;
                    border: none;
                    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.15);
                    overflow: hidden;
                }

                .modal-header {
                    border-bottom: 1px solid #f8fafc;
                    padding: 1.2rem 2rem;
                    background: #fff;
                }

                .modal-body {
                    padding: 1.5rem 2rem;
                    background: #fff;
                }

                .info-section {
                    background: #fcfdfe;
                    border-radius: 16px;
                    padding: 1.2rem;
                    margin-bottom: 1.25rem;
                    border: 1px solid #edf2f7;
                }

                .detail-label {
                    font-size: 0.75rem;
                    text-transform: uppercase;
                    color: #64748b;
                    font-weight: 800;
                    letter-spacing: 0.08em;
                    margin-bottom: 0.5rem;
                    display: block;
                }

                .detail-value {
                    font-size: 1.1rem;
                    color: #1e293b;
                    font-weight: 600;
                }

                .route-node {
                    display: flex;
                    align-items: center;
                    background: white;
                    border: 1px solid #f1f5f9;
                    padding: 0.8rem 1rem;
                    border-radius: 12px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
                }

                .route-line {
                    width: 35px;
                    height: 2px;
                    background: #e2e8f0;
                    margin: 0 10px;
                    position: relative;
                }

                .route-line::after {
                    content: '\ea6e';
                    font-family: 'remixicon';
                    font-size: 1.1rem;
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    color: #64748b;
                }

                .product-banner {
                    background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                    border-left: 5px solid #0ea5e9;
                    padding: 1.2rem;
                    border-radius: 14px;
                    margin-bottom: 1.5rem;
                }

                .rounded-xl {
                    border-radius: 10px !important;
                }

                .btn-approve {
                    background: #0ea5e9;
                    border: none;
                    transition: all 0.3s;
                    color: white;
                }

                .btn-approve:hover {
                    background: #0284c7;
                    transform: translateY(-1px);
                    box-shadow: 0 10px 15px -3px rgba(14, 165, 233, 0.3);
                }

                .badge-step {
                    background: #e0f2fe;
                    color: #0369a1;
                    padding: 0.2rem 0.6rem;
                    border-radius: 6px;
                    font-weight: 700;
                    margin-right: 0.5rem;
                }
            </style>
        </head>

        <body>
            <div class="wrapper">
                <%@ include file="sidebar.jsp" %>
                    <div class="content-page">
                        <div class="container-fluid">
                            <div class="page-header">
                                <div>
                                    <h1 class="font-weight-bold h2">Internal Transfers</h1>
                                    <p class="text-muted mb-0">Create Request & Approve Note</p>
                                </div>
                                <div>
                                    <a href="warehouse-transfer" class="btn btn-outline-primary"><i
                                            class="ri-truck-line"></i> Warehouse Ops</a>
                                    <a href="internal-transfer?action=form" class="btn btn-success ml-2"><i
                                            class="ri-add-line"></i> Create New Request</a>
                                </div>
                            </div>

                            <c:if test="${not empty sessionScope.msg}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="ri-checkbox-circle-line mr-2"></i> ${sessionScope.msg}
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <% session.removeAttribute("msg"); %>
                            </c:if>

                            <div class="card card-main">
                                <div class="card-header bg-white border-bottom py-3">
                                    <h5 class="mb-0 font-weight-bold text-primary">List of Transfer Requests</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Order ID</th>
                                                    <th>Route (From -> To)</th>
                                                    <th>Product Detail</th>
                                                    <th>Quantity</th>
                                                    <th>Status</th>
                                                    <th class="text-right px-4">Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${pendingList}" var="item">
                                                    <tr>
                                                        <td><span class="font-weight-bold">${item.transferCode}</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <span
                                                                    class="badge badge-light border px-2 py-1">${item.fromLocationName}</span>
                                                                <i class="ri-arrow-right-line mx-2 text-muted"></i>
                                                                <span
                                                                    class="badge badge-light border px-2 py-1">${item.toLocationName}</span>
                                                            </div>
                                                        </td>
                                                        <td>ID: ${item.productDetailId}</td>
                                                        <td class="font-weight-bold text-primary">${item.quantity}</td>
                                                        <td><span class="badge-pending">Pending</span></td>
                                                        <td class="text-right px-4">
                                                            <button type="button"
                                                                class="btn btn-info btn-sm rounded-pill px-4"
                                                                onclick="viewDetail(${item.id})">
                                                                <i class="ri-eye-line mr-1"></i> View Detail
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty pendingList}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-5">
                                                            <div class="text-muted">
                                                                <i class="ri-inbox-line ri-3x mb-3 d-block"></i>
                                                                <p>No pending transfer requests.</p>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
            </div>
            <!-- Detail Modal -->
            <div class="modal fade" id="detailModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title font-weight-bold">Chi tiết yêu cầu chuyển kho</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div id="loadingDetail" class="text-center py-4">
                                <div class="spinner-border text-primary" role="status"></div>
                                <p class="mt-2 text-muted">Đang tải thông tin...</p>
                            </div>
                            <div id="detailContent" style="display: none;">
                                <!-- Header Info -->
                                <div class="row mb-3">
                                    <div class="col-md-7">
                                        <span class="detail-label text-primary">Mã vận đơn</span>
                                        <span id="dtCode" class="detail-value h5 font-weight-bold mb-0"></span>
                                    </div>
                                    <div class="col-md-5 text-md-right border-left pl-4">
                                        <span class="detail-label">Số lượng chuyển</span>
                                        <div class="d-flex align-items-baseline justify-content-md-end">
                                            <span id="dtQty" class="text-dark font-weight-bold h3 mb-0"></span>
                                            <span class="text-muted ml-1" style="font-size: 1rem;">chiếc</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Left Column: Product & Note -->
                                    <div class="col-md-6">
                                        <div class="product-banner mb-3">
                                            <span class="detail-label text-primary">Xe / Sản phẩm</span>
                                            <div id="dtProduct" class="detail-value font-weight-bold truncate-2"
                                                style="font-size: 1.15rem;"></div>
                                        </div>
                                        <div class="info-section mb-0" style="padding: 1rem;">
                                            <span class="detail-label">Lý do / Ghi chú</span>
                                            <div class="p-2 border rounded bg-white text-muted"
                                                style="min-height: 80px;">
                                                <span id="dtNote"
                                                    style="font-style: italic; line-height: 1.5; display: block; font-size: 0.95rem;"></span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Right Column: Route -->
                                    <div class="col-md-6">
                                        <div class="info-section h-100 mb-0">
                                            <span class="detail-label">Lộ trình vận chuyển</span>
                                            <div class="d-flex flex-column gap-3 mt-2">
                                                <div class="route-node">
                                                    <i class="ri-map-pin-2-fill text-danger mr-3"
                                                        style="font-size: 1.2rem;"></i>
                                                    <div style="line-height: 1.3;">
                                                        <small class="text-muted d-block"
                                                            style="font-size: 0.75rem;">NGUỒN</small>
                                                        <span id="dtFrom" style="font-size: 1rem;"></span>
                                                    </div>
                                                </div>
                                                <div class="text-center my-1">
                                                    <i class="ri-arrow-down-line text-muted h4 mb-0"></i>
                                                </div>
                                                <div class="route-node">
                                                    <i class="ri-checkbox-circle-fill text-success mr-3"
                                                        style="font-size: 1.2rem;"></i>
                                                    <div style="line-height: 1.3;">
                                                        <small class="text-muted d-block"
                                                            style="font-size: 0.75rem;">ĐÍCH</small>
                                                        <span id="dtTo" style="font-size: 1rem;"></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Actions -->
                                <div class="d-flex justify-content-end mt-4 pt-3 border-top">
                                    <form action="internal-transfer" method="POST" class="mr-2">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="transferId" id="cancelId">
                                        <button type="submit"
                                            class="btn btn-outline-danger px-4 rounded-xl font-weight-bold"
                                            onclick="return confirm('Bạn có chắc chắn muốn HỦY yêu cầu này?')">
                                            Hủy yêu cầu
                                        </button>
                                    </form>
                                    <form action="internal-transfer" method="POST">
                                        <input type="hidden" name="action" value="approve">
                                        <input type="hidden" name="transferId" id="approveId">
                                        <button type="submit"
                                            class="btn btn-approve px-5 rounded-xl font-weight-bold shadow-sm"
                                            onclick="return confirm('Phê duyệt và tạo phiếu chuyển cho đơn này?')">
                                            <i class="ri-check-line mr-1"></i> Phê duyệt ngay
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/assets/js/backend-bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
            <script>
                function viewDetail(id) {
                    $('#detailModal').modal('show');
                    $('#loadingDetail').show();
                    $('#detailContent').hide();

                    fetch('${pageContext.request.contextPath}/internal-transfer?action=getDetail&id=' + id)
                        .then(res => res.json())
                        .then(data => {
                            $('#loadingDetail').hide();
                            $('#dtCode').text(data.code);
                            $('#dtFrom').text(data.from);
                            $('#dtTo').text(data.to);
                            $('#dtProduct').text(data.product);
                            $('#dtQty').text(data.qty);
                            $('#dtNote').text(data.note || 'Không có ghi chú');

                            $('#approveId').val(data.id);
                            $('#cancelId').val(data.id);

                            $('#detailContent').fadeIn();
                        })
                        .catch(err => {
                            console.error(err);
                            alert('Lỗi khi tải dữ liệu chi tiết');
                            $('#detailModal').modal('hide');
                        });
                }
            </script>
        </body>

        </html>