<%@ page import="java.util.*, model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>📖 Reading Test</title>
    <link rel="stylesheet" href="css/dotest.css" />
    <script src="js/dotest.js"></script>
</head>
<body>
<%
    int examId = Integer.parseInt(request.getParameter("examId"));
    Exam exam = (Exam) request.getAttribute("exam");
    List<Passage> passages = (List<Passage>) request.getAttribute("passages");
    Map<Integer, List<Question>> passageQuestions = (Map<Integer, List<Question>>) request.getAttribute("passageQuestions");
    Map<Integer, List<Answer>> questionAnswers = (Map<Integer, List<Answer>>) request.getAttribute("questionAnswers");
    Map<Integer, List<Option>> questionOptions = (Map<Integer, List<Option>>) request.getAttribute("questionOptions");
%>

<h2 style="margin: 20px;">📖 Reading Test: <%= exam.getTitle() %></h2>

<form action="SubmitTestServlet" method="post">
    <input type="hidden" name="examId" value="<%= examId %>"/>

    <% int passageNumber = 1;
       for (Passage p : passages) {
           List<Question> questions = passageQuestions.get(p.getPassageId());
    %>
    <div class="section-content" id="section-<%= passageNumber %>" style="<%= (passageNumber == 1 ? "display:flex;" : "display:none;") %>">
        <div class="left-panel">
            <div class="section-box">
                <h3>📄 Passage <%= passageNumber %>: <%= p.getTitle() %></h3>
                <p><%= p.getContent().replaceAll("\n", "<br/>") %></p>
            </div>
        </div>

        <div class="right-panel">
            <h4>📌 Questions for: <%= p.getTitle() %></h4>
            <% if (questions != null) {
                for (Question q : questions) {
                    int qId = q.getQuestionId();
                    String type = q.getQuestionType();
            %>
            <div class="question-box">
                <% if (q.getInstruction() != null && !q.getInstruction().isEmpty()) { %>
                <p><strong><%= q.getInstruction() %></strong></p>
                <% } %>

                <% if (q.getImageUrl() != null && !q.getImageUrl().isEmpty()) { %>
                <img src="<%= q.getImageUrl() %>" width="400px"/><br/>
                <% } %>

                <% if (q.getQuestionText() != null && !q.getQuestionText().isEmpty()) { %>
                <p><%= q.getQuestionText() %></p>
                <% } %>

                <% if ("MULTIPLE_CHOICE".equals(type)) {
                    List<Option> options = questionOptions.get(qId);
                    if (options != null) {
                        for (Option o : options) { %>
                            <label>
                                <input type="checkbox" name="answer_<%= qId %>" value="<%= o.getOptionText() %>"/>
                                <%= o.getOptionLabel() %>. <%= o.getOptionText() %>
                            </label><br/>
                        <% }
                    } else { %>
                        <p style="color:red;">❗ No options for question ID <%= qId %></p>
                    <% }
                } else if ("TRUE_FALSE_NOT_GIVEN".equals(type)) { %>
                    <label><input type="radio" name="answer_<%= qId %>" value="TRUE"/> TRUE</label><br/>
                    <label><input type="radio" name="answer_<%= qId %>" value="FALSE"/> FALSE</label><br/>
                    <label><input type="radio" name="answer_<%= qId %>" value="NOT GIVEN"/> NOT GIVEN</label><br/>
                <% } else if ("SUMMARY_COMPLETION".equals(type) || "MATCHING".equals(type)
                           || "FLOWCHART".equals(type) || "TABLE_COMPLETION".equals(type)) {
                    List<Answer> answerList = questionAnswers.get(qId);
                    if (answerList != null) {
                        for (int i = 0; i < answerList.size(); i++) { %>
                            <input type="text" name="answer_<%= qId %>_<%= i %>" title="Your answer"/><br/>
                        <% }
                    } else { %>
                        <p style="color:red;">❗ No answers for question ID <%= qId %></p>
                    <% }
                } else { %>
                    <input type="text" name="answer_<%= qId %>" placeholder="Your answer"/><br/>
                <% } %>
            </div>
            <% } } %>
        </div>
    </div>
    <% passageNumber++; } %>

    <div class="section-nav" style="text-align:center; margin-top: 20px;">
        <% for (int i = 1; i <= passages.size(); i++) { %>
            <button type="button" onclick="showSection(<%= i %>)">Section <%= i %></button>
        <% } %>
    </div>

    <div style="text-align:center; margin-top: 20px;">
        <input type="submit" value="✅ Hoàn thành bài làm" class="btn-submit"/>
    </div>
</form>
</body>
</html>
