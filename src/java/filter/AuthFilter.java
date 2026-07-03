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
 * AuthFilter — applied to every request (/*).
 *
 * Validates the auth_token JWT cookie and injects the parsed Claims
 * as a request attribute ("jwtClaims") so that downstream servlets
 * and JSPs can read the current user without hitting the database.
 *
 * This filter does NOT block unauthenticated requests — it simply
 * leaves jwtClaims null when no valid token is present.
 * Individual servlets or the AdminFilter enforce access rules.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;

        Claims claims = JwtUtil.getClaimsFromRequest(req);
        // Attach claims (may be null for unauthenticated requests)
        req.setAttribute("jwtClaims", claims);

        if (claims != null) {
            // Expose role as a string attribute for convenience in JSPs
            req.setAttribute("currentRole", claims.get("role", String.class));
            req.setAttribute("currentUserId", JwtUtil.getUserId(claims));
            req.setAttribute("currentUsername", JwtUtil.getUsername(claims));
            req.setAttribute("currentDisplayName", JwtUtil.getDisplayName(claims));
        }

        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig fc) throws ServletException {}
    @Override public void destroy() {}
}
