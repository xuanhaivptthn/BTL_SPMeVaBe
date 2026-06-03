<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Thanh toán đơn hàng - Cửa hàng Mẹ & Bé</title>

                    <style>
                        /* Modern Premium Checkout Styles */
                        :root {
                            --primary-pink: #ff85a2;
                            --primary-pink-hover: #ff6b8f;
                            --secondary-blue: #4a90e2;
                            --secondary-blue-light: #f0f7ff;
                            --neutral-bg: transparent;
                            --neutral-dark: #2c3e50;
                            --neutral-muted: #7f8c8d;
                            --border-color: #f1e4e8;
                            --shadow-card: none;
                            --shadow-hover: none;
                            --radius-lg: 16px;
                            --radius-md: 10px;
                        }

                        .checkout-page-container {
                            max-width: 1200px;
                            margin: 40px auto;
                            padding: 0 20px;
                        }

                        .checkout-title-section {
                            text-align: center;
                            margin-bottom: 40px;
                        }

                        .checkout-title-section h2 {
                            font-size: 32px;
                            color: var(--neutral-dark);
                            font-weight: 700;
                            margin-bottom: 10px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 12px;
                        }

                        .checkout-title-section h2 i {
                            color: var(--primary-pink);
                        }

                        .checkout-title-section p {
                            color: var(--neutral-muted);
                            font-size: 16px;
                        }

                        /* Two-Column Grid Layout */
                        .checkout-grid {
                            display: grid;
                            grid-template-columns: 1.4fr 1fr;
                            gap: 30px;
                            align-items: start;
                        }

                        @media (max-width: 992px) {
                            .checkout-grid {
                                grid-template-columns: 1fr;
                            }
                        }

                        /* Premium Card Styles */
                        .checkout-card {
                            background: transparent;
                            border-radius: var(--radius-lg);
                            border: 1px solid var(--border-color);
                            box-shadow: none;
                            overflow: hidden;
                            margin-bottom: 25px;
                            transition: transform 0.3s ease;
                        }

                        .checkout-card:hover {
                            box-shadow: none;
                        }

                        .card-header {
                            background: transparent;
                            padding: 20px 25px;
                            border-bottom: 1px solid var(--border-color);
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .card-header h3 {
                            font-size: 18px;
                            color: var(--neutral-dark);
                            margin: 0;
                            font-weight: 700;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .card-header h3 i {
                            color: var(--primary-pink);
                            font-size: 18px;
                        }

                        .card-body {
                            padding: 25px;
                        }

                        /* Form Controls */
                        .form-group {
                            margin-bottom: 20px;
                        }

                        .form-group label {
                            display: block;
                            font-size: 14px;
                            font-weight: 600;
                            color: var(--neutral-dark);
                            margin-bottom: 8px;
                        }

                        .form-group label i {
                            margin-right: 5px;
                            color: var(--primary-pink);
                        }

                        .form-control-premium {
                            width: 100%;
                            padding: 12px 16px;
                            border: 1px solid var(--border-color);
                            border-radius: var(--radius-md);
                            font-size: 15px;
                            outline: none;
                            transition: all 0.3s ease;
                            color: var(--neutral-dark);
                            background-color: transparent;
                        }

                        .form-control-premium:focus {
                            border-color: var(--primary-pink);
                            background-color: transparent;
                            box-shadow: 0 0 0 4px rgba(255, 133, 162, 0.1);
                        }

                        textarea.form-control-premium {
                            resize: vertical;
                            min-height: 100px;
                        }

                        /* Saved Address Dropdown styling */
                        .saved-address-container {
                            background-color: transparent;
                            border: 1px dashed var(--primary-pink);
                            padding: 15px 20px;
                            border-radius: var(--radius-md);
                            margin-bottom: 25px;
                        }

                        .saved-address-container label {
                            font-weight: 700;
                            color: var(--neutral-dark);
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            margin-bottom: 10px;
                            font-size: 14px;
                        }

                        .saved-address-container label i {
                            color: var(--primary-pink);
                        }

                        .address-select {
                            width: 100%;
                            padding: 10px 15px;
                            border-radius: var(--radius-md);
                            border: 1px solid var(--border-color);
                            font-family: inherit;
                            background-color: transparent;
                            font-size: 14px;
                            outline: none;
                            cursor: pointer;
                            color: var(--neutral-dark);
                        }

                        .address-select:focus {
                            border-color: var(--primary-pink);
                        }

                        /* Payment Methods Grid */
                        .payment-methods-grid {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 15px;
                            margin-bottom: 25px;
                        }

                        @media (max-width: 576px) {
                            .payment-methods-grid {
                                grid-template-columns: 1fr;
                            }
                        }

                        .payment-method-card {
                            border: 1px solid var(--border-color);
                            border-radius: var(--radius-md);
                            padding: 15px 20px;
                            cursor: pointer;
                            position: relative;
                            transition: all 0.3s ease;
                            display: flex;
                            align-items: flex-start;
                            gap: 12px;
                            background-color: transparent;
                        }

                        .payment-method-card:hover {
                            border-color: var(--primary-pink);
                            background-color: transparent;
                        }

                        .payment-method-card.active {
                            border-color: var(--primary-pink);
                            background-color: transparent;
                            box-shadow: none;
                        }

                        .payment-method-card input[type="radio"] {
                            margin-top: 4px;
                            accent-color: var(--primary-pink);
                            cursor: pointer;
                        }

                        .pm-info {
                            display: flex;
                            flex-direction: column;
                        }

                        .pm-title {
                            font-size: 15px;
                            font-weight: 700;
                            color: var(--neutral-dark);
                            margin-bottom: 4px;
                            display: flex;
                            align-items: center;
                            gap: 6px;
                        }

                        .pm-title i {
                            color: var(--primary-pink);
                        }

                        .pm-desc {
                            font-size: 12px;
                            color: var(--neutral-muted);
                            line-height: 1.4;
                        }

                        /* Online QR Transfer Panel */
                        .qr-panel {
                            background-color: transparent;
                            border: 1px dashed var(--border-color);
                            border-radius: var(--radius-md);
                            padding: 20px;
                            margin-top: 20px;
                            animation: fadeIn 0.4s ease-out;
                        }

                        @keyframes fadeIn {
                            from {
                                opacity: 0;
                                transform: translateY(-10px);
                            }

                            to {
                                opacity: 1;
                                transform: translateY(0);
                            }
                        }

                        .qr-info-grid {
                            display: flex;
                            gap: 25px;
                            align-items: center;
                        }

                        @media (max-width: 768px) {
                            .qr-info-grid {
                                flex-direction: column;
                                text-align: center;
                            }
                        }

                        .qr-code-box {
                            flex: 0 0 180px;
                            background: transparent;
                            padding: 10px;
                            border-radius: var(--radius-md);
                            border: 1px solid var(--border-color);
                            box-shadow: none;
                            text-align: center;
                        }

                        .qr-code-box img {
                            width: 100%;
                            height: auto;
                            display: block;
                            border-radius: 6px;
                        }

                        .qr-scan-note {
                            font-size: 11px;
                            color: var(--neutral-muted);
                            margin-top: 8px;
                            margin-bottom: 0;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 5px;
                        }

                        .qr-scan-note i {
                            color: var(--secondary-blue);
                        }

                        .qr-details {
                            flex: 1;
                        }

                        .qr-title {
                            font-size: 16px;
                            font-weight: 700;
                            color: var(--neutral-dark);
                            margin-top: 0;
                            margin-bottom: 15px;
                            border-bottom: 1px solid var(--border-color);
                            padding-bottom: 8px;
                        }

                        .qr-detail-item {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 10px;
                            font-size: 13px;
                            border-bottom: 1px dashed var(--border-color);
                            padding-bottom: 6px;
                        }

                        .qr-detail-item:last-of-type {
                            border-bottom: none;
                        }

                        .qr-detail-item span {
                            color: var(--neutral-muted);
                        }

                        .qr-detail-item strong {
                            color: var(--neutral-dark);
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }

                        /* Copy Button */
                        .btn-copy {
                            background-color: var(--secondary-blue-light);
                            color: var(--secondary-blue);
                            border: none;
                            padding: 3px 8px;
                            border-radius: 4px;
                            cursor: pointer;
                            font-size: 11px;
                            font-weight: 600;
                            display: inline-flex;
                            align-items: center;
                            gap: 4px;
                            transition: all 0.2s ease;
                        }

                        .btn-copy:hover {
                            background-color: var(--secondary-blue);
                            color: white;
                        }

                        .alert-info-mini {
                            background-color: transparent;
                            border: 1px solid #ffe8ad;
                            color: #b77c00;
                            font-size: 12px;
                            padding: 8px 12px;
                            border-radius: 6px;
                            margin-top: 15px;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }

                        /* Order Items List */
                        .order-items-list {
                            max-height: 250px;
                            overflow-y: auto;
                            margin-bottom: 20px;
                            padding-right: 5px;
                        }

                        .order-item {
                            display: flex;
                            align-items: center;
                            gap: 15px;
                            padding: 12px 0;
                            border-bottom: 1px solid #f9f9f9;
                        }

                        .order-item:last-child {
                            border-bottom: none;
                        }

                        .item-img {
                            width: 50px;
                            height: 50px;
                            border-radius: 8px;
                            overflow: hidden;
                            border: 1px solid var(--border-color);
                            flex-shrink: 0;
                        }

                        .item-img img {
                            width: 100%;
                            height: 100%;
                            object-fit: cover;
                        }

                        .item-info {
                            flex: 1;
                        }

                        .item-name {
                            font-size: 14px;
                            font-weight: 700;
                            color: var(--neutral-dark);
                            margin: 0 0 4px 0;
                            line-height: 1.3;
                        }

                        .item-meta {
                            font-size: 12px;
                            color: var(--neutral-muted);
                            margin: 0;
                        }

                        .item-price {
                            font-size: 14px;
                            font-weight: 700;
                            color: var(--neutral-dark);
                        }

                        /* Coupon Section */
                        .coupon-section {
                            border-top: 1px solid var(--border-color);
                            border-bottom: 1px solid var(--border-color);
                            padding: 20px 0;
                            margin-bottom: 20px;
                        }

                        .coupon-input-group {
                            display: flex;
                            gap: 10px;
                        }

                        .coupon-input-group input {
                            flex: 1;
                            padding: 10px 14px;
                            border: 1px solid var(--border-color);
                            border-radius: var(--radius-md);
                            font-size: 14px;
                            outline: none;
                            text-transform: uppercase;
                            background-color: transparent;
                        }

                        .coupon-input-group input:focus {
                            border-color: var(--primary-pink);
                        }

                        .btn-apply {
                            background-color: var(--neutral-dark);
                            color: white;
                            border: none;
                            padding: 0 20px;
                            border-radius: var(--radius-md);
                            font-size: 14px;
                            font-weight: 700;
                            cursor: pointer;
                            transition: all 0.3s ease;
                        }

                        .btn-apply:hover {
                            background-color: var(--primary-pink);
                        }

                        .coupon-message-box {
                            margin-top: 10px;
                            font-size: 13px;
                            border-radius: 6px;
                            padding: 8px 12px;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }

                        .coupon-success {
                            background-color: #ecfdf5;
                            border: 1px solid #a7f3d0;
                            color: #065f46;
                        }

                        .coupon-error {
                            background-color: #fef2f2;
                            border: 1px solid #fecaca;
                            color: #991b1b;
                        }

                        /* Cost Breakdown */
                        .cost-breakdown {
                            margin-bottom: 25px;
                        }

                        .cost-row {
                            display: flex;
                            justify-content: space-between;
                            margin-bottom: 12px;
                            font-size: 14px;
                            color: var(--neutral-muted);
                        }

                        .cost-row.text-success {
                            color: #059669;
                            font-weight: 600;
                        }

                        .cost-row.grand-total {
                            font-size: 18px;
                            font-weight: 800;
                            color: var(--neutral-dark);
                            margin-top: 15px;
                            border-top: 1px solid #f9f9f9;
                            padding-top: 15px;
                        }

                        .cost-row.grand-total .total-price-highlight {
                            color: var(--primary-pink);
                            font-size: 22px;
                        }

                        /* Action Buttons */
                        .btn-pay-now {
                            width: 100%;
                            background: var(--primary-pink);
                            color: white;
                            border: none;
                            padding: 15px;
                            border-radius: var(--radius-md);
                            font-size: 16px;
                            font-weight: 800;
                            cursor: pointer;
                            box-shadow: none;
                            transition: all 0.3s ease;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 10px;
                        }

                        .btn-pay-now:hover {
                            background-color: var(--primary-pink-hover);
                            transform: translateY(-2px);
                            box-shadow: none;
                        }

                        .btn-pay-now:active {
                            transform: translateY(0);
                        }

                        .btn-back-to-cart {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 8px;
                            width: 100%;
                            background: none;
                            border: 1px solid var(--border-color);
                            color: var(--neutral-muted);
                            padding: 12px;
                            border-radius: var(--radius-md);
                            font-size: 14px;
                            font-weight: 700;
                            margin-top: 15px;
                            text-decoration: none;
                            transition: all 0.3s ease;
                        }

                        .btn-back-to-cart:hover {
                            border-color: var(--primary-pink);
                            color: var(--primary-pink);
                            background-color: transparent;
                        }
                    </style>
                </head>

                <body>
                    <jsp:include page="components/header.jsp" />

                    <div class="checkout-page-container">
                        <div class="checkout-title-section">
                            <h2><i class="fa-solid fa-bag-shopping"></i> Thanh toán đơn hàng</h2>
                            <p>Trải nghiệm mua sắm an toàn, nhanh chóng và tiện lợi tại Mẹ & Bé Shop</p>
                        </div>

                        <c:set var="discount" value="${not empty discountAmount ? discountAmount : 0.0}" />
                        <c:set var="finalTotal" value="${totalPrice - discount}" />

                        <form id="checkout-form" action="${pageContext.request.contextPath}/checkout" method="post">
                            <!-- Hidden Fields for Flow Coordination -->
                            <input type="hidden" name="action" id="checkout-action" value="checkout">

                            <div class="checkout-grid">

                                <!-- LEFT COLUMN: Shipping & Payment Info -->
                                <div class="checkout-main">

                                    <!-- 1. Shipping Address Section -->
                                    <div class="checkout-card">
                                        <div class="card-header">
                                            <h3><i class="fa-solid fa-location-dot"></i> 1. Thông tin giao hàng</h3>
                                        </div>
                                        <div class="card-body">
                                            <!-- Saved Addresses Dropdown -->
                                            <c:if test="${not empty listDiaChi}">
                                                <div class="saved-address-container">
                                                    <label for="savedAddresses"><i class="fa-solid fa-address-book"></i>
                                                        Chọn địa chỉ đã lưu:</label>
                                                    <select id="savedAddresses" class="address-select"
                                                        onchange="fillAddress(this)">
                                                        <option value="">-- Thêm địa chỉ mới --</option>
                                                        <c:forEach var="dc" items="${listDiaChi}">
                                                            <option value="${dc.id}" data-ten="${dc.tenNguoiNhan}"
                                                                data-sdt="${dc.soDienThoai}" data-diachi="${dc.diaChi}"
                                                                ${dc.isDefault() ? 'selected' : '' }>
                                                                ${dc.tenNguoiNhan} (${dc.soDienThoai}) - ${dc.diaChi}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </c:if>

                                            <!-- Direct Inputs -->
                                            <div class="form-group">
                                                <label for="tenNguoiNhan"><i class="fa-regular fa-user"></i> Tên người
                                                    nhận:</label>
                                                <input type="text" id="tenNguoiNhan" name="tenNguoiNhan"
                                                    value="${not empty tenNguoiNhan ? tenNguoiNhan : ''}"
                                                    class="form-control-premium" required
                                                    placeholder="Nhập họ và tên người nhận">
                                            </div>

                                            <div class="form-group">
                                                <label for="sdtNhanHang"><i class="fa-solid fa-phone"></i> Số điện
                                                    thoại:</label>
                                                <input type="text" id="sdtNhanHang" name="sdtNhanHang"
                                                    value="${not empty sdtNhanHang ? sdtNhanHang : ''}"
                                                    class="form-control-premium" required
                                                    placeholder="Nhập số điện thoại nhận hàng">
                                            </div>

                                            <div class="form-group">
                                                <label for="diaChiGiaoHang"><i class="fa-solid fa-map-pin"></i> Địa chỉ
                                                    giao hàng:</label>
                                                <input type="text" id="diaChiGiaoHang" name="diaChiGiaoHang"
                                                    value="${not empty diaChiGiaoHang ? diaChiGiaoHang : ''}"
                                                    class="form-control-premium" required
                                                    placeholder="Nhập địa chỉ nhà, tên đường, phường/xã, quận/huyện, tỉnh">
                                            </div>

                                            <div class="form-group" style="margin-bottom: 0;">
                                                <label for="ghiChu"><i class="fa-regular fa-comment-dots"></i> Ghi chú
                                                    đơn hàng:</label>
                                                <textarea id="ghiChu" name="ghiChu" class="form-control-premium"
                                                    placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi giao...">${not empty ghiChu ? ghiChu : ''}</textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 2. Payment Method Section -->
                                    <div class="checkout-card">
                                        <div class="card-header">
                                            <h3><i class="fa-solid fa-credit-card"></i> 2. Phương thức thanh toán</h3>
                                        </div>
                                        <div class="card-body">
                                            <div class="payment-methods-grid">
                                                <!-- Cash On Delivery (COD) -->
                                                <label id="pm-card-cod"
                                                    class="payment-method-card ${phuongThucThanhToan == 'COD' || empty phuongThucThanhToan ? 'active' : ''}">
                                                    <input type="radio" name="phuongThucThanhToan" value="COD"
                                                        ${phuongThucThanhToan=='COD' || empty phuongThucThanhToan
                                                        ? 'checked' : '' } onchange="updatePaymentUI('COD')">
                                                    <div class="pm-info">
                                                        <span class="pm-title"><i class="fa-solid fa-truck"></i> Thanh
                                                            toán COD</span>
                                                        <span class="pm-desc">Thanh toán bằng tiền mặt trực tiếp khi
                                                            nhận hàng tận tay.</span>
                                                    </div>
                                                </label>

                                                <!-- Online QR transfer -->
                                                <label id="pm-card-qr"
                                                    class="payment-method-card ${phuongThucThanhToan == 'QR_ONLINE' ? 'active' : ''}">
                                                    <input type="radio" name="phuongThucThanhToan" value="QR_ONLINE"
                                                        ${phuongThucThanhToan=='QR_ONLINE' ? 'checked' : '' }
                                                        onchange="updatePaymentUI('QR_ONLINE')">
                                                    <div class="pm-info">
                                                        <span class="pm-title"><i class="fa-solid fa-qrcode"></i> Quét
                                                            mã QR Online</span>
                                                        <span class="pm-desc">Chuyển khoản ngân hàng tức thì qua mã QR
                                                            VietQR tiện dụng.</span>
                                                    </div>
                                                </label>
                                            </div>

                                            <!-- QR payment detailed panel -->
                                            <div id="qr-payment-panel" class="qr-panel"
                                                style="display: ${phuongThucThanhToan == 'QR_ONLINE' ? 'block' : 'none'};">
                                                <div class="qr-info-grid">
                                                    <!-- VietQR Generator Compact -->
                                                    <div class="qr-code-box">
                                                        <img id="vietqr-img"
                                                            src="https://img.vietqr.io/image/mbbank-0936344825-compact2.png?amount=<fmt:formatNumber value='${finalTotal}' type='number' pattern='#####' />&addInfo=MEVABE%20DH%20${nextOrderId}&accountName=ME%20VA%20BE%20SHOP"
                                                            alt="Mã QR chuyển tiền">
                                                        <p class="qr-scan-note"><i class="fa-solid fa-expand"></i> Quét
                                                            mã bằng App Ngân hàng</p>
                                                    </div>

                                                    <!-- Bank Transfer details -->
                                                    <div class="qr-details">
                                                        <h4 class="qr-title">Thông tin chuyển khoản</h4>
                                                        <div class="qr-detail-item">
                                                            <span>Ngân hàng:</span>
                                                            <strong>MBBank (Ngân hàng Quân Đội)</strong>
                                                        </div>
                                                        <div class="qr-detail-item">
                                                            <span>Số tài khoản:</span>
                                                            <strong>1234567890
                                                                <button type="button" class="btn-copy"
                                                                    onclick="copyText('1234567890', this)">
                                                                    <i class="fa-regular fa-copy"></i> Sao chép
                                                                </button>
                                                            </strong>
                                                        </div>
                                                        <div class="qr-detail-item">
                                                            <span>Tên tài khoản:</span>
                                                            <strong>ME VABE SHOP</strong>
                                                        </div>
                                                        <div class="qr-detail-item">
                                                            <span>Số tiền:</span>
                                                            <strong>
                                                                <fmt:formatNumber value="${finalTotal}" type="number"
                                                                    pattern="#,###" />đ
                                                                <button type="button" class="btn-copy"
                                                                    onclick="copyText('<fmt:formatNumber value="
                                                                    ${finalTotal}" type="number" pattern="#####" />',
                                                                this)">
                                                                <i class="fa-regular fa-copy"></i> Sao chép
                                                                </button>
                                                            </strong>
                                                        </div>
                                                        <div class="qr-detail-item">
                                                            <span>Nội dung CK:</span>
                                                            <strong><span id="memo-value">MEVABE DH ${nextOrderId}</span>
                                                                <button type="button" class="btn-copy"
                                                                    onclick="copyText('MEVABE DH ${nextOrderId}', this)">
                                                                    <i class="fa-regular fa-copy"></i> Sao chép
                                                                </button>
                                                            </strong>
                                                        </div>

                                                        <div class="alert-info-mini">
                                                            <i class="fa-solid fa-triangle-exclamation"></i> Đây là giao
                                                            dịch giả lập. Bạn không cần chuyển khoản thật.
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- RIGHT COLUMN: Order Summary & Coupon -->
                                <div class="checkout-sidebar">

                                    <div class="checkout-card">
                                        <div class="card-header">
                                            <h3><i class="fa-solid fa-receipt"></i> Tóm tắt đơn hàng</h3>
                                        </div>
                                        <div class="card-body">
                                            <!-- Order items scrolling wrapper -->
                                            <div class="order-items-list">
                                                <c:forEach var="item" items="${cartProducts}">
                                                    <div class="order-item">
                                                        <div class="item-img">
                                                            <c:choose>
                                                                <c:when test="${not empty item.product.hinhAnh}">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${fn:startsWith(item.product.hinhAnh, 'http')}">
                                                                            <img src="${item.product.hinhAnh}"
                                                                                alt="${item.product.tenSanPham}">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}/${item.product.hinhAnh}"
                                                                                alt="${item.product.tenSanPham}">
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="https://dummyimage.com/150x150/f0e3e7/ff85a2.png&text=Mẹ+Bé"
                                                                        alt="Default Product">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="item-info">
                                                            <h4 class="item-name">
                                                                <c:out value="${item.product.tenSanPham}" />
                                                            </h4>
                                                            <p class="item-meta">SL: ${item.quantity} x
                                                                <fmt:formatNumber value="${item.product.giaTien}"
                                                                    type="number" pattern="#,###" />đ
                                                            </p>
                                                        </div>
                                                        <div class="item-price">
                                                            <fmt:formatNumber
                                                                value="${item.product.giaTien * item.quantity}"
                                                                type="number" pattern="#,###" />đ
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>

                                            <!-- Coupon Section (Gửi form truyền thống) -->
                                            <div class="coupon-section">
                                                <label class="form-group"><span
                                                        style="font-size: 13px; font-weight: 700; color: var(--neutral-dark);"><i
                                                            class="fa-solid fa-tags"></i> Sử dụng mã giảm
                                                        giá</span></label>
                                                <div class="coupon-input-group">
                                                    <input type="text" id="couponCode" name="maGiamGia"
                                                        value="${not empty maGiamGia ? maGiamGia : ''}"
                                                        placeholder="NHẬP MÃ (VD: MEVABE10)" autocomplete="off">
                                                    <button type="button" class="btn-apply"
                                                        onclick="submitApplyCoupon()">Áp dụng</button>
                                                </div>

                                                <!-- Feedback messages -->
                                                <c:if test="${not empty couponMessage}">
                                                    <div class="coupon-message-box coupon-success">
                                                        <i class="fa-regular fa-circle-check"></i>
                                                        <c:out value="${couponMessage}" />
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty couponError}">
                                                    <div class="coupon-message-box coupon-error">
                                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                                        <c:out value="${couponError}" />
                                                    </div>
                                                </c:if>
                                            </div>

                                            <!-- Cost Breakdown list -->
                                            <div class="cost-breakdown">
                                                <div class="cost-row">
                                                    <span>Tạm tính hàng hoá</span>
                                                    <span><strong>
                                                            <fmt:formatNumber value="${totalPrice}" type="number"
                                                                pattern="#,###" />đ
                                                        </strong></span>
                                                </div>
                                                <div class="cost-row text-success">
                                                    <span>Giảm giá khuyến mãi</span>
                                                    <span>-<strong>
                                                            <fmt:formatNumber value="${discount}" type="number"
                                                                pattern="#,###" />đ
                                                        </strong></span>
                                                </div>
                                                <div class="cost-row">
                                                    <span>Phí vận chuyển</span>
                                                    <span><strong>Miễn phí</strong></span>
                                                </div>
                                                <div class="cost-row grand-total">
                                                    <span>Tổng thanh toán</span>
                                                    <span class="total-price-highlight">
                                                        <fmt:formatNumber value="${finalTotal}" type="number"
                                                            pattern="#,###" />đ
                                                    </span>
                                                </div>
                                            </div>

                                            <!-- Pay Buttons -->
                                            <button type="submit" class="btn-pay-now">
                                                <i class="fa-solid fa-lock"></i> XÁC NHẬN ĐẶT HÀNG
                                            </button>

                                            <a href="${pageContext.request.contextPath}/cart" class="btn-back-to-cart">
                                                <i class="fa-solid fa-arrow-left-long"></i> Quay lại giỏ hàng
                                            </a>
                                        </div>
                                    </div>

                                </div>

                            </div>
                        </form>
                    </div>

                    <script>
                        // Copy text helper with UI micro-interactions
                        function copyText(text, btn) {
                            navigator.clipboard.writeText(text).then(function () {
                                var originalHtml = btn.innerHTML;
                                btn.innerHTML = '<i class="fa-solid fa-check"></i> Đã chép';
                                btn.style.backgroundColor = '#d1fae5';
                                btn.style.color = '#065f46';

                                setTimeout(function () {
                                    btn.innerHTML = originalHtml;
                                    btn.style.backgroundColor = '';
                                    btn.style.color = '';
                                }, 1800);
                            }).catch(function (err) {
                                console.error('Lỗi sao chép: ', err);
                            });
                        }

                        // Toggle payment method selection and show/hide corresponding panels
                        function updatePaymentUI(method) {
                            var codCard = document.getElementById('pm-card-cod');
                            var qrCard = document.getElementById('pm-card-qr');
                            var qrPanel = document.getElementById('qr-payment-panel');

                            if (method === 'COD') {
                                codCard.classList.add('active');
                                qrCard.classList.remove('active');
                                qrPanel.style.display = 'none';
                            } else if (method === 'QR_ONLINE') {
                                qrCard.classList.add('active');
                                codCard.classList.remove('active');
                                qrPanel.style.display = 'block';
                            }
                        }

                        // Form submit hook specifically for checking coupon
                        function submitApplyCoupon() {
                            var input = document.getElementById('couponCode');
                            if (input.value.trim() === '') {
                                alert('Vui lòng nhập mã giảm giá trước khi chọn Áp dụng.');
                                input.focus();
                                return;
                            }
                            // Set action and bypass validation to submit coupon check
                            document.getElementById('checkout-action').value = 'applyCoupon';

                            // Temporary disable required attributes on inputs to prevent browser block when just checking coupon
                            document.getElementById('tenNguoiNhan').removeAttribute('required');
                            document.getElementById('sdtNhanHang').removeAttribute('required');
                            document.getElementById('diaChiGiaoHang').removeAttribute('required');

                            document.getElementById('checkout-form').submit();
                        }

                        // Autofill addresses from database selection
                        function fillAddress(select) {
                            var option = select.options[select.selectedIndex];
                            if (option.value !== "") {
                                document.getElementById('tenNguoiNhan').value = option.getAttribute('data-ten');
                                document.getElementById('sdtNhanHang').value = option.getAttribute('data-sdt');
                                document.getElementById('diaChiGiaoHang').value = option.getAttribute('data-diachi');
                            } else {
                                document.getElementById('tenNguoiNhan').value = "";
                                document.getElementById('sdtNhanHang').value = "";
                                document.getElementById('diaChiGiaoHang').value = "";
                            }
                        }

                        // Init defaults when loaded
                        window.addEventListener('load', function () {
                            var select = document.getElementById("savedAddresses");
                            // If they haven't submitted anything yet and default exists
                            if (select && select.value !== "" && document.getElementById('tenNguoiNhan').value === "") {
                                fillAddress(select);
                            }
                        });
                    </script>

                    <jsp:include page="components/footer.jsp" />
                </body>

                </html>