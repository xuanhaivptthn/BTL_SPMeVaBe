<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2>Thông tin thanh toán</h2>

    <form action="${pageContext.request.contextPath}/checkout" method="post">
        <div>
            <label>Địa chỉ giao hàng:</label><br/>
            <input type="text" name="diaChiGiaoHang" required style="width: 300px;"/>
        </div>
        <br/>
        <div>
            <label>Ghi chú đơn hàng:</label><br/>
            <textarea name="ghiChu" rows="4" style="width: 300px;"></textarea>
        </div>
        <br/>
        <button type="submit">Xác nhận đặt hàng</button>
    </form>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
