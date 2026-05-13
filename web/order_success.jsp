<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .success-container {
            max-width: 600px;
            margin: 50px auto;
            text-align: center;
            padding: 40px;
            background: #fff;
            border-radius: var(--radius);
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
        }
        .success-icon {
            font-size: 80px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        .success-title {
            font-size: 28px;
            color: var(--text-color);
            margin-bottom: 15px;
            font-weight: 700;
        }
        .success-message {
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        .btn-group {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
    </style>
</head>
<body>
    <jsp:include page="components/header.jsp" />

    <div class="container">
        <div class="success-container">
            <div class="success-icon">✓</div>
            <h1 class="success-title">Đặt hàng thành công!</h1>
            <p class="success-message">
                Cảm ơn bạn đã tin tưởng và mua sắm tại cửa hàng của chúng tôi.<br>
                Đơn hàng của bạn đang được xử lý và sẽ được giao trong thời gian sớm nhất.
            </p>
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/history" class="btn btn-secondary">Xem lịch sử đơn hàng</a>
                <a href="${pageContext.request.contextPath}/" class="btn">Tiếp tục mua sắm</a>
            </div>
        </div>
    </div>

    <jsp:include page="components/footer.jsp" />
</body>
</html>
