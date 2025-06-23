package model;

import java.io.Serializable;

public class Goal implements Serializable {
    private float goalReading;
    private float goalListening;
    private float goalOverall;

    public Goal() {
    }

    public Goal(float goalReading, float goalListening, float goalOverall) {
        this.goalReading = goalReading;
        this.goalListening = goalListening;
        this.goalOverall = goalOverall;
    }

    public float getGoalReading() {
        return goalReading;
    }

    public void setGoalReading(float goalReading) {
        this.goalReading = goalReading;
    }

    public float getGoalListening() {
        return goalListening;
    }

    public void setGoalListening(float goalListening) {
        this.goalListening = goalListening;
    }

    public float getGoalOverall() {
        return goalOverall;
    }

    public void setGoalOverall(float goalOverall) {
        this.goalOverall = goalOverall;
    }

    @Override
    public String toString() {
        return "Goal{" +
                "goalReading=" + goalReading +
                ", goalListening=" + goalListening +
                ", goalOverall=" + goalOverall +
                '}';
    }
}
