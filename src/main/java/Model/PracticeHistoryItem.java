package Model;

import java.time.LocalDate;

public class PracticeHistoryItem {
    private LocalDate completedAt;
    private String title;
    private String score;

    // Getters and setters
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
        return "PracticeHistoryItem{" + "completedAt=" + completedAt + ", title=" + title + ", score=" + score + '}';
    }
    
}
