<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <title>Quản lý Đơn hàng</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">

                    <style>
                        .page-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 20px;
                        }

                        .page-header h2 {
                            margin: 0;
                        }

                        /* Status badge */
                        .status-badge {
                            display: inline-block;
                            padding: 4px 12px;
                            border-radius: 20px;
                            font-size: 12px;
                            font-weight: 700;
                            white-space: nowrap;
                        }

                        .status-PENDING {
                            background: #fff3cd;
                            color: #856404;
                        }

                        .status-PROCESSING {
                            background: #cfe2ff;
                            color: #0a58ca;
                        }

                        .status-SHIPPED {
                            background: #d1ecf1;
                            color: #0c5460;
                        }

                        .status-DELIVERED {
                            background: #d4edda;
                            color: #155724;
                        }

                        .status-CANCELLED {
                            background: #f8d7da;
                            color: #721c24;
                        }

                        .badge-updated {
                            display: inline-flex;
                            align-items: center;
                            gap: 5px;
                            background: #fff3cd;
                            color: #856404;
                            border: 1px solid #ffe082;
                            border-radius: 6px;
                            padding: 3px 9px;
                            font-size: 11px;
                            font-weight: 700;
                            white-space: nowrap;
                        }

                        /* Detail modal styles */
                        .detail-modal-overlay {
                            display: none;
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.55);
                            z-index: 2000;
                            align-items: flex-start;
                            justify-content: center;
                            overflow-y: auto;
                            padding: 40px 20px;
                        }

                        .detail-modal-content {
                            background: #fff;
                            border-radius: 14px;
                            padding: 32px;
                            width: 720px;
                            max-width: 100%;
                            box-shadow: 0 16px 48px rgba(0, 0, 0, 0.22);
                            position: relative;
                        }

                        .detail-modal-header {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 24px;
                            padding-bottom: 16px;
                            border-bottom: 1px solid #eee;
                        }

                        .detail-modal-header h3 {
                            margin: 0;
                            font-size: 20px;
                        }

                        .detail-close-btn {
                            background: none;
                            border: none;
                            font-size: 24px;
                            cursor: pointer;
                            color: #888;
                            line-height: 1;
                            padding: 4px;
                        }

                        .detail-close-btn:hover {
                            color: #333;
                        }

                        .detail-section {
                            margin-bottom: 22px;
                        }

                        .detail-section-title {
                            font-size: 13px;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            color: #999;
                            margin-bottom: 10px;
                        }

                        .detail-info-grid {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 10px 20px;
                        }

                        .detail-info-item label {
                            display: block;
                            font-size: 12px;
                            color: #888;
                            margin-bottom: 2px;
                        }

                        .detail-info-item span {
                            font-size: 15px;
                            color: #222;
                            font-weight: 500;
                        }

                        .detail-items-table {
                            width: 100%;
                            border-collapse: collapse;
                            border: 1px solid #eee;
                            border-radius: 8px;
                            overflow: hidden;
                        }

                        .detail-items-table th {
                            background: #f8f9ff;
                            padding: 10px 14px;
                            text-align: left;
                            font-size: 12px;
                            font-weight: 700;
                            text-transform: uppercase;
                            color: #888;
                            letter-spacing: 0.5px;
                        }

                        .detail-items-table td {
                            padding: 10px 14px;
                            font-size: 14px;
                            color: #444;
                            border-top: 1px solid #f0f0f0;
                        }

                        .detail-total-row {
                            display: flex;
                            justify-content: flex-end;
                            margin-top: 12px;
                            padding-top: 12px;
                            border-top: 2px solid #eee;
                            font-size: 16px;
                            font-weight: 700;
                            color: #222;
                            gap: 16px;
                        }

                        .detail-total-row span:last-child {
                            color: var(--primary-color);
                        }

                        .btn-view {
                            display: inline-flex;
                            align-items: center;
                            gap: 5px;
                            padding: 5px 12px;
                            background: #f0f4ff;
                            color: #2563eb;
                            border: 1px solid #c7d7fd;
                            border-radius: 7px;
                            font-size: 13px;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.15s;
                            white-space: nowrap;
                        }

                        .btn-view:hover {
                            background: #2563eb;
                            color: #fff;
                        }
                    </style>
                </head>

                <body>
                    <div class="admin-container">
                        <aside class="admin-sidebar">
                            <h2>Quản Trị</h2>
                            <nav class="admin-nav">
                                <a href="${pageContext.request.contextPath}/admin/index.jsp">Dashboard</a>
                                <a href="${pageContext.request.contextPath}/admin/users">Quản lý Người dùng</a>
                                <a href="${pageContext.request.contextPath}/admin/products">Quản lý Sản phẩm</a>
                                <a href="${pageContext.request.contextPath}/admin/orders">Quản lý Đơn hàng</a>
                                <a href="${pageContext.request.contextPath}/">Về trang khách hàng</a>
                            </nav>
                        </aside>
                        <main class="admin-content">
                            <div class="admin-card">
                                <div class="page-header">
                                    <h2>Danh sách Đơn hàng</h2>
                                    <div style="display: flex; gap: 10px;">
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="post"
                                            style="margin: 0;">
                                            <input type="hidden" name="action" value="recalculatePoints" />
                                            <button type="submit" class="btn btn-primary"
                                                onclick="return confirm('Bạn có chắc muốn tính lại điểm tích luỹ cho tất cả khách hàng dựa trên các đơn hàng đã giao?');"
                                                style="display:inline-flex;align-items:center;gap:6px;">
                                                <i class="fas fa-sync-alt"></i> Tính lại điểm tích luỹ
                                            </button>
                                        </form>
                                        <a href="${pageContext.request.contextPath}/admin/order_add.jsp"
                                            class="btn btn-secondary"
                                            style="display:inline-flex;align-items:center;gap:6px;">
                                            &#43; Thêm Đơn Hàng
                                        </a>
                                    </div>
                                </div>

                                <div style="margin-bottom: 20px;">
                                    <form action="${pageContext.request.contextPath}/admin/orders" method="get"
                                        style="display: flex; gap: 10px; flex-wrap:wrap;">
                                        <input type="text" name="donHangId" value="${fn:escapeXml(searchDonHangId)}"
                                            class="form-control" placeholder="Mã đơn hàng" style="max-width: 200px;" />
                                        <input type="text" name="khachHangId" value="${fn:escapeXml(searchKhachHangId)}"
                                            class="form-control" placeholder="Mã khách hàng"
                                            style="max-width: 200px;" />
                                        <select name="status" class="form-control" style="width:180px;">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="PENDING" ${searchStatus=='PENDING' ? 'selected' : '' }>Đang
                                                chờ xử lý</option>
                                            <option value="PROCESSING" ${searchStatus=='PROCESSING' ? 'selected' : '' }>
                                                Đang xử lý</option>
                                            <option value="SHIPPED" ${searchStatus=='SHIPPED' ? 'selected' : '' }>Đang
                                                giao</option>
                                            <option value="DELIVERED" ${searchStatus=='DELIVERED' ? 'selected' : '' }>Đã
                                                giao</option>
                                            <option value="CANCELLED" ${searchStatus=='CANCELLED' ? 'selected' : '' }>Đã
                                                huỷ</option>
                                        </select>
                                        <button type="submit" class="btn btn-secondary">Lọc</button>
                                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn">Xóa bộ
                                            lọc</a>
                                    </form>
                                </div>

                                <table class="table-modern">
                                    <thead>
                                        <tr>
                                            <th>Mã ĐH</th>
                                            <th>Khách Hàng ID</th>
                                            <th>Ngày đặt</th>
                                            <th>Tổng tiền</th>
                                            <th>Người nhận & SĐT</th>
                                            <th>Địa chỉ giao hàng</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="o" items="${orders}">
                                            <tr>
                                                <td><strong>#${o.id}</strong></td>
                                                <td>${o.khachHangId}</td>
                                                <td>${o.ngayDatFormatted}</td>
                                                <td>
                                                    <strong style="color:var(--primary-color);">
                                                        <fmt:formatNumber value="${o.tongTien}" type="number"
                                                            pattern="#,###" /> VND
                                                    </strong>
                                                    <c:if test="${not empty o.maGiamGia && o.soTienGiam > 0}">
                                                        <div
                                                            style="font-size: 12px; color: #16a34a; margin-top: 4px; display: flex; align-items: center; gap: 4px;">
                                                            <i class="fas fa-tag"></i> <span>${o.maGiamGia} (-
                                                                <fmt:formatNumber value="${o.soTienGiam}"
                                                                    pattern="#,###" />)
                                                            </span>
                                                        </div>
                                                    </c:if>
                                                    <div style="margin-top: 6px;">
                                                        <c:choose>
                                                            <c:when test="${o.phuongThucThanhToan == 'QR_ONLINE'}">
                                                                <span class="payment-badge qr-badge"
                                                                    style="display:inline-flex; align-items:center; gap:4px; font-size:11px; background:#e0f2fe; color:#0369a1; padding:2px 8px; border-radius:12px; font-weight:600; white-space:nowrap;">
                                                                    <i class="fas fa-qrcode"></i> QR Online
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${o.phuongThucThanhToan == 'COD'}">
                                                                <span class="payment-badge cod-badge"
                                                                    style="display:inline-flex; align-items:center; gap:4px; font-size:11px; background:#f3f4f6; color:#374151; padding:2px 8px; border-radius:12px; font-weight:600; white-space:nowrap;">
                                                                    <i class="fas fa-money-bill-wave"></i> COD trực tiếp
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="payment-badge standard-badge"
                                                                    style="display:inline-flex; align-items:center; gap:4px; font-size:11px; background:#f3f4f6; color:#374151; padding:2px 8px; border-radius:12px; font-weight:600; white-space:nowrap;">
                                                                    <i class="fas fa-wallet"></i> ${empty
                                                                    o.phuongThucThanhToan ? 'Mặc định' :
                                                                    o.phuongThucThanhToan}
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div>${o.tenNguoiNhan}</div>
                                                    <div style="color:#888;font-size:13px;">${o.sdtNhanHang}</div>
                                                    <c:if test="${o.khachHangDaCapNhat}">
                                                        <div style="margin-top:6px;">
                                                            <span class="badge-updated">
                                                                <i class="fas fa-pen"></i> Khách đã cập nhật
                                                            </span>
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td style="max-width:160px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;"
                                                    title="${o.diaChiGiaoHang}">${o.diaChiGiaoHang}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${o.trangThai == 'PENDING'}">
                                                            <span class="status-badge status-PENDING">Đang chờ xử
                                                                lý</span>
                                                        </c:when>
                                                        <c:when test="${o.trangThai == 'PROCESSING'}">
                                                            <span class="status-badge status-PROCESSING">Đang xử
                                                                lý</span>
                                                        </c:when>
                                                        <c:when test="${o.trangThai == 'SHIPPED'}">
                                                            <span class="status-badge status-SHIPPED">Đang giao</span>
                                                        </c:when>
                                                        <c:when test="${o.trangThai == 'DELIVERED'}">
                                                            <span class="status-badge status-DELIVERED">Đã giao</span>
                                                        </c:when>
                                                        <c:when test="${o.trangThai == 'CANCELLED'}">
                                                            <span class="status-badge status-CANCELLED">Đã huỷ</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge">${o.trangThai}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div style="display: flex; gap: 6px; flex-wrap:wrap;">
                                                        <!-- Nút xem chi tiết -->
                                                        <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${o.id}"
                                                            class="btn-view" title="Xem chi tiết đơn hàng">
                                                            <i class="fas fa-eye"></i> Chi tiết
                                                        </a>
                                                        <!-- Cập nhật trạng thái -->
                                                        <form action="${pageContext.request.contextPath}/admin/orders"
                                                            method="post" style="display:flex; gap:6px;">
                                                            <input type="hidden" name="action" value="updateStatus" />
                                                            <input type="hidden" name="id" value="${o.id}" />
                                                            <select name="status" class="form-control"
                                                                style="width:auto; padding:5px; font-size:13px;">
                                                                <option value="PENDING" ${o.trangThai=='PENDING'
                                                                    ? 'selected' : '' }>Chờ xử lý</option>
                                                                <option value="PROCESSING" ${o.trangThai=='PROCESSING'
                                                                    ? 'selected' : '' }>Đang xử lý</option>
                                                                <option value="SHIPPED" ${o.trangThai=='SHIPPED'
                                                                    ? 'selected' : '' }>Đang giao</option>
                                                                <option value="DELIVERED" ${o.trangThai=='DELIVERED'
                                                                    ? 'selected' : '' }>Đã giao</option>
                                                                <option value="CANCELLED" ${o.trangThai=='CANCELLED'
                                                                    ? 'selected' : '' }>Đã huỷ</option>
                                                            </select>
                                                            <button type="submit" class="btn btn-secondary"
                                                                style="padding: 5px 10px; font-size:13px;">Cập
                                                                nhật</button>
                                                        </form>
                                                        <!-- Xóa -->
                                                        <form action="${pageContext.request.contextPath}/admin/orders"
                                                            method="post">
                                                            <input type="hidden" name="action" value="delete" />
                                                            <input type="hidden" name="id" value="${o.id}" />
                                                            <button type="submit" class="btn"
                                                                style="background: #d9534f; padding: 5px 10px; font-size:13px;"
                                                                onclick="return confirm('Bạn có chắc muốn xóa đơn hàng này?');">Xóa</button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </main>
                    </div>

                </body>

                </html>