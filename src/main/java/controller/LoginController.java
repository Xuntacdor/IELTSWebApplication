package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
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

        String remember = req.getParameter("rememberMe");

        User user = UserDAO.checkLogin(email, password);
        System.out.println("User object: " + user);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            // Remember Me logic
            // Luôn lưu email
            Cookie emailCookie = new Cookie("email", email);
            emailCookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
            resp.addCookie(emailCookie);

// Chỉ lưu password nếu tick Remember Me
            if ("on".equals(remember)) {
                Cookie passwordCookie = new Cookie("password", password);
                passwordCookie.setMaxAge(7 * 24 * 60 * 60);
                resp.addCookie(passwordCookie);
            } else {
                // Xóa password cookie nếu không nhớ mật khẩu
                Cookie passwordCookie = new Cookie("password", "");
                passwordCookie.setMaxAge(0);
                resp.addCookie(passwordCookie);
            }

            resp.sendRedirect("HomeServlet");
        } else {
            req.setAttribute("error", "Wrong user name or password!");
            req.getRequestDispatcher("View/Login.jsp").forward(req, resp);
        }
    }

    // Optional: handle GET để tự động điền lại email/password nếu có cookie
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("email".equals(cookie.getName())) {
                    req.setAttribute("email", cookie.getValue());
                }
                if ("password".equals(cookie.getName())) {
                    req.setAttribute("password", cookie.getValue());
                }
            }
        }
        req.getRequestDispatcher("View/Login.jsp").forward(req, resp);
    }
}
