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

/**
 *
 * @author NTKC
 */
@WebServlet(name = "ApproveTopUpServlet", urlPatterns = {"/ApproveTopUpServlet"})
public class ApproveTopUpServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ApproveTopUpServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ApproveTopUpServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể redirect về trang chính nếu ai đó cố vào link này bằng GET
        response.sendRedirect(request.getContextPath() + "/admin/pending-topup");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        int amount = Integer.parseInt(request.getParameter("amount"));
        String action = request.getParameter("action");

        if ("approve".equals(action)) {
            PendingTopUpDAO.approveRequest(requestId, userId, amount);
            request.getSession().setAttribute("message", "✅ Duyệt thành công yêu cầu nạp " + amount + " CAM!");
        } else if ("reject".equals(action)) {
            PendingTopUpDAO.rejectRequest(requestId, userId, amount);
            request.getSession().setAttribute("message", "❌ Đã từ chối yêu cầu nạp " + amount + " CAM (chưa nhận được chuyển khoản).");
        }

        response.sendRedirect(request.getContextPath() + "/admin/pending-topup");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
