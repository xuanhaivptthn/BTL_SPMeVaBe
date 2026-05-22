package controller;

import dao.KhachHangDAO;
import dao.NguoiDungDAO;
import model.NguoiDung;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("redirectAfterLogin", "/profile");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung user = (NguoiDung) session.getAttribute("user");
        
        // Fetch loyalty points if CUSTOMER
        if ("CUSTOMER".equals(user.getRole())) {
            KhachHangDAO khachHangDAO = new KhachHangDAO();
            int diemTichLuy = khachHangDAO.getDiemTichLuy(user.getId());
            request.setAttribute("diemTichLuy", diemTichLuy);
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        NguoiDung user = (NguoiDung) session.getAttribute("user");
        String action = request.getParameter("action");

        NguoiDungDAO nguoiDungDAO = new NguoiDungDAO();

        if ("update_profile".equals(action)) {
            String hoTen = request.getParameter("hoTen");
            String email = request.getParameter("email");
            String dienThoai = request.getParameter("dienThoai");

            if (hoTen == null || hoTen.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                dienThoai == null || dienThoai.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ các trường thông tin!");
                doGet(request, response);
                return;
            }

            boolean success = nguoiDungDAO.updateProfile(user.getId(), hoTen.trim(), email.trim(), dienThoai.trim());
            if (success) {
                // Update user object in current session
                NguoiDung updatedUser = nguoiDungDAO.getById(user.getId());
                if (updatedUser != null) {
                    session.setAttribute("user", updatedUser);
                }
                response.sendRedirect(request.getContextPath() + "/profile?status=success");
            } else {
                request.setAttribute("error", "Cập nhật thông tin thất bại. Email có thể đã tồn tại.");
                doGet(request, response);
            }

        } else if ("change_password".equals(action)) {
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (oldPassword == null || oldPassword.isEmpty() ||
                newPassword == null || newPassword.isEmpty() ||
                confirmPassword == null || confirmPassword.isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ các trường đổi mật khẩu!");
                request.setAttribute("activeTab", "password");
                doGet(request, response);
                return;
            }

            if (newPassword.length() < 6) {
                request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
                request.setAttribute("activeTab", "password");
                doGet(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
                request.setAttribute("activeTab", "password");
                doGet(request, response);
                return;
            }

            // Verify old password
            boolean isOldPasswordCorrect = nguoiDungDAO.checkPassword(user.getId(), oldPassword);
            if (!isOldPasswordCorrect) {
                request.setAttribute("error", "Mật khẩu cũ không chính xác!");
                request.setAttribute("activeTab", "password");
                doGet(request, response);
                return;
            }

            // Perform password update
            boolean success = nguoiDungDAO.updatePassword(user.getId(), newPassword);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/profile?status=password_success");
            } else {
                request.setAttribute("error", "Thay đổi mật khẩu thất bại!");
                request.setAttribute("activeTab", "password");
                doGet(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}
