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
        try {
            String examTitle = request.getParameter("examTitle");
            String examType = request.getParameter("category");

            if (examTitle == null || examType == null || examTitle.trim().isEmpty() || examType.trim().isEmpty()) {
                response.sendRedirect("View/addReadingTest.jsp?error=MissingExamInfo");
                return;
            }

            Exam exam = new Exam();
            exam.setTitle(examTitle.trim());
            exam.setType(examType);
            exam.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            int examId = examDAO.insertExam(exam);

            int section = 1;
            try {
                section = Integer.parseInt(request.getParameter("section"));
            } catch (Exception ignored) {
            }

            String passageTitle = request.getParameter("passageTitle");
            String passageContent = request.getParameter("passageContent");

            if ((passageTitle == null || passageTitle.trim().isEmpty())
                    && (passageContent == null || passageContent.trim().isEmpty())) {
                response.sendRedirect("View/addReadingTest.jsp?error=MissingPassage");
                return;
            }

            Passage passage = new Passage();
            passage.setExamId(examId);
            passage.setTitle(passageTitle.trim());
            passage.setContent(passageContent.trim());
            passage.setType(examType.startsWith("READING") ? "READING" : "LISTENING");
            passage.setSection(section);
            passage.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            int passageId = passageDAO.insertPassage(passage);

            for (int groupId = 1; groupId <= 100; groupId++) {
                String groupType = request.getParameter("groupType_" + groupId);
                if (groupType == null || groupType.trim().isEmpty()) continue;

                String groupInstruction = request.getParameter("groupInstruction_" + groupId);
                String imageUrl = uploadImageByGroup(request, groupId);

                if ("MATCHING_HEADINGS".equals(groupType)) {
                    Question q = new Question();
                    q.setPassageId(passageId);
                    q.setQuestionType(groupType);
                    q.setInstruction(groupInstruction);
                    q.setImageUrl(imageUrl);
                    q.setNumberInPassage(-1);
                    q.setExplanation("");
                    q.setQuestionText("Match the following sections with headings:");
                    int questionId = questionDAO.insertQuestion(q);

                    String headingsText = request.getParameter("headingList_" + groupId);
                    if (headingsText != null && !headingsText.trim().isEmpty()) {
                        for (String line : headingsText.split("\r?\n")) {
                            if (!line.trim().isEmpty()) {
                                Answer a = new Answer();
                                a.setQuestionId(questionId);
                                a.setAnswerText("LIST: " + line.trim());
                                a.setCorrect(false);
                                answerDAO.insertAnswer(a);
                            }
                        }
                    }

                    String mappingText = request.getParameter("headingMapping_" + groupId);
                    if (mappingText != null && !mappingText.trim().isEmpty()) {
                        for (String line : mappingText.split("\r?\n")) {
                            if (!line.trim().isEmpty()) {
                                Answer a = new Answer();
                                a.setQuestionId(questionId);
                                a.setAnswerText(line.trim());
                                a.setCorrect(true);
                                answerDAO.insertAnswer(a);
                            }
                        }
                    }
                    continue;
                }

                if ("MATCHING_INFORMATION".equals(groupType)) {
                    for (int q = 1; q <= 100; q++) {
                        String statement = request.getParameter("q_" + groupId + "_" + q);
                        String correctPara = request.getParameter("shortA_" + groupId + "_" + q);
                        if (statement == null || statement.trim().isEmpty()) continue;

                        Question question = new Question();
                        question.setPassageId(passageId);
                        question.setQuestionType(groupType);
                        question.setInstruction(groupInstruction);
                        question.setImageUrl(imageUrl);
                        question.setNumberInPassage(-1);
                        question.setExplanation("");
                        question.setQuestionText(statement.trim());
                        int questionId = questionDAO.insertQuestion(question);

                        if (correctPara != null && !correctPara.trim().isEmpty()) {
                            Answer a = new Answer();
                            a.setQuestionId(questionId);
                            a.setAnswerText(correctPara.trim());
                            a.setCorrect(true);
                            answerDAO.insertAnswer(a);
                        }
                    }
                    continue;
                }

                for (int q = 1; q <= 100; q++) {
                    String questionText = "SUMMARY_COMPLETION".equals(groupType)
                            ? request.getParameter("summary_" + groupId + "_" + q)
                            : request.getParameter("q_" + groupId + "_" + q);
                    if (questionText == null || questionText.trim().isEmpty()) continue;

                    Question question = new Question();
                    question.setPassageId(passageId);
                    question.setQuestionType(groupType);
                    question.setInstruction(groupInstruction);
                    question.setImageUrl(imageUrl);
                    question.setNumberInPassage(-1);
                    question.setExplanation("");
                    question.setQuestionText(generateFullQuestionText(groupType, groupId, q, questionText, request));
                    int questionId = questionDAO.insertQuestion(question);

                    insertAnswersAndOptions(groupType, groupId, q, questionId, request);
                }
            }

            response.sendRedirect("View/addSuccess.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("View/addReadingTest.jsp?error=InternalError");
        }
    }

    private String uploadImageByGroup(HttpServletRequest request, int groupId) throws IOException, ServletException {
        for (Part part : request.getParts()) {
            if (part.getName().equals("groupImage_" + groupId) && part.getSize() > 0) {
                String fileName = part.getSubmittedFileName().replaceAll("\\s+", "_");
                String diskPath = "C:/IELTS_Uploads/";
                File dir = new File(diskPath);
                if (!dir.exists()) dir.mkdirs();
                File saveFile = new File(diskPath + fileName);
                part.write(saveFile.getAbsolutePath());
                return "uploads/" + fileName;
            }
        }
        return null;
    }

    private String generateFullQuestionText(String type, int groupId, int q, String questionText, HttpServletRequest request) {
        if ("SUMMARY_COMPLETION".equals(type)) {
            String title = request.getParameter("q_" + groupId + "_" + q);
            return (title != null ? title.trim() + "\n" : "") + questionText.trim();
        }
        return questionText.trim();
    }

    private void insertAnswersAndOptions(String type, int groupId, int q, int questionId, HttpServletRequest request) {
        switch (type) {
            case "MULTIPLE_CHOICE":
                for (int i = 0; ; i++) {
                    String optText = request.getParameter("a_" + groupId + "_" + q + "_" + i);
                    if (optText == null || optText.trim().isEmpty()) break;
                    boolean isCorrect = request.getParameter("correct_" + groupId + "_" + q + "_" + i) != null;
                    Answer answer = new Answer();
                    answer.setQuestionId(questionId);
                    answer.setAnswerText(optText.trim());
                    answer.setCorrect(isCorrect);
                    answerDAO.insertAnswer(answer);
                }
                break;

            case "TRUE_FALSE_NOT_GIVEN":
            case "YES_NO_NOT_GIVEN":
                String answer = request.getParameter("answer_" + groupId + "_" + q);
                if (answer != null && !answer.trim().isEmpty()) {
                    Answer a = new Answer();
                    a.setQuestionId(questionId);
                    a.setAnswerText(answer.trim());
                    a.setCorrect(true);
                    answerDAO.insertAnswer(a);
                }
                break;

            case "MATCHING":
                for (int i = 0; i < 10; i++) {
                    String left = request.getParameter("matchQ_" + groupId + "_" + q + "_" + i);
                    String right = request.getParameter("matchA_" + groupId + "_" + q + "_" + i);
                    if (left != null && right != null && !left.trim().isEmpty() && !right.trim().isEmpty()) {
                        Answer pair = new Answer();
                        pair.setQuestionId(questionId);
                        pair.setAnswerText(left.trim() + " = " + right.trim());
                        pair.setCorrect(true);
                        answerDAO.insertAnswer(pair);
                    }
                }
                break;

            case "SUMMARY_COMPLETION":
            default:
                String answerText = request.getParameter("shortA_" + groupId + "_" + q);
                if ((answerText == null || answerText.trim().isEmpty())
                        && (type.equals("FLOWCHART") || type.equals("TABLE_COMPLETION") || type.equals("DIAGRAM_LABELING"))) {
                    answerText = request.getParameter("imageQ_" + groupId + "_" + q);
                }

                if (answerText != null && !answerText.trim().isEmpty()) {
                    if ("SUMMARY_COMPLETION".equals(type)) {
                        for (String ans : answerText.split("\r?\n")) {
                            if (!ans.trim().isEmpty()) {
                                Answer a = new Answer();
                                a.setQuestionId(questionId);
                                a.setAnswerText(ans.trim());
                                a.setCorrect(true);
                                answerDAO.insertAnswer(a);
                            }
                        }
                    } else {
                        Answer a = new Answer();
                        a.setQuestionId(questionId);
                        a.setAnswerText(answerText.trim());
                        a.setCorrect(true);
                        answerDAO.insertAnswer(a);
                    }
                }
                break;
        }
    }
}
