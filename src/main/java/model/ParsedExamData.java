package model;

import java.util.List;

public class ParsedExamData {
    private Exam exam;
    private List<Passage> passages;
    private List<Question> questions;

    public Exam getExam() { return exam; }
    public void setExam(Exam exam) { this.exam = exam; }

    public List<Passage> getPassages() { return passages; }
    public void setPassages(List<Passage> passages) { this.passages = passages; }

    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }
    
    
}