package controller;

import dao.*;
import model.*;

import dao.DonHangDAO;
import model.DonHang;
import model.NguoiDung;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/history"})
public class OrderHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        DonHangDAO dao = new DonHangDAO();
        List<DonHang> history = dao.getByKhachHangId(user.getId());
        
        request.setAttribute("history", history);
        request.getRequestDispatcher("/history.jsp").forward(request, response);
    }
}
