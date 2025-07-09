package controller;

import dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;

import java.io.IOException;
import java.util.*;

@WebServlet(name = "DoTestServlet", urlPatterns = {"/doTest"})
public class DoTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String examIdRaw = req.getParameter("examId");
            if (examIdRaw == null || !examIdRaw.matches("\\d+")) {
                resp.sendRedirect("View/error.jsp?msg=Invalid examId");
                return;
            }
            int examId = Integer.parseInt(examIdRaw);

            // Load DAOs
            ExamDAO examDAO = new ExamDAO();
            PassageDAO passageDAO = new PassageDAO();
            QuestionDAO questionDAO = new QuestionDAO();
            OptionDAO optionDAO = new OptionDAO();
            AnswerDAO answerDAO = new AnswerDAO();

            Exam exam = examDAO.getExamById(examId);
            if (exam == null) {
                resp.sendRedirect("View/error.jsp?msg=Exam not found");
                return;
            }

            List<Passage> passages = passageDAO.getPassagesByExamId(examId);
            passages.sort(Comparator.comparingInt(Passage::getSection));

            Map<Integer, List<Question>> passageQuestions = new HashMap<>();
            Map<Integer, List<Option>> questionOptions = new HashMap<>();
            Map<Integer, List<Answer>> questionAnswers = new HashMap<>();

            for (Passage p : passages) {
                List<Question> questions = questionDAO.getQuestionsByPassageId(p.getPassageId());
                passageQuestions.put(p.getPassageId(), questions);

                for (Question q : questions) {
                    int qId = q.getQuestionId();
                    questionOptions.put(qId, optionDAO.getOptionsByQuestionId(qId));
                    questionAnswers.put(qId, answerDAO.getAnswersByQuestionId(qId));
                }
            }

            // Gán dữ liệu cho JSP
            req.setAttribute("exam", exam);
            req.setAttribute("passages", passages);
            req.setAttribute("passageQuestions", passageQuestions);
            req.setAttribute("questionOptions", questionOptions);
            req.setAttribute("questionAnswers", questionAnswers);

            // Chuyển tới trang hiển thị phù hợp
            String type = exam.getType().toUpperCase();
            String jspPath = type.contains("LISTENING")
                    ? "/View/DoTestListening.jsp"
                    : "/View/DoTestReading.jsp";

            req.getRequestDispatcher(jspPath).forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Lỗi khi tải đề thi: " + e.getMessage());
            req.getRequestDispatcher("/View/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "DoTestServlet: Load and render IELTS test based on examId";
    }
}
