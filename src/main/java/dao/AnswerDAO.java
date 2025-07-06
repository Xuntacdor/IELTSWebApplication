package dao;

import model.Answer;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AnswerDAO {

    // ✅ Thêm 1 đáp án
    public int insertAnswer(Answer answer) {
        String sql = "INSERT INTO Answers (question_id, answer_text, is_correct) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, answer.getQuestionId());
            ps.setString(2, answer.getAnswerText());
            ps.setBoolean(3, answer.isCorrect());
            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi insert Answer:");
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ Thêm nhiều đáp án
    public int insertAnswers(List<Answer> answers) {
        String sql = "INSERT INTO Answers (question_id, answer_text, is_correct) VALUES (?, ?, ?)";
        int total = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Answer answer : answers) {
                ps.setInt(1, answer.getQuestionId());
                ps.setString(2, answer.getAnswerText());
                ps.setBoolean(3, answer.isCorrect());
                ps.addBatch();
            }
            int[] result = ps.executeBatch();
            for (int r : result) total += r;
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi insert batch Answers:");
            e.printStackTrace();
        }
        return total;
    }

    // ✅ Lấy 1 đáp án đầu tiên
    public Answer getAnswerByQuestionId(int questionId) {
        String sql = "SELECT * FROM Answers WHERE question_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Answer a = new Answer();
                a.setAnswerId(rs.getInt("answer_id"));
                a.setQuestionId(rs.getInt("question_id"));
                a.setAnswerText(rs.getString("answer_text"));
                a.setCorrect(rs.getBoolean("is_correct"));
                return a;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Lấy toàn bộ đáp án theo question_id
    public List<Answer> getAnswersByQuestionId(int questionId) {
        List<Answer> list = new ArrayList<>();
        String sql = "SELECT * FROM Answers WHERE question_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Answer a = new Answer();
                a.setAnswerId(rs.getInt("answer_id"));
                a.setQuestionId(rs.getInt("question_id"));
                a.setAnswerText(rs.getString("answer_text"));
                a.setCorrect(rs.getBoolean("is_correct"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Lấy đáp án đúng của một câu hỏi
    public List<Answer> getCorrectAnswersByQuestionId(int questionId) {
        List<Answer> list = new ArrayList<>();
        String sql = "SELECT * FROM Answers WHERE question_id = ? AND is_correct = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Answer a = new Answer();
                a.setAnswerId(rs.getInt("answer_id"));
                a.setQuestionId(rs.getInt("question_id"));
                a.setAnswerText(rs.getString("answer_text"));
                a.setCorrect(true);
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Group tất cả các đáp án theo câu hỏi
    public Map<Integer, List<Answer>> getAllAnswersGroupedByQuestion() {
        Map<Integer, List<Answer>> map = new HashMap<>();
        String sql = "SELECT * FROM Answers";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int qId = rs.getInt("question_id");
                Answer a = new Answer();
                a.setAnswerId(rs.getInt("answer_id"));
                a.setQuestionId(qId);
                a.setAnswerText(rs.getString("answer_text"));
                a.setCorrect(rs.getBoolean("is_correct"));
                map.computeIfAbsent(qId, k -> new ArrayList<>()).add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public static void main(String[] args) {
        AnswerDAO dao = new AnswerDAO();
        Answer a = new Answer(40, "Sample Answer A");
        a.setCorrect(true);
        dao.insertAnswer(a);

        List<Answer> list = new ArrayList<>();
        list.add(new Answer(1, "Option A", true));
        list.add(new Answer(2, "Option B", false));
        list.add(new Answer(3, "Option C", false));
        dao.insertAnswers(list);

        System.out.println("✅ Inserted test answers.");
    }
}