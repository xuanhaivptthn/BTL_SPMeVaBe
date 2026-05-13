<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="products-layout">
        <!-- Sidebar for Filters -->
        <aside class="products-sidebar">
            <form action="products" method="GET">
                <div class="filter-group">
                    <h3>Tìm kiếm</h3>
                    <input type="text" name="search" class="form-control" placeholder="Tìm sản phẩm..." value="${param.search}">
                </div>

                <div class="filter-group">
                    <h3>Danh mục</h3>
                    <ul class="filter-list">
                        <li><label><input type="checkbox" name="category" value="1" ${selectedCategories.contains('1') ? 'checked' : ''}> Mẹ bầu và sau sinh</label></li>
                        <li><label><input type="checkbox" name="category" value="2" ${selectedCategories.contains('2') ? 'checked' : ''}> Sữa cho bé</label></li>
                        <li><label><input type="checkbox" name="category" value="3" ${selectedCategories.contains('3') ? 'checked' : ''}> Bé ăn dặm</label></li>
                        <li><label><input type="checkbox" name="category" value="4" ${selectedCategories.contains('4') ? 'checked' : ''}> Bỉm tã và vệ sinh</label></li>
                        <li><label><input type="checkbox" name="category" value="5" ${selectedCategories.contains('5') ? 'checked' : ''}> Bình sữa và phụ kiện</label></li>
                        <li><label><input type="checkbox" name="category" value="6" ${selectedCategories.contains('6') ? 'checked' : ''}> Đồ sơ sinh</label></li>
                        <li><label><input type="checkbox" name="category" value="7" ${selectedCategories.contains('7') ? 'checked' : ''}> Thời trang và phụ kiện</label></li>
                    </ul>
                </div>

                <div class="filter-group">
                    <h3>Thương hiệu</h3>
                    <ul class="filter-list">
                        <li><label><input type="checkbox" name="brand" value="morinaga" ${selectedBrands.contains('morinaga') ? 'checked' : ''}> Morinaga</label></li>
                        <li><label><input type="checkbox" name="brand" value="meiji" ${selectedBrands.contains('meiji') ? 'checked' : ''}> Meiji</label></li>
                        <li><label><input type="checkbox" name="brand" value="pigeon" ${selectedBrands.contains('pigeon') ? 'checked' : ''}> Pigeon</label></li>
                    </ul>
                </div>

                <button type="submit" class="btn" style="width: 100%;">Lọc sản phẩm</button>
            </form>
        </aside>

        <!-- Main Content -->
        <main class="products-main">
            <div class="products-header">
                <h2>Danh sách sản phẩm</h2>
                <div class="products-sort">
                    <form action="products" method="GET" id="sortForm">
                        <input type="hidden" name="search" value="${param.search}">
                        <c:if test="${not empty paramValues.category}">
                            <c:forEach var="cat" items="${paramValues.category}">
                                <input type="hidden" name="category" value="${cat}">
                            </c:forEach>
                        </c:if>
                        <c:if test="${not empty paramValues.brand}">
                            <c:forEach var="br" items="${paramValues.brand}">
                                <input type="hidden" name="brand" value="${br}">
                            </c:forEach>
                        </c:if>
                        <label>Sắp xếp:</label>
                        <select name="sort" class="form-control" style="width: auto; display: inline-block;" onchange="document.getElementById('sortForm').submit();">
                            <option value="default" ${param.sort == 'default' ? 'selected' : ''}>Mặc định</option>
                            <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá tăng dần</option>
                            <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
                        </select>
                    </form>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty products}">
                    <p>Không có sản phẩm nào phù hợp.</p>
                </c:when>
                <c:otherwise>
                    <div class="product-grid">
                        <c:forEach var="p" items="${products}">
                            <div class="product-card">
                                <c:choose>
                                    <c:when test="${not empty p.images}">
                                        <c:forEach var="img" items="${p.images}" begin="0" end="0">
                                            <c:choose>
                                                <c:when test="${fn:startsWith(img, 'http')}">
                                                    <img src="${img}" alt="${p.tenSanPham}" class="product-img"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/${img}" alt="${p.tenSanPham}" class="product-img"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p>(Chưa có ảnh)</p>
                                    </c:otherwise>
                                </c:choose>
                                <h3><c:out value="${p.tenSanPham}"/></h3>
                                <p class="product-price"><fmt:formatNumber value="${p.giaTien}" type="number" pattern="#,###"/> VND</p>
                                <form action="${pageContext.request.contextPath}/cart" method="post">
                                    <input type="hidden" name="action" value="add"/>
                                    <input type="hidden" name="productId" value="${p.maSanPham}"/>
                                    <div class="form-group">
                                        Số lượng: <input type="number" name="quantity" value="1" min="1" max="${p.soLuong}" class="form-control" style="width: 80px; display: inline-block;"/>
                                    </div>
                                    <button type="submit" class="btn">Thêm vào giỏ hàng</button>
                                </form>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
