<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2>Đăng nhập</h2>
    <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
    </c:if>
    <c:if test="${param.msg == 'success'}">
        <p style="color:green">Đăng ký thành công! Vui lòng đăng nhập.</p>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/login" method="post">
        Tên đăng nhập: <input type="text" name="username" required/><br/><br/>
        Mật khẩu: <input type="password" name="password" required/><br/><br/>
        <button type="submit">Đăng nhập</button>
    </form>
    
    <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
