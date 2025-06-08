<%@page import="Model.Answer"%>
<%@page import="Model.Question"%>
<%@page import="Model.Passage"%>
<%@page import="Model.Exam"%>
<%@ page import="java.util.*, model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Do My Test</title>
        <link rel="stylesheet" href="css/style.css" />
    </head>
    <body>
        <%
            int examId = Integer.parseInt(request.getParameter("examId"));

            Exam exam = (Exam) request.getAttribute("exam");
            List<Passage> passages = (List<Passage>) request.getAttribute("passages");
            Map<Integer, List<Question>> passageQuestions = (Map<Integer, List<Question>>) request.getAttribute("passageQuestions");
            Map<Integer, List<Answer>> questionAnswers = (Map<Integer, List<Answer>>) request.getAttribute("questionAnswers");
        %>

        <h2>📝 Do Test: <%= exam.getTitle() %></h2>

        <form action="SubmitTestServlet" method="post">
            <input type="hidden" name="examId" value="<%= examId %>"/>
            <%
                for (Passage p : passages) {
            %>
            <div class="section-box">
                <h3><%= p.getTitle() %></h3>
                <p><%= p.getContent().replaceAll("\n", "<br/>") %></p>

                <%
                    List<Question> questions = passageQuestions.get(p.getPassageId());
                    for (Question q : questions) {
                %>
                <div class="question-box">
                    <p><strong><%= q.getInstruction() %></strong></p>
                    <% if (q.getImageUrl() != null && !q.getImageUrl().isEmpty()) { %>
                    <img src="<%= q.getImageUrl() %>" width="400px"/><br/>
                    <% } %>
                    <p><%= q.getQuestionText() %></p>

                    <%
                        List<Answer> options = questionAnswers.get(q.getQuestionId());
                        if ("MULTIPLE_CHOICE".equals(q.getQuestionType())) {
                            for (Answer a : options) {
                    %>
                    <label>
                        <input type="checkbox" name="answer_<%= q.getQuestionId() %>" value="<%= a.getAnswerText() %>"/>
                        <%= a.getAnswerText() %>
                    </label><br/>
                    <%
                            }
                        } else {
                    %>
                    <input type="text" name="answer_<%= q.getQuestionId() %>" placeholder="Your answer"/><br/>
                    <%
                        }
                    %>
                </div>
                <%
                    }
                %>
            </div>
            <%
                }
            %>
            <input type="submit" value="Submit Test"/>
        </form>
    </body>
</html>
