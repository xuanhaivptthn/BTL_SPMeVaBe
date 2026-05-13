<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${product.tenSanPham}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Include FontAwesome for stars -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="container mt-20">
        <!-- Top Section -->
        <div class="product-detail-top">
            <div class="product-detail-image">
                <c:choose>
                    <c:when test="${not empty product.images}">
                        <c:choose>
                            <c:when test="${fn:startsWith(product.images[0], 'http')}">
                                <img src="${product.images[0]}" alt="${product.tenSanPham}" id="main-image"/>
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${product.images[0]}" alt="${product.tenSanPham}" id="main-image"/>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <div style="width:100%; height:400px; background:#f0f0f0; display:flex; align-items:center; justify-content:center;">(Chưa có ảnh)</div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="product-detail-info">
                <h1 class="product-detail-title">${product.tenSanPham}</h1>
                <div class="product-detail-rating-summary">
                    <span class="stars">
                        <c:forEach begin="1" end="5" var="i">
                            <i class="${i <= averageRating ? 'fa-solid fa-star' : (i - 0.5 <= averageRating ? 'fa-solid fa-star-half-stroke' : 'fa-regular fa-star')}"></i>
                        </c:forEach>
                    </span>
                    <a href="#reviews-section" onclick="showTab('reviews')">(${totalReviews} đánh giá)</a>
                </div>
                <div class="product-detail-price">
                    <fmt:formatNumber value="${product.giaTien}" type="number" pattern="#,###"/> VND
                </div>
                <div class="product-detail-basic-info">
                    <p>${product.thongTinSanPham}</p>
                </div>
                
                <form action="${pageContext.request.contextPath}/cart" method="post" class="product-detail-cart-form">
                    <input type="hidden" name="action" value="add"/>
                    <input type="hidden" name="productId" value="${product.maSanPham}"/>
                    <div class="quantity-selector">
                        <label>Số lượng:</label>
                        <input type="number" name="quantity" value="1" min="1" max="${product.soLuong}" class="form-control" style="width: 80px; display: inline-block;"/>
                        <span class="stock-info">(${product.soLuong} sản phẩm có sẵn)</span>
                    </div>
                    <button type="submit" class="btn btn-large" ${product.soLuong <= 0 ? 'disabled' : ''}>
                        <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                    </button>
                </form>
            </div>
        </div>

        <!-- Suggested Products -->
        <div class="suggested-products mt-20">
            <h3>Sản phẩm gợi ý</h3>
            <div class="product-grid" style="grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));">
                <c:forEach var="p" items="${suggestedProducts}">
                    <div class="product-card">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.maSanPham}">
                            <c:choose>
                                <c:when test="${not empty p.images}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(p.images[0], 'http')}">
                                            <img src="${p.images[0]}" alt="${p.tenSanPham}" class="product-img"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/${p.images[0]}" alt="${p.tenSanPham}" class="product-img"/>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <p>(Chưa có ảnh)</p>
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <h4><a href="${pageContext.request.contextPath}/product-detail?id=${p.maSanPham}" class="product-title-link">${p.tenSanPham}</a></h4>
                        <p class="product-price" style="font-size: 16px;"><fmt:formatNumber value="${p.giaTien}" type="number" pattern="#,###"/> đ</p>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Bottom Tabs/Sections -->
        <div class="product-detail-tabs mt-20">
            <div class="tabs-header">
                <button class="tab-btn active" id="btn-tab-details" onclick="showTab('details')">Chi tiết sản phẩm</button>
                <button class="tab-btn" id="btn-tab-reviews" onclick="showTab('reviews')">Đánh giá (${totalReviews})</button>
            </div>
            
            <div id="tab-details" class="tab-content active">
                <h3>Thông số chi tiết</h3>
                <table class="table-modern detail-table">
                    <tr>
                        <th>Thành phần</th>
                        <td>${not empty product.thanhPhan ? product.thanhPhan : 'Đang cập nhật'}</td>
                    </tr>
                    <tr>
                        <th>Xuất xứ</th>
                        <td>${not empty product.xuatXu ? product.xuatXu : 'Đang cập nhật'}</td>
                    </tr>
                    <tr>
                        <th>Khối lượng/Dung tích</th>
                        <td>${not empty product.khoiLuong ? product.khoiLuong : 'Đang cập nhật'}</td>
                    </tr>
                </table>
                <div class="full-description mt-20">
                    <p>${product.thongTinSanPham}</p>
                </div>
            </div>

            <div id="tab-reviews" class="tab-content">
                <div class="reviews-container" id="reviews-section">
                    <!-- Rating Summary -->
                    <div class="rating-overview">
                        <div class="rating-average">
                            <h2><fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/> / 5</h2>
                            <div class="stars big-stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="${i <= averageRating ? 'fa-solid fa-star' : (i - 0.5 <= averageRating ? 'fa-solid fa-star-half-stroke' : 'fa-regular fa-star')}"></i>
                                </c:forEach>
                            </div>
                            <p>${totalReviews} đánh giá</p>
                        </div>
                        <div class="rating-bars">
                            <c:forEach begin="1" end="5" var="i" step="1">
                                <c:set var="starIdx" value="${6 - i}"/>
                                <c:set var="count" value="${reviewStats[starIdx]}"/>
                                <c:set var="percent" value="${totalReviews > 0 ? (count * 100 / totalReviews) : 0}"/>
                                <div class="rating-bar-row">
                                    <span class="star-label">${6-i} <i class="fa-solid fa-star"></i></span>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar-fill" style="width: ${percent}%"></div>
                                    </div>
                                    <span class="count-label">${count}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Filters -->
                    <div class="review-filters mt-20">
                        <span>Lọc theo:</span>
                        <a href="?id=${product.maSanPham}#reviews-section" class="btn ${empty currentRatingFilter ? 'btn-primary' : 'btn-secondary'} btn-sm">Tất cả</a>
                        <c:forEach begin="1" end="5" var="i">
                            <c:set var="starVal" value="${6-i}"/>
                            <a href="?id=${product.maSanPham}&rating=${starVal}#reviews-section" class="btn ${currentRatingFilter == starVal ? 'btn-primary' : 'btn-secondary'} btn-sm">${starVal} Sao</a>
                        </c:forEach>
                    </div>

                    <!-- Review List -->
                    <div class="review-list mt-20">
                        <c:choose>
                            <c:when test="${empty reviews}">
                                <p>Chưa có đánh giá nào.</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${reviews}">
                                    <div class="review-item">
                                        <div class="review-header">
                                            <strong>${r.hoTen}</strong>
                                            <span class="review-date"><fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                        </div>
                                        <div class="review-stars stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="${i <= r.diemDanhGia ? 'fa-solid fa-star' : 'fa-regular fa-star'}"></i>
                                            </c:forEach>
                                        </div>
                                        <div class="review-body">
                                            <p>${r.binhLuan}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Review Form -->
                    <div class="review-form-container mt-20">
                        <h3>Gửi đánh giá của bạn</h3>
                        <form action="${pageContext.request.contextPath}/submit-review" method="post" class="review-form">
                            <input type="hidden" name="productId" value="${product.maSanPham}"/>
                            
                            <div class="form-group rating-input-group">
                                <label style="display:block; margin-bottom: 5px;">Chọn đánh giá:</label>
                                <div class="rating-input">
                                    <input type="radio" id="star5" name="rating" value="5" required/><label for="star5" title="5 sao"><i class="fa-solid fa-star"></i></label>
                                    <input type="radio" id="star4" name="rating" value="4"/><label for="star4" title="4 sao"><i class="fa-solid fa-star"></i></label>
                                    <input type="radio" id="star3" name="rating" value="3"/><label for="star3" title="3 sao"><i class="fa-solid fa-star"></i></label>
                                    <input type="radio" id="star2" name="rating" value="2"/><label for="star2" title="2 sao"><i class="fa-solid fa-star"></i></label>
                                    <input type="radio" id="star1" name="rating" value="1"/><label for="star1" title="1 sao"><i class="fa-solid fa-star"></i></label>
                                </div>
                            </div>

                            <c:if test="${empty sessionScope.user}">
                                <div class="form-group">
                                    <label>Họ và tên:</label>
                                    <input type="text" name="hoTen" class="form-control" placeholder="Nhập tên của bạn"/>
                                </div>
                            </c:if>

                            <div class="form-group">
                                <label>Nhận xét:</label>
                                <textarea name="comment" class="form-control" rows="4" placeholder="Nhập nhận xét của bạn về sản phẩm này..."></textarea>
                            </div>

                            <div class="form-group" style="margin-bottom: 15px;">
                                <label style="display:flex; align-items:center; gap:8px; cursor:pointer;">
                                    <input type="checkbox" name="isAnonymous"> Ẩn tên đầy đủ khi đánh giá
                                </label>
                            </div>

                            <button type="submit" class="btn">Gửi đánh giá</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="components/footer.jsp" />

    <script>
        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
            
            document.getElementById('tab-' + tabId).classList.add('active');
            document.getElementById('btn-tab-' + tabId).classList.add('active');
        }
        
        // Auto-select reviews tab if URL contains #reviews-section
        if (window.location.hash === '#reviews-section' || window.location.search.includes('rating=')) {
            showTab('reviews');
        }
    </script>
</body>
</html>
