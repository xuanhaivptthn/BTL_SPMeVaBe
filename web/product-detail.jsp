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
                    <c:when test="${not empty product.hinhAnh}">
                        <c:choose>
                            <c:when test="${fn:startsWith(product.hinhAnh, 'http')}">
                                <img src="${product.hinhAnh}" alt="${product.tenSanPham}" id="main-image"/>
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${product.hinhAnh}" alt="${product.tenSanPham}" id="main-image"/>
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
                
                <c:choose>
                    <c:when test="${product.soLuong > 0}">
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="product-detail-cart-form">
                            <input type="hidden" name="action" value="add"/>
                            <input type="hidden" name="productId" value="${product.maSanPham}"/>
                            <div class="quantity-selector">
                                <label>Số lượng:</label>
                                <input type="number" name="quantity" value="1" min="1" max="${product.soLuong}" class="form-control" style="width: 80px; display: inline-block;"/>
                                <span class="stock-info">(${product.soLuong} sản phẩm có sẵn)</span>
                            </div>
                            <button type="submit" class="btn btn-large">
                                <i class="fa-solid fa-cart-plus"></i> Thêm vào giỏ hàng
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="out-of-stock-block">
                            <p class="alert-error">Sản phẩm hiện đang hết hàng.</p>
                            <c:if test="${not empty sessionScope.subscribeMessage}">
                                <p class="alert-success">${sessionScope.subscribeMessage}</p>
                                <c:remove var="subscribeMessage" scope="session" />
                            </c:if>
                            <form action="${pageContext.request.contextPath}/subscribe-back-in-stock" method="post" class="subscribe-form">
                                <input type="hidden" name="productId" value="${product.maSanPham}" />
                                <div class="form-group">
                                    <label>Nhập email để nhận thông báo khi có hàng:</label>
                                    <input type="email" name="email" class="form-control" placeholder="you@example.com" required />
                                </div>
                                <button type="submit" class="btn">Đăng ký nhận thông báo</button>
                            </form>
                        </div>
                    </c:otherwise>
                </c:choose>
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
                                            <c:if test="${not empty r.anhDanhGia}">
                                                <div class="review-image-wrap">
                                                    <img src="${pageContext.request.contextPath}/${r.anhDanhGia}"
                                                         alt="Ảnh đánh giá"
                                                         class="review-img-thumb"
                                                         onclick="openReviewImg(this.src)"/>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Review Form -->
                    <div class="review-form-container mt-20">
                        <h3>Gửi đánh giá của bạn</h3>

                        <%-- Server-side upload error messages --%>
                        <c:if test="${param.uploadError == 'not_image'}">
                            <div class="review-img-warning" style="margin-bottom:14px;">
                                <i class="fa-solid fa-triangle-exclamation"></i>
                                <span>File bạn tải lên không phải định dạng hình ảnh. Vui lòng chọn lại file hình ảnh (JPG, PNG, GIF, WEBP, BMP…).</span>
                            </div>
                        </c:if>
                        <c:if test="${param.uploadError == 'too_large'}">
                            <div class="review-img-warning" style="margin-bottom:14px;">
                                <i class="fa-solid fa-triangle-exclamation"></i>
                                <span>File ảnh vượt quá giới hạn 5 MB. Vui lòng chọn ảnh có kích thước nhỏ hơn.</span>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/submit-review" method="post" enctype="multipart/form-data" class="review-form">
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
                                <label>Ảnh đính kèm <span style="font-weight:400; color:#888;">(không bắt buộc – chỉ file hình ảnh, tối đa 5 MB)</span>:</label>
                                <div class="review-upload-area" id="reviewUploadArea" onclick="document.getElementById('reviewImageInput').click()">
                                    <i class="fa-solid fa-camera" style="font-size:28px; color:#aaa;"></i>
                                    <p id="reviewUploadHint" style="margin:6px 0 0; color:#888; font-size:13px;">Nhấn hoặc kéo thả để chọn ảnh</p>
                                    <img id="reviewImgPreview" src="#" alt="Preview" style="display:none; max-height:180px; max-width:100%; margin-top:10px; border-radius:8px; object-fit:cover;"/>
                                </div>
                                <!-- Warning message -->
                                <div id="reviewImgWarning" class="review-img-warning" style="display:none;">
                                    <i class="fa-solid fa-triangle-exclamation"></i>
                                    <span id="reviewImgWarningText"></span>
                                </div>
                                <input type="file" id="reviewImageInput" name="reviewImage"
                                       accept="*/*"
                                       style="display:none;"
                                       onchange="previewReviewImage(event)"/>
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

    <!-- Lightbox overlay for review images -->
    <div id="reviewImgOverlay" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.75); z-index:9999; align-items:center; justify-content:center; cursor:zoom-out;" onclick="closeReviewImg()">
        <img id="reviewImgFull" src="" alt="Ảnh đánh giá" style="max-width:90vw; max-height:90vh; border-radius:10px; box-shadow:0 8px 40px rgba(0,0,0,.6);"/>
    </div>

    <style>
        .review-upload-area {
            border: 2px dashed #d1d5db;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: border-color .2s, background .2s;
            background: #fafafa;
        }
        .review-upload-area:hover {
            border-color: var(--primary, #e07b9a);
            background: #fff5f8;
        }
        .review-upload-area.upload-error {
            border-color: #ef4444;
            background: #fff5f5;
        }
        .review-upload-area.upload-ok {
            border-color: #22c55e;
            background: #f0fff4;
        }
        .review-img-warning {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 8px;
            padding: 10px 14px;
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 8px;
            color: #856404;
            font-size: 13px;
            font-weight: 500;
        }
        .review-img-warning i {
            color: #d97706;
            flex-shrink: 0;
        }
        .review-img-thumb {
            max-width: 220px;
            max-height: 160px;
            border-radius: 8px;
            object-fit: cover;
            margin-top: 8px;
            cursor: zoom-in;
            border: 1px solid #e5e7eb;
            transition: transform .2s;
        }
        .review-img-thumb:hover {
            transform: scale(1.04);
        }
        .review-image-wrap {
            margin-top: 8px;
        }
    </style>

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

        const MAX_SIZE_MB = 5;
        const MAX_SIZE_BYTES = MAX_SIZE_MB * 1024 * 1024;

        function showUploadWarning(msg) {
            const box  = document.getElementById('reviewImgWarning');
            const txt  = document.getElementById('reviewImgWarningText');
            const area = document.getElementById('reviewUploadArea');
            txt.textContent = msg;
            box.style.display  = 'flex';
            area.classList.remove('upload-ok');
            area.classList.add('upload-error');
        }

        function clearUploadWarning() {
            const box  = document.getElementById('reviewImgWarning');
            const area = document.getElementById('reviewUploadArea');
            box.style.display = 'none';
            area.classList.remove('upload-error');
        }

        function previewReviewImage(event) {
            const input   = event.target;
            const file    = input.files[0];
            const preview = document.getElementById('reviewImgPreview');
            const hint    = document.getElementById('reviewUploadHint');
            const area    = document.getElementById('reviewUploadArea');

            // Reset state
            preview.style.display = 'none';
            preview.src = '#';
            clearUploadWarning();
            area.classList.remove('upload-ok');

            if (!file) {
                hint.textContent = 'Nhấn hoặc kéo thả để chọn ảnh';
                return;
            }

            // --- Validation ---
            const isImage = file.type.startsWith('image/');
            const tooBig  = file.size > MAX_SIZE_BYTES;
            const sizeMB  = (file.size / (1024 * 1024)).toFixed(2);

            if (!isImage && tooBig) {
                showUploadWarning(
                    'File "' + file.name + '" không phải hình ảnh và vượt quá ' + MAX_SIZE_MB + ' MB (' + sizeMB + ' MB). Vui lòng chọn lại.'
                );
                input.value = '';
                hint.textContent = 'Nhấn hoặc kéo thả để chọn ảnh';
                return;
            }
            if (!isImage) {
                showUploadWarning(
                    'File "' + file.name + '" không phải định dạng hình ảnh (MIME: ' + (file.type || 'không xác định') + '). Vui lòng chọn file hình ảnh.'
                );
                input.value = '';
                hint.textContent = 'Nhấn hoặc kéo thả để chọn ảnh';
                return;
            }
            if (tooBig) {
                showUploadWarning(
                    'File "' + file.name + '" quá lớn (' + sizeMB + ' MB). Giới hạn tối đa là ' + MAX_SIZE_MB + ' MB.'
                );
                input.value = '';
                hint.textContent = 'Nhấn hoặc kéo thả để chọn ảnh';
                return;
            }

            // --- Valid: show preview ---
            area.classList.add('upload-ok');
            hint.textContent = file.name + ' (' + sizeMB + ' MB)';
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        }

        // Block form submit if invalid file still attached (safety net)
        document.querySelector('.review-form').addEventListener('submit', function(e) {
            const input = document.getElementById('reviewImageInput');
            const warning = document.getElementById('reviewImgWarning');
            if (input.files.length > 0 && warning.style.display !== 'none') {
                e.preventDefault();
                warning.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        });

        function openReviewImg(src) {
            const overlay = document.getElementById('reviewImgOverlay');
            document.getElementById('reviewImgFull').src = src;
            overlay.style.display = 'flex';
        }

        function closeReviewImg() {
            document.getElementById('reviewImgOverlay').style.display = 'none';
        }
    </script>
</body>
</html>
