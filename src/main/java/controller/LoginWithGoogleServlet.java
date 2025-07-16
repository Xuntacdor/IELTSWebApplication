/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.GoogleUser;
import model.User;
import util.GoogleUtils;

@WebServlet(name = "LoginWithGoogleServlet", urlPatterns = {"/LoginWithGoogleServlet"})
public class LoginWithGoogleServlet extends HttpServlet {

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
           
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginWithGoogleServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginWithGoogleServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            response.sendRedirect("View/Login.jsp");
            return;
        }

        try {
            String accessToken = GoogleUtils.getToken(code);
            GoogleUser googleUser = GoogleUtils.getUserInfo(accessToken);

            // Kiểm tra user có trong DB chưa
            User user = UserDAO.getUserByEmail(googleUser.getEmail());
            if (user == null) {
                // Insert nếu chưa có
                user = UserDAO.insertGoogleUser(
                        googleUser.getEmail(),
                        googleUser.getFullName(),
                        googleUser.getPicture()
                );
            }

            if (user == null) {
                response.sendRedirect("View/Login.jsp?error=cannot_create_account");
                return;
            }

            // Login thành công
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            response.sendRedirect("View/Home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("View/Login.jsp?error=google_login_failed");
        }

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
