<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Sản Phẩm Mới</title>
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
                    <a href="${pageContext.request.contextPath}/admin/products" class="btn" style="background: #eee; color: #444; padding: 8px 14px; display:inline-flex; align-items:center; gap:6px;">
                        &#8592; Quay lại
                    </a>
                    <h2 style="margin:0;">Thêm Sản Phẩm Mới</h2>
                </div>
                <c:if test="${not empty errorMsg}">
                    <div style="background:#ffeaea;border:1px solid #f5c6cb;color:#721c24;padding:10px 16px;border-radius:8px;margin-bottom:16px;">${errorMsg}</div>
                </c:if>
                <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data" id="productForm">
                    <input type="hidden" name="action" value="add"/>
                    <div class="form-group">
                        <label>Tên SP:</label>
                        <input type="text" name="name" class="form-control" required/>
                    </div>
                    <div class="form-group">
                        <label>Thông tin:</label>
                        <textarea name="info" class="form-control" rows="3" required></textarea>
                    </div>
                    <div class="form-group">
                        <label>Thành phần:</label>
                        <textarea name="thanhPhan" class="form-control" rows="2"></textarea>
                    </div>
                    <div class="form-group" style="display: flex; gap: 15px;">
                        <div style="flex: 1;">
                            <label>Xuất xứ:</label>
                            <input type="text" name="xuatXu" class="form-control"/>
                        </div>
                        <div style="flex: 1;">
                            <label>Khối lượng:</label>
                            <input type="text" name="khoiLuong" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group" style="display: flex; gap: 15px;">
                        <div style="flex: 1;">
                            <label>Giá:</label>
                            <input type="number" name="price" class="form-control" required/>
                        </div>
                        <div style="flex: 1;">
                            <label>Số lượng:</label>
                            <input type="number" name="quantity" class="form-control" required/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Danh mục:</label>
                        <select name="categoryId" class="form-control" required>
                            <option value="">Chọn danh mục</option>
                            <option value="1">Mẹ bầu và sau sinh</option>
                            <option value="2">Sữa cho bé</option>
                            <option value="3">Bé ăn dặm</option>
                            <option value="4">Bỉm tã và vệ sinh</option>
                            <option value="5">Bình sữa và phụ kiện</option>
                            <option value="6">Đồ sơ sinh</option>
                            <option value="7">Thời trang và phụ kiện</option>
                            <option value="8">Vitamin và sức khỏe</option>
                            <option value="9">Đồ dùng mẹ và bé</option>
                            <option value="10">Giặt xả và Tắm gội</option>
                            <option value="11">Đồ chơi và Học tập</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Upload File Ảnh:</label>
                        <input type="file" name="imageFile" class="form-control" accept="image/*"/>
                    </div>
                    <div class="form-group">
                        <label>Hoặc nhập URL Ảnh tĩnh:</label>
                        <input type="text" name="imageText" class="form-control" placeholder="http://..."/>
                    </div>
                    <div style="display:flex; gap:12px; margin-top:10px;">
                        <button type="submit" class="btn btn-secondary">Thêm Sản Phẩm</button>
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn" style="background: #aaa; text-decoration: none;">Hủy</a>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>
