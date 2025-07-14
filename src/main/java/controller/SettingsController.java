package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "SettingsServlet", urlPatterns = {"/SettingsServlet"})
public class SettingsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("View/settings.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect("Login.jsp");
            return;
        }
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        user.setFullName(fullName);
        user.setEmail(email);
        boolean success = UserDAO.updateUser(user);
        if (success) {
            session.setAttribute("user", user);
            req.setAttribute("message", "Cập nhật thành công!");
        } else {
            req.setAttribute("message", "Cập nhật thất bại!");
        }
        req.getRequestDispatcher("View/settings.jsp").forward(req, resp);
    }
} 