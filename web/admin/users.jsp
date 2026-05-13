<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Người dùng</title>
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
                <h2>Danh sách Người dùng</h2>
                <div style="margin-bottom: 20px;">
                    <form action="${pageContext.request.contextPath}/admin/users" method="get" style="display: flex; gap: 10px;">
                        <input type="text" name="search" value="${fn:escapeXml(search)}" class="form-control" placeholder="Tìm kiếm theo ID, Họ Tên, Email, Điện Thoại" style="max-width: 400px;"/>
                        <button type="submit" class="btn btn-secondary">Tìm kiếm</button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn">Xóa bộ lọc</a>
                    </form>
                </div>
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Họ Tên</th>
                            <th>Tên Đăng Nhập</th>
                            <th>Email</th>
                            <th>Điện Thoại</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>${u.id}</td>
                                <td>${u.hoTen}</td>
                                <td>${u.tenDangNhap}</td>
                                <td>${u.email}</td>
                                <td>${u.dienThoai}</td>
                                <td>${u.role}</td>
                                <td>${u.status}</td>
                                <td>
                                    <button type="button" class="btn btn-secondary" style="padding: 5px 10px;"
                                            data-id="${u.id}"
                                            data-hoten="${fn:escapeXml(u.hoTen)}"
                                            data-tendangnhap="${fn:escapeXml(u.tenDangNhap)}"
                                            data-email="${fn:escapeXml(u.email)}"
                                            data-dienthoai="${fn:escapeXml(u.dienThoai)}"
                                            data-role="${u.role}"
                                            data-status="${u.status}"
                                            onclick="editUser(this)">Sửa</button>
                                    <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="id" value="${u.id}"/>
                                        <button type="submit" class="btn" style="background: #d9534f; padding: 5px 10px;" onclick="return confirm('Bạn có chắc muốn xóa người dùng này?');">Xóa</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="admin-card mt-20">
                <h3 id="formTitle">Thêm người dùng mới</h3>
                <form action="${pageContext.request.contextPath}/admin/users" method="post" id="userForm">
                    <input type="hidden" name="action" id="formAction" value="add"/>
                    <input type="hidden" name="id" id="formId" value=""/>
                    <div class="form-group" style="display: flex; gap: 15px;">
                        <div style="flex: 1;">
                            <label>Họ Tên:</label>
                            <input type="text" name="hoTen" class="form-control" required/>
                        </div>
                        <div style="flex: 1;">
                            <label>Tên Đăng Nhập:</label>
                            <input type="text" name="tenDangNhap" id="inputTenDangNhap" class="form-control" required/>
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
                            <label>Mật Khẩu <span id="pwdHint" style="font-size:0.85em;color:#666;">(Bắt buộc khi tạo mới)</span>:</label>
                            <input type="password" name="matKhau" id="inputMatKhau" class="form-control" required/>
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
                    <button type="submit" class="btn btn-secondary" id="submitBtn">Thêm Người Dùng</button>
                    <button type="button" class="btn" style="background: #aaa; display:none;" id="cancelBtn" onclick="resetForm()">Hủy</button>
                </form>
            </div>
        </main>
    </div>

    <script>
        function editUser(btn) {
            document.getElementById('formTitle').innerText = 'Sửa Người Dùng';
            document.getElementById('formAction').value = 'update';
            document.getElementById('formId').value = btn.getAttribute('data-id');
            document.querySelector('input[name="hoTen"]').value = btn.getAttribute('data-hoten');
            document.getElementById('inputTenDangNhap').value = btn.getAttribute('data-tendangnhap');
            document.getElementById('inputTenDangNhap').readOnly = true; // Không cho sửa tên đăng nhập
            document.querySelector('input[name="email"]').value = btn.getAttribute('data-email');
            document.querySelector('input[name="dienThoai"]').value = btn.getAttribute('data-dienthoai');
            document.querySelector('select[name="role"]').value = btn.getAttribute('data-role');
            document.querySelector('select[name="status"]').value = btn.getAttribute('data-status');
            
            var pwdInput = document.getElementById('inputMatKhau');
            pwdInput.required = false;
            pwdInput.value = '';
            document.getElementById('pwdHint').innerText = '(Để trống nếu không muốn đổi)';
            
            document.getElementById('submitBtn').innerText = 'Cập nhật';
            document.getElementById('cancelBtn').style.display = 'inline-block';
            window.scrollTo(0, document.getElementById('userForm').offsetTop);
        }
        
        function resetForm() {
            document.getElementById('formTitle').innerText = 'Thêm người dùng mới';
            document.getElementById('formAction').value = 'add';
            document.getElementById('formId').value = '';
            document.getElementById('userForm').reset();
            document.getElementById('inputTenDangNhap').readOnly = false;
            
            var pwdInput = document.getElementById('inputMatKhau');
            pwdInput.required = true;
            document.getElementById('pwdHint').innerText = '(Bắt buộc khi tạo mới)';
            
            document.getElementById('submitBtn').innerText = 'Thêm Người Dùng';
            document.getElementById('cancelBtn').style.display = 'none';
        }
    </script>
</body>
</html>
