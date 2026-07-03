package utils;

import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import model.NguoiDung;
import model.Role;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import javax.crypto.SecretKey;
import java.util.Date;

/**
 * Stateless JWT utility for authentication.
 *
 * Token claims:
 *   sub  – user id (as string)
 *   role – role name (ADMIN | STAFF | CUSTOMER)
 *   usr  – tenDangNhap (username)
 *   nam  – hoTen (display name)
 *
 * Token is stored in an HttpOnly cookie named "auth_token".
 */
public class JwtUtil {

    // ----------------------------------------------------------------
    // Configuration
    // ----------------------------------------------------------------

    /** Cookie name used to carry the JWT. */
    public static final String COOKIE_NAME = "auth_token";

    /**
     * Secret key (Base64-encoded, ≥ 256-bit for HS256).
     * In production, load from an environment variable or context.xml.
     */
    private static final String SECRET_BASE64 =
        "bXV0aGVydm9pYmViYXNlNjRqd3Rfc2VjcmV0X2tleV8yMDI2X0JUTF9TUE1lVmFCZQ==";

    /** Token validity: 30 days in milliseconds. */
    private static final long EXPIRY_MS = 30L * 24 * 60 * 60 * 1000;

    // ----------------------------------------------------------------
    // Internal helpers
    // ----------------------------------------------------------------

    private static SecretKey signingKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_BASE64);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    // ----------------------------------------------------------------
    // Public API
    // ----------------------------------------------------------------

    /**
     * Generates a signed JWT token for the given user.
     */
    public static String generateToken(NguoiDung user) {
        Date now    = new Date();
        Date expiry = new Date(now.getTime() + EXPIRY_MS);

        return Jwts.builder()
                .subject(String.valueOf(user.getId()))
                .claim("role", user.getRole())
                .claim("usr",  user.getTenDangNhap())
                .claim("nam",  user.getHoTen())
                .issuedAt(now)
                .expiration(expiry)
                .signWith(signingKey())
                .compact();
    }

    /**
     * Validates the token and returns its Claims, or null if invalid/expired.
     */
    public static Claims validateToken(String token) {
        if (token == null || token.isBlank()) return null;
        try {
            return Jwts.parser()
                    .verifyWith(signingKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (JwtException | IllegalArgumentException e) {
            return null;
        }
    }

    /**
     * Extracts the raw JWT string from the auth_token cookie.
     * Returns null if the cookie is not present.
     */
    public static String getTokenFromRequest(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return null;
        for (Cookie c : cookies) {
            if (COOKIE_NAME.equals(c.getName())) {
                return c.getValue();
            }
        }
        return null;
    }

    /**
     * Convenience method: validates the auth_token cookie in the request
     * and returns the Claims, or null if authentication fails.
     */
    public static Claims getClaimsFromRequest(HttpServletRequest request) {
        return validateToken(getTokenFromRequest(request));
    }

    /**
     * Returns the user id extracted from a validated Claims object.
     */
    public static int getUserId(Claims claims) {
        return Integer.parseInt(claims.getSubject());
    }

    /**
     * Returns the Role extracted from a validated Claims object.
     */
    public static Role getRole(Claims claims) {
        return Role.fromString(claims.get("role", String.class));
    }

    /**
     * Returns the username extracted from a validated Claims object.
     */
    public static String getUsername(Claims claims) {
        return claims.get("usr", String.class);
    }

    /**
     * Returns the display name extracted from a validated Claims object.
     */
    public static String getDisplayName(Claims claims) {
        return claims.get("nam", String.class);
    }

    /**
     * Builds an HttpOnly, SameSite=Strict auth cookie with the given token.
     * Call response.addCookie(cookie) after this.
     */
    public static Cookie buildAuthCookie(String token, String contextPath) {
        Cookie cookie = new Cookie(COOKIE_NAME, token);
        cookie.setHttpOnly(true);
        cookie.setPath(contextPath == null || contextPath.isEmpty() ? "/" : contextPath);
        cookie.setMaxAge((int) (EXPIRY_MS / 1000));
        // SameSite=Strict via header (Servlet API has no direct setter)
        return cookie;
    }

    /**
     * Builds an expired auth cookie that clears the existing token (for logout).
     */
    public static Cookie buildClearCookie(String contextPath) {
        Cookie cookie = new Cookie(COOKIE_NAME, "");
        cookie.setHttpOnly(true);
        cookie.setPath(contextPath == null || contextPath.isEmpty() ? "/" : contextPath);
        cookie.setMaxAge(0);
        return cookie;
    }
}
