/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PendingTopUp;

import util.DBConnection;

/**
 *
 * @author NTKC
 */
public class PendingTopUpDAO {

    public static void insertRequest(int userId, int amount) {
        String sql = "INSERT INTO PendingTopUp (user_id, amount) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, amount);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static List<PendingTopUp> getAllPending() {
        List<PendingTopUp> list = new ArrayList<>();
        String sql = "SELECT * FROM PendingTopUp WHERE status = 'PENDING'";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PendingTopUp p = new PendingTopUp(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getInt("amount"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("approved_at")
                );
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void approveRequest(int requestId, int userId, int amount) {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // ✅ 1. Update trạng thái yêu cầu nạp
            String sql1 = "UPDATE PendingTopUp SET status='APPROVED', approved_at=GETDATE() WHERE id=?";
            try (PreparedStatement ps1 = con.prepareStatement(sql1)) {
                ps1.setInt(1, requestId);
                ps1.executeUpdate();
            }

            // ✅ 2. Cộng CAM vào tài khoản user
            String sql2 = "UPDATE Users SET cam_balance = cam_balance + ? WHERE user_id=?";
            try (PreparedStatement ps2 = con.prepareStatement(sql2)) {
                ps2.setInt(1, amount);
                ps2.setInt(2, userId);  // cột id, không phải user_id
                ps2.executeUpdate();
            }

            // ✅ 3. Ghi log giao dịch
            String sql3 = "INSERT INTO CamTransactions (user_id, amount, type, description, created_at) VALUES (?, ?, 'TOP_UP', ?, GETDATE())";
            try (PreparedStatement ps3 = con.prepareStatement(sql3)) {
                ps3.setInt(1, userId);
                ps3.setInt(2, amount);
                ps3.setString(3, "Nạp CAM qua chuyển khoản thủ công");
                ps3.executeUpdate();
            }

            con.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void rejectRequest(int requestId, int userId, int amount) {
        try (Connection con = DBConnection.getConnection()) {
            // 1. Cập nhật trạng thái
            String sql = "UPDATE PendingTopUp SET status = 'REJECTED', approved_at = GETDATE() WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, requestId);
                ps.executeUpdate();
            }

            // 2. Ghi log
            String logSql = "INSERT INTO CamTransactions (user_id, amount, type, description, created_at) VALUES (?, ?, 'REJECTED', ?, GETDATE())";
            try (PreparedStatement ps = con.prepareStatement(logSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, amount);
                ps.setString(3, "Yêu cầu nạp CAM bị từ chối: chưa nhận được chuyển khoản.");
                ps.executeUpdate();
            }

            // 3. Lấy email người dùng để gửi thông báo
            String email = null;
            String fullName = null;
            String query = "SELECT email, full_name FROM Users WHERE user_id = ?";
            try (PreparedStatement ps = con.prepareStatement(query)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    email = rs.getString("email");
                    fullName = rs.getString("full_name");
                }
            }

            if (email != null) {
                String subject = "Yêu cầu nạp CAM của bạn đã bị từ chối";
                String body = "Xin chào " + fullName + ",\n\n"
                        + "Yêu cầu nạp " + amount + " CAM của bạn đã bị từ chối vì chưa nhận được chuyển khoản.\n"
                        + "Nếu bạn đã chuyển khoản, vui lòng liên hệ với quản trị viên để xác nhận thủ công.\n\n"
                        + "Trân trọng,\nIELTSWebApp CAM Support Team";

                util.EmailUtil.sendEmail(email, subject, body);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
