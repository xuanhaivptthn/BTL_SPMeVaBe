<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Sản phẩm</title>
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
                <h2>Danh sách Sản phẩm</h2>
                <div style="margin-bottom: 20px;">
                    <form action="${pageContext.request.contextPath}/admin/products" method="get" style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <input type="text" name="search" value="${fn:escapeXml(search)}" class="form-control" placeholder="Tìm kiếm theo tên SP" style="max-width: 300px;"/>
                        <select name="category" class="form-control" style="width: 200px;">
                            <option value="">Tất cả danh mục</option>
                            <option value="1" ${selectedCategory == '1' ? 'selected' : ''}>Mẹ bầu và sau sinh</option>
                            <option value="2" ${selectedCategory == '2' ? 'selected' : ''}>Sữa cho bé</option>
                            <option value="3" ${selectedCategory == '3' ? 'selected' : ''}>Bé ăn dặm</option>
                            <option value="4" ${selectedCategory == '4' ? 'selected' : ''}>Bỉm tã và vệ sinh</option>
                            <option value="5" ${selectedCategory == '5' ? 'selected' : ''}>Bình sữa và phụ kiện</option>
                            <option value="6" ${selectedCategory == '6' ? 'selected' : ''}>Đồ sơ sinh</option>
                            <option value="7" ${selectedCategory == '7' ? 'selected' : ''}>Thời trang và phụ kiện</option>
                            <option value="8" ${selectedCategory == '8' ? 'selected' : ''}>Vitamin và sức khỏe</option>
                            <option value="9" ${selectedCategory == '9' ? 'selected' : ''}>Đồ dùng mẹ và bé</option>
                            <option value="10" ${selectedCategory == '10' ? 'selected' : ''}>Giặt xả và Tắm gội</option>
                            <option value="11" ${selectedCategory == '11' ? 'selected' : ''}>Đồ chơi và Học tập</option>
                        </select>
                        <input type="text" name="brand" value="${fn:escapeXml(selectedBrand)}" class="form-control" placeholder="Thương hiệu (vd: Moony, Meiji)" style="max-width: 200px;"/>
                        <button type="submit" class="btn btn-secondary">Lọc</button>
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn">Xóa bộ lọc</a>
                    </form>
                </div>
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên SP</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Ảnh</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>${p.maSanPham}</td>
                                <td>${p.tenSanPham}</td>
                                <td><fmt:formatNumber value="${p.giaTien}" type="number" pattern="#,###"/></td>
                                <td>${p.soLuong}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.hinhAnh}">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(p.hinhAnh, 'http')}">
                                                    <img src="${p.hinhAnh}" alt="${p.tenSanPham}" width="80" style="border-radius: var(--radius)"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/${p.hinhAnh}" alt="${p.tenSanPham}" width="80" style="border-radius: var(--radius)"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>(Chưa có ảnh)</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button type="button" class="btn btn-secondary" style="padding: 5px 10px;"
                                            data-id="${p.maSanPham}"
                                            data-name="${fn:escapeXml(p.tenSanPham)}"
                                            data-price="${p.giaTien}"
                                            data-qty="${p.soLuong}"
                                            data-info="${fn:escapeXml(p.thongTinSanPham)}"
                                            data-image="${p.hinhAnh}"
                                            data-category="${p.danhMucId}"
                                            onclick="editProduct(this)">Sửa</button>
                                    <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="id" value="${p.maSanPham}"/>
                                        <button type="submit" class="btn" style="background: #d9534f; padding: 5px 10px;" onclick="return confirm('Xoá sản phẩm này?');">Xoá</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="admin-card mt-20">
                <h3 id="formTitle">Thêm sản phẩm mới</h3>
                <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data" id="productForm">
                    <input type="hidden" name="action" id="formAction" value="add"/>
                    <input type="hidden" name="id" id="formId" value=""/>
                    <div class="form-group">
                        <label>Tên SP:</label>
                        <input type="text" name="name" class="form-control" required/>
                    </div>
                    <div class="form-group">
                        <label>Thông tin:</label>
                        <textarea name="info" class="form-control" rows="3" required></textarea>
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
                    <button type="submit" class="btn btn-secondary" id="submitBtn">Thêm Sản Phẩm</button>
                    <button type="button" class="btn" style="background: #aaa; display:none;" id="cancelBtn" onclick="resetForm()">Hủy</button>
                </form>
            </div>
        </main>
    </div>
    <script>
        function editProduct(btn) {
            document.getElementById('formTitle').innerText = 'Sửa Sản Phẩm';
            document.getElementById('formAction').value = 'update';
            document.getElementById('formId').value = btn.getAttribute('data-id');
            document.querySelector('input[name="name"]').value = btn.getAttribute('data-name');
            document.querySelector('textarea[name="info"]').value = btn.getAttribute('data-info');
            document.querySelector('input[name="price"]').value = btn.getAttribute('data-price');
            document.querySelector('input[name="quantity"]').value = btn.getAttribute('data-qty');
            document.querySelector('input[name="imageText"]').value = btn.getAttribute('data-image');
            var cat = btn.getAttribute('data-category');
            if(cat) document.querySelector('select[name="categoryId"]').value = cat;
            document.getElementById('submitBtn').innerText = 'Cập nhật';
            document.getElementById('cancelBtn').style.display = 'inline-block';
            window.scrollTo(0, document.getElementById('productForm').offsetTop);
        }
        
        function resetForm() {
            document.getElementById('formTitle').innerText = 'Thêm sản phẩm mới';
            document.getElementById('formAction').value = 'add';
            document.getElementById('formId').value = '';
            document.getElementById('productForm').reset();
            var sel = document.querySelector('select[name="categoryId"]'); if(sel) sel.value = '';
            document.getElementById('submitBtn').innerText = 'Thêm Sản Phẩm';
            document.getElementById('cancelBtn').style.display = 'none';
        }
    </script>
</body>
</html>
