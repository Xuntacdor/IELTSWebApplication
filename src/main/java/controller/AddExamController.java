package controller;

import dao.*;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

@WebServlet(name = "AddExamServlet", urlPatterns = {"/AddExamServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024)
public class AddExamController extends HttpServlet {

    private final ExamDAO examDAO = new ExamDAO();
    private final PassageDAO passageDAO = new PassageDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final OptionDAO optionDAO = new OptionDAO();
    private final AnswerDAO answerDAO = new AnswerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String examTitle = request.getParameter("examTitle");
        if (examTitle == null || examTitle.trim().isEmpty()) {
            response.sendRedirect("addReadingTest.jsp?error=MissingExamTitle");
            return;
        }

        Exam exam = new Exam();
        exam.setTitle(examTitle);
        exam.setType("READING");
        exam.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        int examId = examDAO.insertExam(exam);

        for (int s = 1;; s++) {
            String sectionTitle = request.getParameter("sectionTitle" + s);
            String sectionContent = request.getParameter("sectionContent" + s);
            if (sectionTitle == null && sectionContent == null) {
                break;
            }

            Passage passage = new Passage();
            passage.setTitle(sectionTitle);
            passage.setContent(sectionContent);
            passage.setType("READING");
            passage.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            passage.setExamId(examId);
            int passageId = passageDAO.insertPassage(passage);

            for (int q = 1;; q++) {
                String questionType = request.getParameter("type_s" + s + "_q" + q);
                if (questionType == null) {
                    break;
                }

                String instruction = request.getParameter("instruction_s" + s + "_q" + q);

                String imageUrl = "";
                Part imagePart = request.getPart("image_s" + s + "_q" + q);
                if (imagePart != null && imagePart.getSize() > 0) {
                    String rawName = imagePart.getSubmittedFileName();
                    String fileName = "section" + s + "_q" + q + "_" + System.currentTimeMillis() + "_" + rawName.replaceAll("\\s+", "_");

                    String uploadPath = getServletContext().getRealPath("/uploads");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    imagePart.write(uploadPath + File.separator + fileName);
                    imageUrl = "uploads/" + fileName;
                }

                int questionId = -1;
                for (int i = 0;; i++) {
                    String questionText = request.getParameter("questionText_s" + s + "_q" + q + "_i" + i);
                    String answerText = request.getParameter("answers_s" + s + "_q" + q + "_i" + i);
                    String isCorrectParam = request.getParameter("isCorrect_s" + s + "_q" + q + "_i" + i);
                    boolean isCorrect = isCorrectParam != null;

                    boolean shouldCreateQuestion = questionId == -1 && ((questionText != null && !questionText.trim().isEmpty())
                            || (!imageUrl.isEmpty() && answerText != null && !answerText.trim().isEmpty()));

                    if (shouldCreateQuestion) {
                        Question question = new Question();
                        question.setPassageId(passageId);
                        question.setQuestionType(questionType);
                        question.setInstruction(instruction);
                        question.setQuestionText(questionText != null ? questionText.trim() : "");
                        question.setExplanation("");
                        question.setNumberInPassage(-1);
                        question.setImageUrl(imageUrl);
                        questionId = questionDAO.insertQuestion(question);
                    }

                    if (questionId != -1 && answerText != null && !answerText.trim().isEmpty()) {
                        if ("MULTIPLE_CHOICE".equals(questionType)) {
                            Option option = new Option();
                            option.setQuestionId(questionId);
                            option.setOptionLabel(String.valueOf((char) ('A' + i)));
                            option.setOptionText(answerText.trim());
                            option.setIsCorrect(isCorrect);
                            optionDAO.insertOption(option);
                        } else {
                            // ✅ Dạng TRUE_FALSE_NOT_GIVEN, SUMMARY_COMPLETION... lưu vào Answers
                            Answer answer = new Answer();
                            answer.setQuestionId(questionId);
                            answer.setAnswerText(answerText.trim());
                            answerDAO.insertAnswer(answer);
                        }
                    }

                    if (questionText == null && answerText == null) {
                        break;
                    }
                }
            }
        }

        response.sendRedirect("addSuccess.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Handles adding IELTS Reading Exams with sections and questions.";
    }
}
