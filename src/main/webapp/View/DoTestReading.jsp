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
        %>

        <div class="test-header">
            <h2>📖 Reading Test: <%= exam.getTitle()%></h2>
            <div class="test-tools">
                <span id="timer" class="tool-btn">⏱ 00:00</span>
                <button id="settingsBtn" class="tool-btn">⚙️</button>
                <button id="highlightModeBtn" class="tool-btn" type="button">🖍️ Highlight</button>
                <button id="exitBtn" class="tool-btn">❌</button>
            </div>
        </div>
        <div id="highlightMenu" >
            ✏️ Highlight
        </div>

        <div id="settingsMenu" style="display:none; position:fixed; top:80px; right:20px; background:#fff; border:1px solid #ccc; padding:10px; border-radius:8px; box-shadow:0 4px 10px rgba(0,0,0,0.2); z-index:999;">
            <label><input type="checkbox" id="eyeProtection"> 👁 Eye Protection Mode</label><br>
            <label>🔠 Font Size:
                <select id="fontSizeSelector">
                    <option value="16">Small</option>
                    <option value="18" selected>Medium</option>
                    <option value="22">Large</option>
                </select>
            </label>
        </div>



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
                        <div class="passage-text" data-passage-id="<%= p.getPassageId() %>">
                            <%= p.getContent().replaceAll("\\r?\\n", "<br/>")%>
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
                        <% if (q.getInstruction() != null && !q.getInstruction().isEmpty()) {%>
                        <p><strong><%= q.getInstruction()%></strong></p>
                        <% } %>
                        <% if (q.getImageUrl() != null && !q.getImageUrl().isEmpty()) {%>
                        <img src="<%= request.getContextPath() + "/" + q.getImageUrl().trim()%>" width="400" style="max-width: 100%;" alt="Question image"/><br/>
                        <% } %>
                        <% switch (type) {
                                case "MULTIPLE_CHOICE": {
                                    List<Answer> answers = questionAnswers.get(qId);
                        %>
                        <p><strong><%= q.getQuestionText()%></strong></p>
                        <%
                            if (answers != null) {
                                char label = 'A';
                                for (Answer o : answers) {
                                    String inputId = "q_" + qId + "_" + label;
                        %>
                        <input type="checkbox" id="<%= inputId%>" name="answer_<%= qId%>[]"
                               value="<%= o.getAnswerText()%>" />
                        <label for="<%= inputId%>">
                            <%= label++%>. <%= o.getAnswerText()%>
                        </label><br/>
                        <% }
                        } else {%>
                        <p style="color:red;">❗ No options for question ID <%= qId%></p>
                        <% }
                                break;
                            }
                            case "TRUE_FALSE_NOT_GIVEN":
                            case "YES_NO_NOT_GIVEN": {
                        %>
                        <p><strong><%= q.getQuestionText()%></strong></p>
                        <select name="answer_<%= qId%>" style="
                                width: 100%;
                                max-width: 400px;
                                padding: 15px 20px;
                                font-size: 16px;
                                border-radius: 12px;
                                border: 2px solid #e2e8f0;
                                transition: all 0.3s ease;
                                outline: none;
                                background: rgba(255, 255, 255, 0.9);
                                backdrop-filter: blur(10px);
                                font-family: 'Inter', sans-serif;
                                ">
                            <option value="TRUE">TRUE</option>
                            <option value="FALSE">FALSE</option>
                            <option value="NOT GIVEN">NOT GIVEN</option>
                        </select><br/>
                        <% break;
                            }
                            case "SUMMARY_COMPLETION": {
                                List<Answer> scAnswers = questionAnswers.get(qId);
                                int scCount = (scAnswers != null) ? scAnswers.size() : 1;
                        %>
                        <div class="summary-block">
                            <p><strong><%= q.getQuestionText()%></strong></p>
                            <% for (int i = 0; i < scCount; i++) {%>

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
                                    String passageContent = p.getContent().replaceAll("<[^>]*>", "");
                                    String[] paragraphs = passageContent.split("(\\r?\\n){2,}");
                                    int paragraphCount = paragraphs.length;
                                    List<String> sectionLabels = new ArrayList<>();
                                    for (int i = 0; i < paragraphCount; i++) {
                                        char label = (char) ('A' + i);
                                        sectionLabels.add("Section " + label);
                                    }
                        %>
                        <div style="border: 1px solid #444; padding: 16px 20px; border-radius: 6px; margin-bottom: 20px; background: #fffaf7;">
                            <h4 style="margin-top: 0;">📋 <strong>List of Headings</strong></h4>
                            <ol style="margin-left: 20px;">
                                <% for (String h : headings) {%><li><%= h%></li><% } %>
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
                            case "MATCHING_INFORMATION": {
                                List<Answer> infoAnswers = questionAnswers.get(qId);
                                if (infoAnswers != null) {
                        %>
                        <p><strong><%= q.getQuestionText() != null ? q.getQuestionText() : "Which paragraph contains the following information?"%></strong></p>
                        <div class="matching-information-list">
                            <% for (int i = 0; i < infoAnswers.size(); i++) {
                                    String infoText = infoAnswers.get(i).getAnswerText();%>
                            <div style="margin-bottom: 10px;">
                                <label><%= (i + 1)%>. <%= infoText%></label><br/>
                                <select name="answer_<%= qId%>_<%= i%>">
                                    <option value="">-- Select Paragraph --</option>
                                    <option value="A">A</option><option value="B">B</option><option value="C">C</option>
                                    <option value="D">D</option><option value="E">E</option><option value="F">F</option><option value="G">G</option>
                                </select>
                            </div>
                            <% } %>
                        </div>
                        <% } else { %><p style="color:red;">❗ No answers provided for this question.</p><% }
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
                    <% } %>
                    <% } %>
                </div>
            </div>
            <% } %>

            <div class="section-nav">
                <% for (Passage p : passages) {%>
                <span class="section-btn" data-index="<%= p.getSection()%>">Section <%= p.getSection()%></span>
                <% }%>
            </div>


            <div style="text-align:center; margin-top: 20px;">
                <input type="submit" value="Submit" class="btn-submit" />
            </div>
        </form>

        <script>
            const appContext = "<%= request.getContextPath()%>";
        </script>
        <script src="<%= request.getContextPath()%>/js/doTestReading.js"></script>

    </body>
</html>  