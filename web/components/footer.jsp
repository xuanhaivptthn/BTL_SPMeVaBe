<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
</div> <!-- end container -->

<style>
/* Chèn trực tiếp CSS để tránh cache trình duyệt */
html, body {
    margin: 0 !important;
    padding: 0 !important;
}

body {
    display: flex !important;
    flex-direction: column !important;
    min-height: 100vh !important;
}

body > .container {
    flex: 1 0 auto !important;
    width: 100% !important;
    box-sizing: border-box !important;
}

.footer {
    background-color: #fcf8f9 !important;
    border-top: 1px solid var(--border-color) !important;
    padding: 60px 0 20px !important;
    margin-top: 60px !important;
    color: #555 !important;
    font-size: 15px !important;
    text-align: left !important;
    flex-shrink: 0 !important;
}

.footer-container {
    max-width: var(--max-width);
    margin: 0 auto;
    padding: 0 20px;
    display: grid !important;
    grid-template-columns: 2fr 1fr 1.5fr !important;
    gap: 40px !important;
}

.footer-col {
    display: block !important;
    text-align: left !important;
}

.footer-col h3 {
    font-size: 18px !important;
    font-weight: 700 !important;
    margin-bottom: 20px !important;
    color: var(--text-color) !important;
    position: relative !important;
    padding-bottom: 10px !important;
    margin-top: 0 !important;
}

.footer-col h3::after {
    content: '' !important;
    position: absolute !important;
    left: 0 !important;
    bottom: 0 !important;
    width: 40px !important;
    height: 3px !important;
    background-color: var(--primary-color) !important;
    border-radius: 2px !important;
}

.footer-col .footer-tagline {
    line-height: 1.8 !important;
    margin-bottom: 20px !important;
    color: #666 !important;
}

.footer-socials {
    display: flex !important;
    gap: 12px !important;
}

.footer-socials a {
    display: flex !important;
    align-items: center !important;
    justify-content: center !important;
    width: 36px !important;
    height: 36px !important;
    border-radius: 50% !important;
    background-color: #fff !important;
    border: 1px solid var(--border-color) !important;
    color: var(--text-color) !important;
}

.footer-socials a:hover {
    background-color: var(--primary-color) !important;
    color: #fff !important;
    border-color: var(--primary-color) !important;
}

.footer-links {
    list-style: none !important;
    padding: 0 !important;
}

.footer-links li {
    margin-bottom: 12px !important;
}

.footer-links a {
    color: #555 !important;
    display: inline-block !important;
    text-decoration: none !important;
}

.footer-links a:hover {
    color: var(--primary-color) !important;
}

.footer-contact p {
    margin-bottom: 15px !important;
    display: flex !important;
    align-items: flex-start !important;
    gap: 10px !important;
    line-height: 1.5 !important;
}

.footer-contact p i {
    color: var(--primary-color) !important;
    margin-top: 4px !important;
    width: 16px !important;
    text-align: center !important;
}

.footer-contact a {
    color: inherit !important;
    text-decoration: none !important;
}

.footer-contact a:hover {
    color: var(--primary-color) !important;
}

.footer-bottom {
    max-width: var(--max-width);
    margin: 40px auto 0 !important;
    padding: 20px 20px 0 !important;
    border-top: 1px solid var(--border-color) !important;
    text-align: center !important;
    color: #888 !important;
    font-size: 14px !important;
}

/* Responsive Footer */
@media (max-width: 768px) {
    .footer-container {
        grid-template-columns: 1fr !important;
        gap: 30px !important;
    }
}
</style>

<footer class="footer">
    <div class="footer-container">
        <!-- Cột 1: Giới thiệu cửa hàng -->
        <div class="footer-col">
            <h3 class="footer-logo">Cửa Hàng Mẹ & Bé</h3>
            <p class="footer-tagline">Hành trình tuyệt vời nhất của mẹ là đồng hành cùng bé yêu lớn khôn mỗi ngày. Chúng tôi cam kết mang lại sản phẩm an toàn, chất lượng và tốt nhất cho bé.</p>
            <div class="footer-socials">
                <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                <a href="#" aria-label="Youtube"><i class="fab fa-youtube"></i></a>
                <a href="#" aria-label="Tiktok"><i class="fab fa-tiktok"></i></a>
            </div>
        </div>
        
        <!-- Cột 2: Liên kết nhanh -->
        <div class="footer-col">
            <h3>Liên Kết Nhanh</h3>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-chevron-right" style="font-size: 11px; margin-right: 5px;"></i> Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/products"><i class="fas fa-chevron-right" style="font-size: 11px; margin-right: 5px;"></i> Sản phẩm</a></li>
                <li><a href="${pageContext.request.contextPath}/cart"><i class="fas fa-chevron-right" style="font-size: 11px; margin-right: 5px;"></i> Giỏ hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/history"><i class="fas fa-chevron-right" style="font-size: 11px; margin-right: 5px;"></i> Lịch sử mua hàng</a></li>
                <li><a href="${pageContext.request.contextPath}/contact"><i class="fas fa-chevron-right" style="font-size: 11px; margin-right: 5px;"></i> Liên hệ</a></li>
            </ul>
        </div>
        
        <!-- Cột 3: Thông tin liên hệ -->
        <div class="footer-col footer-contact">
            <h3>Thông Tin Liên Hệ</h3>
            <p><i class="fas fa-map-marker-alt"></i> 123 Đường Cầu Giấy, Quận Cầu Giấy, Hà Nội</p>
            <p><i class="fas fa-phone-alt"></i> Hotline: <a href="tel:19001234">1900 1234</a> - <a href="tel:0987654321">0987 654 321</a></p>
            <p><i class="fas fa-envelope"></i> Email: <a href="mailto:support@mevabe.vn">support@mevabe.vn</a></p>
            <p><i class="fas fa-clock"></i> Giờ mở cửa: 8:00 - 22:00 (Hằng ngày)</p>
        </div>
    </div>
    <div class="footer-bottom">
        <p>&copy; 2026 Cửa hàng Mẹ và Bé. Mọi quyền được bảo lưu.</p>
    </div>
</footer>

<!-- Tích hợp Chatbox tư vấn hỗ trợ khách hàng -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/chatbox.js" defer></script>

