<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2>Danh sách sản phẩm</h2>

    <c:choose>
        <c:when test="${empty products}">
            <p>Không có sản phẩm nào.</p>
        </c:when>
        <c:otherwise>
            <div class="product-grid">
                <c:forEach var="p" items="${products}">
                    <div class="product-card">
                        <c:choose>
                            <c:when test="${not empty p.images}">
                                <c:forEach var="img" items="${p.images}" begin="0" end="0">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(img, 'http')}">
                                            <img src="${img}" alt="${p.tenSanPham}" class="product-img"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/${img}" alt="${p.tenSanPham}" class="product-img"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p>(Chưa có ảnh)</p>
                            </c:otherwise>
                        </c:choose>
                        <h3><c:out value="${p.tenSanPham}"/></h3>
                        <p class="product-price"><c:out value="${p.giaTien}"/> VND</p>
                        <form action="${pageContext.request.contextPath}/cart" method="post">
                            <input type="hidden" name="action" value="add"/>
                            <input type="hidden" name="productId" value="${p.maSanPham}"/>
                            <div class="form-group">
                                Số lượng: <input type="number" name="quantity" value="1" min="1" max="${p.soLuong}" class="form-control" style="width: 80px; display: inline-block;"/>
                            </div>
                            <button type="submit" class="btn">Thêm vào giỏ hàng</button>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
