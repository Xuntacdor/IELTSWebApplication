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
import util.EmailUtil;


@WebServlet(name = "SendResetCodeServlet", urlPatterns = {"/SendResetCodeServlet"})
public class SendResetCodeServlet extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
           
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SendResetCodeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SendResetCodeServlet at " + request.getContextPath() + "</h1>");
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

        request.setCharacterEncoding("UTF-8"); // đảm bảo đọc tiếng Việt chuẩn
        String email = request.getParameter("email");
        String captcha = request.getParameter("captcha");

        HttpSession session = request.getSession();
        String captchaExpected = (String) session.getAttribute("captcha_code");

        // Kiểm tra CAPTCHA
        if (captchaExpected == null || !captcha.equalsIgnoreCase(captchaExpected)) {
            request.setAttribute("error", "Mã xác thực không đúng. Vui lòng thử lại.");
            request.getRequestDispatcher("/View/forgot-password.jsp").forward(request, response);
            return;
        }

        // Sinh mã xác nhận
        String code = String.valueOf((int) (Math.random() * 900000 + 100000));
        session.setAttribute("reset_code", code);
        session.setAttribute("reset_email", email);

        // Soạn và gửi email
        String subject = "Reset Your Password - IELTSWebApp CAM";
        String body = "Hello,\n\nYour password reset code is: " + code +
                      "\n\nPlease enter this code to reset your password.\n\nThanks,\nIELTSWebApp CAM Support";

        try {
            EmailUtil.sendEmail(email, subject, body);
            // Chuyển tới trang nhập mã
            response.sendRedirect(request.getContextPath() + "/View/verify-reset-code.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/View/forgot-password.jsp").forward(request, response);
        }
    }

   
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
