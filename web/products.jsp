<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
</head>
<body>
<h1>Danh sách sản phẩm</h1>

<c:choose>
    <c:when test="${empty products}">
        <p>Không có sản phẩm nào.</p>
    </c:when>
    <c:otherwise>
        <table border="1" cellpadding="6" cellspacing="0">
            <thead>
            <tr>
                <th>MaSanPham</th>
                <th>TenSanPham</th>
                <th>GiaTien</th>
                <th>SoLuong</th>
                <th>Hinh</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td><c:out value="${p.maSanPham}"/></td>
                    <td><c:out value="${p.tenSanPham}"/></td>
                    <td><c:out value="${p.giaTien}"/></td>
                    <td><c:out value="${p.soLuong}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty p.images}">
                                <c:forEach var="img" items="${p.images}" begin="0" end="0">
                                    <img src="${img}" alt="" width="80"/>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                (no image)
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>

</body>
</html>
