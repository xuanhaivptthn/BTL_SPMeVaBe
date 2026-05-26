package controller.auth;

import dao.NguoiDungDAO;
import model.NguoiDung;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("otp_email") == null || session.getAttribute("otp") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPassword = request.getParameter("matKhau");
        String confirmPassword = request.getParameter("xacNhanMatKhau");
        
        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
            return;
        }
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("otp_email");
        
        if (email != null) {
            NguoiDungDAO dao = new NguoiDungDAO();
            NguoiDung user = dao.getByEmail(email);
            if (user != null) {
                boolean success = dao.updatePassword(user.getId(), newPassword);
                if (success) {
                    // Clear session attributes
                    session.removeAttribute("otp");
                    session.removeAttribute("otp_email");
                    
                    response.sendRedirect(request.getContextPath() + "/login?msg=reset_success");
                } else {
                    request.setAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu.");
                    request.getRequestDispatcher("/reset_password.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
        }
    }
}
