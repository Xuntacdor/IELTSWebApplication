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

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Confirm password does not match!");
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
            return;
        }

        try {
            LocalDate dob = LocalDate.parse(dobStr);
            Date sqlDob = Date.valueOf(dob);

            String sql = "INSERT INTO Users (full_name, email, password_hash, gender, date_of_birth) VALUES (?, ?, ?, ?, ?)";
            try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, fullName);
                stmt.setString(2, email);
                stmt.setString(3, password); 
                stmt.setString(4, gender);
                stmt.setDate(5, sqlDob);
                stmt.executeUpdate();
            }

            response.sendRedirect("View/Login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("/View/SignUp.jsp").forward(request, response);
        }
    }
}
