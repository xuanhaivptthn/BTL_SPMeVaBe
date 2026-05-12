<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2>Đăng ký Tài khoản</h2>
    <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        Họ và Tên: <input type="text" name="hoTen" required/><br/><br/>
        Email: <input type="email" name="email" required/><br/><br/>
        Điện thoại: <input type="text" name="dienThoai" required/><br/><br/>
        Tên đăng nhập: <input type="text" name="tenDangNhap" required/><br/><br/>
        Mật khẩu: <input type="password" name="matKhau" required/><br/><br/>
        <button type="submit">Đăng ký</button>
    </form>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
