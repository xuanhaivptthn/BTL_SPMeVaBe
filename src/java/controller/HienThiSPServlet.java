package controller;

import dao.*;
import model.*;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name = "HienThiSP", urlPatterns = {"/products"})
public class HienThiSPServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String[] categories = request.getParameterValues("category");
        String[] brands = request.getParameterValues("brand");
        String sort = request.getParameter("sort");

        int pageSize = 12;
        int currentPage = 1;
        try {
            String p = request.getParameter("page");
            if (p != null && !p.isEmpty()) {
                currentPage = Math.max(1, Integer.parseInt(p));
            }
        } catch (NumberFormatException ignored) {}

        SanPhamDAO dao = new SanPhamDAO();
        List<SanPham> allProducts = dao.getFilteredProducts(search, categories, brands, sort);

        int totalProducts = allProducts.size();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        if (totalPages < 1) totalPages = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalProducts);
        List<SanPham> pagedList = (fromIndex < totalProducts) ? allProducts.subList(fromIndex, toIndex) : new java.util.ArrayList<>();

        List<String> selectedCategories = (categories != null) ? java.util.Arrays.asList(categories) : new java.util.ArrayList<>();
        List<String> selectedBrands = (brands != null) ? java.util.Arrays.asList(brands) : new java.util.ArrayList<>();

        request.setAttribute("products", pagedList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("selectedCategories", selectedCategories);
        request.setAttribute("selectedBrands", selectedBrands);
        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

