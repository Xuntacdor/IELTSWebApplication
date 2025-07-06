package controller;

import dao.*;
import model.*;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

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
        String examType = request.getParameter("category");

        if (examTitle == null || examTitle.trim().isEmpty() ||
            examType == null || examType.trim().isEmpty()) {
            response.sendRedirect("View/addReadingTest.jsp?error=MissingExamInfo");
            return;
        }

        // 1. Insert exam
        Exam exam = new Exam();
        exam.setTitle(examTitle.trim());
        exam.setType(examType);
        exam.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        int examId = examDAO.insertExam(exam);

        // 2. Determine passage type & section
        String passageType = examType.startsWith("READING") ? "READING" : "LISTENING";

        int section = 1;
        try {
            section = Integer.parseInt(request.getParameter("section"));
        } catch (Exception ignored) {}

        // 3. Insert passage
        String passageTitle = request.getParameter("passageTitle");
        String passageContent = request.getParameter("passageContent");

        if ((passageTitle == null || passageTitle.trim().isEmpty()) &&
            (passageContent == null || passageContent.trim().isEmpty())) {
            response.sendRedirect("View/addReadingTest.jsp?error=MissingPassage");
            return;
        }

        Passage passage = new Passage();
        passage.setExamId(examId);
        passage.setTitle(passageTitle.trim());
        passage.setContent(passageContent.trim());
        passage.setType(passageType);
        passage.setSection(section);
        passage.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        int passageId = passageDAO.insertPassage(passage);

        // 4. Insert question groups
        for (int groupId = 1; ; groupId++) {
            String groupType = request.getParameter("groupType_" + groupId);
            if (groupType == null || groupType.trim().isEmpty()) break;

            String groupInstruction = request.getParameter("groupInstruction_" + groupId);
            Part imagePart = request.getPart("groupImage_" + groupId);
            String imageUrl = "";

            if (imagePart != null && imagePart.getSize() > 0) {
                String rawName = imagePart.getSubmittedFileName();
                String fileName = System.currentTimeMillis() + "_" + rawName.replaceAll("\\s+", "_");
                String uploadPath = getServletContext().getRealPath("/uploads");
                new File(uploadPath).mkdirs();
                imagePart.write(uploadPath + File.separator + fileName);
                imageUrl = "uploads/" + fileName;
            }

            // 5. Insert questions
            for (int q = 1; ; q++) {
                String questionText = request.getParameter("q_" + groupId + "_" + q);
                if (questionText == null || questionText.trim().isEmpty()) break;

                Question question = new Question();
                question.setPassageId(passageId);
                question.setQuestionType(groupType);
                question.setInstruction(groupInstruction);
                question.setImageUrl(imageUrl);
                question.setNumberInPassage(-1);
                question.setExplanation("");

                // Handle SUMMARY_COMPLETION (gộp tiêu đề + nội dung)
                if ("SUMMARY_COMPLETION".equals(groupType)) {
                    String summaryTitle = request.getParameter("q_title_" + groupId + "_" + q);
                    String fullText = "";
                    if (summaryTitle != null && !summaryTitle.trim().isEmpty()) {
                        fullText += summaryTitle.trim() + "\n";
                    }
                    fullText += questionText.trim();
                    question.setQuestionText(fullText.trim());
                } else {
                    question.setQuestionText(questionText.trim());
                }

                int questionId = questionDAO.insertQuestion(question);

                // 6. Insert answers/options
                switch (groupType) {
                    case "MULTIPLE_CHOICE":
                        for (int i = 0; ; i++) {
                            String optText = request.getParameter("a_" + groupId + "_" + q + "_" + i);
                            if (optText == null || optText.trim().isEmpty()) break;

                            boolean isCorrect = request.getParameter("correct_" + groupId + "_" + q + "_" + i) != null;

                            Option option = new Option();
                            option.setQuestionId(questionId);
                            option.setOptionLabel(String.valueOf((char) ('A' + i)));
                            option.setOptionText(optText.trim());
                            option.setIsCorrect(isCorrect);
                            optionDAO.insertOption(option);
                        }
                        break;

                    case "TRUE_FALSE_NOT_GIVEN":
                    case "YES_NO_NOT_GIVEN":
                        String tfAnswer = request.getParameter("answer_" + groupId + "_" + q);
                        if (tfAnswer != null && !tfAnswer.trim().isEmpty()) {
                            Answer a = new Answer();
                            a.setQuestionId(questionId);
                            a.setAnswerText(tfAnswer.trim());
                            answerDAO.insertAnswer(a);
                        }
                        break;

                    case "MATCHING":
                        for (int i = 0; i < 10; i++) {
                            String left = request.getParameter("matchQ_" + groupId + "_" + q + "_" + i);
                            String right = request.getParameter("matchA_" + groupId + "_" + q + "_" + i);
                            if (left != null && right != null &&
                                !left.trim().isEmpty() && !right.trim().isEmpty()) {
                                Answer pair = new Answer();
                                pair.setQuestionId(questionId);
                                pair.setAnswerText(left.trim() + " = " + right.trim());
                                answerDAO.insertAnswer(pair);
                            }
                        }
                        break;

                    default:
                        String shortAns = request.getParameter("shortA_" + groupId + "_" + q);
                        if (shortAns != null && !shortAns.trim().isEmpty()) {
                            Answer a = new Answer();
                            a.setQuestionId(questionId);
                            a.setAnswerText(shortAns.trim());
                            answerDAO.insertAnswer(a);
                        }
                        break;
                }
            }
        }

        response.sendRedirect("View/addSuccess.jsp");
    }
}
