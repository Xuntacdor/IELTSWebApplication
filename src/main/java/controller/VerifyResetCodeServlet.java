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
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author NTKC
 */
@WebServlet(name = "VerifyResetCodeServlet", urlPatterns = {"/VerifyResetCodeServlet"})
public class VerifyResetCodeServlet extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
          
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet VerifyResetCodeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VerifyResetCodeServlet at " + request.getContextPath() + "</h1>");
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
        String codeInput = request.getParameter("code");
        HttpSession session = request.getSession();
        String correctCode = (String) session.getAttribute("reset_code");

        if (correctCode != null && codeInput.equals(correctCode)) {
            response.sendRedirect("View/reset-password.jsp");
        } else {
            request.setAttribute("error", "Verification code is incorrect!");
            request.getRequestDispatcher("View/verify-reset-code.jsp").forward(request, response);
        }
    }

   
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
