<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
        .badge-updated {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffe082;
            border-radius: 6px;
            padding: 3px 9px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }
        .badge-updated i {
            font-size: 11px;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <aside class="admin-sidebar">
            <h2>Quản Trị</h2>
            <nav class="admin-nav">
                <a href="${pageContext.request.contextPath}/admin/index.jsp">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/users">Quản lý Người dùng</a>
                <a href="${pageContext.request.contextPath}/admin/products">Quản lý Sản phẩm</a>
                <a href="${pageContext.request.contextPath}/admin/orders">Quản lý Đơn hàng</a>
                <a href="${pageContext.request.contextPath}/">Về trang khách hàng</a>
            </nav>
        </aside>
        <main class="admin-content">
            <div class="admin-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                    <h2 style="margin: 0;">Danh sách Đơn hàng</h2>
                    <a href="${pageContext.request.contextPath}/admin/order_add.jsp" class="btn btn-secondary">Thêm Đơn Hàng Mới</a>
                </div>
                
                <div style="margin-bottom: 20px;">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="get" style="display: flex; gap: 10px;">
                        <input type="text" name="donHangId" value="${fn:escapeXml(searchDonHangId)}" class="form-control" placeholder="Mã đơn hàng" style="max-width: 200px;"/>
                        <input type="text" name="khachHangId" value="${fn:escapeXml(searchKhachHangId)}" class="form-control" placeholder="Mã khách hàng" style="max-width: 200px;"/>
                        <button type="submit" class="btn btn-secondary">Lọc</button>
                        <a href="${pageContext.request.contextPath}/admin/orders" class="btn">Xóa bộ lọc</a>
                    </form>
                </div>
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>Mã ĐH</th>
                            <th>Khách Hàng ID</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
                            <th>Người nhận & SĐT</th>
                            <th>Địa chỉ giao hàng</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td>${o.id}</td>
                                <td>${o.khachHangId}</td>
                                <td>${o.ngayDatFormatted}</td>
                                <td><fmt:formatNumber value="${o.tongTien}" type="number" pattern="#,###"/></td>
                                <td>
                                    <div>${o.tenNguoiNhan}</div>
                                    <div style="color:#888;font-size:13px;">${o.sdtNhanHang}</div>
                                    <c:if test="${o.khachHangDaCapNhat}">
                                        <div style="margin-top:6px;">
                                            <span class="badge-updated">
                                                <i class="fas fa-pen"></i> Khách đã cập nhật thông tin
                                            </span>
                                        </div>
                                    </c:if>
                                </td>
                                <td>${o.diaChiGiaoHang}</td>
                                <td>${o.trangThai}</td>
                                <td>
                                    <div style="display: flex; gap: 10px;">
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:flex; gap:10px;">
                                            <input type="hidden" name="action" value="updateStatus"/>
                                            <input type="hidden" name="id" value="${o.id}"/>
                                            <select name="status" class="form-control" style="width:auto; padding:5px;">
                                                <option value="PENDING" ${o.trangThai == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                                <option value="PROCESSING" ${o.trangThai == 'PROCESSING' ? 'selected' : ''}>PROCESSING</option>
                                                <option value="SHIPPED" ${o.trangThai == 'SHIPPED' ? 'selected' : ''}>SHIPPED</option>
                                                <option value="DELIVERED" ${o.trangThai == 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                                                <option value="CANCELLED" ${o.trangThai == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                            </select>
                                            <button type="submit" class="btn btn-secondary" style="padding: 5px 10px;">Cập nhật</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="post">
                                            <input type="hidden" name="action" value="delete"/>
                                            <input type="hidden" name="id" value="${o.id}"/>
                                            <button type="submit" class="btn" style="background: #d9534f; padding: 5px 10px;" onclick="return confirm('Bạn có chắc muốn xóa đơn hàng này?');">Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
