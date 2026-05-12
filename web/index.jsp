<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Cửa Hàng Mẹ & Bé</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div>
        <h2>Chào mừng đến với Cửa Hàng Mẹ & Bé</h2>
        <p>Cung cấp các sản phẩm tốt nhất cho mẹ và bé yêu của bạn.</p>
        
        <div>
            <h3>Sản phẩm nổi bật</h3>
            <!-- TODO: Có thể fetch sản phẩm từ DB ở HomeServlet -->
            <p><a href="${pageContext.request.contextPath}/products">Xem tất cả sản phẩm</a></p>
        </div>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
