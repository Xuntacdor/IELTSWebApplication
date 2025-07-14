/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.CamPackageDAO;
import dao.CamTransactionDAO;
import dao.UserDAO;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.CamPackage;
import model.User;

/**
 *
 * @author NTKC
 */
@WebServlet(name = "TopUpServlet", urlPatterns = {"/TopUpServlet"})
public class TopUpServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TopUpServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TopUpServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CamPackage> packages = CamPackageDAO.getAllPackages();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);
        request.setAttribute("packages", packages);
        request.getRequestDispatcher("View/topup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int packageId = Integer.parseInt(request.getParameter("packageId"));
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        CamPackage camPackage = CamPackageDAO.getPackageById(packageId);

        if (camPackage != null && user != null) {
            // Calculate total CAM including bonus
            int totalCam = camPackage.getCamAmount() + camPackage.getBonus();
            
            // Cập nhật vào DB
            UserDAO.increaseCamBalance(user.getUserId(), totalCam);
            CamTransactionDAO.insertTransaction(user.getUserId(), totalCam, "TOP_UP", 
                "Nạp " + camPackage.getCamAmount() + " CAM" + 
                (camPackage.getBonus() > 0 ? " + " + camPackage.getBonus() + " Bonus" : ""));

            // Cập nhật lại session
            user.setCamBalance(user.getCamBalance() + totalCam);
            session.setAttribute("user", user);

            List<model.CamTransaction> transactions = CamTransactionDAO.getByUserId(user.getUserId());
            request.setAttribute("transactions", transactions);
            System.out.println("Số giao dịch: " + transactions.size());
            request.setAttribute("transactions", transactions);
            request.setAttribute("successMessage", "Nạp thành công " + totalCam + " CAM!");
            request.getRequestDispatcher("View/cam-wallet.jsp").forward(request, response);
            

        } else {
            response.sendRedirect("View/error.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
