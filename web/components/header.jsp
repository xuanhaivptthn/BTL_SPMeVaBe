<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div>
    <h1><a href="${pageContext.request.contextPath}/">Cửa Hàng Mẹ & Bé</a></h1>
    <nav>
        <a href="${pageContext.request.contextPath}/">Trang chủ</a> | 
        <a href="${pageContext.request.contextPath}/products">Sản phẩm</a> | 
        <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a> | 
        
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <b>Xin chào, ${sessionScope.user.hoTen}</b> |
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'ADMIN' or sessionScope.user.role == 'STAFF'}">
                        <a href="${pageContext.request.contextPath}/admin/index.jsp" style="color:red">Trang Quản Trị</a> |
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/history">Lịch sử mua hàng</a> |
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">Đăng nhập</a> |
                <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </nav>
    <hr/>
</div>
