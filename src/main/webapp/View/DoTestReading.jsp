<%@ page import="java.util.*, model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>📖 Reading Test</title>
    <link rel="stylesheet" href="<%= request.getContextPath()%>/css/dotest.css" />
    <style>
        .passage-text {
            text-align: justify;
            line-height: 1.6;
            word-spacing: 1px;
        }
        .question-box {
            margin-bottom: 20px;
        }
        .section-nav {
            text-align: center;
            margin: 30px 0 10px;
        }
        .section-nav button {
            background-color: #eee;
            border: 1px solid #ccc;
            padding: 10px 18px;
            margin: 0 5px;
            border-radius: 6px;
            cursor: pointer;
        }
        .section-nav button.active {
            background-color: #3498db;
            color: white;
        }
    </style>
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

<h2 style="margin: 20px;">📖 Reading Test: <%= exam.getTitle()%></h2>

<form action="SubmitTestServlet" method="post">
    <input type="hidden" name="examId" value="<%= examId %>" />

<% for (Passage p : passages) {
     int sectionNum = p.getSection();
     List<Question> questions = passageQuestions.get(p.getPassageId());
     String style = (sectionNum == 1) ? "display:flex;" : "display:none;";
%>
<div class="section-content" id="section-<%= sectionNum %>" style="<%= style %>" tabindex="0">
    <div class="left-panel">
        <div class="section-box">
            <h3>📄 Section <%= sectionNum %>: <%= p.getTitle()%></h3>
            <div class="passage-text">
                <%= p.getContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\\r?\\n", " ") %>
            </div>
        </div>
    </div>

    <div class="right-panel">
        <h4>🔍 Questions for: <%= p.getTitle()%></h4>
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
            <img src="<%= q.getImageUrl().trim() %>" width="400" alt="Question image" /><br/>
            <% } %>

            <% switch (type) {
                case "MULTIPLE_CHOICE": {
                    List<Option> options = questionOptions.get(qId);
                    if (options != null) {
                        for (Option o : options) { %>
            <label>
                <input type="checkbox" name="answer_<%= qId %>[]"
                       value="<%= o.getOptionText() %>" />
                <%= o.getOptionLabel() %>. <%= o.getOptionText() %>
            </label><br/>
            <%   }
                    } else { %>
            <p style="color:red;">❗ No options for question ID <%= qId %></p>
            <%   }
                    break;
                }

                case "TRUE_FALSE_NOT_GIVEN":
                case "YES_NO_NOT_GIVEN": %>
            <label><input type="radio" name="answer_<%= qId %>" value="TRUE" /> TRUE</label><br/>
            <label><input type="radio" name="answer_<%= qId %>" value="FALSE" /> FALSE</label><br/>
            <label><input type="radio" name="answer_<%= qId %>" value="NOT GIVEN" /> NOT GIVEN</label><br/>
            <% break;

                case "SUMMARY_COMPLETION": {
                    List<Answer> scAnswers = questionAnswers.get(qId);
                    int scCount = (scAnswers != null) ? scAnswers.size() : 1;
            %>
            <div class="summary-block">
                <p><strong><%= q.getQuestionText() %></strong></p>
                <% for (int i = 0; i < scCount; i++) { %>
                <label><%= (i + 1) %>. </label>
                <input type="text" name="answer_<%= qId %>_<%= i %>" placeholder="Your answer"><br/>
                <% } %>
            </div>
            <% break;
                }

                case "MATCHING":
                case "MATCHING_HEADINGS":
                case "MATCHING_ENDINGS":
                case "TABLE_COMPLETION":
                case "FLOWCHART":
                case "DIAGRAM_LABELING": {
                    List<Answer> genericAnswers = questionAnswers.get(qId);
                    int genericCount = (genericAnswers != null) ? genericAnswers.size() : 1;
                    for (int i = 0; i < genericCount; i++) { %>
            <input type="text" name="answer_<%= qId %>_<%= i %>" placeholder="Your answer"><br/>
            <%   }
                    break;
                }

                default: %>
            <p><%= q.getQuestionText().replaceAll("<", "&lt;").replaceAll(">", "&gt;") %></p>
            <input type="text" name="answer_<%= qId %>" placeholder="Your answer"><br/>
            <% } %>
        </div>
        <% } } %>
    </div>
</div>
<% } %>

<!-- Section navigation -->
<div class="section-nav">
    <% for (Passage p : passages) { %>
    <button type="button" class="section-btn" data-index="<%= p.getSection() %>">Section <%= p.getSection() %></button>
    <% } %>
</div>

<div style="text-align:center; margin-top: 20px;">
    <input type="submit" value="✅ Hoàn thành bài làm" class="btn-submit" />
</div>
</form>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const buttons = document.querySelectorAll(".section-btn");
    const sections = document.querySelectorAll(".section-content");

    buttons.forEach(btn => {
        btn.addEventListener("click", function () {
            const index = this.getAttribute("data-index");
            sections.forEach(sec => sec.style.display = "none");
            document.getElementById("section-" + index).style.display = "flex";

            buttons.forEach(b => b.classList.remove("active"));
            this.classList.add("active");
        });
    });

    // Set first button as active by default
    if (buttons.length > 0) buttons[0].classList.add("active");
});
</script>
</body>
</html>
