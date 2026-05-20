<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="dao.SanPhamDAO" %>
<%@ page import="dao.DanhMucDAO" %>
<%@ page import="model.SanPham" %>
<%@ page import="model.DanhMuc" %>
<%@ page import="java.util.List" %>

<%
    DanhMucDAO danhMucDAO = new DanhMucDAO();
    SanPhamDAO sanPhamDAO = new SanPhamDAO();
    
    List<DanhMuc> listDanhMuc = danhMucDAO.getAll();
    List<SanPham> listNew = sanPhamDAO.getNewProducts(4);
    List<SanPham> listFeatured = sanPhamDAO.getFeaturedProducts(4);
    
    request.setAttribute("listDanhMuc", listDanhMuc);
    request.setAttribute("listNew", listNew);
    request.setAttribute("listFeatured", listFeatured);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Cửa Hàng Mẹ & Bé</title>
</head>
<body>
    <%@include file="components/header.jsp" %>

    <!-- Hero Banner Section -->
    <div class="hero-banner">
        <h2>Chào mừng đến với <span>Cửa Hàng Mẹ và Bé</span></h2>
        <p>Chuyên cung cấp các sản phẩm chất lượng, an toàn tuyệt đối và chăm sóc trọn vẹn cho mẹ bầu cùng bé yêu của bạn.</p>
        <a href="${pageContext.request.contextPath}/products" class="btn" style="font-size: 18px; padding: 15px 30px; border-radius: 30px;">Xem sản phẩm ngay</a>
    </div>

    <!-- Categories Section -->
    <div class="homepage-section">
        <h3 class="section-title">Danh Mục Nổi Bật</h3>
        <div class="categories-grid">
            <c:forEach var="cat" items="${listDanhMuc}">
                <a href="${pageContext.request.contextPath}/products?category=${cat.id}" class="category-card-link">
                    <div class="category-card">
                        <div class="category-icon-wrapper cat-color-${cat.id}">
                            <c:choose>
                                <c:when test="${cat.id == 1}"><i class="fa-solid fa-baby-carriage"></i></c:when>
                                <c:when test="${cat.id == 2}"><i class="fa-solid fa-cow"></i></c:when>
                                <c:when test="${cat.id == 3}"><i class="fa-solid fa-bowl-food"></i></c:when>
                                <c:when test="${cat.id == 4}"><i class="fa-solid fa-toilet-paper"></i></c:when>
                                <c:when test="${cat.id == 5}"><i class="fa-solid fa-prescription-bottle"></i></c:when>
                                <c:when test="${cat.id == 6}"><i class="fa-solid fa-shirt"></i></c:when>
                                <c:when test="${cat.id == 7}"><i class="fa-solid fa-socks"></i></c:when>
                                <c:when test="${cat.id == 8}"><i class="fa-solid fa-capsules"></i></c:when>
                                <c:when test="${cat.id == 9}"><i class="fa-solid fa-basket-shopping"></i></c:when>
                                <c:when test="${cat.id == 10}"><i class="fa-solid fa-soap"></i></c:when>
                                <c:when test="${cat.id == 11}"><i class="fa-solid fa-puzzle-piece"></i></c:when>
                                <c:otherwise><i class="fa-solid fa-gift"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <h4><c:out value="${cat.tenDanhMuc}"/></h4>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>

    <!-- New Products Section -->
    <div class="homepage-section">
        <h3 class="section-title">Sản Phẩm Mới Về</h3>
        <div class="product-grid">
            <c:forEach var="p" items="${listNew}">
                <div class="product-card-wrapper">
                    <span class="card-badge badge-new">Mới</span>
                    <a href="${pageContext.request.contextPath}/product-detail?id=${p.maSanPham}" class="product-card-link">
                        <div class="product-card">
                            <c:choose>
                                <c:when test="${not empty p.hinhAnh}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(p.hinhAnh, 'http')}">
                                            <img src="${p.hinhAnh}" alt="${p.tenSanPham}" class="product-img"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/${p.hinhAnh}" alt="${p.tenSanPham}" class="product-img"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="product-img" style="display:flex; align-items:center; justify-content:center; background:#f7f7f7; border-radius:var(--radius);">
                                        <span style="color:#aaa; font-size:14px;">Chưa có ảnh</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <h3><c:out value="${p.tenSanPham}"/></h3>
                            <p class="product-price"><fmt:formatNumber value="${p.giaTien}" type="number" pattern="#,###"/> VND</p>
                            <c:choose>
                                <c:when test="${p.soLuong <= 0}">
                                    <span class="badge-out-of-stock">Hết hàng</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="btn btn-sm" style="margin-top: 8px; width: 100%;">Xem chi tiết</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Featured Products Section -->
    <div class="homepage-section">
        <h3 class="section-title">Sản Phẩm Nổi Bật</h3>
        <div class="product-grid">
            <c:forEach var="p" items="${listFeatured}">
                <div class="product-card-wrapper">
                    <span class="card-badge badge-featured">Nổi bật</span>
                    <a href="${pageContext.request.contextPath}/product-detail?id=${p.maSanPham}" class="product-card-link">
                        <div class="product-card">
                            <c:choose>
                                <c:when test="${not empty p.hinhAnh}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(p.hinhAnh, 'http')}">
                                            <img src="${p.hinhAnh}" alt="${p.tenSanPham}" class="product-img"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/${p.hinhAnh}" alt="${p.tenSanPham}" class="product-img"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="product-img" style="display:flex; align-items:center; justify-content:center; background:#f7f7f7; border-radius:var(--radius);">
                                        <span style="color:#aaa; font-size:14px;">Chưa có ảnh</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <h3><c:out value="${p.tenSanPham}"/></h3>
                            <p class="product-price"><fmt:formatNumber value="${p.giaTien}" type="number" pattern="#,###"/> VND</p>
                            <c:choose>
                                <c:when test="${p.soLuong <= 0}">
                                    <span class="badge-out-of-stock">Hết hàng</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="btn btn-sm" style="margin-top: 8px; width: 100%;">Xem chi tiết</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
