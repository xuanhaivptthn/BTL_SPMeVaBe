package controller;

import dao.*;
import model.*;

import model.BackInStockSubscription;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SubscribeBackInStockServlet", urlPatterns = {"/subscribe-back-in-stock"})
public class SubscribeBackInStockServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String productIdParam = request.getParameter("productId");
        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        int productId = 0;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (Exception e) {
            session.setAttribute("subscribeMessage", "Thông tin sản phẩm không hợp lệ.");
            response.sendRedirect(request.getHeader("Referer") != null ? request.getHeader("Referer") : request.getContextPath());
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            session.setAttribute("subscribeMessage", "Vui lòng nhập email.");
            response.sendRedirect(request.getHeader("Referer") != null ? request.getHeader("Referer") : request.getContextPath());
            return;
        }

        BackInStockSubscription s = new BackInStockSubscription();
        s.setProductId(productId);
        s.setEmail(email.trim());

        BackInStockDAO dao = new BackInStockDAO();
        boolean ok = dao.insert(s);
        if (ok) {
            session.setAttribute("subscribeMessage", "Cảm ơn! Chúng tôi sẽ thông báo khi có hàng.");
        } else {
            session.setAttribute("subscribeMessage", "Đăng ký thất bại, vui lòng thử lại sau.");
        }

        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath());
    }
}
