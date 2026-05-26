<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu mới</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2 class="text-center">Đặt lại mật khẩu mới</h2>
    <div class="form-container">
        <c:if test="${not empty error}">
            <p class="alert-error text-center">${error}</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/reset-password" method="post">
            <div class="form-group">
                <label>Mật khẩu mới</label>
                <input type="password" name="matKhau" class="form-control" required/>
            </div>
            <div class="form-group">
                <label>Xác nhận mật khẩu mới</label>
                <input type="password" name="xacNhanMatKhau" class="form-control" required/>
            </div>
            <button type="submit" class="btn" style="width:100%">Đổi mật khẩu</button>
        </form>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
