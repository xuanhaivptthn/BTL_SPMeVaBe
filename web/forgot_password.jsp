<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2 class="text-center">Quên mật khẩu</h2>
    <div class="form-container">
        <c:if test="${not empty error}">
            <p class="alert-error text-center">${error}</p>
        </c:if>
        
        <p class="text-center">Vui lòng nhập địa chỉ email đã đăng ký của bạn. Chúng tôi sẽ gửi một mã OTP để xác nhận.</p>

        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" class="form-control" required/>
            </div>
            <button type="submit" class="btn" style="width:100%">Gửi mã OTP</button>
        </form>
        
        <p class="text-center mt-20"><a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a></p>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
