package Utils;

import Model.User;
import java.sql.*;

public class UserDAO {

    public static User checkLogin(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
        try (Connection conn = DBUtils.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setRole(rs.getString("role")); 
                    System.out.println("LOGIN THÀNH CÔNG");
                    return user;
                }
            }
            System.out.println("KHÔNG TÌM THẤY NGƯỜI DÙNG");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public static void insertUser(String fullName, String email, String password, String gender, String dob){
        String sql = "INSERT INTO Users (full_name, email, password_hash, gender, date_of_birth) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBUtils.getConnection()){
            PreparedStatement stm = con.prepareStatement(sql);
            stm.setString(1, fullName);
            stm.setString(2, email);
            stm.setString(3, password);
            stm.setString(4, gender);
            stm.setString(5, dob);

            
            
            
        } catch (Exception e) {
        }
    }
    public static void main(String[] args) {
        User user = checkLogin("hmquang9805@gmail.com", "admin");
        System.out.println(user.getRole());
        System.out.println(user);
    }

}
