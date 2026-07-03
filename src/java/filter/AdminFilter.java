package filter;

import io.jsonwebtoken.Claims;
import model.Role;
import utils.JwtUtil;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * AdminFilter — guards the /admin/* URL space.
 *
 * Access rules:
 *   ADMIN  → full access (all /admin/* pages including /admin/users)
 *   STAFF  → partial access (/admin/* EXCEPT /admin/users)
 *   Others → redirect to /login or 403 Forbidden
 *
 * Authentication is checked via the JWT cookie (not HTTP session).
 */
@WebFilter(filterName = "AdminFilter", urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        // AuthFilter already parsed the token; re-read from request attribute
        Claims claims = (Claims) req.getAttribute("jwtClaims");
        if (claims == null) {
            // No valid token — not logged in
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Role role = JwtUtil.getRole(claims);

        if (!role.hasAdminAccess()) {
            // Logged in but not an admin/staff
            res.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Bạn không có quyền truy cập trang quản trị!");
            return;
        }

        // STAFF cannot access user management pages
        String requestPath = req.getServletPath();
        if (role == Role.STAFF && requestPath != null && requestPath.startsWith("/admin/users")) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Nhân viên không có quyền quản lý tài khoản người dùng!");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig fc) throws ServletException {}
    @Override public void destroy() {}
}
