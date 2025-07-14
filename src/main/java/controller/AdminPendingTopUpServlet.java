/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.PendingTopUpDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.PendingTopUp;

/**
 *
 * @author NTKC
 */
@WebServlet(name = "AdminPendingTopUpServlet", urlPatterns = {"/admin/pending-topup"})
public class AdminPendingTopUpServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminPendingTopUpServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminPendingTopUpServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PendingTopUp> pendingList = PendingTopUpDAO.getAllPending();
        request.setAttribute("pendingList", pendingList);

        // Đọc message nếu có (từ session) để hiển thị
        String message = (String) request.getSession().getAttribute("message");
        if (message != null) {
            request.setAttribute("message", message);
            request.getSession().removeAttribute("message");
        }

        request.getRequestDispatcher("/View/pending-topup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Không dùng processRequest nữa
        response.sendRedirect(request.getContextPath() + "/admin/pending-topup");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
