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
import jakarta.servlet.http.HttpSession;
import model.User;
import dao.CamPackageDAO;
import model.CamPackage;

/**
 *
 * @author NTKC
 */
@WebServlet(name = "RequestTopUpServlet", urlPatterns = {"/RequestTopUpServlet"})
public class RequestTopUpServlet extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RequestTopUpServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RequestTopUpServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int packageId = Integer.parseInt(request.getParameter("packageId"));
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            CamPackage camPackage = CamPackageDAO.getPackageById(packageId);
            if (camPackage != null) {
                int totalCam = camPackage.getCamAmount() + camPackage.getBonus();
                PendingTopUpDAO.insertRequest(user.getUserId(), totalCam);
                request.setAttribute("successMessage", 
                    "Yêu cầu nạp " + totalCam + " CAM của bạn đã được ghi nhận. Admin sẽ xác nhận sớm!");
                request.getRequestDispatcher("View/cam-wallet.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Gói CAM không tồn tại!");
                request.getRequestDispatcher("View/cam-wallet.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("View/Home.jsp");
        }
    }

    
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
