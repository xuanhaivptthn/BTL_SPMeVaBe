<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="Controller.SanPhamDAO" %>
<%@ page import="Model.SanPham" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2>Giỏ hàng của bạn</h2>
    <c:choose>
        <c:when test="${empty cartProducts}">
            <p>Giỏ hàng đang trống. <a href="${pageContext.request.contextPath}/products">Tiếp tục mua sắm</a></p>
        </c:when>
        <c:otherwise>
            <table class="table-modern">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Hình ảnh</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartProducts}">
                        <tr>
                            <td><c:out value="${item.product.tenSanPham}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.product.hinhAnh}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(item.product.hinhAnh, 'http')}">
                                                <img src="${item.product.hinhAnh}" alt="img" class="product-img" style="width:80px; height:80px;"/>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/${item.product.hinhAnh}" alt="img" class="product-img" style="width:80px; height:80px;"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>Không có ảnh</c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatNumber value="${item.product.giaTien}" type="number" pattern="#,###"/></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="update"/>
                                    <input type="hidden" name="productId" value="${item.product.maSanPham}"/>
                                    <input type="number" name="quantity" value="${item.quantity}" min="1" class="form-control" style="width:70px; display:inline-block; padding: 5px;"/>
                                    <button type="submit" class="btn btn-secondary" style="padding: 5px 10px; font-size: 14px;">Cập nhật</button>
                                </form>
                            </td>
                            <td><fmt:formatNumber value="${item.product.giaTien * item.quantity}" type="number" pattern="#,###"/></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="remove"/>
                                    <input type="hidden" name="productId" value="${item.product.maSanPham}"/>
                                    <button type="submit" class="btn" style="background-color: #d9534f; padding: 5px 10px; font-size: 14px;">Xoá</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <h3>Tổng tiền: <fmt:formatNumber value="${totalPrice}" type="number" pattern="#,###"/> VND</h3>
            <div class="mt-20">
                <a href="${pageContext.request.contextPath}/products" class="btn" style="background-color: #6c757d; margin-right: 10px;">Tham khảo các mặt hàng khác</a>
                <a href="${pageContext.request.contextPath}/checkout" class="btn">Tiến hành thanh toán</a>
            </div>
        </c:otherwise>
    </c:choose>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
