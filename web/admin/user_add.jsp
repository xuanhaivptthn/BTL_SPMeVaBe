<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Người Dùng Mới</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
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
                <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 24px;">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn" style="background: #eee; color: #444; padding: 8px 14px; display:inline-flex; align-items:center; gap:6px;">
                        &#8592; Quay lại
                    </a>
                    <h2 style="margin:0;">Thêm Người Dùng Mới</h2>
                </div>
                <c:if test="${not empty errorMsg}">
                    <div style="background:#ffeaea;border:1px solid #f5c6cb;color:#721c24;padding:10px 16px;border-radius:8px;margin-bottom:16px;">${errorMsg}</div>
                </c:if>
                <form action="${pageContext.request.contextPath}/admin/users" method="post" id="userForm">
                    <input type="hidden" name="action" value="add"/>
                    <div class="form-group" style="display: flex; gap: 15px;">
                        <div style="flex: 1;">
                            <label>Họ Tên:</label>
                            <input type="text" name="hoTen" class="form-control" required/>
                        </div>
                        <div style="flex: 1;">
                            <label>Tên Đăng Nhập:</label>
                            <input type="text" name="tenDangNhap" class="form-control" required/>
                        </div>
                    </div>
                    <div class="form-group" style="display: flex; gap: 15px;">
                        <div style="flex: 1;">
                            <label>Email:</label>
                            <input type="email" name="email" class="form-control" required/>
                        </div>
                        <div style="flex: 1;">
                            <label>Điện Thoại:</label>
                            <input type="text" name="dienThoai" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group" style="display: flex; gap: 15px;">
                        <div style="flex: 1;">
                            <label>Mật Khẩu <span style="font-size:0.85em;color:#666;">(Bắt buộc khi tạo mới)</span>:</label>
                            <input type="password" name="matKhau" class="form-control" required/>
                        </div>
                        <div style="flex: 1; display: flex; gap: 15px;">
                            <div style="flex: 1;">
                                <label>Vai trò:</label>
                                <select name="role" class="form-control">
                                    <option value="CUSTOMER">CUSTOMER</option>
                                    <option value="ADMIN">ADMIN</option>
                                </select>
                            </div>
                            <div style="flex: 1;">
                                <label>Trạng thái:</label>
                                <select name="status" class="form-control">
                                    <option value="ACTIVE">ACTIVE</option>
                                    <option value="INACTIVE">INACTIVE</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div style="display:flex; gap:12px; margin-top:10px;">
                        <button type="submit" class="btn btn-secondary">Thêm Người Dùng</button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn" style="background: #aaa; text-decoration: none;">Hủy</a>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
