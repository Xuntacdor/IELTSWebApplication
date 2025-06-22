package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;
import model.PracticeHistoryItem;
import java.util.HashMap;
import java.util.Map;

public class UserProgressDAO {

    public static List<LocalDate> getSubmittedDatesByUser(int userId) {
        List<LocalDate> dates = new ArrayList<>();
        String sql = "SELECT completed_at FROM UserProgress WHERE user_id = ? AND completed_at IS NOT NULL";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Timestamp ts = rs.getTimestamp("completed_at");
                if (ts != null) {
                    dates.add(ts.toLocalDateTime().toLocalDate());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return dates;
    }

    public static List<PracticeHistoryItem> getPracticeHistory(int userId) {
        List<PracticeHistoryItem> history = new ArrayList<>();
        String sql = "SELECT up.completed_at, e.title, up.score "
                + "FROM UserProgress up JOIN Exams e ON up.exam_id = e.exam_id "
                + "WHERE up.user_id = ? AND up.completed_at IS NOT NULL "
                + "ORDER BY up.completed_at DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PracticeHistoryItem item = new PracticeHistoryItem();
                item.setCompletedAt(rs.getTimestamp("completed_at").toLocalDateTime().toLocalDate());
                item.setTitle(rs.getString("title"));
                item.setScore(rs.getString("score"));
                history.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return history;
    }

    public static Map<String, Float> getAverageScoreByType(int userId) {
        Map<String, Float> result = new HashMap<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT type, AVG(score) AS avg_score "
                    + "FROM UserProgress "
                    + "WHERE user_id = ? "
                    + "GROUP BY type";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String type = rs.getString("type"); // e.g. "Reading", "Listening"
                        float score = rs.getFloat("avg_score"); // alias phải đúng
                        if (!rs.wasNull()) {
                            result.put(type, score);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public static void main(String[] args) {
        Map<String, Float> map = UserProgressDAO.getAverageScoreByType(3);
        System.out.println(map);
    }
}
