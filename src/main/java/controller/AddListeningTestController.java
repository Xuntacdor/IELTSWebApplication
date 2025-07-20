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
                System.out.println("❌ No audio file selected!");
                response.sendRedirect("View/addListeningTest.jsp?error=NoAudioSelected");
                return;
            }
            System.out.println("✅ Audio URL received: " + audioUrl);

            if ("LISTENING_FULL".equals(examType)) {
                processListeningFull(examId, audioUrl, request);
            } else {
                processListeningSingle(examId, audioUrl, request);
            }
            
            System.out.println("[AddListeningTestController] Done, redirecting to addSuccess.jsp");
            response.sendRedirect("View/addSuccess.jsp");
        } catch (Exception e) {
            System.out.println("[AddListeningTestController] Exception: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("View/addListeningTest.jsp?error=InternalError");
        }
    }

    private void processListeningFull(int examId, String audioUrl, HttpServletRequest request) throws Exception {
        System.out.println("Processing LISTENING_FULL exam");
        
        // Process all sections (1-4)
        for (int sectionIdx = 1; sectionIdx <= 4; sectionIdx++) {
            String sectionTitle = request.getParameter("sectionTitle" + sectionIdx);
            
            if (sectionTitle == null || sectionTitle.trim().isEmpty()) {
                System.out.println("Section " + sectionIdx + " is empty, skipping");
                continue;
            }
            
            System.out.println("Processing Section " + sectionIdx + ": title=" + sectionTitle);
            
            // Insert passage (section)
            Passage passage = new Passage();
            passage.setExamId(examId);
            passage.setSection(sectionIdx);
            passage.setTitle(sectionTitle.trim());
            passage.setType("LISTENING");
            passage.setContent("");
            passage.setAudioUrl(audioUrl); // Use the same audio for all sections
            passage.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            int passageId = passageDAO.insertPassage(passage);
            System.out.println("  Inserted passageId: " + passageId);

            // Process question groups for this section
            processQuestionGroups(passageId, sectionIdx, request);
        }
    }

    private void processListeningSingle(int examId, String audioUrl, HttpServletRequest request) throws Exception {
        System.out.println("Processing LISTENING_SINGLE exam");
        
        int section = Integer.parseInt(request.getParameter("section"));
        String sectionTitle = request.getParameter("sectionTitle");
        
        if (sectionTitle == null || sectionTitle.trim().isEmpty()) {
            System.out.println("Missing section title for single listening");
            return;
        }
        
        // Insert passage
        Passage passage = new Passage();
        passage.setExamId(examId);
        passage.setSection(section);
        passage.setTitle(sectionTitle.trim());
        passage.setType("LISTENING");
        passage.setContent("");
        passage.setAudioUrl(audioUrl);
        passage.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        int passageId = passageDAO.insertPassage(passage);
        System.out.println("  Inserted passageId: " + passageId);
        
        // Process question groups for single section (no section prefix)
        processQuestionGroupsSingle(passageId, request);
    }

    private void processQuestionGroups(int passageId, int sectionIdx, HttpServletRequest request) throws Exception {
        // Process all question groups
        for (int groupId = 1; groupId <= 100; groupId++) {
            String groupType = request.getParameter("groupType_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId);
            if (groupType == null || groupType.isEmpty()) {
                continue;
            }
            
            String groupInstruction = request.getParameter("groupInstruction_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId);
            String imageUrl = uploadImageByGroup(request, sectionIdx, groupId);
            
            System.out.println("    Group " + groupId + ": type=" + groupType + ", instruction=" + groupInstruction + ", imageUrl=" + imageUrl);
            
            // Process questions for this group
            processQuestions(passageId, groupType, groupInstruction, imageUrl, sectionIdx, groupId, request);
        }
    }

    private void processQuestionGroupsSingle(int passageId, HttpServletRequest request) throws Exception {
        // Process all question groups for single section (no section prefix)
        for (int groupId = 1; groupId <= 100; groupId++) {
            String groupType = request.getParameter("groupType_" + groupId);
            if (groupType == null || groupType.isEmpty()) {
                continue;
            }
            
            String groupInstruction = request.getParameter("groupInstruction_" + groupId);
            String imageUrl = uploadImageByGroupSingle(request, groupId);
            
            System.out.println("    Group " + groupId + ": type=" + groupType + ", instruction=" + groupInstruction + ", imageUrl=" + imageUrl);
            
            // Process questions for this group
            processQuestionsSingle(passageId, groupType, groupInstruction, imageUrl, groupId, request);
        }
    }

    private void processQuestions(int passageId, String groupType, String groupInstruction, String imageUrl, 
                                 int sectionIdx, int groupId, HttpServletRequest request) throws Exception {
        
        for (int q = 1; q <= 100; q++) {
            String questionText = request.getParameter("q_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId + "_" + q);
            if (questionText == null || questionText.trim().isEmpty()) {
                continue;
            }
            
            System.out.println("      Question " + q + ": " + questionText);
            
            Question question = new Question();
            question.setPassageId(passageId);
            question.setQuestionType(groupType);
            question.setInstruction(groupInstruction != null ? groupInstruction.trim() : "");
            question.setImageUrl(imageUrl);
            question.setNumberInPassage(-1);
            question.setExplanation("");
            question.setQuestionText(questionText.trim());
            
            int questionId = questionDAO.insertQuestion(question);
            System.out.println("        Inserted questionId: " + questionId);
            
            insertAnswersAndOptions(groupType, sectionIdx, groupId, q, questionId, request);
        }
    }

    private void processQuestionsSingle(int passageId, String groupType, String groupInstruction, String imageUrl, 
                                      int groupId, HttpServletRequest request) throws Exception {
        
        for (int q = 1; q <= 100; q++) {
            String questionText = request.getParameter("q_" + groupId + "_" + q);
            if (questionText == null || questionText.trim().isEmpty()) {
                continue;
            }
            
            System.out.println("      Question " + q + ": " + questionText);
            
            Question question = new Question();
            question.setPassageId(passageId);
            question.setQuestionType(groupType);
            question.setInstruction(groupInstruction != null ? groupInstruction.trim() : "");
            question.setImageUrl(imageUrl);
            question.setNumberInPassage(-1);
            question.setExplanation("");
            question.setQuestionText(questionText.trim());
            
            int questionId = questionDAO.insertQuestion(question);
            System.out.println("        Inserted questionId: " + questionId);
            
            insertAnswersAndOptionsSingle(groupType, groupId, q, questionId, request);
        }
    }

    private String uploadImageByGroup(HttpServletRequest request, int sectionIdx, int groupId) throws IOException, ServletException {
        String partName = "groupImage_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId;
        
        for (Part part : request.getParts()) {
            if (part.getName().equals(partName) && part.getSize() > 0) {
                String fileName = part.getSubmittedFileName();
                if (fileName != null && !fileName.trim().isEmpty()) {
                    // Generate unique filename
                    String extension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = "group_" + sectionIdx + "_" + groupId + "_" + UUID.randomUUID().toString() + extension;
                    
                    // Save file to uploads directory
                    String uploadPath = getServletContext().getRealPath("/uploads/images/");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    File file = new File(uploadPath + uniqueFileName);
                    part.write(file.getAbsolutePath());
                    
                    return "uploads/images/" + uniqueFileName;
                }
            }
        }
        return null;
    }

    private String uploadImageByGroupSingle(HttpServletRequest request, int groupId) throws IOException, ServletException {
        String partName = "groupImage_" + groupId;
        
        for (Part part : request.getParts()) {
            if (part.getName().equals(partName) && part.getSize() > 0) {
                String fileName = part.getSubmittedFileName();
                if (fileName != null && !fileName.trim().isEmpty()) {
                    // Generate unique filename
                    String extension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = "group_single_" + groupId + "_" + UUID.randomUUID().toString() + extension;
                    
                    // Save file to uploads directory
                    String uploadPath = getServletContext().getRealPath("/uploads/images/");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    File file = new File(uploadPath + uniqueFileName);
                    part.write(file.getAbsolutePath());
                    
                    return "uploads/images/" + uniqueFileName;
                }
            }
        }
        return null;
    }

    private void insertAnswersAndOptions(String type, int sectionIdx, int groupId, int q, int questionId, HttpServletRequest request) {
        System.out.println("        [insertAnswersAndOptions] type=" + type + ", section=" + sectionIdx + ", group=" + groupId + ", q=" + q);
        
        switch (type) {
            case "MULTIPLE_CHOICE":
                insertMultipleChoiceAnswers(sectionIdx, groupId, q, questionId, request);
                break;
                
            case "MATCHING":
                insertMatchingAnswers(sectionIdx, groupId, q, questionId, request);
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
                insertCompletionAnswers(sectionIdx, groupId, q, questionId, request);
                break;
                
            default:
                System.out.println("        Unknown question type: " + type);
                break;
        }
    }

    private void insertMultipleChoiceAnswers(int sectionIdx, int groupId, int q, int questionId, HttpServletRequest request) {
        for (int i = 0; i < 10; i++) { // Support up to 10 options
            String optText = request.getParameter("a_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId + "_" + q + "_" + i);
            if (optText == null || optText.trim().isEmpty()) {
                continue;
            }
            
            boolean isCorrect = request.getParameter("correct_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId + "_" + q + "_" + i) != null;
            System.out.println("          Option " + i + ": " + optText + ", correct=" + isCorrect);
            
            Answer answer = new Answer();
            answer.setQuestionId(questionId);
            answer.setAnswerText(optText.trim());
            answer.setCorrect(isCorrect);
            answerDAO.insertAnswer(answer);
        }
    }

    private void insertMatchingAnswers(int sectionIdx, int groupId, int q, int questionId, HttpServletRequest request) {
        for (int i = 0; i < 20; i++) { // Support up to 20 matching pairs
            String left = request.getParameter("matchQ_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId + "_" + q + "_" + i);
            String right = request.getParameter("matchA_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId + "_" + q + "_" + i);
            
            if (left != null && right != null && !left.trim().isEmpty() && !right.trim().isEmpty()) {
                System.out.println("          Matching " + i + ": " + left + " = " + right);
                
                Answer pair = new Answer();
                pair.setQuestionId(questionId);
                pair.setAnswerText(left.trim() + " = " + right.trim());
                pair.setCorrect(true);
                answerDAO.insertAnswer(pair);
            }
        }
    }

    private void insertAnswersAndOptionsSingle(String type, int groupId, int q, int questionId, HttpServletRequest request) {
        System.out.println("        [insertAnswersAndOptionsSingle] type=" + type + ", group=" + groupId + ", q=" + q);
        
        switch (type) {
            case "MULTIPLE_CHOICE":
                insertMultipleChoiceAnswersSingle(groupId, q, questionId, request);
                break;
                
            case "MATCHING":
                insertMatchingAnswersSingle(groupId, q, questionId, request);
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
                insertCompletionAnswersSingle(groupId, q, questionId, request);
                break;
                
            default:
                System.out.println("        Unknown question type: " + type);
                break;
        }
    }

    private void insertMultipleChoiceAnswersSingle(int groupId, int q, int questionId, HttpServletRequest request) {
        for (int i = 0; i < 10; i++) { // Support up to 10 options
            String optText = request.getParameter("a_" + groupId + "_" + q + "_" + i);
            if (optText == null || optText.trim().isEmpty()) {
                continue;
            }
            
            boolean isCorrect = request.getParameter("correct_" + groupId + "_" + q + "_" + i) != null;
            System.out.println("          Option " + i + ": " + optText + ", correct=" + isCorrect);
            
            Answer answer = new Answer();
            answer.setQuestionId(questionId);
            answer.setAnswerText(optText.trim());
            answer.setCorrect(isCorrect);
            answerDAO.insertAnswer(answer);
        }
    }

    private void insertMatchingAnswersSingle(int groupId, int q, int questionId, HttpServletRequest request) {
        for (int i = 0; i < 20; i++) { // Support up to 20 matching pairs
            String left = request.getParameter("matchQ_" + groupId + "_" + q + "_" + i);
            String right = request.getParameter("matchA_" + groupId + "_" + q + "_" + i);
            
            if (left != null && right != null && !left.trim().isEmpty() && !right.trim().isEmpty()) {
                System.out.println("          Matching " + i + ": " + left + " = " + right);
                
                Answer pair = new Answer();
                pair.setQuestionId(questionId);
                pair.setAnswerText(left.trim() + " = " + right.trim());
                pair.setCorrect(true);
                answerDAO.insertAnswer(pair);
            }
        }
    }

    private void insertCompletionAnswersSingle(int groupId, int q, int questionId, HttpServletRequest request) {
        // Handle different completion types
        String answerText = request.getParameter("shortA_" + groupId + "_" + q);
        
        if (answerText != null && !answerText.trim().isEmpty()) {
            System.out.println("          Completion answer: " + answerText);
            
            Answer answer = new Answer();
            answer.setQuestionId(questionId);
            answer.setAnswerText(answerText.trim());
            answer.setCorrect(true);
            answerDAO.insertAnswer(answer);
        } else {
            // Try alternative parameter names for different completion types
            String[] altParams = {
                "completionA_" + groupId + "_" + q,
                "labelA_" + groupId + "_" + q,
                "fillA_" + groupId + "_" + q
            };
            
            for (String param : altParams) {
                String altAnswer = request.getParameter(param);
                if (altAnswer != null && !altAnswer.trim().isEmpty()) {
                    System.out.println("          Alternative completion answer: " + altAnswer);
                    
                    Answer answer = new Answer();
                    answer.setQuestionId(questionId);
                    answer.setAnswerText(altAnswer.trim());
                    answer.setCorrect(true);
                    answerDAO.insertAnswer(answer);
                    break;
                }
            }
        }
    }

    private void insertCompletionAnswers(int sectionIdx, int groupId, int q, int questionId, HttpServletRequest request) {
        // Handle different completion types
        String answerText = request.getParameter("shortA_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId + "_" + q);
        
        if (answerText != null && !answerText.trim().isEmpty()) {
            System.out.println("          Completion answer: " + answerText);
            
            Answer answer = new Answer();
            answer.setQuestionId(questionId);
            answer.setAnswerText(answerText.trim());
            answer.setCorrect(true);
            answerDAO.insertAnswer(answer);
        } else {
            // Try alternative parameter names for different completion types
            String[] altParams = {
                "completionA_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId + "_" + q,
                "labelA_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId + "_" + q,
                "fillA_" + (sectionIdx > 0 ? sectionIdx + "_" : "") + groupId + "_" + q
            };
            
            for (String param : altParams) {
                String altAnswer = request.getParameter(param);
                if (altAnswer != null && !altAnswer.trim().isEmpty()) {
                    System.out.println("          Alternative completion answer: " + altAnswer);
                    
                    Answer answer = new Answer();
                    answer.setQuestionId(questionId);
                    answer.setAnswerText(altAnswer.trim());
                    answer.setCorrect(true);
                    answerDAO.insertAnswer(answer);
                    break;
                }
            }
        }
    }
}
