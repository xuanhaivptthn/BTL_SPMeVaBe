<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng</title>
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

    <h2>Danh sách Đơn hàng</h2>
    
    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>Mã ĐH</th>
            <th>Khách Hàng ID</th>
            <th>Ngày đặt</th>
            <th>Tổng tiền</th>
            <th>Địa chỉ giao hàng</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        <c:forEach var="o" items="${orders}">
            <tr>
                <td>${o.id}</td>
                <td>${o.khachHangId}</td>
                <td>${o.ngayDatFormatted}</td>
                <td>${o.tongTien}</td>
                <td>${o.diaChiGiaoHang}</td>
                <td>${o.trangThai}</td>
                <td>
                    <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                        <input type="hidden" name="action" value="updateStatus"/>
                        <input type="hidden" name="id" value="${o.id}"/>
                        <select name="status">
                            <option value="PENDING" ${o.trangThai == 'PENDING' ? 'selected' : ''}>PENDING</option>
                            <option value="PROCESSING" ${o.trangThai == 'PROCESSING' ? 'selected' : ''}>PROCESSING</option>
                            <option value="SHIPPED" ${o.trangThai == 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                            <option value="DELIVERED" ${o.trangThai == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                            <option value="CANCELLED" ${o.trangThai == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                        </select>
                        <button type="submit">Cập nhật</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>

</body>
</html>
