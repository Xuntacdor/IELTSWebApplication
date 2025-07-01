package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        if (email != null) {
            email = email.trim();
        }

        String password = req.getParameter("password");
        if (password != null) {
            password = password.trim();
        }

        User user = UserDAO.checkLogin(email, password);
        System.out.println("User object: " + user);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole()); 
            resp.sendRedirect("HomeServlet");
        } else {
            req.setAttribute("error", "Wrong user name or password!");
            req.getRequestDispatcher("View/Login.jsp").forward(req, resp);
        }
    }

}
