package dao;

import model.CamTransaction;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CamTransactionDAO {

    // Thêm 1 giao dịch mới
    public static boolean insertTransaction(CamTransaction ct) {
        String sql = "INSERT INTO CamTransactions (user_id, amount, type, description, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ct.getUserId());
            stmt.setInt(2, ct.getAmount());
            stmt.setString(3, ct.getType());
            stmt.setString(4, ct.getDescription());

            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public static boolean insertTransaction(int userId, int amount, String type, String description) {
        CamTransaction ct = new CamTransaction();
        ct.setUserId(userId);
        ct.setAmount(amount);
        ct.setType(type);
        ct.setDescription(description);
        return insertTransaction(ct);
    }

    // Lấy danh sách giao dịch của 1 user
    public static List<CamTransaction> getTransactionsByUser(int userId) {
        List<CamTransaction> list = new ArrayList<>();
        String sql = "SELECT * FROM CamTransactions WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CamTransaction ct = new CamTransaction();
                    ct.setId(rs.getInt("id"));
                    ct.setUserId(rs.getInt("user_id"));
                    ct.setAmount(rs.getInt("amount"));
                    ct.setType(rs.getString("type"));
                    ct.setDescription(rs.getString("description"));
                    ct.setCreatedAt(rs.getString("created_at"));
                    list.add(ct);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy tổng số CAM đã nạp của user
    public static int getTotalTopUp(int userId) {
        String sql = "SELECT SUM(amount) AS total FROM CamTransactions WHERE user_id = ? AND amount > 0";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy tổng CAM đã tiêu
    public static int getTotalSpent(int userId) {
        String sql = "SELECT SUM(amount) AS total FROM CamTransactions WHERE user_id = ? AND amount < 0";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public static List<CamTransaction> getByUserId(int userId) {
    List<CamTransaction> list = new ArrayList<>();
    String sql = "SELECT * FROM CamTransactions WHERE user_id = ? ORDER BY created_at DESC";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            CamTransaction trans = new CamTransaction();
            trans.setId(rs.getInt("id"));
            trans.setUserId(rs.getInt("user_id"));
            trans.setAmount(rs.getInt("amount"));
            trans.setType(rs.getString("type"));
            trans.setDescription(rs.getString("description"));
            trans.setCreatedAt(rs.getString("created_at")); 

            list.add(trans);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}



}
