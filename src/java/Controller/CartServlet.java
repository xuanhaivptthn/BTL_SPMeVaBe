package Controller;

import Model.SanPham;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        Model.NguoiDung user = (Model.NguoiDung) session.getAttribute("user");
        if (user == null || "ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
            session.setAttribute("redirectAfterLogin", "/cart");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        java.util.List<Model.CartItem> cartProducts = new java.util.ArrayList<>();
        double totalPrice = 0;
        
        if (cart != null && !cart.isEmpty()) {
            Controller.SanPhamDAO dao = new Controller.SanPhamDAO();
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                Model.SanPham sp = dao.getById(entry.getKey());
                if (sp != null) {
                    cartProducts.add(new Model.CartItem(sp, entry.getValue()));
                    totalPrice += sp.getGiaTien() * entry.getValue();
                }
            }
        }
        
        request.setAttribute("cartProducts", cartProducts);
        request.setAttribute("totalPrice", totalPrice);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Cart map: productId -> quantity
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        if ("add".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cart.put(productId, cart.getOrDefault(productId, 0) + quantity);
            } catch (NumberFormatException e) {
                // Ignore
            }
        } else if ("update".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (quantity <= 0) {
                    cart.remove(productId);
                } else {
                    cart.put(productId, quantity);
                }
            } catch (NumberFormatException e) {
                // Ignore
            }
        } else if ("remove".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                cart.remove(productId);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        Model.NguoiDung user = (Model.NguoiDung) session.getAttribute("user");
        if (user == null || "ADMIN".equals(user.getRole()) || "STAFF".equals(user.getRole())) {
            session.setAttribute("redirectAfterLogin", "/cart");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
