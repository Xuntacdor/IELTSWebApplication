package dao;

import model.Passage;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PassageDAO {

    public int insertPassage(Passage passage) {
        String sql = "INSERT INTO Passages (exam_id, title, content, type, audio_url, created_at, section) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, passage.getExamId());
            ps.setString(2, passage.getTitle());
            ps.setString(3, passage.getContent());
            ps.setString(4, passage.getType());
            ps.setString(5, passage.getAudioUrl());
            ps.setTimestamp(6, passage.getCreatedAt());
            ps.setInt(7, passage.getSection());

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi khi insert passage:");
            e.printStackTrace();
        }
        return -1;
    }

    public List<Passage> getPassagesByExamId(int examId) {
        List<Passage> list = new ArrayList<>();
        String sql = "SELECT * FROM Passages WHERE exam_id = ? ORDER BY section ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
                p.setSection(rs.getInt("section"));
                list.add(p);
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi khi lấy passage theo exam_id:");
            e.printStackTrace();
        }
        return list;
    }

    public Passage getPassageById(int id) {
        String sql = "SELECT * FROM Passages WHERE passage_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Passage p = new Passage();
                p.setPassageId(rs.getInt("passage_id"));
                p.setExamId(rs.getInt("exam_id"));
                p.setTitle(rs.getString("title"));
                p.setContent(rs.getString("content"));
                p.setAudioUrl(rs.getString("audio_url"));
                p.setType(rs.getString("type"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setSection(rs.getInt("section"));
                return p;
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi khi lấy passage theo id:");
            e.printStackTrace();
        }
        return null;
    }
}
