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
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .page-header h2 { margin: 0; }

        /* Pagination styles */
        .pagination-wrap {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .pagination-info {
            font-size: 14px;
            color: #666;
        }
        .pagination-controls {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .page-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 36px;
            height: 36px;
            padding: 0 10px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            background: #fff;
            color: #444;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.15s;
        }
        .page-btn:hover { background: #f0f0f0; border-color: #ccc; color: var(--primary-color); }
        .page-btn.active { background: var(--primary-color); color: #fff; border-color: var(--primary-color); }
        .page-btn.disabled { opacity: 0.4; pointer-events: none; }

        .per-page-select {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #555;
        }
        .per-page-select select {
            padding: 5px 10px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            font-size: 14px;
            cursor: pointer;
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
                    <h2>Danh sách Sản phẩm</h2>
                    <a href="${pageContext.request.contextPath}/admin/product_add.jsp" class="btn btn-secondary" style="display:inline-flex;align-items:center;gap:6px;">
                        &#43; Thêm Sản Phẩm
                    </a>
                </div>
                <div style="margin-bottom: 20px;">
                    <form action="${pageContext.request.contextPath}/admin/products" method="get" id="filterForm" style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
                        <input type="hidden" name="pageSize" id="filterPageSize" value="${pageSize}"/>
                        <input type="text" name="search" value="${fn:escapeXml(search)}" class="form-control" placeholder="Tìm kiếm theo tên SP" style="max-width: 250px;"/>
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
                        <input type="text" name="brand" value="${fn:escapeXml(selectedBrand)}" class="form-control" placeholder="Thương hiệu" style="max-width: 160px;"/>
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

                <!-- Phân trang -->
                <div class="pagination-wrap">
                    <div class="pagination-info">
                        Hiển thị <strong>${(currentPage - 1) * pageSize + 1}</strong>–<strong>${(currentPage - 1) * pageSize + fn:length(products)}</strong>
                        trong tổng số <strong>${totalProducts}</strong> sản phẩm
                    </div>
                    <div style="display:flex; align-items:center; gap:16px; flex-wrap:wrap;">
                        <div class="per-page-select">
                            Hiển thị:
                            <select onchange="changePageSize(this.value)">
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                            </select>
                            / trang
                        </div>
                        <div class="pagination-controls">
                            <a class="page-btn ${currentPage <= 1 ? 'disabled' : ''}"
                               href="?page=${currentPage - 1}&pageSize=${pageSize}&search=${fn:escapeXml(search)}&category=${fn:escapeXml(selectedCategory)}&brand=${fn:escapeXml(selectedBrand)}">
                               &#8592;
                            </a>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:when test="${i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)}">
                                        <a class="page-btn" href="?page=${i}&pageSize=${pageSize}&search=${fn:escapeXml(search)}&category=${fn:escapeXml(selectedCategory)}&brand=${fn:escapeXml(selectedBrand)}">${i}</a>
                                    </c:when>
                                    <c:when test="${i == currentPage - 3 || i == currentPage + 3}">
                                        <span class="page-btn" style="border:none;pointer-events:none;">…</span>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                            <a class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}"
                               href="?page=${currentPage + 1}&pageSize=${pageSize}&search=${fn:escapeXml(search)}&category=${fn:escapeXml(selectedCategory)}&brand=${fn:escapeXml(selectedBrand)}">
                               &#8594;
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal Sửa Sản Phẩm -->
            <div id="editModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center; overflow-y:auto;">
                <div style="background:#fff; border-radius:12px; padding:32px; width:600px; max-width:95%; box-shadow:0 10px 40px rgba(0,0,0,0.2); margin: 30px auto;">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                        <h3 style="margin:0;">Sửa Sản Phẩm</h3>
                        <button onclick="closeModal()" style="background:none;border:none;font-size:22px;cursor:pointer;color:#888;">&times;</button>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data" id="productForm">
                        <input type="hidden" name="action" id="formAction" value="update"/>
                        <input type="hidden" name="id" id="formId" value=""/>
                        <div class="form-group">
                            <label>Tên SP:</label>
                            <input type="text" name="name" id="editName" class="form-control" required/>
                        </div>
                        <div class="form-group">
                            <label>Thông tin:</label>
                            <textarea name="info" id="editInfo" class="form-control" rows="3" required></textarea>
                        </div>
                        <div class="form-group" style="display: flex; gap: 15px;">
                            <div style="flex: 1;">
                                <label>Giá:</label>
                                <input type="number" name="price" id="editPrice" class="form-control" required/>
                            </div>
                            <div style="flex: 1;">
                                <label>Số lượng:</label>
                                <input type="number" name="quantity" id="editQty" class="form-control" required/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Danh mục:</label>
                            <select name="categoryId" id="editCategory" class="form-control" required>
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
                            <label>Upload File Ảnh mới (nếu muốn thay):</label>
                            <input type="file" name="imageFile" class="form-control" accept="image/*"/>
                        </div>
                        <div class="form-group">
                            <label>Hoặc nhập URL Ảnh tĩnh:</label>
                            <input type="text" name="imageText" id="editImage" class="form-control" placeholder="http://..."/>
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
        function editProduct(btn) {
            document.getElementById('formId').value = btn.getAttribute('data-id');
            document.getElementById('editName').value = btn.getAttribute('data-name');
            document.getElementById('editInfo').value = btn.getAttribute('data-info');
            document.getElementById('editPrice').value = btn.getAttribute('data-price');
            document.getElementById('editQty').value = btn.getAttribute('data-qty');
            document.getElementById('editImage').value = btn.getAttribute('data-image');
            var cat = btn.getAttribute('data-category');
            if (cat) document.getElementById('editCategory').value = cat;
            
            var modal = document.getElementById('editModal');
            modal.style.display = 'flex';
        }
        
        function closeModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        document.getElementById('editModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });

        function changePageSize(size) {
            var url = new URL(window.location.href);
            url.searchParams.set('pageSize', size);
            url.searchParams.set('page', '1');
            window.location.href = url.toString();
        }
    </script>
</body>
</html>
