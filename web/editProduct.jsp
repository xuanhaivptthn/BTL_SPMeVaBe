<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa sản phẩm</title>
</head>
<body>
<h1>Chỉnh sửa sản phẩm</h1>
<c:if test="${not empty product}">
    <form action="${pageContext.request.contextPath}/admin/product" method="post">
        <input type="hidden" name="action" value="save" />
        <input type="hidden" name="id" value="${product.maSanPham}" />
        <div>
            <label>Tên:</label>
            <input type="text" name="TenSanPham" value="${product.tenSanPham}" />
        </div>
        <div>
            <label>Thông tin:</label>
            <textarea name="ThongTinSanPham">${product.thongTinSanPham}</textarea>
        </div>
        <div>
            <label>Giá:</label>
            <input type="text" name="GiaTien" value="${product.giaTien}" />
        </div>
        <div>
            <label>Số lượng:</label>
            <input type="text" name="SoLuong" value="${product.soLuong}" />
        </div>
        <div>
            <label>Images (comma-separated URLs):</label>
            <textarea name="images">
                <c:forEach var="img" items="${product.images}">
                    ${img},
                </c:forEach>
            </textarea>
        </div>
        <div>
            <button type="submit">Lưu</button>
            <a href="${pageContext.request.contextPath}/products">Hủy</a>
        </div>
    </form>
    <form action="${pageContext.request.contextPath}/admin/product" method="post" onsubmit="return confirm('Xóa sản phẩm này?');">
        <input type="hidden" name="action" value="delete" />
        <input type="hidden" name="id" value="${product.maSanPham}" />
        <button type="submit">Xóa sản phẩm</button>
    </form>
</c:if>
</body>
</html>
