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
    Map<Integer, List<Option>> questionOptions = (Map<Integer, List<Option>>) request.getAttribute("questionOptions");
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

        <%-- ✅ Hiển thị audio nếu có --%>
        <% if (p.getAudioUrl() != null && !p.getAudioUrl().isEmpty()) { %>
            <audio controls style="margin-top:10px; margin-bottom:10px;">
                <source src="<%= p.getAudioUrl() %>" type="audio/mpeg">
                Your browser does not support the audio element.
            </audio><br/>
        <% } %>

        <%-- ✅ Duyệt câu hỏi --%>
        <%
            List<Question> questions = passageQuestions.get(p.getPassageId());
            for (Question q : questions) {
        %>
        <div class="question-box">
            <p><strong><%= q.getInstruction() != null ? q.getInstruction() : "" %></strong></p>

            <% if (q.getImageUrl() != null && !q.getImageUrl().isEmpty()) { %>
                <img src="<%= q.getImageUrl() %>" width="400px"/><br/>
            <% } %>

            <% if (q.getQuestionText() != null && !q.getQuestionText().isEmpty()) { %>
                <p><%= q.getQuestionText() %></p>
            <% } %>

            <%
                String type = q.getQuestionType();
                int qId = q.getQuestionId();

                if ("MULTIPLE_CHOICE".equals(type)) {
                    List<Option> options = questionOptions.get(qId);
                    for (Option o : options) {
            %>
            <label>
                <input type="checkbox" name="answer_<%= qId %>" value="<%= o.getOptionText() %>"/>
                <%= o.getOptionLabel() %>. <%= o.getOptionText() %>
            </label><br/>
            <%
                    }
                } else if ("TRUE_FALSE_NOT_GIVEN".equals(type)) {
            %>
            <label><input type="radio" name="answer_<%= qId %>" value="TRUE"/> TRUE</label><br/>
            <label><input type="radio" name="answer_<%= qId %>" value="FALSE"/> FALSE</label><br/>
            <label><input type="radio" name="answer_<%= qId %>" value="NOT GIVEN"/> NOT GIVEN</label><br/>
            <%
                } else if ("SUMMARY_COMPLETION".equals(type) || "MATCHING".equals(type)
                        || "FLOWCHART".equals(type) || "TABLE_COMPLETION".equals(type)) {
                    List<Answer> answerList = questionAnswers.get(qId);
                    for (int i = 0; i < answerList.size(); i++) {
            %>
            <input type="text" name="answer_<%= qId %>_<%= i %>" placeholder="Answer <%= i + 1 %>"/><br/>
            <%
                    }
                } else {
            %>
            <input type="text" name="answer_<%= qId %>" placeholder="Your answer"/><br/>
            <%
                }
            %>
        </div>
        <% } %>
    </div>
    <% } %>
    <input type="submit" value="Submit Test"/>
</form>
</body>
</html>
