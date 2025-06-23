package dao;

import model.Exam;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDAO {

    public int insertExam(Exam exam) {
        String sql = "INSERT INTO Exams (title, description, type, created_at) VALUES (?, '', ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
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
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
                e.setType(rs.getString("type"));
                e.setCreatedAt(rs.getTimestamp("created_at"));
                return e;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // ✅ Bắt đầu transaction test

            ExamDAO dao = new ExamDAO();

            // ✅ 1. Insert exam test
            Exam testExam = new Exam();
            testExam.setTitle("Sample Test Exam");
            testExam.setType("Listening");
            testExam.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            int insertedId = dao.insertExam(testExam);
            System.out.println("✅ Inserted Exam ID: " + insertedId);

            // ✅ 2. Get exam by ID
            Exam fetchedExam = dao.getExamById(insertedId);
            if (fetchedExam != null) {
                System.out.println("✅ Fetched Exam Title: " + fetchedExam.getTitle());
            } else {
                System.out.println("❌ Failed to fetch exam by ID.");
            }

            // ✅ 3. Get all exams
            List<Exam> examList = dao.getAllExams();
            System.out.println("✅ Total Exams Found: " + examList.size());
            for (Exam e : examList) {
                System.out.println("   - " + e.getExamId() + ": " + e.getTitle() + " [" + e.getType() + "]");
            }

            // ✅ Rollback transaction to avoid affecting DB
            conn.rollback();
            System.out.println("🧹 Rolled back successfully — DB remains unchanged.");

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    public List<Exam> getExamsByType(String type) {
        List<Exam> list = new ArrayList<>();
        String sql = "SELECT * FROM Exams WHERE type = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Exam e = new Exam();
                e.setExamId(rs.getInt("exam_id"));
                e.setTitle(rs.getString("title"));
                e.setType(rs.getString("type"));
                e.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
