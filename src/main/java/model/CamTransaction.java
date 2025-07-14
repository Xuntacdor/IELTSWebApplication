package model;

import java.io.Serializable;

public class CamTransaction implements Serializable {
    private int id;
    private int userId;
    private int amount;           // dương: nạp, âm: tiêu
    private String type;          // TOP_UP, BUY_PREMIUM...
    private String description;
    private String createdAt;     // để đơn giản bạn để String (hoặc java.sql.Timestamp nếu cần)

    public CamTransaction() {}

    public CamTransaction(int id, int userId, int amount, String type, String description, String createdAt) {
        this.id = id;
        this.userId = userId;
        this.amount = amount;
        this.type = type;
        this.description = description;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "CamTransaction{" +
                "id=" + id +
                ", userId=" + userId +
                ", amount=" + amount +
                ", type='" + type + '\'' +
                ", createdAt='" + createdAt + '\'' +
                '}';
    }
}