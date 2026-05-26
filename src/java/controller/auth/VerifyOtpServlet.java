package controller.auth;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VerifyOtpServlet", urlPatterns = {"/verify-otp"})
public class VerifyOtpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("otp_email") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        request.getRequestDispatcher("/verify_otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String enteredOtp = request.getParameter("otp");
        HttpSession session = request.getSession();
        String sessionOtp = (String) session.getAttribute("otp");
        
        if (sessionOtp != null && sessionOtp.equals(enteredOtp)) {
            // OTP is correct
            response.sendRedirect(request.getContextPath() + "/reset-password");
        } else {
            request.setAttribute("error", "Mã OTP không chính xác. Vui lòng thử lại.");
            request.getRequestDispatcher("/verify_otp.jsp").forward(request, response);
        }
    }
}
