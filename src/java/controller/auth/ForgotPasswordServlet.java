package controller.auth;

import dao.NguoiDungDAO;
import model.NguoiDung;
import utils.EmailUtility;

import java.io.IOException;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        
        NguoiDungDAO dao = new NguoiDungDAO();
        NguoiDung user = dao.getByEmail(email);
        
        if (user != null) {
            // Generate 8-character OTP (lowercase + numbers)
            String otp = generateOTP(8);
            
            // Store in session
            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("otp_email", email);
            
            // Send Email
            String subject = "Mã xác thực quên mật khẩu";
            String body = "Chào " + user.getHoTen() + ",\n\n"
                    + "Bạn đã yêu cầu đặt lại mật khẩu. "
                    + "Đây là mã xác thực (OTP) của bạn: " + otp + "\n\n"
                    + "Vui lòng nhập mã này vào trang web để đổi mật khẩu mới. Mã này có phân biệt chữ hoa, chữ thường.\n\n"
                    + "Trân trọng,\nĐội ngũ hỗ trợ.";
                    
            boolean isSent = EmailUtility.sendEmail(email, subject, body);
            
            if (isSent) {
                response.sendRedirect(request.getContextPath() + "/verify-otp");
            } else {
                request.setAttribute("error", "Không thể gửi email. Vui lòng kiểm tra lại cấu hình SMTP.");
                request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Email không tồn tại trong hệ thống.");
            request.getRequestDispatcher("/forgot_password.jsp").forward(request, response);
        }
    }
    
    private String generateOTP(int length) {
        String chars = "abcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder otp = new StringBuilder();
        Random rnd = new Random();
        for (int i = 0; i < length; i++) {
            otp.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return otp.toString();
    }
}
