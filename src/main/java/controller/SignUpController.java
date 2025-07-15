package controller;

import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.UserDAO;

@WebServlet(name = "SignUpController", urlPatterns = {"/SignUpController"})
public class SignUpController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dateOfBirth");

        // Validate fields
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập họ và tên.");
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
            return;
        }
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email.");
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
            return;
        }
        if (password == null || password.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu.");
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
            return;
        }
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập lại mật khẩu.");
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
            return;
        }
        if (gender == null || gender.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn giới tính.");
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
            return;
        }
        if (dobStr == null || dobStr.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn ngày sinh.");
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
            return;
        }

        // Check if user already exists by email
        if (UserDAO.userExistsByEmail(email)) {
            request.setAttribute("error", "Email đã được sử dụng!");
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
            return;
        }

        try {
            java.time.LocalDate dob = java.time.LocalDate.parse(dobStr);
            java.sql.Date sqlDob = java.sql.Date.valueOf(dob);

            String sql = "INSERT INTO Users (full_name, email, password_hash, gender, date_of_birth) VALUES (?, ?, ?, ?, ?)";
            try (java.sql.Connection conn = util.DBConnection.getConnection(); java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, fullName);
                stmt.setString(2, email);
                stmt.setString(3, password); // TODO: hash password in production
                stmt.setString(4, gender);
                stmt.setDate(5, sqlDob);
                stmt.executeUpdate();
            }
            response.sendRedirect("View/Login.jsp");
        } catch (Exception e) {
            String msg = (e.getMessage() == null || e.getMessage().trim().isEmpty()) ? "Đăng ký thất bại. Vui lòng thử lại sau." : ("Đăng ký thất bại: " + e.getMessage());
            request.setAttribute("error", msg);
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
        }
    }
}
