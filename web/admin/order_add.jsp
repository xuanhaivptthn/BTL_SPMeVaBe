<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Đơn Hàng Mới</title>
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
                <h2>Thêm Đơn Hàng Mới</h2>
                <form action="${pageContext.request.contextPath}/admin/orders" method="post" id="addOrderForm">
                    <input type="hidden" name="action" value="add"/>
                    <div class="form-group">
                        <label>ID Khách Hàng (User ID):</label>
                        <input type="number" name="khachHangId" class="form-control" required/>
                    </div>
                    <div class="form-group">
                        <label>Địa chỉ giao hàng:</label>
                        <input type="text" name="diaChiGiaoHang" class="form-control" required/>
                    </div>
                    <div class="form-group">
                        <label>Ghi chú:</label>
                        <textarea name="ghiChu" class="form-control" rows="2"></textarea>
                    </div>

                    <h3 class="mt-20">Danh sách sản phẩm</h3>
                    <table class="table-modern" id="productsTable">
                        <thead>
                            <tr>
                                <th>Mã SP (ID)</th>
                                <th>Số lượng</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="number" name="sanPhamId[]" class="form-control" required/></td>
                                <td><input type="number" name="soLuong[]" class="form-control" value="1" min="1" required/></td>
                                <td><button type="button" class="btn" style="background: #d9534f;" onclick="removeRow(this)">Xóa</button></td>
                            </tr>
                        </tbody>
                    </table>
                    <button type="button" class="btn btn-secondary mt-10" onclick="addRow()">+ Thêm Sản Phẩm</button>

                    <div style="margin-top: 30px;">
                        <button type="submit" class="btn btn-secondary">Tạo Đơn Hàng</button>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn" style="background: #aaa; text-decoration: none;">Hủy</a>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script>
        function addRow() {
            var tbody = document.querySelector('#productsTable tbody');
            var tr = document.createElement('tr');
            tr.innerHTML = `
                <td><input type="number" name="sanPhamId[]" class="form-control" required/></td>
                <td><input type="number" name="soLuong[]" class="form-control" value="1" min="1" required/></td>
                <td><button type="button" class="btn" style="background: #d9534f;" onclick="removeRow(this)">Xóa</button></td>
            `;
            tbody.appendChild(tr);
        }

        function removeRow(btn) {
            var tr = btn.closest('tr');
            if (document.querySelectorAll('#productsTable tbody tr').length > 1) {
                tr.remove();
            } else {
                alert('Phải có ít nhất 1 sản phẩm!');
            }
        }
    </script>
</body>
</html>
