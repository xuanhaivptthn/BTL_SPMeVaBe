<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>Hoá Đơn Đơn Hàng #${order.id}</title>
        <style>
            tr td {
                border: solid black 1px;
            }
        </style>
    </head>

    <body onload="window.print()">
        <button class="print-btn" onclick="window.print()">In Hoá Đơn</button>
        <div class="invoice-container">
            <div class="header">
                <div class="company-info">
                    <h1>Shop Mẹ và Bé</h1>
                    <p>Địa chỉ:</p>
                    <p>SĐT: - Email: </p>
                </div>
                <div class="invoice-details">
                    <h2>Hoá Đơn</h2>
                    <p><strong>Mã ĐH:</strong> #${order.id}</p>
                    <p><strong>Ngày lập:</strong> ${order.ngayDatFormatted}</p>
                </div>
            </div>

            <div class="customer-info">
                <h3>Thông Tin KH</h3>
                <p><strong>Khách hàng:</strong> ${fn:escapeXml(order.tenNguoiNhan)}</p>
                <p><strong>Số điện thoại:</strong> ${fn:escapeXml(order.sdtNhanHang)}</p>
                <p><strong>Địa chỉ:</strong> ${fn:escapeXml(order.diaChiGiaoHang)}</p>
                <c:if test="${not empty order.ghiChu}">
                    <p><strong>Ghi chú:</strong> ${fn:escapeXml(order.ghiChu)}</p>
                </c:if>
            </div>

            <table style="border: solid 1px black">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên Sản Phẩm</th>
                        <th class="text-center">Số Lượng</th>
                        <th class="text-right">Đơn Giá</th>
                        <th class="text-right">Thành Tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty chiTiet}">
                            <c:forEach var="item" items="${chiTiet}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${fn:escapeXml(item.tenSanPham)}</td>
                                    <td class="text-center">${item.soLuong}</td>
                                    <td class="text-right">
                                        <fmt:formatNumber value="${item.donGia}" pattern="#,###" /> đ
                                    </td>
                                    <td class="text-right"><strong>
                                            <fmt:formatNumber value="${item.soLuong * item.donGia}"
                                                              pattern="#,###" /> đ
                                        </strong></td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="text-center">Không có sản phẩm</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="totals">
                <table style="border: solid black 1px">
                    <tr>
                        <th>Tạm tính:</th>
                        <td class="text-right">
                            <fmt:formatNumber value="${order.tongTien + order.soTienGiam}"
                                              pattern="#,###" /> đ
                        </td>
                    </tr>
                    <c:if test="${not empty order.maGiamGia && order.soTienGiam > 0}">
                        <tr>
                            <th>Khuyến mãi (${order.maGiamGia}):</th>
                            <td class="text-right" style="color: #16a34a;">-
                                <fmt:formatNumber value="${order.soTienGiam}" pattern="#,###" /> đ
                            </td>
                        </tr>
                    </c:if>
                    <tr>
                        <th>Phí giao hàng:</th>
                        <td class="text-right">0 đ</td>
                    </tr>
                    <tr>
                        <th>Thuế GTGT:</th>
                        <td class="text-right">0 đ</td>
                    </tr>
                    <tr class="grand-total">
                        <th>Tổng Thanh Toán:</th>
                        <td class="text-right">
                            <fmt:formatNumber value="${order.tongTien}" pattern="#,###" /> đ
                        </td>
                    </tr>
                </table>
            </div>

            <div class="footer">
                <p>Hoá đơn này có giá trị xác nhận đơn hàng đã thanh toán thành công.</p>
            </div>
        </div>
    </body>

</html>