<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <h2>Thông tin thanh toán</h2>
    
    <div style="margin-bottom: 20px;">
        <h3>Địa chỉ đã lưu</h3>
        <c:if test="${not empty listDiaChi}">
            <select id="savedAddresses" style="width: 300px; padding: 5px;" onchange="fillAddress(this)">
                <option value="">-- Chọn địa chỉ --</option>
                <c:forEach var="dc" items="${listDiaChi}">
                    <option value="${dc.id}" 
                            data-ten="${dc.tenNguoiNhan}"
                            data-sdt="${dc.soDienThoai}"
                            data-diachi="${dc.diaChi}"
                            ${dc.isDefault() ? 'selected' : ''}>
                        ${dc.tenNguoiNhan} - ${dc.soDienThoai} - ${dc.diaChi}
                    </option>
                </c:forEach>
            </select>
        </c:if>
        <c:if test="${empty listDiaChi}">
            <p>Bạn chưa có địa chỉ nào lưu.</p>
        </c:if>
    </div>

    <form action="${pageContext.request.contextPath}/checkout" method="post" class="form">
        <div class="form-group">
            <label>Tên người nhận:</label><br/>
            <input type="text" id="tenNguoiNhan" name="tenNguoiNhan" class="form-control" required style="width: 300px;"/>
        </div>
        <br/>
        <div class="form-group">
            <label>Số điện thoại:</label><br/>
            <input type="text" id="sdtNhanHang" name="sdtNhanHang" class="form-control" required style="width: 300px;"/>
        </div>
        <br/>
        <div class="form-group">
            <label>Địa chỉ giao hàng:</label><br/>
            <input type="text" id="diaChiGiaoHang" name="diaChiGiaoHang" class="form-control" required style="width: 300px;"/>
        </div>
        <br/>
        <div class="form-group">
            <label>Ghi chú đơn hàng:</label><br/>
            <textarea name="ghiChu" class="form-control" rows="4" style="width: 300px;"></textarea>
        </div>
        <br/>
        <button type="submit" class="btn">Xác nhận đặt hàng</button>
    </form>

    <script>
        function fillAddress(select) {
            var option = select.options[select.selectedIndex];
            if (option.value !== "") {
                document.getElementById('tenNguoiNhan').value = option.getAttribute('data-ten');
                document.getElementById('sdtNhanHang').value = option.getAttribute('data-sdt');
                document.getElementById('diaChiGiaoHang').value = option.getAttribute('data-diachi');
            } else {
                document.getElementById('tenNguoiNhan').value = "";
                document.getElementById('sdtNhanHang').value = "";
                document.getElementById('diaChiGiaoHang').value = "";
            }
        }
        
        // Init if default exists
        window.onload = function() {
            var select = document.getElementById("savedAddresses");
            if (select && select.value !== "") {
                fillAddress(select);
            }
        };
    </script>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
