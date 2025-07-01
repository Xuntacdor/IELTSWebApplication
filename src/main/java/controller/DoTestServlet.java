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
            int examId = Integer.parseInt(req.getParameter("examId"));

            // Load exam + passages
            ExamDAO examDAO = new ExamDAO();
            PassageDAO passageDAO = new PassageDAO();
            QuestionDAO questionDAO = new QuestionDAO();
            OptionDAO optionDAO = new OptionDAO();
            AnswerDAO answerDAO = new AnswerDAO();

            Exam exam = examDAO.getExamById(examId);
            List<Passage> passages = passageDAO.getPassagesByExamId(examId);

            Map<Integer, List<Question>> passageQuestions = new HashMap<>();
            for (Passage p : passages) {
                passageQuestions.put(p.getPassageId(), questionDAO.getQuestionsByPassageId(p.getPassageId()));
            }

            Map<Integer, List<Option>> questionOptions = optionDAO.getAllOptionsGroupedByQuestion();
            Map<Integer, List<Answer>> questionAnswers = answerDAO.getAllAnswersGroupedByQuestion();

            // Set attribute cho JSP
            req.setAttribute("exam", exam);
            req.setAttribute("passages", passages);
            req.setAttribute("passageQuestions", passageQuestions);
            req.setAttribute("questionOptions", questionOptions);
            req.setAttribute("questionAnswers", questionAnswers);

            // Chuyển tới đúng giao diện (listening hoặc reading)
            String jspPath = exam.getType().equalsIgnoreCase("LISTENING")
                    ? "View/DoTestListening.jsp"
                    : "View/DoTestReading.jsp";

            req.getRequestDispatcher(jspPath).forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("View/error.jsp");
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
