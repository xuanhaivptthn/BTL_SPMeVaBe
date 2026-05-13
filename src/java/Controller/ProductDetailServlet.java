package Controller;

import Model.DanhGia;
import Model.SanPham;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product-detail"})
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            SanPhamDAO sanPhamDAO = new SanPhamDAO();
            SanPham product = sanPhamDAO.getById(productId);

            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/products");
                return;
            }

            // Get rating filter if any
            String ratingParam = request.getParameter("rating");
            Integer ratingFilter = null;
            if (ratingParam != null && !ratingParam.trim().isEmpty()) {
                try {
                    ratingFilter = Integer.parseInt(ratingParam);
                } catch (NumberFormatException ignored) {}
            }

            DanhGiaDAO danhGiaDAO = new DanhGiaDAO();
            List<DanhGia> reviews = danhGiaDAO.getReviewsByProductId(productId, ratingFilter);
            int[] reviewStats = danhGiaDAO.getReviewStats(productId);

            int totalReviews = reviewStats[0];
            double averageRating = 0;
            if (totalReviews > 0) {
                int totalScore = reviewStats[1]*5 + reviewStats[2]*4 + reviewStats[3]*3 + reviewStats[4]*2 + reviewStats[5]*1;
                averageRating = (double) totalScore / totalReviews;
            }

            // Get suggested products
            List<SanPham> suggestedProducts = sanPhamDAO.getSuggestedProducts(product.getDanhMucId(), productId, 4);

            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("reviewStats", reviewStats);
            request.setAttribute("totalReviews", totalReviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("suggestedProducts", suggestedProducts);
            request.setAttribute("currentRatingFilter", ratingFilter);

            request.getRequestDispatcher("/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
