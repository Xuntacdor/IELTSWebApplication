<%@ page import="java.util.*, model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>📖 Reading Test</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/DoTestReading.css" />
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

        <form action="${pageContext.request.contextPath}/SubmitTestServlet" method="post">
            <input type="hidden" name="examId" value="<%= examId%>" />

            <% for (Passage p : passages) {
                    int sectionNum = p.getSection();
                    List<Question> questions = passageQuestions.get(p.getPassageId());
                    String style = (sectionNum == 1) ? "display:flex;" : "display:none;";
            %>
            <div class="section-content" id="section-<%= sectionNum%>" style="<%= style%>" tabindex="0">
                <div class="left-panel">
                    <div class="section-box">
                        <h3>📄 Section <%= sectionNum%>: <%= p.getTitle()%></h3>
                        <div class="passage-text"><%= p.getContent()%></div>
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
                        <% if (q.getInstruction() != null && !q.getInstruction().isEmpty()) {%>
                        <p><strong><%= q.getInstruction()%></strong></p>
                        <% } %>

                        <% if (q.getImageUrl() != null && !q.getImageUrl().isEmpty()) {%>
                        <img src="<%= request.getContextPath() + "/" + q.getImageUrl().trim()%>" width="400" style="max-width: 100%;" alt="Question image"/><br/>
                        <% } %>

                        <% switch (type) {
                                case "MULTIPLE_CHOICE": {
                                    List<Option> options = questionOptions.get(qId);
                                    if (options != null) {
                                        for (Option o : options) {
                        %>
                        <%
                            String inputId = "q_" + qId + "_" + o.getOptionLabel();
                        %>
                        <input type="checkbox"
                               id="<%= inputId%>"
                               name="answer_<%= qId%>[]"
                               value="<%= o.getOptionText()%>" />

                        <label for="<%= inputId%>">
                            <%= o.getOptionLabel()%>. <%= o.getOptionText()%>
                        </label><br/>

                        <%   }
                        } else {%>
                        <p style="color:red;">❗ No options for question ID <%= qId%></p>
                        <% }
                                break;
                            }

                            case "TRUE_FALSE_NOT_GIVEN":
                            case "YES_NO_NOT_GIVEN":%>
                        <label><input type="radio" name="answer_<%= qId%>" value="TRUE" /> TRUE</label><br/>
                        <label><input type="radio" name="answer_<%= qId%>" value="FALSE" /> FALSE</label><br/>
                        <label><input type="radio" name="answer_<%= qId%>" value="NOT GIVEN" /> NOT GIVEN</label><br/>
                            <% break;

                                case "SUMMARY_COMPLETION": {
                                    List<Answer> scAnswers = questionAnswers.get(qId);
                                    int scCount = (scAnswers != null) ? scAnswers.size() : 1;
                            %>
                        <div class="summary-block">
                            <p><strong><%= q.getQuestionText()%></strong></p>
                            <% for (int i = 0; i < scCount; i++) {%>
                            <label><%= (i + 1)%>. </label>
                            <input type="text" name="answer_<%= qId%>_<%= i%>" placeholder="Your answer"><br/>
                            <% } %>
                        </div>
                        <% break;
                            }

                            case "MATCHING_HEADINGS": {
                                List<Answer> allAnswers = questionAnswers.get(qId);
                                if (allAnswers != null) {
                                    List<String> headings = new ArrayList<>();
                                    for (Answer a : allAnswers) {
                                        if (a.getAnswerText().startsWith("LIST: ")) {
                                            headings.add(a.getAnswerText().substring(6).trim());
                                        }
                                    }

                                    // Tính số đoạn trong passage (dựa vào xuống dòng kép \n\n)
                                    String passageContent = p.getContent().replaceAll("<[^>]*>", ""); // loại thẻ HTML
                                    String[] paragraphs = passageContent.split("(\\r?\\n){2,}");
                                    int paragraphCount = paragraphs.length;

                                    // Tạo danh sách section label A, B, C...
                                    List<String> sectionLabels = new ArrayList<>();
                                    for (int i = 0; i < paragraphCount; i++) {
                                        char label = (char) ('A' + i);
                                        sectionLabels.add("Section " + label);
                                    }
                        %>

                        <!-- Danh sách headings -->
                        <div style="border: 1px solid #444; padding: 16px 20px; border-radius: 6px; margin-bottom: 20px; background: #fffaf7;">
                            <h4 style="margin-top: 0;">📋 <strong>List of Headings</strong></h4>
                            <ol style="margin-left: 20px;">
                                <% for (String h : headings) {%>
                                <li><%= h%></li>
                                    <% } %>
                            </ol>
                        </div>

                        <p><strong>Choose the correct heading for each section:</strong></p>
                        <div class="matching-headings-grid">
                            <% for (int i = 0; i < sectionLabels.size(); i++) {%>
                            <select name="answer_<%= qId%>_<%= i%>">
                                <option value=""><%= sectionLabels.get(i)%></option>
                                <% for (String h : headings) {%>
                                <option value="<%= h%>"><%= h%></option>
                                <% } %>
                            </select>
                            <% } %>
                        </div>

                        <% }
                                break;
                            }
                            case "MATCHING":
                            case "MATCHING_ENDINGS":
                            case "TABLE_COMPLETION":
                            case "FLOWCHART":
                            case "DIAGRAM_LABELING": {
                                List<Answer> genericAnswers = questionAnswers.get(qId);
                                int genericCount = (genericAnswers != null) ? genericAnswers.size() : 1;
                                for (int i = 0; i < genericCount; i++) {
                        %>
                        <input type="text" name="answer_<%= qId%>_<%= i%>" placeholder="Your answer"><br/>
                        <% }
                                break;
                            }

                            default:%>
                        <p><%= q.getQuestionText().replaceAll("<", "&lt;").replaceAll(">", "&gt;")%></p>
                        <input type="text" name="answer_<%= qId%>" placeholder="Your answer"><br/>
                        <% } %>
                    </div>
                    <% }
                        } %>
                </div>
            </div>
            <% } %>

            <div class="section-nav">
                <% for (Passage p : passages) {%>
                <button type="button" class="section-btn" data-index="<%= p.getSection()%>">Section <%= p.getSection()%></button>
                <% }%>
            </div>

            <div style="text-align:center; margin-top: 20px;">
                <input type="submit" value="Submit" class="btn-submit" />
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

                if (buttons.length > 0)
                    buttons[0].classList.add("active");
            });
        </script>

    </body>
</html>
