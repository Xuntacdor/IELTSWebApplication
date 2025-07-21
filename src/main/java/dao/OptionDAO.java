package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Option;
import util.DBConnection;

public class OptionDAO {

    private final String INSERT_SQL = "INSERT INTO Options (question_id, option_label, option_text, is_correct) VALUES (?, ?, ?, ?)";
    private final String SELECT_BY_QUESTION = "SELECT * FROM Options WHERE question_id = ?";

    public void insertOption(Option option) {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(INSERT_SQL)) {
            ps.setInt(1, option.getQuestionId());
            ps.setString(2, option.getOptionLabel());
            ps.setString(3, option.getOptionText());
            ps.setBoolean(4, option.isCorrect());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Option> getOptionsByQuestionId(int questionId) {
        List<Option> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(SELECT_BY_QUESTION)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Option opt = new Option();
                opt.setOptionId(rs.getInt("option_id"));
                opt.setQuestionId(rs.getInt("question_id"));
                opt.setOptionLabel(rs.getString("option_label"));
                opt.setOptionText(rs.getString("option_text"));
                opt.setIsCorrect(rs.getBoolean("is_correct"));
                list.add(opt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Option> getCorrectOptionsByQuestionId(int questionId) {
        List<Option> list = new ArrayList<>();
        String sql = "SELECT * FROM Options WHERE question_id = ? AND is_correct = 1";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Option o = new Option();
                o.setOptionId(rs.getInt("option_id"));
                o.setQuestionId(rs.getInt("question_id"));
                o.setOptionLabel(rs.getString("option_label"));
                o.setOptionText(rs.getString("option_text"));
                o.setIsCorrect(true);
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<Integer, List<Option>> getAllOptionsGroupedByQuestion() {
        Map<Integer, List<Option>> map = new HashMap<>();
        String sql = "SELECT * FROM Options";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int qId = rs.getInt("question_id");
                Option o = new Option();
                o.setOptionId(rs.getInt("option_id"));
                o.setQuestionId(qId);
                o.setOptionLabel(rs.getString("option_label"));
                o.setOptionText(rs.getString("option_text"));
                o.setIsCorrect(rs.getBoolean("is_correct"));

                map.computeIfAbsent(qId, k -> new ArrayList<>()).add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public boolean deleteOptionsByQuestionId(int questionId) {
        String sql = "DELETE FROM Options WHERE question_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateOption(Option option) {
        String sql = "UPDATE Options SET option_text = ?, is_correct = ? WHERE option_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, option.getOptionText());
            ps.setBoolean(2, option.isCorrect());
            ps.setInt(3, option.getOptionId());
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
