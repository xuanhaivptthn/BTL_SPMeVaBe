package controller.admin;

import dao.NguoiDungDAO;
import io.jsonwebtoken.Claims;
import model.Role;
import utils.JwtUtil;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * One-time password migration endpoint.
 *
 * Finds all NguoiDung rows whose matKhau is not yet BCrypt-hashed
 * and re-hashes them in place.
 *
 * Access: ADMIN only.
 * URL:    /admin/migrate-passwords
 *
 * Call this ONCE after deploying the JWT/BCrypt update.
 * It is idempotent — already-hashed passwords are skipped.
 */
@WebServlet(name = "MigratePasswordsServlet", urlPatterns = {"/admin/migrate-passwords"})
public class MigratePasswordsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Claims claims = (Claims) request.getAttribute("jwtClaims");
        if (claims == null || JwtUtil.getRole(claims) != Role.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "ADMIN only");
            return;
        }

        int migrated = new NguoiDungDAO().migratePasswordsToHash();

        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("Password migration complete.");
        out.println("Passwords migrated: " + migrated);
        out.println("Already-hashed passwords were skipped.");
    }
}
