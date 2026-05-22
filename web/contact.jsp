<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Liên hệ nhóm phát triển - Cửa Hàng Mẹ & Bé</title>
            <!-- Thư viện FontAwesome -->
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                /* CSS tuỳ biến cho trang Liên hệ riêng biệt - 2 Columns Solid Style */
                .contact-hero {
                    text-align: center;
                    padding: 45px 20px;
                    background-color: #fff4f6;
                    /* Solid soft pink background */
                    border-radius: 16px;
                    margin-bottom: 40px;
                    border: 1px solid rgba(255, 133, 162, 0.2);
                    box-shadow: var(--shadow-sm);
                }

                .contact-hero h2 {
                    font-size: 30px;
                    color: #2c3e50;
                    margin-bottom: 10px;
                    font-weight: 700;
                }

                .contact-hero h2 span {
                    color: var(--primary-color);
                }

                .contact-hero p {
                    font-size: 15px;
                    color: #666;
                    max-width: 650px;
                    margin: 0 auto;
                    line-height: 1.6;
                }

                /* 2 Columns Layout Grid */
                .contact-main-layout {
                    display: grid;
                    grid-template-columns: 1.1fr 1fr;
                    gap: 40px;
                    max-width: var(--max-width);
                    margin: 0 auto 50px;
                    align-items: start;
                }

                @media (max-width: 850px) {
                    .contact-main-layout {
                        grid-template-columns: 1fr;
                        gap: 30px;
                    }
                }

                /* Cột bên trái: Biểu mẫu liên hệ */
                .contact-form-card {
                    /* background-color: #ffffff;
                    /* border: 1px solid var(--border-color); */
                    /* border-radius: 16px; */
                    /* padding: 35px; */
                    /* box-shadow: var(--shadow-sm); */
                }

                .contact-form-card h3 {
                    /* margin-bottom: 25px; */
                    color: #2c3e50;
                    font-size: 22px;
                    font-weight: 700;
                    position: relative;
                    /* padding-bottom: 8px; */
                }

                .contact-form-card h3::after {
                    content: '';
                    display: block;
                    width: 40px;
                    height: 3px;
                    background-color: var(--primary-color);
                    margin-top: 6px;
                    border-radius: 2px;
                }

                /* Cột bên phải: Thành viên nhóm */
                .team-column-container h3 {
                    color: #2c3e50;
                    font-size: 22px;
                    font-weight: 700;
                    position: relative;
                }

                .team-column-container h3::after {
                    content: '';
                    display: block;
                    width: 40px;
                    height: 3px;
                    background-color: var(--secondary-color);
                    margin-top: 6px;
                    border-radius: 2px;
                }

                .team-list {
                    display: flex;
                    flex-direction: column;
                    gap: 25px;
                }

                .team-card {
                    background-color: #ffffff;
                    border: 1px solid var(--border-color);
                    border-radius: 16px;
                    padding: 25px;
                    transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.02);
                    position: relative;
                    overflow: hidden;
                    display: flex;
                    gap: 20px;
                    align-items: center;
                }

                @media (max-width: 480px) {
                    .team-card {
                        flex-direction: column;
                        text-align: center;
                        padding: 25px 15px;
                    }
                }

                .member-details {
                    flex: 1;
                }

                .member-name {
                    font-size: 18px;
                    font-weight: 700;
                    color: #2c3e50;
                    margin-bottom: 4px;
                }

                .team-card:nth-child(even) .member-role {
                    background-color: #eef5fc;
                    /* Solid background */
                    color: var(--secondary-color);
                }

                .member-info {
                    font-size: 13px;
                    color: #666;
                    border-top: 1px solid #f8f8f8;
                    padding-top: 10px;
                }

                .member-info p {
                    margin-bottom: 5px;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                .member-info p i {
                    width: 14px;
                    color: #888;
                    text-align: center;
                }

                /* Success Toast */
                .toast-notification {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background-color: #2ecc71;
                    color: white;
                    padding: 15px 25px;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    font-weight: 600;
                    z-index: 9999;
                    transform: translateX(120%);
                    transition: transform 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                }

                .toast-notification.show {
                    transform: translateX(0);
                }
            </style>
        </head>

        <body>
            <%@include file="components/header.jsp" %>

                <!-- Hero Banner -->
                <div class="contact-hero">
                    <h2>Liên Hệ <span>Nhóm Phát Triển</span></h2>
                    <p>Mọi ý kiến đóng góp, phản hồi về tính năng hay giao diện của Website Mẹ & Bé, vui lòng gửi cho
                        chúng tôi qua biểu mẫu bên dưới.</p>
                </div>

                <!-- Layout 2 Cột chính -->
                <div class="contact-main-layout">

                    <!-- Cột 1: Biểu mẫu liên hệ -->
                    <div class="contact-form-card">
                        <h3>
                            <i class="fa-solid fa-paper-plane"
                                style="color: var(--primary-color); margin-right: 8px;"></i> Gửi góp ý
                        </h3>
                        <form id="contactForm" onsubmit="handleContactSubmit(event)">
                            <div class="form-group">
                                <label style="font-weight: 600; display: block; margin-bottom: 8px; font-size: 15px;">Họ
                                    tên của bạn</label>
                                <input type="text" class="form-control" placeholder="Nhập họ và tên..." required>
                            </div>
                            <div class="form-group">
                                <label
                                    style="font-weight: 600; display: block; margin-bottom: 8px; font-size: 15px;">Địa
                                    chỉ Email</label>
                                <input type="email" class="form-control" placeholder="Nhập email của bạn..." required>
                            </div>
                            <div class="form-group">
                                <label
                                    style="font-weight: 600; display: block; margin-bottom: 8px; font-size: 15px;">Tiêu
                                    đề góp ý</label>
                                <input type="text" class="form-control" placeholder="Ví dụ: Lỗi giao diện, Góp ý..."
                                    required>
                            </div>
                            <div class="form-group">
                                <label
                                    style="font-weight: 600; display: block; margin-bottom: 8px; font-size: 15px;">Nội
                                    dung phản hồi</label>
                                <textarea class="form-control" rows="5" placeholder="Mô tả chi tiết nội dung góp ý..."
                                    style="resize: none;" required></textarea>
                            </div>
                            <button type="submit" class="btn" style="width: 100%; padding: 12px; margin-top: 10px;">
                                Gửi phản hồi
                            </button>
                        </form>
                    </div>

                    <!-- Cột 2: Thành viên nhóm -->
                    <div class="team-column-container">
                        <h3>
                            <i class="fa-solid fa-users" style="color: var(--secondary-color); margin-right: 8px;"></i>
                            Thành viên nhóm
                        </h3>
                        <div class="team-list">

                            <!-- Thành viên 1 -->
                            <div class="team-card">
                                <div class="member-details">
                                    <div class="member-name">Trần Xuân Hải</div>
                                    <div class="member-info">
                                        <p><i class="fa-solid fa-id-card"></i> <b>MSV:</b> 23103100135</p>
                                        <p><i class="fa-solid fa-graduation-cap"></i> <b>Lớp:</b> DHTI17A3HN</p>
                                        <p><i class="fa-solid fa-envelope"></i> txhai.dhti17a3hn@sv.uneti.edu.vn</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Thành viên 2 -->
                            <div class="team-card">
                                <div class="member-details">
                                    <div class="member-name">Nguyễn Văn Cường</div>
                                    <div class="member-info">
                                        <p><i class="fa-solid fa-id-card"></i> <b>MSV:</b> 23103100132</p>
                                        <p><i class="fa-solid fa-graduation-cap"></i> <b>Lớp:</b> DHTI17A3HN</p>
                                        <p><i class="fa-solid fa-envelope"></i> nvcuong.dhti17a3hn@sv.uneti.edu.vn</p>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                </div>

                <!-- Success Toast -->
                <div id="successToast" class="toast-notification">
                    <i class="fa-solid fa-circle-check" style="font-size: 20px;"></i>
                    <span>Gửi phản hồi thành công! Cám ơn bạn đã góp ý.</span>
                </div>

                <script>
                    // Hàm xử lý gửi form góp ý demo
                    function handleContactSubmit(event) {
                        event.preventDefault();

                        // Lấy các giá trị (chỉ dùng để mô phỏng)
                        const form = document.getElementById('contactForm');

                        // Hiển thị toast thông báo thành công
                        const toast = document.getElementById('successToast');
                        toast.classList.add('show');

                        // Reset form sau khi gửi thành công
                        form.reset();

                        // Tự động ẩn toast sau 3.5 giây
                        setTimeout(() => {
                            toast.classList.remove('show');
                        }, 3500);
                    }
                </script>

                <jsp:include page="components/footer.jsp" />
        </body>

        </html>