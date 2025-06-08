package dao;

import Model.Answer;
import Utils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnswerDAO {

    // ✅ Thêm 1 answer
    public int insertAnswer(Answer answer) {
        String sql = "INSERT INTO Answers (question_id, answer_text) VALUES (?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, answer.getQuestionId());
            ps.setString(2, answer.getAnswerText());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi insert Answer:");
            e.printStackTrace();
        }
        return -1;
    }

    // ✅ Lấy 1 answer duy nhất theo questionId (nếu chỉ có 1 dòng)
    public Answer getAnswerByQuestionId(int questionId) {
        String sql = "SELECT * FROM Answers WHERE question_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Answer a = new Answer();
                a.setAnswerId(rs.getInt("answer_id"));
                a.setQuestionId(rs.getInt("question_id"));
                a.setAnswerText(rs.getString("answer_text"));
                return a;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Lấy danh sách answer (nhiều dòng) theo questionId
    public List<Answer> getAnswersByQuestionId(int questionId) {
        List<Answer> list = new ArrayList<>();
        String sql = "SELECT * FROM Answers WHERE question_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Answer a = new Answer();
                a.setAnswerId(rs.getInt("answer_id"));
                a.setQuestionId(rs.getInt("question_id"));
                a.setAnswerText(rs.getString("answer_text"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Xóa hết answer của 1 questionId
    public int deleteAnswersByQuestionId(int questionId) {
        String sql = "DELETE FROM Answers WHERE question_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi xóa answer:");
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ Cập nhật nội dung 1 answer
    public int updateAnswer(Answer answer) {
        String sql = "UPDATE Answers SET answer_text = ? WHERE answer_id = ?";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, answer.getAnswerText());
            ps.setInt(2, answer.getAnswerId());
            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi update answer:");
            e.printStackTrace();
        }
        return 0;
    }

  
}
