<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin tài khoản | Cửa Hàng Mẹ & Bé</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        :root {
            --profile-primary: var(--primary-color, #ff85a2);
            --profile-primary-hover: var(--primary-hover, #ff6b8f);
            --profile-bg: #fdfafb;
            --profile-card-shadow: 0 10px 30px rgba(255, 101, 132, 0.08);
            --profile-gold-color: #e6af2e;
        }

        .profile-wrapper {
            max-width: 1100px;
            margin: 40px auto 80px;
            padding: 0 20px;
            font-family: 'Inter', 'Segoe UI', system-ui, -apple-system, sans-serif;
        }

        .profile-container {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 30px;
            align-items: start;
        }

        @media (max-width: 868px) {
            .profile-container {
                grid-template-columns: 1fr;
            }
        }

        /* CARD STYLE COMMON */
        .profile-card {
            background: #fff;
            border-radius: 20px;
            border: 1px solid rgba(255, 101, 132, 0.08);
            box-shadow: var(--profile-card-shadow);
            padding: 30px;
            box-sizing: border-box;
            transition: transform 0.3s ease;
        }

        /* LEFT SIDEBAR */
        .profile-sidebar {
            text-align: center;
        }

        .avatar-container {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto 20px;
        }

        .avatar-circle {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background-color: var(--profile-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 42px;
            font-weight: 800;
            box-shadow: 0 8px 20px rgba(255, 133, 162, 0.2);
            border: 4px solid #fff;
        }

        .profile-name {
            font-size: 22px;
            font-weight: 700;
            color: #2c3e50;
            margin: 10px 0 5px;
        }

        .profile-role-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 25px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .badge-customer {
            background-color: #ffeef2;
            color: var(--profile-primary);
        }

        .badge-admin {
            background: #fdf3e7;
            color: #e67e22;
        }

        .badge-staff {
            background: #e8f4fd;
            color: #3498db;
        }

        /* LOYALTY CARD */
        .loyalty-card {
            background-color: var(--profile-gold-color);
            border-radius: 16px;
            padding: 20px;
            color: #fff;
            text-align: left;
            position: relative;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(230, 175, 46, 0.2);
            margin-top: 10px;
        }

        .loyalty-card::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            pointer-events: none;
        }

        .loyalty-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .loyalty-title {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
            opacity: 0.9;
        }

        .loyalty-icon {
            font-size: 24px;
            color: #fff;
            animation: pulse-gold 2s infinite alternate;
        }

        .loyalty-points {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 5px;
            letter-spacing: -0.5px;
        }

        .loyalty-points span {
            font-size: 16px;
            font-weight: 500;
            opacity: 0.9;
        }

        .loyalty-tier {
            font-size: 14px;
            font-weight: 600;
            background: rgba(255,255,255,0.2);
            padding: 3px 10px;
            border-radius: 30px;
            display: inline-block;
        }

        @keyframes pulse-gold {
            0% { transform: scale(1); }
            100% { transform: scale(1.15); filter: drop-shadow(0 0 5px rgba(255,255,255,0.6)); }
        }

        /* RIGHT CONTENT */
        .profile-main {
            min-height: 480px;
        }

        /* TABS SELECTOR */
        .tabs-header {
            display: flex;
            border-bottom: 2px solid #f0f0f0;
            margin-bottom: 30px;
            gap: 20px;
        }

        .tab-btn {
            background: none;
            border: none;
            padding: 12px 10px;
            font-size: 16px;
            font-weight: 600;
            color: #7f8c8d;
            cursor: pointer;
            position: relative;
            transition: color 0.3s ease;
        }

        .tab-btn:hover {
            color: var(--profile-primary);
        }

        .tab-btn.active {
            color: var(--profile-primary);
        }

        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: var(--profile-primary);
            border-radius: 3px;
        }

        /* TAB PANELS */
        .tab-panel {
            display: none;
            animation: fadeIn 0.4s ease forwards;
        }

        .tab-panel.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* FORM STYLING */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 25px;
        }

        @media (max-width: 600px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }

        .profile-form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 20px;
        }

        .profile-form-group.full-width {
            grid-column: span 2;
        }

        @media (max-width: 600px) {
            .profile-form-group.full-width {
                grid-column: span 1;
            }
        }

        .profile-form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #34495e;
        }

        .profile-input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .profile-input-icon {
            position: absolute;
            left: 15px;
            color: #bdc3c7;
            font-size: 16px;
        }

        .profile-form-control {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border-radius: 12px;
            border: 1.5px solid #e2e8f0;
            font-size: 15px;
            transition: all 0.3s ease;
            box-sizing: border-box;
            background-color: #fff;
            color: #2c3e50;
        }

        .profile-form-control:focus {
            outline: none;
            border-color: var(--profile-primary);
            box-shadow: 0 0 0 4px rgba(255, 101, 132, 0.12);
        }

        .profile-form-control:disabled {
            background-color: #f8fafc;
            color: #94a3b8;
            cursor: not-allowed;
            border-color: #e2e8f0;
        }

        .profile-btn {
            background-color: var(--profile-primary);
            color: white;
            border: none;
            padding: 14px 28px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 5px 15px rgba(255, 101, 132, 0.2);
        }

        .profile-btn:hover {
            background-color: var(--profile-primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 101, 132, 0.3);
        }

        .profile-btn:active {
            transform: translateY(0);
        }

        /* NOTIFICATIONS */
        .profile-alert {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-size: 15px;
            font-weight: 500;
            border: 1px solid transparent;
        }

        .profile-alert-success {
            background-color: #ecfdf5;
            color: #065f46;
            border-color: #a7f3d0;
        }

        .profile-alert-error {
            background-color: #fef2f2;
            color: #991b1b;
            border-color: #fca5a5;
        }

        .profile-alert i {
            font-size: 18px;
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="profile-wrapper">
        <div class="profile-container">
            
            <!-- Left Sidebar Card -->
            <div class="profile-card profile-sidebar">
                <div class="avatar-container">
                    <div class="avatar-circle">
                        ${sessionScope.user.hoTen.substring(0, 1).toUpperCase()}
                    </div>
                </div>
                
                <h3 class="profile-name">${sessionScope.user.hoTen}</h3>
                
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'ADMIN'}">
                        <span class="profile-role-badge badge-admin">Quản trị viên</span>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'STAFF'}">
                        <span class="profile-role-badge badge-staff">Nhân viên</span>
                    </c:when>
                    <c:otherwise>
                        <span class="profile-role-badge badge-customer">Khách hàng thân thiết</span>
                    </c:otherwise>
                </c:choose>

                <!-- Loyalty details for customer -->
                <c:if test="${sessionScope.user.role == 'CUSTOMER'}">
                    <div class="loyalty-card">
                        <div class="loyalty-header">
                            <span class="loyalty-title">Thành viên Me&Be</span>
                            <i class="fas fa-crown loyalty-icon"></i>
                        </div>
                        <div class="loyalty-points">
                            ${not empty diemTichLuy ? diemTichLuy : 0} <span>điểm</span>
                        </div>
                        <div class="loyalty-tier">
                            <c:choose>
                                <c:when test="${diemTichLuy >= 1000}">Hạng Kim Cương</c:when>
                                <c:when test="${diemTichLuy >= 500}">Hạng Vàng</c:when>
                                <c:when test="${diemTichLuy >= 200}">Hạng Bạc</c:when>
                                <c:otherwise>Hạng Đồng</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Right Content Form Card -->
            <div class="profile-card profile-main">
                
                <!-- Toast Alerts -->
                <c:if test="${not empty error}">
                    <div class="profile-alert profile-alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${error}</span>
                    </div>
                </c:if>
                <c:if test="${param.status == 'success'}">
                    <div class="profile-alert profile-alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>Cập nhật thông tin tài khoản thành công!</span>
                    </div>
                </c:if>
                <c:if test="${param.status == 'password_success'}">
                    <div class="profile-alert profile-alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>Thay đổi mật khẩu tài khoản thành công!</span>
                    </div>
                </c:if>

                <!-- Tabs Navigation -->
                <div class="tabs-header">
                    <button class="tab-btn ${activeTab != 'password' ? 'active' : ''}" onclick="switchTab('profile-info', this)">
                        <i class="fas fa-user-edit" style="margin-right: 6px;"></i> Thông tin cá nhân
                    </button>
                    <button class="tab-btn ${activeTab == 'password' ? 'active' : ''}" onclick="switchTab('password-change', this)">
                        <i class="fas fa-key" style="margin-right: 6px;"></i> Đổi mật khẩu
                    </button>
                </div>

                <!-- Tab Panel 1: Profile Information -->
                <div id="profile-info" class="tab-panel ${activeTab != 'password' ? 'active' : ''}">
                    <form action="${pageContext.request.contextPath}/profile" method="post" onsubmit="return validateProfileForm()">
                        <input type="hidden" name="action" value="update_profile">
                        
                        <div class="form-grid">
                            <!-- Username -->
                            <div class="profile-form-group">
                                <label>Tên đăng nhập (Username)</label>
                                <div class="profile-input-wrapper">
                                    <i class="fas fa-user-shield profile-input-icon"></i>
                                    <input type="text" class="profile-form-control" value="${sessionScope.user.tenDangNhap}" disabled>
                                </div>
                            </div>
                            
                            <!-- Role -->
                            <div class="profile-form-group">
                                <label>Loại tài khoản</label>
                                <div class="profile-input-wrapper">
                                    <i class="fas fa-id-card profile-input-icon"></i>
                                    <input type="text" class="profile-form-control" value="${sessionScope.user.role}" disabled>
                                </div>
                            </div>

                            <!-- Fullname -->
                            <div class="profile-form-group full-width">
                                <label for="hoTen">Họ và tên <span style="color:var(--profile-primary)">*</span></label>
                                <div class="profile-input-wrapper">
                                    <i class="fas fa-user profile-input-icon"></i>
                                    <input type="text" id="hoTen" name="hoTen" class="profile-form-control" value="${sessionScope.user.hoTen}" required placeholder="Nhập họ và tên đầy đủ">
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="profile-form-group">
                                <label for="email">Địa chỉ Email <span style="color:var(--profile-primary)">*</span></label>
                                <div class="profile-input-wrapper">
                                    <i class="fas fa-envelope profile-input-icon"></i>
                                    <input type="email" id="email" name="email" class="profile-form-control" value="${sessionScope.user.email}" required placeholder="name@domain.com">
                                </div>
                            </div>

                            <!-- Phone -->
                            <div class="profile-form-group">
                                <label for="dienThoai">Số điện thoại <span style="color:var(--profile-primary)">*</span></label>
                                <div class="profile-input-wrapper">
                                    <i class="fas fa-phone profile-input-icon"></i>
                                    <input type="tel" id="dienThoai" name="dienThoai" class="profile-form-control" value="${sessionScope.user.dienThoai}" required placeholder="Số điện thoại liên lạc">
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="profile-btn">
                            <i class="fas fa-save"></i> Lưu Thay Đổi
                        </button>
                    </form>
                </div>

                <!-- Tab Panel 2: Change Password -->
                <div id="password-change" class="tab-panel ${activeTab == 'password' ? 'active' : ''}">
                    <form action="${pageContext.request.contextPath}/profile" method="post" onsubmit="return validatePasswordForm()">
                        <input type="hidden" name="action" value="change_password">
                        
                        <div class="profile-form-group">
                            <label for="oldPassword">Mật khẩu hiện tại <span style="color:var(--profile-primary)">*</span></label>
                            <div class="profile-input-wrapper">
                                <i class="fas fa-lock-open profile-input-icon"></i>
                                <input type="password" id="oldPassword" name="oldPassword" class="profile-form-control" required placeholder="Nhập mật khẩu hiện tại">
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="profile-form-group">
                                <label for="newPassword">Mật khẩu mới <span style="color:var(--profile-primary)">*</span></label>
                                <div class="profile-input-wrapper">
                                    <i class="fas fa-lock profile-input-icon"></i>
                                    <input type="password" id="newPassword" name="newPassword" class="profile-form-control" required minlength="6" placeholder="Ít nhất 6 ký tự">
                                </div>
                            </div>

                            <div class="profile-form-group">
                                <label for="confirmPassword">Xác nhận mật khẩu mới <span style="color:var(--profile-primary)">*</span></label>
                                <div class="profile-input-wrapper">
                                    <i class="fas fa-check-double profile-input-icon"></i>
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="profile-form-control" required minlength="6" placeholder="Nhập lại mật khẩu mới">
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="profile-btn">
                            <i class="fas fa-key"></i> Đổi Mật Khẩu
                        </button>
                    </form>
                </div>

            </div>

        </div>
    </div>

    <jsp:include page="components/footer.jsp" />

    <script>
        function switchTab(panelId, btn) {
            // Hide all tab panels
            document.querySelectorAll('.tab-panel').forEach(panel => {
                panel.classList.remove('active');
            });
            
            // Deactivate all tab buttons
            document.querySelectorAll('.tab-btn').forEach(tab => {
                tab.classList.remove('active');
            });

            // Show active panel and button
            document.getElementById(panelId).classList.add('active');
            btn.classList.add('active');

            // Hide alert when switching tabs to avoid confusion
            const alert = document.querySelector('.profile-alert');
            if (alert) {
                alert.style.display = 'none';
            }
        }

        function validateProfileForm() {
            const hoTen = document.getElementById('hoTen').value.trim();
            const email = document.getElementById('email').value.trim();
            const dienThoai = document.getElementById('dienThoai').value.trim();

            if (!hoTen || !email || !dienThoai) {
                alert('Vui lòng điền đầy đủ các thông tin có dấu *!');
                return false;
            }

            // Basic email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('Vui lòng nhập định dạng email hợp lệ!');
                return false;
            }

            // Basic phone validation (at least 9 digits)
            const phoneRegex = /^[0-9+ ]{9,13}$/;
            if (!phoneRegex.test(dienThoai)) {
                alert('Vui lòng nhập định dạng số điện thoại hợp lệ (từ 9 đến 13 số)!');
                return false;
            }

            return true;
        }

        function validatePasswordForm() {
            const oldPassword = document.getElementById('oldPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (!oldPassword || !newPassword || !confirmPassword) {
                alert('Vui lòng điền đầy đủ các thông tin mật khẩu!');
                return false;
            }

            if (newPassword.length < 6) {
                alert('Mật khẩu mới phải dài ít nhất 6 ký tự!');
                return false;
            }

            if (newPassword !== confirmPassword) {
                alert('Mật khẩu mới và xác nhận mật khẩu không khớp nhau!');
                return false;
            }

            if (oldPassword === newPassword) {
                alert('Mật khẩu mới không được trùng với mật khẩu cũ!');
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
