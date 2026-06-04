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

        <h2 class="text-center">Đăng ký Tài khoản</h2>
        <div class="form-container">
            <c:if test="${not empty error}">
                <p class="alert-error text-center">${error}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label>Họ và Tên</label>
                    <input type="text" name="hoTen" class="form-control" required />
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required />
                </div>
                <div class="form-group">
                    <label>Điện thoại</label>
                    <input type="text" name="dienThoai" class="form-control" required />
                </div>
                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input type="text" name="tenDangNhap" class="form-control" required />
                </div>
                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" name="matKhau" class="form-control" required />
                </div>
                <div class="form-group">
                    <label>Nhập lại mật khẩu</label>
                    <input type="password" name="matKhau1" class="form-control" required />
                </div>
                <button type="submit" class="btn" style="width:100%">Đăng ký</button>
            </form>
        </div>

        <jsp:include page="components/footer.jsp" />
    </body>

</html>