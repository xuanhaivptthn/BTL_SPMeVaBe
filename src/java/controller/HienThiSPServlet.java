/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.*;
import model.*;

import model.SanPham;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author gmtfarcb
 */
@WebServlet(name = "HienThiSP", urlPatterns = {"/products"})
public class HienThiSPServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet HienThiSP</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HienThiSP at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
