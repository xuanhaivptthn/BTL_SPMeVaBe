package controller;

import dao.*;
import model.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB
    maxFileSize       = 5 * 1024 * 1024,   // 5 MB per file
    maxRequestSize    = 10 * 1024 * 1024   // 10 MB total
)
@WebServlet(name = "ReviewServlet", urlPatterns = {"/submit-review"})
public class ReviewServlet extends HttpServlet {

    private static final String REVIEW_IMG_RELATIVE = "uploads/ReviewImg";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String productIdParam = request.getParameter("productId");
        String ratingParam    = request.getParameter("rating");
        String comment        = request.getParameter("comment");
        String isAnonymousParam = request.getParameter("isAnonymous");
        String hoTenParam     = request.getParameter("hoTen");

        if (productIdParam == null || ratingParam == null) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId  = Integer.parseInt(productIdParam);
            int rating     = Integer.parseInt(ratingParam);
            boolean isAnonymous = isAnonymousParam != null && isAnonymousParam.equals("on");

            // --- Handle image upload ---
            String savedImagePath = null;
            Part imagePart = request.getPart("reviewImage");
            if (imagePart != null && imagePart.getSize() > 0) {
                final long MAX_SIZE = 5L * 1024 * 1024; // 5 MB
                String contentType = imagePart.getContentType();

                // Server-side validation: phải là image/* và ≤ 5 MB
                if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
                    response.sendRedirect(request.getContextPath()
                            + "/product-detail?id=" + productIdParam
                            + "&uploadError=not_image#reviews-section");
                    return;
                }
                if (imagePart.getSize() > MAX_SIZE) {
                    response.sendRedirect(request.getContextPath()
                            + "/product-detail?id=" + productIdParam
                            + "&uploadError=too_large#reviews-section");
                    return;
                }

                // Lấy phần mở rộng từ content-type hoặc tên file gốc
                String extension = "";
                String originalFileName = getSubmittedFileName(imagePart);
                if (originalFileName != null && originalFileName.contains(".")) {
                    extension = originalFileName.substring(originalFileName.lastIndexOf(".")).toLowerCase();
                } else {
                    // Fallback: suy từ MIME type (e.g. image/png -> .png)
                    String subtype = contentType.substring(contentType.indexOf('/') + 1).toLowerCase();
                    extension = "." + subtype.replaceAll("[^a-z0-9]", "");
                }

                String randomName = UUID.randomUUID().toString().replace("-", "") + extension;

                // Resolve physical directory on the server
                String uploadDir = getServletContext().getRealPath("") + File.separator + REVIEW_IMG_RELATIVE;
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                File destFile = new File(dir, randomName);
                try (InputStream in = imagePart.getInputStream()) {
                    Files.copy(in, destFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }

                // Store relative web path (e.g. uploads/ReviewImg/abc123.jpg)
                savedImagePath = REVIEW_IMG_RELATIVE + "/" + randomName;
            }

            DanhGia review = new DanhGia();
            review.setSanPhamId(productId);
            review.setDiemDanhGia(rating);
            review.setBinhLuan(comment);
            review.setAnDanh(isAnonymous);
            review.setAnhDanhGia(savedImagePath);

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

    /** Extract the original filename from a multipart Part. */
    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition == null) return null;
        for (String token : contentDisposition.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
