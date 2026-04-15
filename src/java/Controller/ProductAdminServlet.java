package Controller;

import Model.SanPham;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin/product")
public class ProductAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String dbName = getServletContext().getInitParameter("dbName");
        if (dbName == null || dbName.isEmpty()) dbName = "QLBanHang";

        String idParam = req.getParameter("id");
        SanPhamDAO dao = new SanPhamDAO();
        if (idParam != null && !idParam.isEmpty()) {
            int id = Integer.parseInt(idParam);
            SanPham p = dao.getById(dbName, id);
            req.setAttribute("product", p);
            req.getRequestDispatcher("/editProduct.jsp").forward(req, resp);
            return;
        }
        req.getRequestDispatcher("/addProduct.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String dbName = getServletContext().getInitParameter("dbName");
        if (dbName == null || dbName.isEmpty()) dbName = "QLBanHang";

        String action = req.getParameter("action");
        SanPhamDAO dao = new SanPhamDAO();

        if ("save".equals(action)) {
            String idParam = req.getParameter("id");
            SanPham p = new SanPham();
            String ten = req.getParameter("TenSanPham");
            String thongtin = req.getParameter("ThongTinSanPham");
            String gia = req.getParameter("GiaTien");
            String sl = req.getParameter("SoLuong");
            String images = req.getParameter("images"); // comma separated URLs

            p.setTenSanPham(ten);
            p.setThongTinSanPham(thongtin);
            try { p.setGiaTien(Double.parseDouble(gia)); } catch (Exception ex) { p.setGiaTien(0); }
            try { p.setSoLuong(Integer.parseInt(sl)); } catch (Exception ex) { p.setSoLuong(0); }

            List<String> imgs = new ArrayList<>();
            if (images != null && !images.trim().isEmpty()) {
                String[] parts = images.split(",");
                for (String s : parts) {
                    String t = s.trim(); if (!t.isEmpty()) imgs.add(t);
                }
            }
            p.setImages(imgs);

            if (idParam == null || idParam.isEmpty()) {
                dao.insert(dbName, p);
            } else {
                p.setMaSanPham(Integer.parseInt(idParam));
                dao.update(dbName, p);
            }
        } else if ("delete".equals(action)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                dao.delete(dbName, Integer.parseInt(idParam));
            }
        }

        resp.sendRedirect(req.getContextPath() + "/products");
    }
}
