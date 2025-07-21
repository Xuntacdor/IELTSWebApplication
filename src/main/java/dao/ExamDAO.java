package dao;

import model.Exam;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDAO {

    public int insertExam(Exam exam) {
        String sql = "INSERT INTO Exams (title, description, type, created_at) VALUES (?, '', ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, exam.getTitle());
            stmt.setString(2, exam.getType());
            stmt.setTimestamp(3, exam.getCreatedAt());
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
                e.setCreatedAt(rs.getTimestamp("created_at"));
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
                e.setCreatedAt(rs.getTimestamp("created_at"));
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
                e.setCreatedAt(rs.getTimestamp("created_at"));
                e.setQuestionTypes(getQuestionTypesByExamId(e.getExamId()));
                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // getExamsByCategory dùng chung cột "type" (vì category không còn nữa)
    public List<Exam> getExamsByCategory(String categoryAsType) {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT * FROM Exams WHERE type = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryAsType);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
                e.setType(rs.getString("type"));
                e.setCreatedAt(rs.getTimestamp("created_at"));
                e.setQuestionTypes(getQuestionTypesByExamId(e.getExamId()));
                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

  public List<Exam> getExamsByCategoryWithPaging(String categoryAsType, int limit, int offset) {
    List<Exam> list = new ArrayList<>();
    String sql = "SELECT * FROM Exams WHERE type = ? ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, categoryAsType);
        ps.setInt(2, offset); // OFFSET đứng trước LIMIT trong SQL Server
        ps.setInt(3, limit);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Exam e = new Exam();
            e.setExamId(rs.getInt("exam_id"));
            e.setTitle(rs.getString("title"));
            e.setType(rs.getString("type"));
            e.setCreatedAt(rs.getTimestamp("created_at"));
            e.setQuestionTypes(getQuestionTypesByExamId(e.getExamId()));
            list.add(e);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}


    // Đếm tổng số đề theo category
    public int countExamsByCategory(String categoryAsType) {
        String sql = "SELECT COUNT(*) FROM Exams WHERE type = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryAsType);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

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

    public boolean deleteExam(int examId) {
        String sql = "DELETE FROM Exams WHERE exam_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateExam(Exam exam) {
        String sql = "UPDATE Exams SET title = ?, type = ? WHERE exam_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, exam.getTitle());
            ps.setString(2, exam.getType());
            ps.setInt(3, exam.getExamId());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
        ExamDAO dao = new ExamDAO();

        Exam newExam = new Exam();
        newExam.setTitle("Sample Exam " + System.currentTimeMillis());
        newExam.setType("READING_SINGLE"); 
        newExam.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        int newId = dao.insertExam(newExam);
        System.out.println("✅ Inserted Exam ID: " + newId);

       
    }
}
