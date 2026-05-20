<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử mua hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .history-wrap {
            max-width: 1000px;
            margin: 0 auto 60px;
            padding: 0 20px;
        }

        .history-wrap h2 {
            font-size: 26px;
            color: #2c3e50;
            margin-bottom: 6px;
        }

        .history-subtitle {
            color: #888;
            margin-bottom: 28px;
            font-size: 15px;
        }

        .history-empty {
            text-align: center;
            padding: 80px 20px;
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            color: #aaa;
        }

        .history-empty i {
            font-size: 52px;
            color: #e0e0e0;
            margin-bottom: 16px;
            display: block;
        }

        .history-empty p {
            font-size: 18px;
            margin-bottom: 20px;
        }

        .table-history {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            box-shadow: 0 2px 10px rgba(0,0,0,0.04);
        }

        .table-history thead th {
            background: #f8f9ff;
            padding: 14px 18px;
            text-align: left;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #999;
            border-bottom: 1px solid #eee;
        }

        .table-history tbody tr {
            transition: background 0.15s;
            cursor: pointer;
        }

        .table-history tbody tr:hover {
            background: #fff5f8;
        }

        .table-history tbody td {
            padding: 15px 18px;
            border-bottom: 1px solid #f4f4f4;
            font-size: 15px;
            color: #444;
            vertical-align: middle;
        }

        .table-history tbody tr:last-child td {
            border-bottom: none;
        }

        /* Status badge */
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            white-space: nowrap;
        }
        .status-PENDING    { background: #fff3cd; color: #856404; }
        .status-PROCESSING { background: #cfe2ff; color: #0a58ca; }
        .status-SHIPPED    { background: #d1ecf1; color: #0c5460; }
        .status-DELIVERED  { background: #d4edda; color: #155724; }
        .status-CANCELLED  { background: #f8d7da; color: #721c24; }

        .btn-view-detail {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 8px;
            background: var(--primary-color);
            color: #fff;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: background 0.2s, transform 0.1s;
            white-space: nowrap;
        }

        .btn-view-detail:hover {
            background: var(--primary-hover);
            color: #fff;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="history-wrap">
        <h2>Lịch sử mua hàng</h2>
        <p class="history-subtitle">Bấm vào <strong>Xem chi tiết</strong> để xem thông tin đơn hàng và cập nhật thông tin giao hàng.</p>

        <c:choose>
            <c:when test="${empty history}">
                <div class="history-empty">
                    <i class="fas fa-shopping-bag"></i>
                    <p>Bạn chưa có đơn hàng nào.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn">Mua sắm ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <table class="table-history">
                    <thead>
                        <tr>
                            <th>Mã ĐH</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Người nhận</th>
                            <th>Địa chỉ giao hàng</th>
                            <th>Trạng thái</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="dh" items="${history}">
                            <tr onclick="location.href='${pageContext.request.contextPath}/history?orderId=${dh.id}'">
                                <td><strong>#${dh.id}</strong></td>
                                <td>${dh.ngayDatFormatted}</td>
                                <td><strong style="color:var(--primary-color);"><fmt:formatNumber value="${dh.tongTien}" type="number" pattern="#,###"/> VND</strong></td>
                                <td>${dh.tenNguoiNhan}</td>
                                <td>${dh.diaChiGiaoHang}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${dh.trangThai == 'PENDING'}">
                                            <span class="status-badge status-PENDING">Đang chờ xử lý</span>
                                        </c:when>
                                        <c:when test="${dh.trangThai == 'PROCESSING'}">
                                            <span class="status-badge status-PROCESSING">Đang xử lý</span>
                                        </c:when>
                                        <c:when test="${dh.trangThai == 'SHIPPED'}">
                                            <span class="status-badge status-SHIPPED">Đang giao</span>
                                        </c:when>
                                        <c:when test="${dh.trangThai == 'DELIVERED'}">
                                            <span class="status-badge status-DELIVERED">Đã giao</span>
                                        </c:when>
                                        <c:when test="${dh.trangThai == 'CANCELLED'}">
                                            <span class="status-badge status-CANCELLED">Đã huỷ</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">${dh.trangThai}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/history?orderId=${dh.id}"
                                       class="btn-view-detail"
                                       onclick="event.stopPropagation();">
                                        <i class="fas fa-eye"></i> Xem chi tiết
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
