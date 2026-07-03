package controller.auth;

import utils.JwtUtil;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Clear JWT cookie
        response.addCookie(JwtUtil.buildClearCookie(request.getContextPath()));

        // Also set SameSite header when clearing the cookie
        response.setHeader("Set-Cookie",
            JwtUtil.COOKIE_NAME + "=; Path="
            + (request.getContextPath().isEmpty() ? "/" : request.getContextPath())
            + "; HttpOnly; SameSite=Strict; Max-Age=0");

        // Invalidate any remaining HTTP session (e.g. OTP data, cart)
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(request.getContextPath() + "/");
    }
}
