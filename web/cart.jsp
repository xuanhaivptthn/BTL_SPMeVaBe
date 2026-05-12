<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="Controller.SanPhamDAO" %>
<%@ page import="Model.SanPham" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2>Giỏ hàng của bạn</h2>

    <%
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            out.println("<p>Giỏ hàng trống.</p>");
        } else {
            SanPhamDAO dao = new SanPhamDAO();
            double tongCong = 0;
    %>
        <table border="1" cellpadding="10" cellspacing="0">
            <tr>
                <th>Tên sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Thành tiền</th>
                <th>Hành động</th>
            </tr>
            <%
                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    int productId = entry.getKey();
                    int quantity = entry.getValue();
                    SanPham sp = dao.getById(productId);
                    if (sp != null) {
                        double thanhTien = sp.getGiaTien() * quantity;
                        tongCong += thanhTien;
            %>
            <tr>
                <td><%= sp.getTenSanPham() %></td>
                <td><%= sp.getGiaTien() %></td>
                <td>
                    <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="productId" value="<%= productId %>"/>
                        <input type="number" name="quantity" value="<%= quantity %>" min="1" style="width: 50px;"/>
                        <button type="submit">Cập nhật</button>
                    </form>
                </td>
                <td><%= thanhTien %></td>
                <td>
                    <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="remove"/>
                        <input type="hidden" name="productId" value="<%= productId %>"/>
                        <button type="submit">Xoá</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>
        <h3>Tổng cộng: <%= tongCong %> VND</h3>
        <p><a href="${pageContext.request.contextPath}/checkout">Tiến hành thanh toán</a></p>
    <%
        }
    %>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
