package model;

import java.io.Serializable;
import java.time.LocalDate;

public class PracticeHistoryItem implements Serializable {
    private LocalDate completedAt;
    private String title;
    private String score;

    public PracticeHistoryItem() {
    }

    public PracticeHistoryItem(LocalDate completedAt, String title, String score) {
        this.completedAt = completedAt;
        this.title = title;
        this.score = score;
    }

    public LocalDate getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDate completedAt) {
        this.completedAt = completedAt;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getScore() {
        return score;
    }

    public void setScore(String score) {
        this.score = score;
    }

    @Override
    public String toString() {
        return "PracticeHistoryItem{" +
                "completedAt=" + completedAt +
                ", title='" + title + '\'' +
                ", score='" + score + '\'' +
                '}';
    }
}
