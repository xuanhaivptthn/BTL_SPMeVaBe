package controller.auth;

import dao.NguoiDungDAO;
import io.jsonwebtoken.Claims;
import model.NguoiDung;
import model.Role;
import utils.JwtUtil;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Already authenticated — redirect away from login page
        Claims claims = (Claims) request.getAttribute("jwtClaims");
        if (claims != null) {
            Role role = JwtUtil.getRole(claims);
            if (role.hasAdminAccess()) {
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String pass     = request.getParameter("password");

        NguoiDungDAO dao = new NguoiDungDAO();
        NguoiDung user = dao.checkLogin(username, pass);

        if (user == null) {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Generate JWT and set HttpOnly cookie
        String token = JwtUtil.generateToken(user);
        response.addCookie(JwtUtil.buildAuthCookie(token, request.getContextPath()));

        // Preserve SameSite=Strict by adding it to the Set-Cookie header
        // (Servlet API < 6 does not expose a SameSite setter)
        response.setHeader("Set-Cookie",
            JwtUtil.COOKIE_NAME + "=" + token
            + "; Path=" + (request.getContextPath().isEmpty() ? "/" : request.getContextPath())
            + "; HttpOnly; SameSite=Strict; Max-Age=2592000");

        Role role = Role.fromString(user.getRole());

        if (role.hasAdminAccess()) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
        } else {
            // Honor saved redirect (stored in session before JWT era)
            HttpSession session = request.getSession(false);
            String redirect = (session != null)
                ? (String) session.getAttribute("redirectAfterLogin") : null;
            if (redirect != null && session != null) {
                session.removeAttribute("redirectAfterLogin");
            }
            response.sendRedirect(request.getContextPath() + (redirect != null ? redirect : "/"));
        }
    }
}
