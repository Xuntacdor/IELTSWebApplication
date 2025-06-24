package dao;

import model.Exam;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDAO {

    public int insertExam(Exam exam) {
        String sql = "INSERT INTO Exams (title, description, type, exam_category, created_at) VALUES (?, '', ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, exam.getTitle());
            stmt.setString(2, exam.getType());
            stmt.setString(3, exam.getExamCategory());
            stmt.setTimestamp(4, exam.getCreatedAt());
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Exam> getAllExams() {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT * FROM Exams ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
                e.setType(rs.getString("type"));
                e.setExamCategory(rs.getString("exam_category"));
                e.setCreatedAt(rs.getTimestamp("created_at"));

                // Gán questionTypes cho exam (nếu muốn)
                e.setQuestionTypes(getQuestionTypesByExamId(e.getExamId()));

                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Exam getExamById(int examId) {
        String sql = "SELECT * FROM Exams WHERE exam_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
                e.setType(rs.getString("type"));
                e.setExamCategory(rs.getString("exam_category"));
                e.setCreatedAt(rs.getTimestamp("created_at"));

                // Gán questionTypes nếu cần
                e.setQuestionTypes(getQuestionTypesByExamId(examId));

                return e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Exam> getExamsByType(String type) {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT * FROM Exams WHERE type = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
                e.setType(rs.getString("type"));
                e.setExamCategory(rs.getString("exam_category"));
                e.setCreatedAt(rs.getTimestamp("created_at"));

                // Gán questionTypes nếu muốn
                e.setQuestionTypes(getQuestionTypesByExamId(e.getExamId()));

                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Exam> getExamsByCategory(String category) {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT * FROM Exams WHERE exam_category = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
                e.setType(rs.getString("type"));
                e.setExamCategory(rs.getString("exam_category"));
                e.setCreatedAt(rs.getTimestamp("created_at"));

                // ✅ Gán loại câu hỏi cho mỗi exam
                e.setQuestionTypes(getQuestionTypesByExamId(e.getExamId()));

                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ NEW: Lấy danh sách loại câu hỏi theo examId
    public List<String> getQuestionTypesByExamId(int examId) {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT question_type FROM Questions " +
                     "WHERE passage_id IN (SELECT passage_id FROM Passages WHERE exam_id = ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                types.add(rs.getString("question_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return types;
    }
}
