package controller;

import dao.*;
import model.*;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/history"})
public class LichSuMuaHangServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdParam = request.getParameter("orderId");

        if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
            // Show order detail
            try {
                int orderId = Integer.parseInt(orderIdParam.trim());
                DonHangDAO dao = new DonHangDAO();
                DonHang donHang = dao.getById(orderId);

                // Security: only allow viewing own orders
                if (donHang == null || donHang.getKhachHangId() != user.getId()) {
                    response.sendRedirect(request.getContextPath() + "/history");
                    return;
                }

                List<ChiTietDonHang> chiTiet = dao.getChiTietWithTenSP(orderId);
                request.setAttribute("donHang", donHang);
                request.setAttribute("chiTiet", chiTiet);
                request.getRequestDispatcher("/order_detail.jsp").forward(request, response);

            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/history");
            }
        } else {
            // Show history list
            DonHangDAO dao = new DonHangDAO();
            List<DonHang> history = dao.getByKhachHangId(user.getId());

            request.setAttribute("history", history);
            request.getRequestDispatcher("/history.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateContact".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String tenNguoiNhan = request.getParameter("tenNguoiNhan");
                String sdtNhanHang = request.getParameter("sdtNhanHang");
                String diaChiGiaoHang = request.getParameter("diaChiGiaoHang");

                DonHangDAO dao = new DonHangDAO();
                DonHang donHang = dao.getById(orderId);

                // Security: only allow updating own orders
                if (donHang != null && donHang.getKhachHangId() == user.getId()) {
                    boolean updated = dao.updateContactInfo(orderId, tenNguoiNhan, sdtNhanHang, diaChiGiaoHang);
                    if (updated) {
                        response.sendRedirect(request.getContextPath() + "/history?orderId=" + orderId + "&success=1");
                        return;
                    }
                }
            } catch (NumberFormatException e) {
                // fall through to redirect
            }

        } else if ("cancelOrder".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));

                DonHangDAO dao = new DonHangDAO();
                DonHang donHang = dao.getById(orderId);

                // Security: only allow cancelling own orders
                if (donHang != null && donHang.getKhachHangId() == user.getId()) {
                    boolean cancelled = dao.cancelOrder(orderId);
                    if (cancelled) {
                        response.sendRedirect(request.getContextPath() + "/history?orderId=" + orderId + "&cancelled=1");
                        return;
                    }
                }
            } catch (NumberFormatException e) {
                // fall through to redirect
            }
        }

        response.sendRedirect(request.getContextPath() + "/history");
    }
}
