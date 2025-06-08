package Controller;

import dao.AnswerDAO;
import dao.ExamDAO;
import dao.PassageDAO;
import dao.QuestionDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import Model.Answer;
import Model.Exam;
import Model.Passage;
import Model.Question;

import java.io.IOException;
import java.util.*;

@WebServlet("/doTest")
public class DoTestServlet extends HttpServlet {

    private final ExamDAO examDAO = new ExamDAO();
    private final PassageDAO passageDAO = new PassageDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final AnswerDAO answerDAO = new AnswerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String examIdParam = request.getParameter("examId");
        if (examIdParam == null || examIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing examId");
            return;
        }

        int examId = Integer.parseInt(examIdParam);

        Exam exam = examDAO.getExamById(examId); // dùng hàm riêng nếu có
        if (exam == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Exam not found");
            return;
        }

        List<Passage> passages = passageDAO.getPassagesByExamId(examId);
        Map<Integer, List<Question>> passageQuestions = new HashMap<>();
        Map<Integer, List<Answer>> questionAnswers = new HashMap<>();

        for (Passage p : passages) {
            List<Question> questions = questionDAO.getQuestionsByPassageId(p.getPassageId());
            passageQuestions.put(p.getPassageId(), questions);

            for (Question q : questions) {
                questionAnswers.put(q.getQuestionId(), answerDAO.getAnswersByQuestionId(q.getQuestionId()));
            }
        }

        request.setAttribute("exam", exam);
        request.setAttribute("passages", passages);
        request.setAttribute("passageQuestions", passageQuestions);
        request.setAttribute("questionAnswers", questionAnswers);
        request.getRequestDispatcher("doTest.jsp").forward(request, response);
    }

}
