package dao;

import model.Question;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    public int insertQuestion(Question question) {
        String sql = "INSERT INTO Questions (passage_id, question_type, question_text, instruction, explanation, number_in_passage, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, question.getPassageId());
            stmt.setString(2, question.getQuestionType());
            stmt.setString(3, question.getQuestionText());
            stmt.setString(4, question.getInstruction());
            stmt.setString(5, question.getExplanation());
            stmt.setInt(6, question.getNumberInPassage());
            stmt.setString(7, question.getImageUrl());

            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi INSERT vào bảng Questions:");
            e.printStackTrace();
        }
        return -1;
    }

    public List<Question> getQuestionsByPassageId(int passageId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Questions WHERE passage_id = ? ORDER BY number_in_passage";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, passageId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setPassageId(rs.getInt("passage_id"));
                q.setQuestionType(rs.getString("question_type"));
                q.setQuestionText(rs.getString("question_text"));
                q.setInstruction(rs.getString("instruction"));
                q.setExplanation(rs.getString("explanation"));
                q.setNumberInPassage(rs.getInt("number_in_passage"));
                q.setImageUrl(rs.getString("image_url"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả câu hỏi của bài thi
    public List<Question> getQuestionsByExamId(int examId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.* FROM Questions q "
                + "JOIN Passages p ON q.passage_id = p.passage_id "
                + "WHERE p.exam_id = ? ORDER BY p.passage_id, q.number_in_passage";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setQuestionId(rs.getInt("question_id"));
                q.setPassageId(rs.getInt("passage_id"));
                q.setQuestionType(rs.getString("question_type"));
                q.setQuestionText(rs.getString("question_text"));
                q.setInstruction(rs.getString("instruction"));
                q.setExplanation(rs.getString("explanation"));
                q.setNumberInPassage(rs.getInt("number_in_passage"));
                q.setImageUrl(rs.getString("image_url"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
