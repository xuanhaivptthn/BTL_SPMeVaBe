<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${not empty sessionScope.user}">
    <c:redirect url="/" />
</c:if>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2 class="text-center">Đăng nhập</h2>
    <div class="form-container">
        <c:if test="${not empty error}">
            <p class="alert-error text-center">${error}</p>
        </c:if>
        <c:if test="${param.msg == 'success'}">
            <p class="alert-success text-center">Đăng ký thành công! Vui lòng đăng nhập.</p>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" required/>
            </div>
            <div class="form-group">
                <label>Mật khẩu</label>
                <input type="password" name="password" class="form-control" required/>
            </div>
            <button type="submit" class="btn" style="width:100%">Đăng nhập</button>
        </form>
        
        <p class="text-center mt-20">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a></p>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
