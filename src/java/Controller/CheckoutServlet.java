package Controller;

import Model.ChiTietDonHang;
import Model.DonHang;
import Model.SanPham;
import Model.DiaChiNhanHang;
import Controller.DiaChiNhanHangDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CheckoutServlet", urlPatterns = { "/checkout" })
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        Model.NguoiDung user = (Model.NguoiDung) session.getAttribute("user");
        if (user == null || "ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
            session.setAttribute("redirectAfterLogin", "/cart");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        DiaChiNhanHangDAO dcDao = new DiaChiNhanHangDAO();
        List<Model.DiaChiNhanHang> listDiaChi = dcDao.getByKhachHangId(user.getId());
        request.setAttribute("listDiaChi", listDiaChi);
        
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String tenNguoiNhan = request.getParameter("tenNguoiNhan");
        String sdtNhanHang = request.getParameter("sdtNhanHang");
        String diaChi = request.getParameter("diaChiGiaoHang");
        String ghiChu = request.getParameter("ghiChu");
        boolean saveAddress = "on".equals(request.getParameter("saveAddress"));

        // Lấy Khách Hàng đang đăng nhập
        Model.NguoiDung user = (Model.NguoiDung) session.getAttribute("user");
        if (user == null || "ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
            session.setAttribute("redirectAfterLogin", "/cart");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int khachHangId = user.getId();

        SanPhamDAO spDao = new SanPhamDAO();
        double tongTien = 0;
        List<ChiTietDonHang> chiTietList = new ArrayList<>();

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            int spId = entry.getKey();
            int sl = entry.getValue();
            SanPham sp = spDao.getById(spId);
            if (sp != null) {
                tongTien += sp.getGiaTien() * sl;
                ChiTietDonHang ct = new ChiTietDonHang();
                ct.setSanPhamId(spId);
                ct.setSoLuong(sl);
                ct.setDonGia(sp.getGiaTien());
                chiTietList.add(ct);
            }
        }

        DonHang dh = new DonHang();
        dh.setKhachHangId(khachHangId);
        dh.setTongTien(tongTien);
        dh.setTrangThai("PENDING");
        dh.setTenNguoiNhan(tenNguoiNhan);
        dh.setSdtNhanHang(sdtNhanHang);
        dh.setDiaChiGiaoHang(diaChi);
        dh.setGhiChu(ghiChu);

        DonHangDAO dhDao = new DonHangDAO();
        boolean success = dhDao.insert(dh, chiTietList);
        
        if (success) {
            // Luôn lưu địa chỉ này làm địa chỉ mặc định mới hoặc cập nhật
            DiaChiNhanHangDAO dcDao = new DiaChiNhanHangDAO();
            Model.DiaChiNhanHang dc = new Model.DiaChiNhanHang();
            dc.setKhachHangId(khachHangId);
            dc.setTenNguoiNhan(tenNguoiNhan);
            dc.setSoDienThoai(sdtNhanHang);
            dc.setDiaChi(diaChi);
            dc.setDefault(true);
            dcDao.insert(dc);
        }

        if (success) {
            session.removeAttribute("cart");
            response.sendRedirect(request.getContextPath() + "/order_success.jsp");
        } else {
            session.setAttribute("error", "Đặt hàng thất bại. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
