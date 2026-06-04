package controller.admin;

import dao.*;
import model.*;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;

@WebServlet(name = "AdminOrderServlet", urlPatterns = {"/admin/orders"})
public class Admin_QLDonHangServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            handleDetail(request, response);
            return;
        } else if ("print".equals(action)) {
            handlePrint(request, response);
            return;
        }
        
        String khachHangId = request.getParameter("khachHangId");
        String donHangId = request.getParameter("donHangId");
        String status = request.getParameter("status");
        
        DonHangDAO dao = new DonHangDAO();
        List<DonHang> list;
        
        if ((khachHangId != null && !khachHangId.trim().isEmpty())
                || (donHangId != null && !donHangId.trim().isEmpty())
                || (status != null && !status.trim().isEmpty())) {
            list = dao.getFilteredOrders(khachHangId, donHangId, status);
            request.setAttribute("searchKhachHangId", khachHangId);
            request.setAttribute("searchDonHangId", donHangId);
            request.setAttribute("searchStatus", status);
        } else {
            list = dao.getAll();
        }
        
        request.setAttribute("orders", list);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam.trim());
            DonHangDAO dao = new DonHangDAO();
            DonHang dh = dao.getById(id);
            if (dh == null) {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            List<ChiTietDonHang> chiTiet = dao.getChiTietWithTenSP(id);
            request.setAttribute("order", dh);
            request.setAttribute("chiTiet", chiTiet);
            
            request.getRequestDispatcher("/admin/order_detail_admin.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void handlePrint(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam.trim());
            DonHangDAO dao = new DonHangDAO();
            DonHang dh = dao.getById(id);
            if (dh == null || !"DELIVERED".equals(dh.getTrangThai())) {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }
            List<ChiTietDonHang> chiTiet = dao.getChiTietWithTenSP(id);
            request.setAttribute("order", dh);
            request.setAttribute("chiTiet", chiTiet);
            
            request.getRequestDispatcher("/admin/invoice.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            DonHangDAO dao = new DonHangDAO();
            DonHang oldDh = dao.getById(id);
            
            if (dao.updateStatus(id, status)) {
                if (oldDh != null) {
                    KhachHangDAO khDao = new KhachHangDAO();
                    // Nếu cập nhật thành DELIVERED từ trạng thái khác
                    if ("DELIVERED".equals(status) && !"DELIVERED".equals(oldDh.getTrangThai())) {
                        int diem = (int) (oldDh.getTongTien() / 1000);
                        khDao.addDiemTichLuy(oldDh.getKhachHangId(), diem);
                    } 
                    // Nếu đổi từ DELIVERED sang trạng thái khác (hủy, vv)
                    else if (!"DELIVERED".equals(status) && "DELIVERED".equals(oldDh.getTrangThai())) {
                        int diem = (int) (oldDh.getTongTien() / 1000);
                        khDao.addDiemTichLuy(oldDh.getKhachHangId(), -diem);
                    }
                }
            }
        } else if ("recalculatePoints".equals(action)) {
            KhachHangDAO khDao = new KhachHangDAO();
            khDao.recalculateAllPoints();
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
            dao.SanPhamDAO spDao = new dao.SanPhamDAO();
            
            if (sanPhamIds != null && soLuongs != null) {
                for (int i = 0; i < sanPhamIds.length; i++) {
                    try {
                        int spId = Integer.parseInt(sanPhamIds[i]);
                        int sl = Integer.parseInt(soLuongs[i]);
                        if (sl > 0) {
                            model.SanPham sp = spDao.getById(spId);
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
