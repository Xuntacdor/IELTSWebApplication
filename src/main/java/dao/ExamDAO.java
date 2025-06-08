package dao;

import Model.Exam;
import Utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDAO {

    public int insertExam(Exam exam) {
        String sql = "INSERT INTO Exams (title, description, type, created_at) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, exam.getTitle());
            stmt.setString(2, exam.getDescription() != null ? exam.getDescription() : "");
            stmt.setString(3, exam.getType());
            stmt.setTimestamp(4, exam.getCreatedAt());

            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Exam> getAllExams() {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT * FROM Exams ORDER BY created_at DESC";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setType(rs.getString("type"));
                e.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Exam getExamById(int examId) {
        String sql = "SELECT * FROM Exams WHERE exam_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setType(rs.getString("type"));
                e.setCreatedAt(rs.getTimestamp("created_at"));
                return e;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
