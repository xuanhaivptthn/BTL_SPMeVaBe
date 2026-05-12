<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
</head>
<body>
    <div>
        <h1>Quản Trị Hệ Thống - Cửa Hàng Mẹ & Bé</h1>
        <nav>
            <a href="${pageContext.request.contextPath}/admin/index.jsp">Dashboard</a> | 
            <a href="${pageContext.request.contextPath}/admin/products">Quản lý Sản phẩm</a> | 
            <a href="${pageContext.request.contextPath}/admin/orders">Quản lý Đơn hàng</a> | 
            <a href="${pageContext.request.contextPath}/">Về trang khách hàng</a>
        </nav>
        <hr/>
    </div>

    <h2>Dashboard</h2>
    <p>Chào mừng Admin. Chọn chức năng trên menu để tiếp tục.</p>

</body>
</html>
