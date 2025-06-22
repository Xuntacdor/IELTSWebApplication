package dao;

import model.Passage;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PassageDAO {

    public int insertPassage(Passage passage) {
        String sql = "INSERT INTO Passages (title, content, audio_url, type, created_at, exam_id) VALUES (?, ?, ?, ?, ?, ?)";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, passage.getTitle());
            stmt.setString(2, passage.getContent());
            stmt.setString(3, passage.getAudioUrl());
            stmt.setString(4, passage.getType());
            stmt.setTimestamp(5, passage.getCreatedAt());
            stmt.setInt(6, passage.getExamId());

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

    public List<Passage> getPassagesByExamId(int examId) {
        List<Passage> list = new ArrayList<>();
        String sql = "SELECT * FROM Passages WHERE exam_id = ?";
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Passage p = new Passage();
                p.setPassageId(rs.getInt("passage_id"));
                p.setExamId(rs.getInt("exam_id"));
                p.setTitle(rs.getString("title"));
                p.setContent(rs.getString("content"));
                p.setAudioUrl(rs.getString("audio_url"));
                p.setType(rs.getString("type"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
