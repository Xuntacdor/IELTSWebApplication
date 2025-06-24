package model;

import java.sql.Timestamp;
import java.util.List;

public class Exam {
    private int examId;
    private String title;
    private String type;
    private String examCategory;
    private Timestamp createdAt;
    
    private List<String> questionTypes;

    public Exam() {
    }

    public Exam(int examId, String title, String type, String examCategory, Timestamp createdAt) {
        this.examId = examId;
        this.title = title;
        this.type = type;
        this.examCategory = examCategory;
        this.createdAt = createdAt;
    }

    public int getExamId() {
        return examId;
    }

    public void setExamId(int examId) {
        this.examId = examId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getExamCategory() {
        return examCategory;
    }

    public void setExamCategory(String examCategory) {
        this.examCategory = examCategory;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public List<String> getQuestionTypes() {
        return questionTypes;
    }

    public void setQuestionTypes(List<String> questionTypes) {
        this.questionTypes = questionTypes;
    }
    
}
