<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Sản phẩm</title>
</head>
<body>
    <div>
        <h1>Quản Trị Hệ Thống - Cửa Hàng Mẹ & Bé</h1>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/index.jsp">Dashboard</a> | 
            <a href="${pageContext.request.contextPath}/admin/products">Quản lý Sản phẩm</a> | 
            <a href="${pageContext.request.contextPath}/admin/orders">Quản lý Đơn hàng</a> | 
            <a href="${pageContext.request.contextPath}/">Về trang khách hàng</a>
        </nav>
        <hr/>
    </div>

    <h2>Danh sách Sản phẩm</h2>
    
    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>ID</th>
            <th>Tên SP</th>
            <th>Giá</th>
            <th>Số lượng</th>
            <th>Ảnh</th>
            <th>Thao tác</th>
        </tr>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.maSanPham}</td>
                <td>${p.tenSanPham}</td>
                <td>${p.giaTien}</td>
                <td>${p.soLuong}</td>
                <td>
                    <c:choose>
                        <c:when test="${not empty p.images}">
                            <c:choose>
                                <c:when test="${fn:startsWith(p.images[0], 'http')}">
                                    <img src="${p.images[0]}" alt="${p.tenSanPham}" width="80"/>
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/${p.images[0]}" alt="${p.tenSanPham}" width="80"/>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>(Chưa có ảnh)</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="id" value="${p.maSanPham}"/>
                        <button type="submit" onclick="return confirm('Xoá sản phẩm này?');">Xoá</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>

    <br/>
    <h3>Thêm sản phẩm mới</h3>
    <!-- Bắt buộc phải có enctype="multipart/form-data" để upload file -->
    <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
        <input type="hidden" name="action" value="add"/>
        <table cellpadding="5">
            <tr>
                <td>Tên SP:</td>
                <td><input type="text" name="name" required/></td>
            </tr>
            <tr>
                <td>Thông tin:</td>
                <td><textarea name="info" rows="3" required></textarea></td>
            </tr>
            <tr>
                <td>Giá:</td>
                <td><input type="number" name="price" required/></td>
            </tr>
            <tr>
                <td>Số lượng:</td>
                <td><input type="number" name="quantity" required/></td>
            </tr>
            <tr>
                <td>Upload File Ảnh:</td>
                <td><input type="file" name="imageFile" accept="image/*"/></td>
            </tr>
            <tr>
                <td>Hoặc nhập URL Ảnh tĩnh:</td>
                <td><input type="text" name="imageText" placeholder="http://..."/></td>
            </tr>
            <tr>
                <td colspan="2"><button type="submit">Thêm Sản Phẩm</button></td>
            </tr>
        </table>
    </form>

</body>
</html>
