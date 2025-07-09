package dao;

import model.Question;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import model.Answer;
import model.Exam;
import model.Passage;

public class QuestionDAO {

    public int insertQuestion(Question question) {
        String sql = "INSERT INTO Questions (passage_id, question_type, question_text, instruction, explanation, number_in_passage, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

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
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public List<Question> getQuestionsByExamId(int examId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT q.* FROM Questions q "
                + "JOIN Passages p ON q.passage_id = p.passage_id "
                + "WHERE p.exam_id = ? ORDER BY p.passage_id, q.number_in_passage";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public static void main(String[] args) {
        try {
            ExamDAO examDAO = new ExamDAO();
            PassageDAO passageDAO = new PassageDAO();
            QuestionDAO questionDAO = new QuestionDAO();
            AnswerDAO answerDAO = new AnswerDAO();

            // 1. Tạo đề thi
            Exam exam = new Exam();
            exam.setTitle("IELTS Reading - Matching Information");
            exam.setType("READING_SINGLE");
            int examId = examDAO.insertExam(exam);
            System.out.println("✅ Exam ID: " + examId);

            // 2. Tạo passage
            Passage passage = new Passage();
            passage.setExamId(examId);
            passage.setSection(1);
            passage.setTitle("Climate Change and Wildlife");
            passage.setContent("Section A\nClimate change has significantly affected polar bears...\n\n"
                    + "Section B\nDeforestation impacts biodiversity in rainforests...\n\n"
                    + "Section C\nRising sea levels threaten coastal ecosystems...");
            int passageId = passageDAO.insertPassage(passage);
            System.out.println("✅ Passage ID: " + passageId);

            // 3. Tạo câu hỏi Matching Information
            Question question = new Question();
            question.setPassageId(passageId);
            question.setQuestionType("MATCHING_INFORMATION");
            question.setQuestionText("Which section contains the following information?");
            question.setInstruction("Choose the correct section (A, B or C) for each statement.");
            int questionId = questionDAO.insertQuestion(question);
            System.out.println("✅ Question ID: " + questionId);

            // 4. Thêm đáp án (các lựa chọn A, B, C, D...)
            List<String> allOptions = Arrays.asList("A", "B", "C");
            for (String option : allOptions) {
                Answer a = new Answer();
                a.setQuestionId(questionId);
                a.setAnswerText(option);
                a.setCorrect(false); // option thôi, chưa phải đúng
                answerDAO.insertAnswer(a);
            }

            // 5. Thêm các câu đúng với section tương ứng
            List<String> correctStatements = Arrays.asList(
                    "A", // polar bears
                    "B", // biodiversity
                    "C" // rising sea levels
            );
            for (String correct : correctStatements) {
                Answer a = new Answer();
                a.setQuestionId(questionId);
                a.setAnswerText(correct);
                a.setCorrect(true);
                answerDAO.insertAnswer(a);
            }

            System.out.println("✅ Đề MATCHING_INFORMATION đã được tạo thành công!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
}
