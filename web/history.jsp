<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử mua hàng</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2>Lịch sử mua hàng của bạn</h2>

    <c:choose>
        <c:when test="${empty history}">
            <p>Bạn chưa có đơn hàng nào.</p>
        </c:when>
        <c:otherwise>
            <table class="table-modern">
                <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Địa chỉ giao hàng</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="dh" items="${history}">
                        <tr>
                            <td>${dh.id}</td>
                            <td>${dh.ngayDatFormatted}</td>
                            <td>${dh.tongTien}</td>
                            <td>${dh.diaChiGiaoHang}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${dh.trangThai == 'PENDING'}">Đang chờ xử lý</c:when>
                                    <c:when test="${dh.trangThai == 'PROCESSING'}">Đang xử lý</c:when>
                                    <c:when test="${dh.trangThai == 'SHIPPED'}">Đang giao</c:when>
                                    <c:when test="${dh.trangThai == 'DELIVERED'}">Đã giao</c:when>
                                    <c:when test="${dh.trangThai == 'CANCELLED'}">Đã huỷ</c:when>
                                    <c:otherwise>${dh.trangThai}</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
