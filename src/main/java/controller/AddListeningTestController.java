package controller;

import dao.*;
import model.*;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;

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
        // Log toàn bộ param nhận được
        System.out.println("---- All request params ----");
        request.getParameterMap().forEach((k, v) -> System.out.println(k + " = " + java.util.Arrays.toString(v)));
        System.out.println("---------------------------");
        try {
            String examTitle = request.getParameter("examTitle");
            String examType = request.getParameter("category");
            if (isEmpty(examTitle) || isEmpty(examType)) {
                System.out.println("[ERR] Missing exam info");
                response.sendRedirect("View/addListeningTest.jsp?error=MissingExamInfo");
                return;
            }
            Exam exam = new Exam();
            exam.setTitle(examTitle.trim());
            exam.setType(examType);
            exam.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            int examId = examDAO.insertExam(exam);
            System.out.println("[OK] Exam inserted: " + examId);
            String audioUrl = request.getParameter("examAudioPath");
            if (isEmpty(audioUrl)) {
                System.out.println("[ERR] No audio file selected");
                response.sendRedirect("View/addListeningTest.jsp?error=NoAudioSelected");
                return;
            }
            if ("LISTENING_FULL".equals(examType)) {
                processSections(examId, audioUrl, request, true);
            } else {
                processSections(examId, audioUrl, request, false);
            }
            response.sendRedirect("View/addSuccess.jsp");
        } catch (Exception e) {
            System.out.println("[ERR] Exception: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("View/addListeningTest.jsp?error=InternalError");
        }
    }

    private void processSections(int examId, String audioUrl, HttpServletRequest request, boolean isFull) throws Exception {
        int maxSections = isFull ? 4 : 1;
        for (int sectionIdx = 1; sectionIdx <= maxSections; sectionIdx++) {
            String sectionTitle = request.getParameter(isFull ? ("sectionTitle" + sectionIdx) : "sectionTitle");
            if (isEmpty(sectionTitle)) continue;
            Passage passage = new Passage();
            passage.setExamId(examId);
            passage.setSection(sectionIdx);
            passage.setTitle(sectionTitle.trim());
            passage.setType("LISTENING");
            passage.setContent("");
            passage.setAudioUrl(audioUrl);
            passage.setCreatedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            int passageId = passageDAO.insertPassage(passage);
            System.out.println("[OK] Section " + sectionIdx + " inserted: " + passageId);
            processGroups(passageId, sectionIdx, request, isFull);
            if (!isFull) break;
        }
    }

    private void processGroups(int passageId, int sectionIdx, HttpServletRequest request, boolean isFull) throws Exception {
        for (int groupId = 1; groupId <= 100; groupId++) {
            String groupType = request.getParameter((isFull ? ("groupType_" + sectionIdx + "_") : "groupType_") + groupId);
            if (isEmpty(groupType)) continue;
            String groupInstruction = request.getParameter((isFull ? ("groupInstruction_" + sectionIdx + "_") : "groupInstruction_") + groupId);
            String imageUrl = uploadImageByGroup(request, sectionIdx, groupId, isFull);
            System.out.println("[OK] Group " + groupId + " type=" + groupType);
            processQuestions(passageId, groupType, groupInstruction, imageUrl, sectionIdx, groupId, request, isFull);
        }
    }

    private void processQuestions(int passageId, String groupType, String groupInstruction, String imageUrl,
                                  int sectionIdx, int groupId, HttpServletRequest request, boolean isFull) throws Exception {
        for (int q = 1; q <= 100; q++) {
            String prefix = (isFull ? sectionIdx + "_" : "");
            String questionText = request.getParameter("q_" + prefix + groupId + "_" + q);
            if (isEmpty(questionText)) continue;
            Question question = new Question();
            question.setPassageId(passageId);
            question.setQuestionType(groupType);
            question.setInstruction(groupInstruction != null ? groupInstruction.trim() : "");
            question.setImageUrl(imageUrl);
            question.setNumberInPassage(-1);
            question.setExplanation("");
            question.setQuestionText(questionText.trim());
            int questionId = questionDAO.insertQuestion(question);
            System.out.println("[OK] Q" + q + " inserted: " + questionId);
            insertAnswersAndOptions(groupType, sectionIdx, groupId, q, questionId, request, isFull);
        }
    }

    private String uploadImageByGroup(HttpServletRequest request, int sectionIdx, int groupId, boolean isFull) throws IOException, ServletException {
        String partName = (isFull ? ("groupImage_" + sectionIdx + "_") : "groupImage_") + groupId;
        for (Part part : request.getParts()) {
            if (part.getName().equals(partName) && part.getSize() > 0) {
                String fileName = part.getSubmittedFileName();
                if (!isEmpty(fileName)) {
                    String ext = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = (isFull ? ("group_" + sectionIdx + "_") : "group_single_") + groupId + "_" + java.util.UUID.randomUUID() + ext;
                    String uploadPath = getServletContext().getRealPath("/uploads/images/");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    File file = new File(uploadPath + uniqueFileName);
                    part.write(file.getAbsolutePath());
                    return "uploads/images/" + uniqueFileName;
                }
            }
        }
        return null;
    }

    private void insertAnswersAndOptions(String type, int sectionIdx, int groupId, int q, int questionId, HttpServletRequest request, boolean isFull) {
        try {
            switch (type) {
                case "MULTIPLE_CHOICE":
                    insertMultipleChoiceAnswers(sectionIdx, groupId, q, questionId, request, isFull);
                    break;
                case "MATCHING":
                    insertMatchingAnswers(sectionIdx, groupId, q, questionId, request, isFull);
                    break;
                case "SUMMARY_COMPLETION":
                case "TABLE_COMPLETION":
                case "FLOWCHART":
                case "FORM_COMPLETION":
                case "NOTE_COMPLETION":
                case "MAP_LABELING":
                case "PLAN_LABELING":
                case "DIAGRAM_LABELING":
                case "SENTENCE_COMPLETION":
                    insertCompletionAnswers(sectionIdx, groupId, q, questionId, request, isFull);
                    break;
                default:
                    System.out.println("[ERR] Unknown question type: " + type);
            }
        } catch (Exception e) {
            System.out.println("[ERR] Insert answer: " + e.getMessage());
        }
    }

    private void insertMultipleChoiceAnswers(int sectionIdx, int groupId, int q, int questionId, HttpServletRequest request, boolean isFull) {
        for (int i = 0; i < 10; i++) {
            String prefix = (isFull ? sectionIdx + "_" : "");
            String paramName = "a_" + prefix + groupId + "_" + q + "_" + i;
                String optText = request.getParameter(paramName);
            if (isEmpty(optText)) continue;
            String correctParam = "correct_" + prefix + groupId + "_" + q + "_" + i;
            boolean isCorrect = request.getParameter(correctParam) != null;
                Answer answer = new Answer();
                answer.setQuestionId(questionId);
                answer.setAnswerText(optText.trim());
                answer.setCorrect(isCorrect);
            answerDAO.insertAnswer(answer);
        }
    }

    private void insertMatchingAnswers(int sectionIdx, int groupId, int q, int questionId, HttpServletRequest request, boolean isFull) {
        for (int i = 0; i < 20; i++) {
            String prefix = (isFull ? sectionIdx + "_" : "");
            String left = request.getParameter("matchQ_" + prefix + groupId + "_" + q + "_" + i);
            String right = request.getParameter("matchA_" + prefix + groupId + "_" + q + "_" + i);
            if (isEmpty(left) || isEmpty(right)) continue;
                    Answer pair = new Answer();
                    pair.setQuestionId(questionId);
                    pair.setAnswerText(left.trim() + " = " + right.trim());
                    pair.setCorrect(true);
            answerDAO.insertAnswer(pair);
        }
    }

    private void insertCompletionAnswers(int sectionIdx, int groupId, int q, int questionId, HttpServletRequest request, boolean isFull) {
        String prefix = (isFull ? sectionIdx + "_" : "");
        String answerText = request.getParameter("shortA_" + prefix + groupId + "_" + q);
        if (!isEmpty(answerText)) {
                Answer answer = new Answer();
                answer.setQuestionId(questionId);
                answer.setAnswerText(answerText.trim());
                answer.setCorrect(true);
            answerDAO.insertAnswer(answer);
            return;
        }
        String[] altParams = {"completionA_", "labelA_", "fillA_", "sentenceA_"};
        for (String alt : altParams) {
            String altAnswer = request.getParameter(alt + prefix + groupId + "_" + q);
            if (!isEmpty(altAnswer)) {
                Answer answer = new Answer();
                answer.setQuestionId(questionId);
                answer.setAnswerText(altAnswer.trim());
                answer.setCorrect(true);
                answerDAO.insertAnswer(answer);
                        break;
            }
        }
    }

    private boolean isEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
