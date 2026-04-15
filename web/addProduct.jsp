<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm sản phẩm</title>
</head>
<body>
<h1>Thêm sản phẩm</h1>
<form action="${pageContext.request.contextPath}/admin/product" method="post">
    <input type="hidden" name="action" value="save" />
    <div>
        <label>Tên:</label>
        <input type="text" name="TenSanPham" />
    </div>
    <div>
        <label>Thông tin:</label>
        <textarea name="ThongTinSanPham"></textarea>
    </div>
    <div>
        <label>Giá:</label>
        <input type="text" name="GiaTien" />
    </div>
    <div>
        <label>Số lượng:</label>
        <input type="text" name="SoLuong" />
    </div>
    <div>
        <label>Images (comma-separated URLs):</label>
        <textarea name="images"></textarea>
    </div>
    <div>
        <button type="submit">Lưu</button>
        <a href="${pageContext.request.contextPath}/products">Hủy</a>
    </div>
<form>
</body>
</html>
