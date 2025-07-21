package controller;

import dao.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/SubmitTestServlet")
public class SubmitTestController extends HttpServlet {

    private final AnswerDAO answerDAO = new AnswerDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final OptionDAO optionDAO = new OptionDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int examId = Integer.parseInt(request.getParameter("examId"));
        List<Question> allQuestions = questionDAO.getQuestionsByExamId(examId);

        int total = 0;
        int correct = 0;
        List<Map<String, String>> wrongList = new ArrayList<>();

        for (Question q : allQuestions) {
            String type = q.getQuestionType();
            int qId = q.getQuestionId();

            if ("MULTIPLE_CHOICE".equals(type)) {
                total++;
                String[] userAnswers = request.getParameterValues("answer_" + qId);

                Set<String> userSet = new HashSet<>();
                if (userAnswers != null) {
                    for (String ua : userAnswers) {
                        if (ua != null) {
                            userSet.add(ua.trim().toLowerCase());
                        }
                    }
                }

                List<Option> correctOptions = optionDAO.getCorrectOptionsByQuestionId(qId);
                Set<String> correctSet = new HashSet<>();
                for (Option o : correctOptions) {
                    correctSet.add(o.getOptionText().trim().toLowerCase());
                }

                if (userSet.equals(correctSet)) {
                    correct++;
                } else {
                    Map<String, String> wrong = new HashMap<>();
                    wrong.put("question", q.getQuestionText());
                    wrong.put("correct", String.join(", ", correctSet));
                    wrong.put("your", userSet.isEmpty() ? "(Không trả lời)" : String.join(", ", userSet));
                    wrongList.add(wrong);
                }

            } else if ("SUMMARY_COMPLETION".equals(type)
                    || "MATCHING".equals(type)
                    || "FLOWCHART".equals(type)
                    || "TABLE_COMPLETION".equals(type)) {

                List<Answer> correctAnswers = answerDAO.getCorrectAnswersByQuestionId(qId);
                total += correctAnswers.size();

                for (int i = 0; i < correctAnswers.size(); i++) {
                    String param = "answer_" + qId + "_" + i;
                    String ua = request.getParameter(param);
                    String correctAns = correctAnswers.get(i).getAnswerText().trim();
                    if (ua != null && ua.trim().equalsIgnoreCase(correctAns)) {
                        correct++;
                    } else {
                        Map<String, String> wrong = new HashMap<>();
                        wrong.put("question", q.getQuestionText() + " (" + (i+1) + ")");
                        wrong.put("correct", correctAns);
                        wrong.put("your", (ua == null || ua.trim().isEmpty()) ? "(Không trả lời)" : ua.trim());
                        wrongList.add(wrong);
                    }
                }

            } else if ("TRUE_FALSE_NOT_GIVEN".equals(type)
                    || "YES_NO_NOT_GIVEN".equals(type)) {

                total++;
                String ua = request.getParameter("answer_" + qId);
                List<Answer> correctAnswers = answerDAO.getCorrectAnswersByQuestionId(qId);
                boolean found = false;
                for (Answer a : correctAnswers) {
                    if (ua != null && a.getAnswerText().equalsIgnoreCase(ua.trim())) {
                        correct++;
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    Map<String, String> wrong = new HashMap<>();
                    wrong.put("question", q.getQuestionText());
                    wrong.put("correct", correctAnswers.isEmpty() ? "" : correctAnswers.get(0).getAnswerText());
                    wrong.put("your", (ua == null || ua.trim().isEmpty()) ? "(Không trả lời)" : ua.trim());
                    wrongList.add(wrong);
                }

            } else if ("MATCHING_HEADINGS".equals(type)) {
                // Đếm số dropdown
                List<Answer> correctAnswers = answerDAO.getCorrectAnswersByQuestionId(qId);
                int count = correctAnswers.size();
                total += count;

                for (int i = 0; i < count; i++) {
                    String param = "answer_" + qId + "_" + i;
                    String ua = request.getParameter(param);
                    String correctAns = correctAnswers.get(i).getAnswerText().trim();
                    if (ua != null && ua.trim().equalsIgnoreCase(correctAns)) {
                        correct++;
                    } else {
                        Map<String, String> wrong = new HashMap<>();
                        wrong.put("question", q.getQuestionText() + " (" + (i+1) + ")");
                        wrong.put("correct", correctAns);
                        wrong.put("your", (ua == null || ua.trim().isEmpty()) ? "(Không trả lời)" : ua.trim());
                        wrongList.add(wrong);
                    }
                }

            } else {
                // Default 1-answer (short answer)
                total++;
                String ua = request.getParameter("answer_" + qId);
                List<Answer> correctAnswers = answerDAO.getCorrectAnswersByQuestionId(qId);
                boolean found = false;
                if (ua != null && !ua.trim().isEmpty()) {
                    for (Answer a : correctAnswers) {
                        if (a.getAnswerText().equalsIgnoreCase(ua.trim())) {
                            correct++;
                            found = true;
                            break;
                        }
                    }
                }
                if (!found) {
                    Map<String, String> wrong = new HashMap<>();
                    wrong.put("question", q.getQuestionText());
                    wrong.put("correct", correctAnswers.isEmpty() ? "" : correctAnswers.get(0).getAnswerText());
                    wrong.put("your", (ua == null || ua.trim().isEmpty()) ? "(Không trả lời)" : ua.trim());
                    wrongList.add(wrong);
                }
            }
        }

        double score = total > 0 ? ((double) correct / total) * 100 : 0;

        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                int userId = user.getUserId();
                ExamDAO examDAO = new ExamDAO();
                Exam exam = examDAO.getExamById(examId);
                String type = (exam != null) ? exam.getType() : "Unknown";
                UserProgressDAO.insertUserProgress(userId, examId, score, type);
            }
        }

        request.setAttribute("correct", correct);
        request.setAttribute("total", total);
        request.setAttribute("score", score);
        request.setAttribute("wrongList", wrongList);
        request.getRequestDispatcher("./View/result.jsp").forward(request, response);
    }
}
