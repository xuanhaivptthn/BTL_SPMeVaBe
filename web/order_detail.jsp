<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${donHang.id}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .order-detail-wrap {
            max-width: 820px;
            margin: 0 auto 60px;
            padding: 0 20px;
        }

        .order-detail-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 30px;
        }

        .order-detail-header a.back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #777;
            font-weight: 600;
            font-size: 15px;
            transition: color 0.2s;
        }

        .order-detail-header a.back-link:hover {
            color: var(--primary-color);
        }

        .order-detail-header h2 {
            margin: 0;
            font-size: 24px;
            color: #2c3e50;
        }

        /* Status badge */
        .status-badge {
            display: inline-block;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .status-PENDING    { background: #fff3cd; color: #856404; }
        .status-PROCESSING { background: #cfe2ff; color: #0a58ca; }
        .status-SHIPPED    { background: #d1ecf1; color: #0c5460; }
        .status-DELIVERED  { background: #d4edda; color: #155724; }
        .status-CANCELLED  { background: #f8d7da; color: #721c24; }

        /* Cards */
        .detail-card {
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px 28px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }

        .detail-card h3 {
            font-size: 17px;
            margin: 0 0 18px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f0f0f0;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .detail-card h3 i {
            color: var(--primary-color);
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px 30px;
        }

        .info-item label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #999;
            margin-bottom: 4px;
        }

        .info-item p {
            font-size: 15px;
            color: #333;
            margin: 0;
            word-break: break-word;
        }

        /* Products table */
        .items-table {
            width: 100%;
            border-collapse: collapse;
        }

        .items-table th {
            text-align: left;
            padding: 10px 12px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            color: #999;
            background: #f9f9f9;
            border-bottom: 1px solid #eee;
        }

        .items-table td {
            padding: 12px 12px;
            border-bottom: 1px solid #f4f4f4;
            color: #444;
            font-size: 15px;
        }

        .items-table tr:last-child td {
            border-bottom: none;
        }

        .items-total {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 16px;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 1px solid #eee;
        }

        .items-total strong {
            font-size: 22px;
            color: var(--primary-color);
        }

        /* Edit form */
        .edit-form-card {
            border: 2px solid var(--primary-color);
            background: #fff8fb;
        }

        .edit-form-card h3 {
            color: var(--primary-color);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 700;
            color: #555;
        }

        .form-group input, .form-group textarea {
            padding: 10px 14px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-family: 'Nunito', sans-serif;
            font-size: 15px;
            outline: none;
            transition: border-color 0.25s, box-shadow 0.25s;
            background: #fff;
        }

        .form-group input:focus, .form-group textarea:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 133, 162, 0.15);
        }

        .form-full {
            grid-column: 1 / -1;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 8px;
        }

        /* Notice banners */
        .notice-locked {
            background: #fff8e1;
            border: 1px solid #ffe082;
            border-radius: 10px;
            padding: 14px 18px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
            font-size: 14px;
            color: #7a5c00;
            margin-bottom: 20px;
        }

        .notice-locked i {
            font-size: 18px;
            color: #f5a623;
            margin-top: 1px;
            flex-shrink: 0;
        }

        .notice-success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 10px;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            color: #155724;
            margin-bottom: 20px;
        }

        .notice-success i {
            font-size: 18px;
            color: #28a745;
        }

        .notice-cancelled {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 10px;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            color: #721c24;
            margin-bottom: 20px;
        }

        .notice-cancelled i {
            font-size: 18px;
            color: #dc3545;
        }

        .btn-danger {
            background: #dc3545;
            color: #fff;
        }

        .btn-danger:hover {
            background: #b02a37;
            color: #fff;
        }

        @media (max-width: 600px) {
            .info-grid, .form-row { grid-template-columns: 1fr; }
            .form-full { grid-column: auto; }
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="order-detail-wrap">
        <div class="order-detail-header">
            <a href="${pageContext.request.contextPath}/history" class="back-link">
                <i class="fas fa-arrow-left"></i> Lịch sử mua hàng
            </a>
            <h2>Đơn hàng #${donHang.id}</h2>
            <c:choose>
                <c:when test="${donHang.trangThai == 'PENDING'}">
                    <span class="status-badge status-PENDING">Đang chờ xử lý</span>
                </c:when>
                <c:when test="${donHang.trangThai == 'PROCESSING'}">
                    <span class="status-badge status-PROCESSING">Đang xử lý</span>
                </c:when>
                <c:when test="${donHang.trangThai == 'SHIPPED'}">
                    <span class="status-badge status-SHIPPED">Đang giao</span>
                </c:when>
                <c:when test="${donHang.trangThai == 'DELIVERED'}">
                    <span class="status-badge status-DELIVERED">Đã giao</span>
                </c:when>
                <c:when test="${donHang.trangThai == 'CANCELLED'}">
                    <span class="status-badge status-CANCELLED">Đã huỷ</span>
                </c:when>
            </c:choose>
        </div>

        <%-- Cancelled notification --%>
        <c:if test="${param.cancelled == '1'}">
            <div class="notice-cancelled">
                <i class="fas fa-times-circle"></i>
                Đơn hàng #${donHang.id} đã được huỷ thành công.
            </div>
        </c:if>

        <%-- Success notification --%>
        <c:if test="${param.success == '1'}">
            <div class="notice-success">
                <i class="fas fa-check-circle"></i>
                Thông tin liên hệ/giao hàng đã được cập nhật thành công!
            </div>
        </c:if>

        <%-- Order info card --%>
        <div class="detail-card">
            <h3><i class="fas fa-info-circle"></i> Thông tin đơn hàng</h3>
            <div class="info-grid">
                <div class="info-item">
                    <label>Mã đơn hàng</label>
                    <p>#${donHang.id}</p>
                </div>
                <div class="info-item">
                    <label>Ngày đặt</label>
                    <p>${donHang.ngayDatFormatted}</p>
                </div>
                <div class="info-item">
                    <label>Người nhận</label>
                    <p>${donHang.tenNguoiNhan}</p>
                </div>
                <div class="info-item">
                    <label>Số điện thoại</label>
                    <p>${donHang.sdtNhanHang}</p>
                </div>
                <div class="info-item" style="grid-column: 1 / -1;">
                    <label>Địa chỉ giao hàng</label>
                    <p>${donHang.diaChiGiaoHang}</p>
                </div>
                <c:if test="${not empty donHang.ghiChu}">
                <div class="info-item" style="grid-column: 1 / -1;">
                    <label>Ghi chú</label>
                    <p>${donHang.ghiChu}</p>
                </div>
                </c:if>
            </div>
        </div>

        <%-- Products card --%>
        <div class="detail-card">
            <h3><i class="fas fa-box"></i> Sản phẩm đã đặt</h3>
            <table class="items-table">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th style="text-align:center;">Số lượng</th>
                        <th style="text-align:right;">Đơn giá</th>
                        <th style="text-align:right;">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ct" items="${chiTiet}">
                        <tr>
                            <td>${ct.tenSanPham}</td>
                            <td style="text-align:center;">${ct.soLuong}</td>
                            <td style="text-align:right;">
                                <fmt:formatNumber value="${ct.donGia}" type="number" pattern="#,###"/> VND
                            </td>
                            <td style="text-align:right;">
                                <fmt:formatNumber value="${ct.donGia * ct.soLuong}" type="number" pattern="#,###"/> VND
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="items-total">
                <span style="color:#777; font-weight:600;">Tổng cộng:</span>
                <strong><fmt:formatNumber value="${donHang.tongTien}" type="number" pattern="#,###"/> VND</strong>
            </div>
        </div>

        <%-- Edit contact info section --%>
        <c:choose>
            <c:when test="${donHang.trangThai == 'PENDING' || donHang.trangThai == 'PROCESSING'}">
                <div class="detail-card edit-form-card">
                    <h3><i class="fas fa-edit"></i> Cập nhật thông tin liên hệ / giao hàng</h3>
                    <form method="post" action="${pageContext.request.contextPath}/history">
                        <input type="hidden" name="action" value="updateContact"/>
                        <input type="hidden" name="orderId" value="${donHang.id}"/>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="tenNguoiNhan">Tên người nhận</label>
                                <input type="text" id="tenNguoiNhan" name="tenNguoiNhan"
                                       value="${donHang.tenNguoiNhan}" required placeholder="Nhập tên người nhận"/>
                            </div>
                            <div class="form-group">
                                <label for="sdtNhanHang">Số điện thoại</label>
                                <input type="text" id="sdtNhanHang" name="sdtNhanHang"
                                       value="${donHang.sdtNhanHang}" required placeholder="Nhập số điện thoại"/>
                            </div>
                            <div class="form-group form-full">
                                <label for="diaChiGiaoHang">Địa chỉ giao hàng</label>
                                <input type="text" id="diaChiGiaoHang" name="diaChiGiaoHang"
                                       value="${donHang.diaChiGiaoHang}" required placeholder="Nhập địa chỉ giao hàng"/>
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn" id="btn-update-contact">
                                <i class="fas fa-save"></i> Lưu thay đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/history" class="btn btn-secondary">
                                Huỷ
                            </a>
                        </div>
                    </form>
                </div>

                <%-- Cancel order section --%>
                <div class="detail-card" style="border-color: #f5c6cb; background: #fff8f8;">
                    <h3 style="color: #b02a37;"><i class="fas fa-ban"></i> Huỷ đơn hàng</h3>
                    <p style="color: #666; margin-bottom: 18px; font-size: 15px;">
                        Bạn có thể huỷ đơn hàng này vì đơn đang ở trạng thái
                        <strong>
                            <c:choose>
                                <c:when test="${donHang.trangThai == 'PENDING'}">Đang chờ xử lý</c:when>
                                <c:otherwise>Đang xử lý</c:otherwise>
                            </c:choose>
                        </strong>.
                        Sau khi huỷ, đơn hàng sẽ không thể khôi phục lại.
                    </p>
                    <form method="post" action="${pageContext.request.contextPath}/history"
                          onsubmit="return confirm('Bạn có chắc chắn muốn huỷ đơn hàng #${donHang.id} không? Hành động này không thể hoàn tác.')">
                        <input type="hidden" name="action" value="cancelOrder"/>
                        <input type="hidden" name="orderId" value="${donHang.id}"/>
                        <button type="submit" class="btn btn-danger" id="btn-cancel-order">
                            <i class="fas fa-times-circle"></i> Xác nhận huỷ đơn hàng
                        </button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <div class="notice-locked">
                    <i class="fas fa-lock"></i>
                    <span>
                        <strong>Không thể cập nhật thông tin.</strong>
                        Thông tin liên hệ và giao hàng chỉ có thể được chỉnh sửa khi đơn hàng đang ở trạng thái
                        <strong>Đang chờ xử lý (PENDING)</strong> hoặc <strong>Đang xử lý (PROCESSING)</strong>.
                        Đơn hàng này hiện đang ở trạng thái
                        <c:choose>
                            <c:when test="${donHang.trangThai == 'SHIPPED'}"><strong>Đang giao</strong></c:when>
                            <c:when test="${donHang.trangThai == 'DELIVERED'}"><strong>Đã giao</strong></c:when>
                            <c:when test="${donHang.trangThai == 'CANCELLED'}"><strong>Đã huỷ</strong></c:when>
                            <c:otherwise><strong>${donHang.trangThai}</strong></c:otherwise>
                        </c:choose>
                        và không thể chỉnh sửa.
                    </span>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
