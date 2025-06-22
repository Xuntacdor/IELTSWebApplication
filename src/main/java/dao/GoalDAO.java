
package dao;

import model.Goal;
import util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class GoalDAO {

    public static Goal getGoalByUserId(int userId) {
        Goal goal = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT goal_reading, goal_listening, goal_overall FROM UserGoals WHERE user_id = ?")) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                float r = rs.getFloat("goal_reading");
                float l = rs.getFloat("goal_listening");
                float o = rs.getFloat("goal_overall");
                goal = new Goal(r, l, o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return goal;
    }
    public static void main(String[] args) {
        Goal g =  GoalDAO.getGoalByUserId(3);
        System.out.println(g);
    }
}
