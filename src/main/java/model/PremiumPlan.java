package model;

import java.io.Serializable;

public class PremiumPlan implements Serializable {
    private int id;
    private String name;
    private int camCost;
    private int durationInDays;

    public PremiumPlan() {
    }

    public PremiumPlan(int id, String name, int camCost, int durationInDays) {
        this.id = id;
        this.name = name;
        this.camCost = camCost;
        this.durationInDays = durationInDays;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCamCost() {
        return camCost;
    }

    public void setCamCost(int camCost) {
        this.camCost = camCost;
    }

    public int getDurationInDays() {
        return durationInDays;
    }

    public void setDurationInDays(int durationInDays) {
        this.durationInDays = durationInDays;
    }

    @Override
    public String toString() {
        return "PremiumPlan{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", camCost=" + camCost +
                ", durationInDays=" + durationInDays +
                '}';
    }
}
