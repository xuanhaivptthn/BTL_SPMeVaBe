package controller;

import dao.*;
import model.*;

import model.ChiTietDonHang;
import model.DonHang;
import model.SanPham;
import model.DiaChiNhanHang;
import dao.DiaChiNhanHangDAO;
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

        model.NguoiDung user = (model.NguoiDung) session.getAttribute("user");
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
        
        DonHangDAO dhDao = new DonHangDAO();
        Integer draftOrderId = (Integer) session.getAttribute("draftOrderId");
        
        // Lấy danh sách địa chỉ nhận hàng
        DiaChiNhanHangDAO dcDao = new DiaChiNhanHangDAO();
        List<model.DiaChiNhanHang> listDiaChi = dcDao.getByKhachHangId(user.getId());
        request.setAttribute("listDiaChi", listDiaChi);

        // Lấy danh sách sản phẩm trong giỏ hàng để hiển thị
        SanPhamDAO spDao = new SanPhamDAO();
        List<model.CartItem> cartProducts = new ArrayList<>();
        double totalPrice = 0;

        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            int spId = entry.getKey();
            int sl = entry.getValue();
            SanPham sp = spDao.getById(spId);
            if (sp != null) {
                cartProducts.add(new model.CartItem(sp, sl));
                totalPrice += sp.getGiaTien() * sl;
            }
        }

        request.setAttribute("cartProducts", cartProducts);
        request.setAttribute("totalPrice", totalPrice);
        
        DonHang draftDh = null;
        if (draftOrderId != null) {
            draftDh = dhDao.getById(draftOrderId);
            // Nếu không tìm thấy hoặc đã đổi trạng thái, coi như chưa có
            if (draftDh == null || !"UNPAID".equals(draftDh.getTrangThai())) {
                draftOrderId = null;
                session.removeAttribute("draftOrderId");
            }
        }
        
        if (draftOrderId == null) {
            // Khởi tạo đơn hàng nháp mới (UNPAID)
            draftDh = new DonHang();
            draftDh.setKhachHangId(user.getId());
            draftDh.setTongTien(totalPrice);
            draftDh.setTrangThai("UNPAID");
            
            // Điền trước thông tin địa chỉ mặc định
            if (listDiaChi != null && !listDiaChi.isEmpty()) {
                DiaChiNhanHang defaultAddress = listDiaChi.stream()
                    .filter(DiaChiNhanHang::isDefault)
                    .findFirst()
                    .orElse(listDiaChi.get(0));
                draftDh.setTenNguoiNhan(defaultAddress.getTenNguoiNhan());
                draftDh.setSdtNhanHang(defaultAddress.getSoDienThoai());
                draftDh.setDiaChiGiaoHang(defaultAddress.getDiaChi());
                
                request.setAttribute("tenNguoiNhan", defaultAddress.getTenNguoiNhan());
                request.setAttribute("sdtNhanHang", defaultAddress.getSoDienThoai());
                request.setAttribute("diaChiGiaoHang", defaultAddress.getDiaChi());
            } else {
                draftDh.setTenNguoiNhan("");
                draftDh.setSdtNhanHang("");
                draftDh.setDiaChiGiaoHang("");
            }
            draftDh.setGhiChu("");
            draftDh.setPhuongThucThanhToan("COD");
            draftDh.setSoTienGiam(0);
            
            List<ChiTietDonHang> chiTietList = new ArrayList<>();
            for (model.CartItem item : cartProducts) {
                ChiTietDonHang ct = new ChiTietDonHang();
                ct.setSanPhamId(item.getProduct().getMaSanPham());
                ct.setSoLuong(item.getQuantity());
                ct.setDonGia(item.getProduct().getGiaTien());
                chiTietList.add(ct);
            }
            
            boolean created = dhDao.insert(draftDh, chiTietList);
            if (created) {
                session.setAttribute("draftOrderId", draftDh.getId());
                request.setAttribute("nextOrderId", draftDh.getId());
            }
        } else {
            // Đã có đơn hàng nháp, dùng lại và hiển thị lên giao diện
            request.setAttribute("nextOrderId", draftDh.getId());
            
            // Ưu tiên các thuộc tính được thiết lập trong request để repopulate khi submit coupon
            if (request.getAttribute("tenNguoiNhan") == null) {
                request.setAttribute("tenNguoiNhan", draftDh.getTenNguoiNhan());
            }
            if (request.getAttribute("sdtNhanHang") == null) {
                request.setAttribute("sdtNhanHang", draftDh.getSdtNhanHang());
            }
            if (request.getAttribute("diaChiGiaoHang") == null) {
                request.setAttribute("diaChiGiaoHang", draftDh.getDiaChiGiaoHang());
            }
            if (request.getAttribute("ghiChu") == null) {
                request.setAttribute("ghiChu", draftDh.getGhiChu());
            }
            if (request.getAttribute("phuongThucThanhToan") == null) {
                request.setAttribute("phuongThucThanhToan", draftDh.getPhuongThucThanhToan());
            }
            if (request.getAttribute("maGiamGia") == null) {
                request.setAttribute("maGiamGia", draftDh.getMaGiamGia());
            }
            if (request.getAttribute("discountAmount") == null) {
                request.setAttribute("discountAmount", draftDh.getSoTienGiam());
            }
        }
        
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

        // Lấy Khách Hàng đang đăng nhập
        model.NguoiDung user = (model.NguoiDung) session.getAttribute("user");
        if (user == null || "ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
            session.setAttribute("redirectAfterLogin", "/cart");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "checkout";
        }

        String tenNguoiNhan = request.getParameter("tenNguoiNhan");
        String sdtNhanHang = request.getParameter("sdtNhanHang");
        String diaChiGiaoHang = request.getParameter("diaChiGiaoHang");
        String ghiChu = request.getParameter("ghiChu");
        String phuongThucThanhToan = request.getParameter("phuongThucThanhToan");
        String maGiamGiaInput = request.getParameter("maGiamGia");

        Integer draftOrderId = (Integer) session.getAttribute("draftOrderId");
        if (draftOrderId == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Tính toán tổng tiền sản phẩm trong giỏ hàng
        SanPhamDAO spDao = new SanPhamDAO();
        double totalPrice = 0;
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            int spId = entry.getKey();
            int sl = entry.getValue();
            SanPham sp = spDao.getById(spId);
            if (sp != null) {
                totalPrice += sp.getGiaTien() * sl;
            }
        }

        // Kiểm tra mã giảm giá
        double discountAmount = 0;
        String couponMessage = null;
        String couponError = null;
        String finalCouponCode = null;

        if (maGiamGiaInput != null && !maGiamGiaInput.trim().isEmpty()) {
            String code = maGiamGiaInput.trim().toUpperCase();
            MaGiamGiaDAO mggDao = new MaGiamGiaDAO();
            model.MaGiamGia mgg = mggDao.getByCode(code);
            if (mgg == null) {
                couponError = "Mã giảm giá không tồn tại hoặc đã hết hạn.";
            } else {
                if (totalPrice < mgg.getGiaTriDonHangToiThieu()) {
                    couponError = "Đơn hàng chưa đạt giá trị tối thiểu " + 
                                  String.format("%,.0f", mgg.getGiaTriDonHangToiThieu()) + "đ để áp dụng mã này.";
                } else {
                    if ("PERCENT".equals(mgg.getLoaiGiamGia())) {
                        discountAmount = totalPrice * (mgg.getGiaTriGiam() / 100.0);
                        if (mgg.getGiamToiDa() > 0 && discountAmount > mgg.getGiamToiDa()) {
                            discountAmount = mgg.getGiamToiDa();
                        }
                    } else if ("AMOUNT".equals(mgg.getLoaiGiamGia())) {
                        discountAmount = mgg.getGiaTriGiam();
                    }
                    
                    if (discountAmount > totalPrice) {
                        discountAmount = totalPrice;
                    }
                    
                    finalCouponCode = mgg.getMa();
                    couponMessage = "Áp dụng mã giảm giá [" + mgg.getMa() + "] thành công! Bạn được giảm " + 
                                    String.format("%,.0f", discountAmount) + "đ.";
                }
            }
        }

        DonHangDAO dhDao = new DonHangDAO();
        double finalTotal = totalPrice - discountAmount;

        // Lưu thông tin tạm thời vào cơ sở dữ liệu
        dhDao.updateDraftOrder(draftOrderId, finalTotal, finalCouponCode, discountAmount, 
                               tenNguoiNhan, sdtNhanHang, diaChiGiaoHang, ghiChu, phuongThucThanhToan);

        if ("applyCoupon".equals(action)) {
            // Set attributes để repopulate trên form
            request.setAttribute("tenNguoiNhan", tenNguoiNhan);
            request.setAttribute("sdtNhanHang", sdtNhanHang);
            request.setAttribute("diaChiGiaoHang", diaChiGiaoHang);
            request.setAttribute("ghiChu", ghiChu);
            request.setAttribute("phuongThucThanhToan", phuongThucThanhToan);
            request.setAttribute("maGiamGia", finalCouponCode != null ? finalCouponCode : maGiamGiaInput);
            request.setAttribute("discountAmount", discountAmount);
            
            if (couponError != null) {
                request.setAttribute("couponError", couponError);
            } else if (couponMessage != null) {
                request.setAttribute("couponMessage", couponMessage);
            }

            doGet(request, response);
        } else {
            // Tiến hành hoàn tất đơn hàng
            DonHang dh = dhDao.getById(draftOrderId);
            if (dh == null || !"UNPAID".equals(dh.getTrangThai())) {
                session.setAttribute("error", "Đơn hàng không tồn tại hoặc đã được xử lý.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Gán thông tin người dùng nhập vào đơn hàng
            dh.setTenNguoiNhan(tenNguoiNhan);
            dh.setSdtNhanHang(sdtNhanHang);
            dh.setDiaChiGiaoHang(diaChiGiaoHang);
            dh.setGhiChu(ghiChu);
            dh.setPhuongThucThanhToan(phuongThucThanhToan);
            dh.setTongTien(finalTotal);
            dh.setMaGiamGia(finalCouponCode);
            dh.setSoTienGiam(discountAmount);

            boolean success = dhDao.finalizeDraftOrder(dh);
            if (success) {
                // Luôn lưu địa chỉ này làm địa chỉ mặc định mới hoặc cập nhật
                DiaChiNhanHangDAO dcDao = new DiaChiNhanHangDAO();
                model.DiaChiNhanHang dc = new model.DiaChiNhanHang();
                dc.setKhachHangId(user.getId());
                dc.setTenNguoiNhan(tenNguoiNhan);
                dc.setSoDienThoai(sdtNhanHang);
                dc.setDiaChi(diaChiGiaoHang);
                dc.setDefault(true);
                dcDao.insert(dc);

                session.removeAttribute("cart");
                session.removeAttribute("draftOrderId");
                response.sendRedirect(request.getContextPath() + "/order_success.jsp");
            } else {
                session.setAttribute("error", "Đặt hàng thất bại. Vui lòng thử lại.");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        }
    }
}
