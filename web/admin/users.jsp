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
        .badge-role-admin {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            background: #e8d5ff;
            color: #6a0dad;
        }
        .badge-role-customer {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            background: #d0e8ff;
            color: #0a58ca;
        }
        .badge-status-active {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            background: #d4edda;
            color: #155724;
        }
        .badge-status-inactive {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            background: #f8d7da;
            color: #721c24;
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
                    <h2>Danh sách Người dùng</h2>
                    <a href="${pageContext.request.contextPath}/admin/user_add.jsp" class="btn btn-secondary" style="display:inline-flex;align-items:center;gap:6px;">
                        &#43; Thêm Người Dùng
                    </a>
                </div>
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
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role == 'ADMIN'}">
                                            <span class="badge-role-admin">ADMIN</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-role-customer">CUSTOMER</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.status == 'ACTIVE'}">
                                            <span class="badge-status-active">ACTIVE</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status-inactive">INACTIVE</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
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

            <!-- Modal Sửa Người Dùng -->
            <div id="editModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
                <div style="background:#fff; border-radius:12px; padding:32px; width:560px; max-width:95%; box-shadow:0 10px 40px rgba(0,0,0,0.2);">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                        <h3 style="margin:0;">Sửa Người Dùng</h3>
                        <button onclick="closeModal()" style="background:none;border:none;font-size:22px;cursor:pointer;color:#888;">&times;</button>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/users" method="post" id="editUserForm">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="id" id="editFormId" value=""/>
                        <div class="form-group" style="display: flex; gap: 15px;">
                            <div style="flex: 1;">
                                <label>Họ Tên:</label>
                                <input type="text" name="hoTen" id="editHoTen" class="form-control" required/>
                            </div>
                            <div style="flex: 1;">
                                <label>Tên Đăng Nhập:</label>
                                <input type="text" name="tenDangNhap" id="editTenDangNhap" class="form-control" readonly style="background:#f5f5f5;"/>
                            </div>
                        </div>
                        <div class="form-group" style="display: flex; gap: 15px;">
                            <div style="flex: 1;">
                                <label>Email:</label>
                                <input type="email" name="email" id="editEmail" class="form-control" required/>
                            </div>
                            <div style="flex: 1;">
                                <label>Điện Thoại:</label>
                                <input type="text" name="dienThoai" id="editDienThoai" class="form-control"/>
                            </div>
                        </div>
                        <div class="form-group" style="display: flex; gap: 15px;">
                            <div style="flex: 1;">
                                <label>Mật Khẩu <span style="font-size:0.85em;color:#888;">(Để trống nếu không đổi)</span>:</label>
                                <input type="password" name="matKhau" class="form-control"/>
                            </div>
                            <div style="flex: 1; display: flex; gap: 15px;">
                                <div style="flex: 1;">
                                    <label>Vai trò:</label>
                                    <select name="role" id="editRole" class="form-control">
                                        <option value="CUSTOMER">CUSTOMER</option>
                                        <option value="ADMIN">ADMIN</option>
                                    </select>
                                </div>
                                <div style="flex: 1;">
                                    <label>Trạng thái:</label>
                                    <select name="status" id="editStatus" class="form-control">
                                        <option value="ACTIVE">ACTIVE</option>
                                        <option value="INACTIVE">INACTIVE</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div style="display:flex; gap:12px; margin-top:10px;">
                            <button type="submit" class="btn btn-secondary">Cập nhật</button>
                            <button type="button" class="btn" style="background:#aaa;" onclick="closeModal()">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        function editUser(btn) {
            document.getElementById('editFormId').value = btn.getAttribute('data-id');
            document.getElementById('editHoTen').value = btn.getAttribute('data-hoten');
            document.getElementById('editTenDangNhap').value = btn.getAttribute('data-tendangnhap');
            document.getElementById('editEmail').value = btn.getAttribute('data-email');
            document.getElementById('editDienThoai').value = btn.getAttribute('data-dienthoai');
            document.getElementById('editRole').value = btn.getAttribute('data-role');
            document.getElementById('editStatus').value = btn.getAttribute('data-status');
            
            var modal = document.getElementById('editModal');
            modal.style.display = 'flex';
        }
        
        function closeModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        // Đóng modal khi click ra ngoài
        document.getElementById('editModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });
    </script>
</body>
</html>
