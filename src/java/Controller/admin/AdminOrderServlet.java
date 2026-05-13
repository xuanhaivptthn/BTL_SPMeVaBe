package Controller.admin;

import Controller.DonHangDAO;
import Model.DonHang;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.ChiTietDonHang;
import java.util.ArrayList;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders"})
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DonHangDAO dao = new DonHangDAO();
        List<DonHang> list = dao.getAll();
        request.setAttribute("orders", list);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            DonHangDAO dao = new DonHangDAO();
            dao.updateStatus(id, status);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            DonHangDAO dao = new DonHangDAO();
            dao.delete(id);
        } else if ("add".equals(action)) {
            int khachHangId = Integer.parseInt(request.getParameter("khachHangId"));
            String tenNguoiNhan = request.getParameter("tenNguoiNhan");
            String sdtNhanHang = request.getParameter("sdtNhanHang");
            String diaChiGiaoHang = request.getParameter("diaChiGiaoHang");
            String ghiChu = request.getParameter("ghiChu");
            String[] sanPhamIds = request.getParameterValues("sanPhamId[]");
            String[] soLuongs = request.getParameterValues("soLuong[]");
            
            double tongTien = 0;
            List<ChiTietDonHang> chiTietList = new ArrayList<>();
            Controller.SanPhamDAO spDao = new Controller.SanPhamDAO();
            
            if (sanPhamIds != null && soLuongs != null) {
                for (int i = 0; i < sanPhamIds.length; i++) {
                    try {
                        int spId = Integer.parseInt(sanPhamIds[i]);
                        int sl = Integer.parseInt(soLuongs[i]);
                        if (sl > 0) {
                            Model.SanPham sp = spDao.getById(spId);
                            if (sp != null) {
                                ChiTietDonHang ct = new ChiTietDonHang();
                                ct.setSanPhamId(spId);
                                ct.setSoLuong(sl);
                                ct.setDonGia(sp.getGiaTien());
                                chiTietList.add(ct);
                                tongTien += (sp.getGiaTien() * sl);
                            }
                        }
                    } catch (NumberFormatException e) {
                        // Bỏ qua dòng lỗi
                    }
                }
            }
            
            DonHang dh = new DonHang();
            dh.setKhachHangId(khachHangId);
            dh.setTenNguoiNhan(tenNguoiNhan);
            dh.setSdtNhanHang(sdtNhanHang);
            dh.setDiaChiGiaoHang(diaChiGiaoHang);
            dh.setGhiChu(ghiChu);
            dh.setTongTien(tongTien);
            dh.setTrangThai("PENDING");
            
            DonHangDAO dao = new DonHangDAO();
            dao.insert(dh, chiTietList);
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
