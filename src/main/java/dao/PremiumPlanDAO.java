package dao;

import model.PremiumPlan;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PremiumPlanDAO {

    public static List<PremiumPlan> getAllPlans() {
        List<PremiumPlan> list = new ArrayList<>();
        String sql = "SELECT * FROM PremiumPlans";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                PremiumPlan plan = new PremiumPlan();
                plan.setId(rs.getInt("id"));
                plan.setName(rs.getString("name"));
                plan.setCamCost(rs.getInt("camCost"));
                plan.setDurationInDays(rs.getInt("durationInDays"));
                list.add(plan);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy gói theo ID
    public static PremiumPlan getPlanById(int id) {
        String sql = "SELECT * FROM PremiumPlans WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    PremiumPlan plan = new PremiumPlan();
                    plan.setId(rs.getInt("id"));
                    plan.setName(rs.getString("name"));
                    plan.setCamCost(rs.getInt("camCost"));
                    plan.setDurationInDays(rs.getInt("durationInDays"));
                    return plan;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
