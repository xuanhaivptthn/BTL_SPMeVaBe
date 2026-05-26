<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác nhận mã OTP</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2 class="text-center">Xác nhận mã OTP</h2>
    <div class="form-container">
        <c:if test="${not empty error}">
            <p class="alert-error text-center">${error}</p>
        </c:if>
        
        <p class="text-center">Mã OTP gồm 8 ký tự đã được gửi đến email: <b>${sessionScope.otp_email}</b></p>

        <form action="${pageContext.request.contextPath}/verify-otp" method="post">
            <div class="form-group">
                <label>Nhập mã OTP</label>
                <input type="text" name="otp" class="form-control" required/>
            </div>
            <button type="submit" class="btn" style="width:100%">Xác nhận</button>
        </form>
        
        <p class="text-center mt-20"><a href="${pageContext.request.contextPath}/forgot-password">Gửi lại mã OTP</a></p>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
