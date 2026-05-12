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

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
