/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AnswerDAO;
import dao.ExamDAO;
import dao.OptionDAO;
import dao.PassageDAO;
import dao.QuestionDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Answer;
import model.Exam;
import model.Option;
import model.Passage;
import model.Question;

/**
 *
 * @author NTKC
 */
@WebServlet(name = "DoTestServlet", urlPatterns = {"/doTest"})
public class DoTestServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DoTestServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DoTestServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int examId = Integer.parseInt(req.getParameter("examId"));

            // DAO
            ExamDAO examDAO = new ExamDAO();
            PassageDAO passageDAO = new PassageDAO();
            QuestionDAO questionDAO = new QuestionDAO();
            OptionDAO optionDAO = new OptionDAO();
            AnswerDAO answerDAO = new AnswerDAO();

            // Lấy đề thi
            Exam exam = examDAO.getExamById(examId);

            // Lấy passages theo đề thi
            List<Passage> passages = passageDAO.getPassagesByExamId(examId);

            // Map<passageId, List<Question>>
            Map<Integer, List<Question>> passageQuestions = new HashMap<>();
            for (Passage p : passages) {
                List<Question> qs = questionDAO.getQuestionsByPassageId(p.getPassageId());
                passageQuestions.put(p.getPassageId(), qs);
            }

            // Map<questionId, List<Option>>
            Map<Integer, List<Option>> questionOptions = optionDAO.getAllOptionsGroupedByQuestion();

            // Map<questionId, List<Answer>>
            Map<Integer, List<Answer>> questionAnswers = answerDAO.getAllAnswersGroupedByQuestion();

            // Truyền dữ liệu cho JSP
            req.setAttribute("exam", exam);
            req.setAttribute("passages", passages);
            req.setAttribute("passageQuestions", passageQuestions);
            req.setAttribute("questionOptions", questionOptions);
            req.setAttribute("questionAnswers", questionAnswers);

            req.getRequestDispatcher("View/doTest.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("View/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
