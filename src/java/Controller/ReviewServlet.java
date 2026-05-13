package Controller;

import Model.DanhGia;
import Model.NguoiDung;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ReviewServlet", urlPatterns = {"/submit-review"})
public class ReviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String productIdParam = request.getParameter("productId");
        String ratingParam = request.getParameter("rating");
        String comment = request.getParameter("comment");
        String isAnonymousParam = request.getParameter("isAnonymous");
        String hoTenParam = request.getParameter("hoTen");

        if (productIdParam == null || ratingParam == null) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdParam);
            int rating = Integer.parseInt(ratingParam);
            boolean isAnonymous = isAnonymousParam != null && isAnonymousParam.equals("on");

            DanhGia review = new DanhGia();
            review.setSanPhamId(productId);
            review.setDiemDanhGia(rating);
            review.setBinhLuan(comment);
            review.setAnDanh(isAnonymous);

            HttpSession session = request.getSession();
            NguoiDung user = (NguoiDung) session.getAttribute("user");

            if (user != null) {
                review.setKhachHangId(user.getId());
                if (isAnonymous) {
                    review.setHoTen("Khách hàng");
                } else {
                    review.setHoTen(user.getHoTen());
                }
            } else {
                review.setKhachHangId(null);
                if (hoTenParam != null && !hoTenParam.trim().isEmpty() && !isAnonymous) {
                    review.setHoTen(hoTenParam);
                } else {
                    review.setHoTen("Khách hàng ẩn danh");
                }
            }

            DanhGiaDAO dao = new DanhGiaDAO();
            dao.addReview(review);

            response.sendRedirect(request.getContextPath() + "/product-detail?id=" + productId + "#reviews-section");

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
