<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Cửa Hàng Mẹ & Bé</title>
</head>
<body>
    <%--<jsp:include page="components/header.jsp" />--%>
    <%@include file="components/header.jsp" %>

    <div>
        <div class="text-center mt-20" style="padding: 50px 0; background: #fff; border-radius: var(--radius); border: 1px solid var(--border-color); box-shadow: var(--shadow-sm);">
        <h2 style="font-size: 32px; color: var(--primary-color);">Chào mừng đến với Cửa Hàng Mẹ và Bé</h2>
        <p style="font-size: 18px; color: #555; margin-bottom: 30px;">Chuyên cung cấp các sản phẩm chất lượng, an toàn cho mẹ và bé yêu của bạn.</p>
        <a href="${pageContext.request.contextPath}/products" class="btn" style="font-size: 18px; padding: 15px 30px;">Xem sản phẩm ngay</a>
    </div>    </div>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
