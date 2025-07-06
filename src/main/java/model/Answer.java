package model;

public class Answer {
    private int answerId;
    private int questionId;
    private String answerText;
    private boolean isCorrect;  // ✅ Mới thêm

    // Constructor đầy đủ
    public Answer(int answerId, int questionId, String answerText, boolean isCorrect) {
        this.answerId = answerId;
        this.questionId = questionId;
        this.answerText = answerText;
        this.isCorrect = isCorrect;
    }

    // Constructor để insert: không cần answerId
    public Answer(int questionId, String answerText, boolean isCorrect) {
        this.questionId = questionId;
        this.answerText = answerText;
        this.isCorrect = isCorrect;
    }

    // Constructor cơ bản (không có isCorrect)
    public Answer(int questionId, String answerText) {
        this.questionId = questionId;
        this.answerText = answerText;
    }

    // Constructor rỗng
    public Answer() {}

    public int getAnswerId() {
        return answerId;
    }

    public void setAnswerId(int answerId) {
        this.answerId = answerId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getAnswerText() {
        return answerText;
    }

    public void setAnswerText(String answerText) {
        this.answerText = answerText;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }
}