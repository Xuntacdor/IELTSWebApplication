package controller;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Exam;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminExamManagementServlet", urlPatterns = {"/admin/exam-management"})
public class AdminExamManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view-all"; // Default action
        }
        
        switch (action) {
            case "view-all":
                viewAllExams(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteExam(request, response);
                break;
            default:
                viewAllExams(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("edit".equals(action)) {
            updateExam(request, response);
        } else {
            response.sendRedirect("exam-management?action=view-all");
        }
    }

    private void viewAllExams(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ExamDAO examDAO = new ExamDAO();
            List<Exam> allExams = examDAO.getAllExams();
            
            request.setAttribute("exams", allExams);
            request.getRequestDispatcher("../View/admin-view-all-exams.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../View/error.jsp?msg=Error loading exams");
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String examIdParam = request.getParameter("examId");
            if (examIdParam == null || !examIdParam.matches("\\d+")) {
                response.sendRedirect("../View/error.jsp?msg=Invalid exam ID");
                return;
            }

            int examId = Integer.parseInt(examIdParam);
            
            // DAO instances
            ExamDAO examDAO = new ExamDAO();
            PassageDAO passageDAO = new PassageDAO();
            QuestionDAO questionDAO = new QuestionDAO();
            AnswerDAO answerDAO = new AnswerDAO();
            OptionDAO optionDAO = new OptionDAO();

            // Get exam
            Exam exam = examDAO.getExamById(examId);
            if (exam == null) {
                response.sendRedirect("../View/error.jsp?msg=Exam not found");
                return;
            }
            
            // Get all passages for this exam
            List<model.Passage> passages = passageDAO.getPassagesByExamId(examId);
            passages.sort(java.util.Comparator.comparingInt(model.Passage::getSection));
            
            // Get questions, options, answers for each passage
            java.util.Map<Integer, List<model.Question>> passageQuestions = new java.util.HashMap<>();
            java.util.Map<Integer, List<model.Option>> questionOptions = new java.util.HashMap<>();
            java.util.Map<Integer, List<model.Answer>> questionAnswers = new java.util.HashMap<>();
            
            for (model.Passage passage : passages) {
                int passageId = passage.getPassageId();
                
                // Get questions for this passage
                List<model.Question> questions = questionDAO.getQuestionsByPassageId(passageId);
                passageQuestions.put(passageId, questions);
                
                // Get options and answers for each question
                for (model.Question question : questions) {
                    int questionId = question.getQuestionId();
                    
                    List<model.Option> options = optionDAO.getOptionsByQuestionId(questionId);
                    questionOptions.put(questionId, options);
                    
                    List<model.Answer> answers = answerDAO.getAnswersByQuestionId(questionId);
                    questionAnswers.put(questionId, answers);
                }
            }
            
            // Set attributes
            request.setAttribute("exam", exam);
            request.setAttribute("passages", passages);
            request.setAttribute("passageQuestions", passageQuestions);
            request.setAttribute("questionOptions", questionOptions);
            request.setAttribute("questionAnswers", questionAnswers);
            
            // Determine which JSP to use based on exam type
            String jspPath;
            if (exam.getType().startsWith("READING")) {
                jspPath = "../View/admin-edit-reading-exam.jsp";
            } else {
                jspPath = "../View/admin-edit-listening-exam.jsp";
            }
            
            request.getRequestDispatcher(jspPath).forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../View/error.jsp?msg=Error loading exam: " + e.getMessage());
        }
    }

    private void updateExam(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            
            String examIdParam = request.getParameter("examId");
            String title = request.getParameter("title");
            String type = request.getParameter("type");
            System.out.println("[DEBUG] examId=" + examIdParam + ", title=" + title + ", type=" + type);
            
            if (examIdParam == null || !examIdParam.matches("\\d+") || 
                title == null || title.trim().isEmpty() ||
                type == null || type.trim().isEmpty()) {
                System.out.println("[ERROR] Invalid input data");
                response.sendRedirect("../View/error.jsp?msg=Invalid input data");
                return;
            }

            int examId = Integer.parseInt(examIdParam);
            
            // DAO instances
            ExamDAO examDAO = new ExamDAO();
            PassageDAO passageDAO = new PassageDAO();
            QuestionDAO questionDAO = new QuestionDAO();
            AnswerDAO answerDAO = new AnswerDAO();
            OptionDAO optionDAO = new OptionDAO();
            
            // Get existing exam
            Exam exam = examDAO.getExamById(examId);
            if (exam == null) {
                System.out.println("[ERROR] Exam not found: " + examId);
                response.sendRedirect("../View/error.jsp?msg=Exam not found");
                return;
            }
            
            // Update exam basic info
            exam.setTitle(title.trim());
            exam.setType(type.trim());
            boolean examUpdated = examDAO.updateExam(exam);
            System.out.println("[DEBUG] examUpdated=" + examUpdated);
            
            if (!examUpdated) {
                System.out.println("[ERROR] Failed to update exam in DB");
                response.sendRedirect("../View/error.jsp?msg=Failed to update exam");
                return;
            }
            
            // Get all passages for this exam
            List<model.Passage> passages = passageDAO.getPassagesByExamId(examId);
            System.out.println("[DEBUG] Passages found: " + passages.size());
            
            // Update passages, questions, options, and answers
            for (model.Passage passage : passages) {
                int passageId = passage.getPassageId();
                int section = passage.getSection();
                System.out.println("[DEBUG] Updating passageId=" + passageId + ", section=" + section);
                
                // Update passage title
                String passageTitle = request.getParameter("passageTitle_" + section);
                if (passageTitle != null) {
                    passage.setTitle(passageTitle.trim());
                    boolean ok = passageDAO.updatePassage(passage);
                    System.out.println("[DEBUG] updatePassage title: " + ok);
                }
                
                // Update passage content (for reading)
                String passageContent = request.getParameter("passageContent_" + section);
                if (passageContent != null) {
                    passage.setContent(passageContent.trim());
                    boolean ok = passageDAO.updatePassage(passage);
                    System.out.println("[DEBUG] updatePassage content: " + ok);
                }
                
                // Update section title (for listening)
                String sectionTitle = request.getParameter("sectionTitle_" + section);
                if (sectionTitle != null) {
                    passage.setTitle(sectionTitle.trim());
                    boolean ok = passageDAO.updatePassage(passage);
                    System.out.println("[DEBUG] updatePassage sectionTitle: " + ok);
                }
                
                // Get questions for this passage
                List<model.Question> questions = questionDAO.getQuestionsByPassageId(passageId);
                System.out.println("[DEBUG] Questions for passageId=" + passageId + ": " + questions.size());
                
                for (model.Question question : questions) {
                    int questionId = question.getQuestionId();
                    System.out.println("[DEBUG] Updating questionId=" + questionId);
                    
                    // Update question text
                    String questionText = request.getParameter("questionText_" + questionId);
                    if (questionText != null) {
                        question.setQuestionText(questionText.trim());
                        boolean ok = questionDAO.updateQuestion(question);
                        System.out.println("[DEBUG] updateQuestion text: " + ok);
                    }
                    
                    // Update instruction
                    String instruction = request.getParameter("instruction_" + questionId);
                    if (instruction != null) {
                        question.setInstruction(instruction.trim());
                        boolean ok = questionDAO.updateQuestion(question);
                        System.out.println("[DEBUG] updateQuestion instruction: " + ok);
                    }
                    
                    // Update options
                    List<model.Option> options = optionDAO.getOptionsByQuestionId(questionId);
                    for (model.Option option : options) {
                        String optionText = request.getParameter("optionText_" + option.getOptionId());
                        if (optionText != null) {
                            option.setOptionText(optionText.trim());
                            boolean ok = optionDAO.updateOption(option);
                            System.out.println("[DEBUG] updateOption optionId=" + option.getOptionId() + ": " + ok);
                        }
                    }
                    
                    // Update answers
                    List<model.Answer> answers = answerDAO.getAnswersByQuestionId(questionId);
                    for (model.Answer answer : answers) {
                        String answerText = request.getParameter("answerText_" + answer.getAnswerId());
                        if (answerText != null) {
                            answer.setAnswerText(answerText.trim());
                            boolean ok = answerDAO.updateAnswer(answer);
                            System.out.println("[DEBUG] updateAnswer answerId=" + answer.getAnswerId() + ": " + ok);
                        }
                        
                        // Update correct status
                        String isCorrect = request.getParameter("isCorrect_" + answer.getAnswerId());
                        answer.setCorrect("on".equals(isCorrect));
                        boolean ok = answerDAO.updateAnswer(answer);
                        System.out.println("[DEBUG] updateAnswer isCorrect answerId=" + answer.getAnswerId() + ": " + ok);
                    }
                }
            }
            System.out.println("[SUCCESS] Exam updated successfully!");
            response.sendRedirect("exam-management?action=view-all&msg=Exam updated successfully");
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[ERROR] Exception: " + e.getMessage());
            response.sendRedirect("../View/error.jsp?msg=Error updating exam: " + e.getMessage());
        }
    }

    private void deleteExam(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String examIdParam = request.getParameter("examId");
            if (examIdParam == null || !examIdParam.matches("\\d+")) {
                response.sendRedirect("../View/error.jsp?msg=Invalid exam ID");
                return;
            }

            int examId = Integer.parseInt(examIdParam);
            
            // DAO instances
            ExamDAO examDAO = new ExamDAO();
            PassageDAO passageDAO = new PassageDAO();
            QuestionDAO questionDAO = new QuestionDAO();
            AnswerDAO answerDAO = new AnswerDAO();
            OptionDAO optionDAO = new OptionDAO();

            // Get exam to check if exists
            Exam exam = examDAO.getExamById(examId);
            if (exam == null) {
                response.sendRedirect("../View/error.jsp?msg=Exam not found");
                return;
            }

            // Get all passages for this exam
            List<model.Passage> passages = passageDAO.getPassagesByExamId(examId);
            
            // Delete all related data
            for (model.Passage passage : passages) {
                int passageId = passage.getPassageId();
                
                // Get all questions for this passage
                List<model.Question> questions = questionDAO.getQuestionsByPassageId(passageId);
                
                for (model.Question question : questions) {
                    int questionId = question.getQuestionId();
                    
                    // Delete answers for this question
                    answerDAO.deleteAnswersByQuestionId(questionId);
                    
                    // Delete options for this question
                    optionDAO.deleteOptionsByQuestionId(questionId);
                }
                
                // Delete questions for this passage
                questionDAO.deleteQuestionsByPassageId(passageId);
            }
            
            // Delete passages for this exam
            passageDAO.deletePassagesByExamId(examId);
            
            // Finally delete the exam
            boolean deleted = examDAO.deleteExam(examId);
            
            if (deleted) {
                response.sendRedirect("exam-management?action=view-all&msg=Exam deleted successfully");
            } else {
                response.sendRedirect("../View/error.jsp?msg=Failed to delete exam");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../View/error.jsp?msg=Error deleting exam: " + e.getMessage());
        }
    }
} 