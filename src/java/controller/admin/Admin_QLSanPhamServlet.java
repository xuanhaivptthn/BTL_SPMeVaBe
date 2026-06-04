package controller.admin;

import dao.*;
import model.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class Admin_QLSanPhamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String categoryId = request.getParameter("category");
        String brand = request.getParameter("brand");
        
        // Pagination parameters
        int pageSize = 10;
        try {
            String ps = request.getParameter("pageSize");
            if (ps != null && !ps.isEmpty()) {
                int parsed = Integer.parseInt(ps);
                if (parsed == 20 || parsed == 50) pageSize = parsed;
                else pageSize = 10;
            }
        } catch (NumberFormatException ignored) {}

        int currentPage = 1;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.isEmpty()) {
                currentPage = Math.max(1, Integer.parseInt(p));
            }
        } catch (NumberFormatException ignored) {}
        
        SanPhamDAO dao = new SanPhamDAO();
        List<SanPham> allProducts;
        
        if ((search != null && !search.trim().isEmpty()) || 
            (categoryId != null && !categoryId.trim().isEmpty()) || 
            (brand != null && !brand.trim().isEmpty())) {
            
            String[] categories = null;
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                categories = new String[]{categoryId};
            }
            
            String[] brands = null;
            if (brand != null && !brand.trim().isEmpty()) {
                brands = new String[]{brand};
            }
            
            allProducts = dao.getFilteredProducts(search, categories, brands, null);
            request.setAttribute("search", search);
            request.setAttribute("selectedCategory", categoryId);
            request.setAttribute("selectedBrand", brand);
        } else {
            allProducts = dao.getAll();
        }

        // Pagination calculation
        int totalProducts = allProducts.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalProducts);
        List<SanPham> pagedList = (fromIndex < totalProducts) ? allProducts.subList(fromIndex, toIndex) : new java.util.ArrayList<>();

        request.setAttribute("products", pagedList);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        SanPhamDAO dao = new SanPhamDAO();

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String info = request.getParameter("info");
            double price = Double.parseDouble(request.getParameter("price"));
            int qty = Integer.parseInt(request.getParameter("quantity"));
            String thanhPhan = request.getParameter("thanhPhan");
            String xuatXu = request.getParameter("xuatXu");
            String khoiLuong = request.getParameter("khoiLuong");

            SanPham sp = new SanPham();
            sp.setTenSanPham(name);
            sp.setThongTinSanPham(info);
            sp.setThanhPhan(thanhPhan);
            sp.setXuatXu(xuatXu);
            sp.setKhoiLuong(khoiLuong);
            sp.setGiaTien(price);
            sp.setSoLuong(qty);
            String categoryParam = request.getParameter("categoryId");
            try {
                if (categoryParam != null && !categoryParam.trim().isEmpty()) {
                    sp.setDanhMucId(Integer.parseInt(categoryParam));
                } else {
                    sp.setDanhMucId(1); // default to category 1 when not provided
                }
            } catch (NumberFormatException e) {
                sp.setDanhMucId(1);
            }
            // Xử lý Upload file ảnh
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                // Đổi tên file để tránh trùng lặp
                fileName = System.currentTimeMillis() + "_" + fileName;
                
                // Lấy đường dẫn thư mục build/web
                String applicationPath = request.getServletContext().getRealPath("");
                // Mẹo: Lùi lại về thư mục web gốc của project NetBeans
                String sourcePath = applicationPath.replace("build" + File.separator + "web", "web");
                
                String uploadFilePath = sourcePath + File.separator + "uploads";
                File uploadFolder = new File(uploadFilePath);
                if (!uploadFolder.exists()) {
                    uploadFolder.mkdirs(); // Tạo thư mục nếu chưa có
                }
                
                // Lưu file vào thư mục gốc
                filePart.write(uploadFilePath + File.separator + fileName);
                
                // (Tùy chọn) Lưu thêm vào thư mục build/web để load được ngay lập tức mà không cần restart server
                String buildUploadPath = applicationPath + File.separator + "uploads";
                File buildUploadFolder = new File(buildUploadPath);
                if (!buildUploadFolder.exists()) {
                    buildUploadFolder.mkdirs();
                }
                filePart.write(buildUploadPath + File.separator + fileName);

                // Lưu đường dẫn ảnh vào DB
                sp.setHinhAnh("uploads/" + fileName);
            } else {
                // Nếu không upload file, kiểm tra xem có điền URL text không
                String imageText = request.getParameter("imageText");
                if (imageText != null && !imageText.trim().isEmpty()) {
                    sp.setHinhAnh(imageText);
                }
            }

            dao.insert(sp);
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String info = request.getParameter("info");
            double price = Double.parseDouble(request.getParameter("price"));
            int qty = Integer.parseInt(request.getParameter("quantity"));
            String thanhPhan = request.getParameter("thanhPhan");
            String xuatXu = request.getParameter("xuatXu");
            String khoiLuong = request.getParameter("khoiLuong");

            SanPham sp = new SanPham();
            sp.setMaSanPham(id);
            sp.setTenSanPham(name);
            sp.setThongTinSanPham(info);
            sp.setThanhPhan(thanhPhan);
            sp.setXuatXu(xuatXu);
            sp.setKhoiLuong(khoiLuong);
            sp.setGiaTien(price);
            sp.setSoLuong(qty);
            String categoryParam = request.getParameter("categoryId");
            try {
                if (categoryParam != null && !categoryParam.trim().isEmpty()) {
                    sp.setDanhMucId(Integer.parseInt(categoryParam));
                }
            } catch (NumberFormatException e) {
                // keep existing category if invalid
            }
            
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                fileName = System.currentTimeMillis() + "_" + fileName;
                String applicationPath = request.getServletContext().getRealPath("");
                String sourcePath = applicationPath.replace("build" + File.separator + "web", "web");
                String uploadFilePath = sourcePath + File.separator + "uploads";
                File uploadFolder = new File(uploadFilePath);
                if (!uploadFolder.exists()) uploadFolder.mkdirs();
                filePart.write(uploadFilePath + File.separator + fileName);
                
                String buildUploadPath = applicationPath + File.separator + "uploads";
                File buildUploadFolder = new File(buildUploadPath);
                if (!buildUploadFolder.exists()) buildUploadFolder.mkdirs();
                filePart.write(buildUploadPath + File.separator + fileName);

                sp.setHinhAnh("uploads/" + fileName);
            } else {
                String imageText = request.getParameter("imageText");
                if (imageText != null && !imageText.trim().isEmpty()) {
                    sp.setHinhAnh(imageText);
                } else {
                    if ("update".equals(action)) {
                        SanPham oldSp = dao.getById(id);
                        if(oldSp != null && oldSp.getHinhAnh() != null) {
                            sp.setHinhAnh(oldSp.getHinhAnh());
                        }
                    }
                }
            }

            dao.update(sp);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }
}
