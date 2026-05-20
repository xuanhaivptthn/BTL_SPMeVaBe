<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Đơn Hàng - Quản Trị</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .page-header h2 { margin: 0; }

        /* Status badge */
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }
        .status-PENDING    { background: #fff3cd; color: #856404; }
        .status-PROCESSING { background: #cfe2ff; color: #0a58ca; }
        .status-SHIPPED    { background: #d1ecf1; color: #0c5460; }
        .status-DELIVERED  { background: #d4edda; color: #155724; }
        .status-CANCELLED  { background: #f8d7da; color: #721c24; }

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

        .detail-section { margin-bottom: 22px; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .detail-section-title {
            font-size: 14px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #666;
            margin-bottom: 15px;
            border-bottom: 2px solid #eee;
            padding-bottom: 8px;
        }
        .detail-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px 20px;
        }
        .detail-info-item label {
            display: block;
            font-size: 12px;
            color: #888;
            margin-bottom: 4px;
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
            padding: 12px 14px;
            text-align: left;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            color: #666;
            letter-spacing: 0.5px;
        }
        .detail-items-table td {
            padding: 12px 14px;
            font-size: 14px;
            color: #444;
            border-top: 1px solid #f0f0f0;
        }
        .detail-total-row {
            display: flex;
            justify-content: flex-end;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #eee;
            font-size: 18px;
            font-weight: 700;
            color: #222;
            gap: 16px;
        }
        .detail-total-row span:last-child { color: var(--primary-color, #e91e63); }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            background: #f0f4ff;
            color: #2563eb;
            border: 1px solid #c7d7fd;
            border-radius: 7px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.15s;
            text-decoration: none;
        }
        .btn-back:hover { background: #2563eb; color: #fff; }
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
            <div class="page-header">
                <h2>Chi tiết Đơn hàng #${order.id}</h2>
                <a href="${pageContext.request.contextPath}/admin/orders" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
            
            <div class="detail-section">
                <div class="detail-section-title">Thông tin đơn hàng</div>
                <div class="detail-info-grid">
                    <div class="detail-info-item">
                        <label>Ngày đặt</label>
                        <span>${empty order.ngayDatFormatted ? '—' : order.ngayDatFormatted}</span>
                    </div>
                    <div class="detail-info-item">
                        <label>Trạng thái</label>
                        <span>
                            <c:choose>
                                <c:when test="${order.trangThai == 'PENDING'}"><span class="status-badge status-PENDING">Đang chờ xử lý</span></c:when>
                                <c:when test="${order.trangThai == 'PROCESSING'}"><span class="status-badge status-PROCESSING">Đang xử lý</span></c:when>
                                <c:when test="${order.trangThai == 'SHIPPED'}"><span class="status-badge status-SHIPPED">Đang giao</span></c:when>
                                <c:when test="${order.trangThai == 'DELIVERED'}"><span class="status-badge status-DELIVERED">Đã giao</span></c:when>
                                <c:when test="${order.trangThai == 'CANCELLED'}"><span class="status-badge status-CANCELLED">Đã huỷ</span></c:when>
                                <c:otherwise><span class="status-badge">${order.trangThai}</span></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="detail-info-item">
                        <label>Khách hàng ID</label>
                        <span>${order.khachHangId}</span>
                    </div>
                    <div class="detail-info-item">
                        <label>Tổng tiền</label>
                        <span style="color:var(--primary-color);font-weight:700;"><fmt:formatNumber value="${order.tongTien}" pattern="#,###"/> VND</span>
                    </div>
                </div>
            </div>
            
            <div class="detail-section">
                <div class="detail-section-title">
                    Thông tin giao hàng
                    <c:if test="${order.khachHangDaCapNhat}">
                        <span class="badge-updated" style="margin-left:8px;"><i class="fas fa-pen"></i> Khách đã cập nhật</span>
                    </c:if>
                </div>
                <div class="detail-info-grid">
                    <div class="detail-info-item">
                        <label>Người nhận</label>
                        <span>${empty order.tenNguoiNhan ? '—' : fn:escapeXml(order.tenNguoiNhan)}</span>
                    </div>
                    <div class="detail-info-item">
                        <label>Số điện thoại</label>
                        <span>${empty order.sdtNhanHang ? '—' : fn:escapeXml(order.sdtNhanHang)}</span>
                    </div>
                    <div class="detail-info-item" style="grid-column:1/-1;">
                        <label>Địa chỉ giao hàng</label>
                        <span>${empty order.diaChiGiaoHang ? '—' : fn:escapeXml(order.diaChiGiaoHang)}</span>
                    </div>
                    <c:if test="${not empty order.ghiChu}">
                        <div class="detail-info-item" style="grid-column:1/-1;">
                            <label>Ghi chú</label>
                            <span>${fn:escapeXml(order.ghiChu)}</span>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <div class="detail-section">
                <div class="detail-section-title">Danh sách sản phẩm</div>
                <table class="detail-items-table">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th style="text-align:center;">Số lượng</th>
                            <th style="text-align:right;">Đơn giá</th>
                            <th style="text-align:right;">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty chiTiet}">
                                <c:forEach var="item" items="${chiTiet}">
                                    <tr>
                                        <td>${fn:escapeXml(item.tenSanPham)}</td>
                                        <td style="text-align:center;">${item.soLuong}</td>
                                        <td style="text-align:right;"><fmt:formatNumber value="${item.donGia}" pattern="#,###"/> VND</td>
                                        <td style="text-align:right;font-weight:600;"><fmt:formatNumber value="${item.soLuong * item.donGia}" pattern="#,###"/> VND</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" style="text-align:center;color:#aaa;">Không có sản phẩm</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <div class="detail-total-row">
                    <span>Tổng cộng:</span>
                    <span><fmt:formatNumber value="${order.tongTien}" pattern="#,###"/> VND</span>
                </div>
            </div>
            
            <div class="detail-section" style="display: flex; gap: 10px; justify-content: flex-end;">
                <!-- Cập nhật trạng thái -->
                <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:flex; gap:10px; align-items:center;">
                    <input type="hidden" name="action" value="updateStatus"/>
                    <input type="hidden" name="id" value="${order.id}"/>
                    <select name="status" class="form-control" style="width:auto; padding:8px; font-size:14px;">
                        <option value="PENDING"    ${order.trangThai == 'PENDING'    ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="PROCESSING" ${order.trangThai == 'PROCESSING' ? 'selected' : ''}>Đang xử lý</option>
                        <option value="SHIPPED"    ${order.trangThai == 'SHIPPED'    ? 'selected' : ''}>Đang giao</option>
                        <option value="DELIVERED"  ${order.trangThai == 'DELIVERED'  ? 'selected' : ''}>Đã giao</option>
                        <option value="CANCELLED"  ${order.trangThai == 'CANCELLED'  ? 'selected' : ''}>Đã huỷ</option>
                    </select>
                    <button type="submit" class="btn btn-secondary" style="padding: 8px 16px; font-size:14px;">Cập nhật Trạng thái</button>
                    <!-- Return to source URL if needed -->
                </form>
            </div>
            
        </main>
    </div>
</body>
</html>