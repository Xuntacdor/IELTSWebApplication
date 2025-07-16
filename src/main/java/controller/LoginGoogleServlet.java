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

/**
 *
 * @author NTKC
 */
@WebServlet(name = "LoginGoogleServlet", urlPatterns = {"/LoginGoogleServlet"})
public class LoginGoogleServlet extends HttpServlet {

    private static final String CLIENT_ID = "305643623150-eemrjatu1fdgcgfrdo9knae36vajjja6.apps.googleusercontent.com";
    private static final String REDIRECT_URI = "http://localhost:9999/IELTSWebApplication/LoginWithGoogleServlet";
    private static final String SCOPE = "email%20profile";

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginGoogleServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginGoogleServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String oauthUrl = "https://accounts.google.com/o/oauth2/auth"
                + "?scope=" + SCOPE
                + "&redirect_uri=" + REDIRECT_URI
                + "&response_type=code"
                + "&client_id=" + CLIENT_ID
                + "&approval_prompt=force";

        response.sendRedirect(oauthUrl);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
