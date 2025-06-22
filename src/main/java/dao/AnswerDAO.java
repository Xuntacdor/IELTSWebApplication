package dao;

import model.Answer;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnswerDAO {

    public int insertAnswer(Answer answer) {
        String sql = "INSERT INTO Answers (question_id, answer_text) VALUES (?, ?)";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, answer.getQuestionId());
            ps.setString(2, answer.getAnswerText());
            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi insert Answer:");
            e.printStackTrace();
        }
        return 0;
    }

    public Answer getAnswerByQuestionId(int questionId) {
        String sql = "SELECT * FROM Answers WHERE question_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public List<Answer> getAnswersByQuestionId(int questionId) {
        List<Answer> list = new ArrayList<>();
        String sql = "SELECT * FROM Answers WHERE question_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
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

    // Trả về tất cả các đáp án đúng của một câu hỏi
    public List<Answer> getCorrectAnswersByQuestionId(int questionId) {
        List<Answer> list = new ArrayList<>();
        String sql = "SELECT * FROM Answers WHERE question_id = ? AND is_correct = TRUE";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
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

    // ✅ Thêm hàm test vào cuối class
    public static void main(String[] args) {
        AnswerDAO dao = new AnswerDAO();
        Answer a = new Answer();
        a.setQuestionId(40); // ID có thật
        a.setAnswerText("Test Answer\n");
        int result = dao.insertAnswer(a);
        System.out.println("Insert result: " + result);
    }
}
