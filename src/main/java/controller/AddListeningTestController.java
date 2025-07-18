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

@WebServlet(name = "AddListeningTestController", urlPatterns = {"/AddListeningTestController"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 10 * 1024 * 1024)
public class AddListeningTestController extends HttpServlet {

    private final ExamDAO examDAO = new ExamDAO();
    private final PassageDAO passageDAO = new PassageDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final AnswerDAO answerDAO = new AnswerDAO();
    private final OptionDAO optionDAO = new OptionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            System.out.println("[AddListeningTestController] Start doPost");
            String examTitle = request.getParameter("examTitle");
            String examType = request.getParameter("category");
            System.out.println("Exam title: " + examTitle + ", type: " + examType);
            if (examTitle == null || examTitle.isEmpty() || examType == null || examType.isEmpty()) {
                System.out.println("Missing exam info");
                response.sendRedirect("View/addListeningTest.jsp?error=MissingExamInfo");
                return;
            }

            // Insert exam
            Exam exam = new Exam();
            exam.setTitle(examTitle.trim());
            exam.setType(examType);
            exam.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            int examId = examDAO.insertExam(exam);
            System.out.println("Inserted examId: " + examId);

            String audioUrl = request.getParameter("examAudioPath");
            if (audioUrl == null || audioUrl.trim().isEmpty()) {
                System.out.println("❌ Không có audioUrl được chọn!");
            } else {
                System.out.println("✅ Audio URL nhận được: " + audioUrl);
            }
            System.out.println("Exam audioUrl: " + audioUrl);
            if ("LISTENING_FULL".equals(examType)) {
                // Lặp qua tất cả section
                int sectionIdx = 1;
                while (true) {
                    String sectionName = request.getParameter("sectionName" + sectionIdx);
                    String sectionTitle = request.getParameter("sectionTitle" + sectionIdx);
                    System.out.println("Section " + sectionIdx + ": name=" + sectionName + ", title=" + sectionTitle);
                    if (sectionName == null || sectionTitle == null) {
                        break;
                    }
                    // Insert passage (section)
                    Passage passage = new Passage();
                    passage.setExamId(examId);
                    passage.setSection(sectionIdx);
                    passage.setTitle(sectionTitle);
                    passage.setType("LISTENING");
                    passage.setContent("");
                    passage.setAudioUrl(audioUrl); // audio toàn bài
                    passage.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                    int passageId = passageDAO.insertPassage(passage);
                    System.out.println("  Inserted passageId: " + passageId);

                    // Process all question groups for this section
                    for (int groupId = 1; groupId <= 100; groupId++) {
                        String groupType = request.getParameter("groupType_" + sectionIdx + "_" + groupId);
                        if (groupType == null || groupType.isEmpty()) {
                            continue;
                        }
                        String groupInstruction = request.getParameter("groupInstruction_" + sectionIdx + "_" + groupId);
                        String imageUrl = uploadImageByGroup(request, sectionIdx, groupId);
                        System.out.println("    Group " + groupId + ": type=" + groupType + ", instruction=" + groupInstruction + ", imageUrl=" + imageUrl);
                        for (int q = 1; q <= 100; q++) {
                            String questionText = request.getParameter("q_" + sectionIdx + "_" + groupId + "_" + q);
                            if (questionText == null || questionText.trim().isEmpty()) {
                                continue;
                            }
                            System.out.println("      Question " + q + ": " + questionText);
                            Question question = new Question();
                            question.setPassageId(passageId);
                            question.setQuestionType(groupType);
                            question.setInstruction(groupInstruction);
                            question.setImageUrl(imageUrl);
                            question.setNumberInPassage(-1);
                            question.setExplanation("");
                            question.setQuestionText(questionText.trim());
                            int questionId = questionDAO.insertQuestion(question);
                            System.out.println("        Inserted questionId: " + questionId);
                            insertAnswersAndOptions(groupType, sectionIdx, groupId, q, questionId, request);
                        }
                    }
                    sectionIdx++;
                }
            } else {
                // LISTENING_SINGLE
                int section = Integer.parseInt(request.getParameter("section"));
                String sectionTitle = request.getParameter("sectionTitle");
                String sectionName = request.getParameter("sectionName");
                Passage passage = new Passage();
                passage.setExamId(examId);
                passage.setSection(section);
                passage.setTitle(sectionTitle);
                passage.setType("LISTENING");
                passage.setContent("");
                passage.setAudioUrl(audioUrl); // dùng chung audio
                passage.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                int passageId = passageDAO.insertPassage(passage);
                System.out.println("  Inserted passageId: " + passageId);
                for (int groupId = 1; groupId <= 100; groupId++) {
                    String groupType = request.getParameter("groupType_" + groupId);
                    if (groupType == null || groupType.isEmpty()) {
                        continue;
                    }
                    String groupInstruction = request.getParameter("groupInstruction_" + groupId);
                    String imageUrl = uploadImageByGroup(request, section, groupId);
                    System.out.println("    Group " + groupId + ": type=" + groupType + ", instruction=" + groupInstruction + ", imageUrl=" + imageUrl);
                    for (int q = 1; q <= 100; q++) {
                        String questionText = request.getParameter("q_" + groupId + "_" + q);
                        if (questionText == null || questionText.trim().isEmpty()) {
                            continue;
                        }
                        System.out.println("      Question " + q + ": " + questionText);
                        Question question = new Question();
                        question.setPassageId(passageId);
                        question.setQuestionType(groupType);
                        question.setInstruction(groupInstruction);
                        question.setImageUrl(imageUrl);
                        question.setNumberInPassage(-1);
                        question.setExplanation("");
                        question.setQuestionText(questionText.trim());
                        int questionId = questionDAO.insertQuestion(question);
                        System.out.println("        Inserted questionId: " + questionId);
                        insertAnswersAndOptions(groupType, section, groupId, q, questionId, request);
                    }
                }
            }
            System.out.println("[AddListeningTestController] Done, redirecting to addSuccess.jsp");
            response.sendRedirect("View/addSuccess.jsp");
        } catch (Exception e) {
            System.out.println("[AddListeningTestController] Exception: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("View/addListeningTest.jsp?error=InternalError");
        }
    }

    private String uploadImageByGroup(HttpServletRequest request, int sectionIdx, int groupId) throws IOException, ServletException {
        for (Part part : request.getParts()) {
            if (part.getName().equals("groupImage_" + sectionIdx + "_" + groupId) && part.getSize() > 0) {
                String fileName = part.getSubmittedFileName().replaceAll("\\s+", "_");
                // Không ghi file ra ổ C nữa, chỉ trả về tên file (giả sử bạn sẽ tự copy file vào web/Audio nếu cần)
                return "Audio/" + fileName;
            }
        }
        return null;
    }

    private void insertAnswersAndOptions(String type, int sectionIdx, int groupId, int q, int questionId, HttpServletRequest request) {
        System.out.println("        [insertAnswersAndOptions] type=" + type + ", section=" + sectionIdx + ", group=" + groupId + ", q=" + q);
        switch (type) {
            case "MULTIPLE_CHOICE":
                for (int i = 0;; i++) {
                    String optText = request.getParameter("a_" + sectionIdx + "_" + groupId + "_" + q + "_" + i);
                    if (optText == null || optText.trim().isEmpty()) {
                        break;
                    }
                    boolean isCorrect = request.getParameter("correct_" + sectionIdx + "_" + groupId + "_" + q + "_" + i) != null;
                    System.out.println("          Option " + i + ": " + optText + ", correct=" + isCorrect);
                    Answer answer = new Answer();
                    answer.setQuestionId(questionId);
                    answer.setAnswerText(optText.trim());
                    answer.setCorrect(isCorrect);
                    answerDAO.insertAnswer(answer);
                }
                break;
            case "MATCHING":
                for (int i = 0; i < 10; i++) {
                    String left = request.getParameter("matchQ_" + sectionIdx + "_" + groupId + "_" + q + "_" + i);
                    String right = request.getParameter("matchA_" + sectionIdx + "_" + groupId + "_" + q + "_" + i);
                    if (left != null && right != null && !left.trim().isEmpty() && !right.trim().isEmpty()) {
                        System.out.println("          Matching " + i + ": " + left + " = " + right);
                        Answer pair = new Answer();
                        pair.setQuestionId(questionId);
                        pair.setAnswerText(left.trim() + " = " + right.trim());
                        pair.setCorrect(true);
                        answerDAO.insertAnswer(pair);
                    }
                }
                break;
            default:
                String answerText = request.getParameter("shortA_" + sectionIdx + "_" + groupId + "_" + q);
                if (answerText != null && !answerText.trim().isEmpty()) {
                    System.out.println("          Short answer: " + answerText);
                    Answer a = new Answer();
                    a.setQuestionId(questionId);
                    a.setAnswerText(answerText.trim());
                    a.setCorrect(true);
                    answerDAO.insertAnswer(a);
                }
                break;
        }
    }
}
