package controller.auth;

import dao.*;
import model.*;

import dao.KhachHangDAO;
import model.KhachHang;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String hoTen = request.getParameter("hoTen");
        String email = request.getParameter("email");
        String dienThoai = request.getParameter("dienThoai");
        String tenDangNhap = request.getParameter("tenDangNhap");
        String matKhau = request.getParameter("matKhau");
        String matKhau1 = request.getParameter("matKhau1");

        if (matKhau != null && !matKhau.equals(matKhau1)) {
            request.setAttribute("error", "Mật khẩu nhập lại không trùng khớp.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        KhachHang k = new KhachHang();
        k.setHoTen(hoTen);
        k.setEmail(email);
        k.setDienThoai(dienThoai);
        k.setTenDangNhap(tenDangNhap);
        k.setMatKhau(matKhau);
        k.setDiemTichLuy(0);

        KhachHangDAO dao = new KhachHangDAO();
        if (dao.insert(k)) {
            response.sendRedirect(request.getContextPath() + "/login?msg=success");
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Tên đăng nhập hoặc email có thể đã tồn tại.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
