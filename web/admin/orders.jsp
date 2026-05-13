<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
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
                <table class="table-modern">
                    <thead>
                        <tr>
                            <th>Mã ĐH</th>
                            <th>Khách Hàng ID</th>
                            <th>Ngày đặt</th>
                            <th>Tổng tiền</th>
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
                                <td>${o.tongTien}</td>
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
