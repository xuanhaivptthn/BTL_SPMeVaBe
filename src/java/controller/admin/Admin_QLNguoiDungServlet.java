package controller.admin;

import dao.*;
import model.*;

import dao.NguoiDungDAO;
import model.NguoiDung;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/users"})
public class Admin_QLNguoiDungServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        NguoiDungDAO dao = new NguoiDungDAO();
        List<NguoiDung> list;
        if (search != null && !search.trim().isEmpty()) {
            list = dao.getFilteredUsers(search);
            request.setAttribute("search", search);
        } else {
            list = dao.getAll();
        }
        request.setAttribute("users", list);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        NguoiDungDAO dao = new NguoiDungDAO();

        if ("add".equals(action)) {
            String hoTen = request.getParameter("hoTen");
            String email = request.getParameter("email");
            String dienThoai = request.getParameter("dienThoai");
            String tenDangNhap = request.getParameter("tenDangNhap");
            String matKhau = request.getParameter("matKhau");
            String role = request.getParameter("role");
            String status = request.getParameter("status");

            NguoiDung nd = new NguoiDung();
            nd.setHoTen(hoTen);
            nd.setEmail(email);
            nd.setDienThoai(dienThoai);
            nd.setTenDangNhap(tenDangNhap);
            nd.setMatKhau(matKhau);
            nd.setRole(role);
            nd.setStatus(status);

            dao.insert(nd);
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String hoTen = request.getParameter("hoTen");
            String email = request.getParameter("email");
            String dienThoai = request.getParameter("dienThoai");
            String matKhau = request.getParameter("matKhau");
            String role = request.getParameter("role");
            String status = request.getParameter("status");

            NguoiDung nd = new NguoiDung();
            nd.setId(id);
            nd.setHoTen(hoTen);
            nd.setEmail(email);
            nd.setDienThoai(dienThoai);
            nd.setMatKhau(matKhau); // Có thể trống, DAO sẽ tự xử lý
            nd.setRole(role);
            nd.setStatus(status);

            dao.update(nd);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.delete(id);
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
