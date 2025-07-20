<%@ page import="java.util.*, model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>🎧 Listening Test</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/dotest.css" />
        <style>
            .audio-player {
                background: #fff;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            
            .audio-controls {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 15px;
            }
            
            .play-btn {
                background: #4f8cff;
                color: white;
                border: none;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                font-size: 20px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
            }
            
            .play-btn:hover {
                background: #2563eb;
                transform: scale(1.1);
            }
            
            .play-btn.playing {
                background: #dc3545;
            }
            
            .progress-bar {
                flex: 1;
                height: 8px;
                background: #e2e8f0;
                border-radius: 4px;
                position: relative;
                cursor: pointer;
            }
            
            .progress-fill {
                height: 100%;
                background: #4f8cff;
                border-radius: 4px;
                width: 0%;
                transition: width 0.1s ease;
            }
            
            .time-display {
                font-family: monospace;
                font-size: 14px;
                color: #666;
                min-width: 100px;
                text-align: center;
            }
            
            .volume-control {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            
            .volume-slider {
                width: 80px;
                height: 4px;
                background: #e2e8f0;
                border-radius: 2px;
                outline: none;
                cursor: pointer;
            }
            
            .question-box {
                background: #fff;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                border: 1px solid #e2e8f0;
            }
            
            .matching-pair {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
                padding: 8px;
                background: #f8f9fa;
                border-radius: 6px;
            }
            
            .matching-left {
                flex: 1;
                font-weight: 500;
            }
            
            .matching-right {
                flex: 1;
            }
            
            .completion-line {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 10px;
            }
            
            .completion-text {
                flex: 1;
            }
            
            .completion-input {
                width: 150px;
                padding: 8px 12px;
                border: 1px solid #bfc9d9;
                border-radius: 5px;
                font-size: 14px;
            }
            
            .labeling-question {
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                background: #f8f9fa;
            }
            
            .label-input {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #bfc9d9;
                border-radius: 5px;
                margin-top: 5px;
            }
            
            .section-info {
                background: #e3f2fd;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
                border-left: 4px solid #2196f3;
            }
            
            .section-title {
                font-size: 18px;
                font-weight: 600;
                color: #1976d2;
                margin-bottom: 5px;
            }
            
            .section-description {
                color: #424242;
                font-size: 14px;
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
        %>

        <h2 style="margin: 20px;">🎧 Listening Test: <%= exam.getTitle()%></h2>

        <form action="${pageContext.request.contextPath}/SubmitTestServlet" method="post">
            <input type="hidden" name="examId" value="<%= examId%>" />

            <% for (Passage p : passages) {
                    int sectionNum = p.getSection();
                    List<Question> questions = passageQuestions.get(p.getPassageId());
                    String style = (sectionNum == 1) ? "display:flex;" : "display:none;";
            %>
            <div class="section-content" id="section-<%= sectionNum%>" style="<%= style%>" tabindex="0">
                <div class="left-panel">
                    <div class="section-info">
                        <div class="section-title">Section <%= sectionNum%></div>
                        <div class="section-description"><%= p.getTitle()%></div>
                    </div>
                    
                    <div class="audio-player">
                        <h4>🎵 Audio Player</h4>
                        <div class="audio-controls">
                            <button type="button" class="play-btn" onclick="togglePlay(this, '<%= p.getAudioUrl()%>')">
                                ▶️
                            </button>
                            <div class="progress-bar" onclick="seekAudio(event, this)">
                                <div class="progress-fill"></div>
                            </div>
                            <div class="time-display">
                                <span class="current-time">0:00</span> / <span class="total-time">0:00</span>
                            </div>
                        </div>
                        <div class="volume-control">
                            <span>🔊</span>
                            <input type="range" class="volume-slider" min="0" max="100" value="50" 
                                   onchange="setVolume(this.value)">
                        </div>
                    </div>
                    
                    <% if (p.getContent() != null && !p.getContent().trim().isEmpty()) { %>
                    <div class="section-box">
                        <h4>📝 Additional Information</h4>
                        <div class="passage-text"><%= p.getContent()%></div>
                    </div>
                    <% } %>
                </div>

                <div class="right-panel">
                    <h4>🔍 Questions for Section <%= sectionNum%></h4>
                    <% if (questions != null) {
                            for (Question q : questions) {
                                int qId = q.getQuestionId();
                                String type = q.getQuestionType();
                    %>
                    <div class="question-box">
                        <% if (q.getInstruction() != null && !q.getInstruction().isEmpty()) {%>
                        <p><strong>📋 <%= q.getInstruction()%></strong></p>
                        <% } %>
                        <% if (q.getImageUrl() != null && !q.getImageUrl().isEmpty()) {%>
                        <img src="<%= request.getContextPath() + "/" + q.getImageUrl().trim()%>" 
                             width="400" style="max-width: 100%; border-radius: 8px;" alt="Question image"/><br/>
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
                        <input type="radio" id="<%= inputId%>" name="answer_<%= qId%>"
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
                            case "MATCHING": {
                                List<Answer> matchingAnswers = questionAnswers.get(qId);
                                if (matchingAnswers != null) {
                        %>
                        <p><strong><%= q.getQuestionText() != null ? q.getQuestionText() : "Match the items:"%></strong></p>
                        <div class="matching-pairs">
                            <% for (int i = 0; i < matchingAnswers.size(); i++) {
                                String[] parts = matchingAnswers.get(i).getAnswerText().split(" = ");
                                if (parts.length == 2) {
                            %>
                            <div class="matching-pair">
                                <div class="matching-left"><%= (i + 1)%>. <%= parts[0]%></div>
                                <div class="matching-right">
                                    <select name="answer_<%= qId%>_<%= i%>" style="width: 100%; padding: 8px; border-radius: 5px; border: 1px solid #bfc9d9;">
                                        <option value="">-- Select --</option>
                                        <option value="<%= parts[1]%>"><%= parts[1]%></option>
                                        <% for (int j = 0; j < matchingAnswers.size(); j++) {
                                            String[] otherParts = matchingAnswers.get(j).getAnswerText().split(" = ");
                                            if (otherParts.length == 2 && j != i) {
                                        %>
                                        <option value="<%= otherParts[1]%>"><%= otherParts[1]%></option>
                                        <% } } %>
                                    </select>
                                </div>
                            </div>
                            <% } } %>
                        </div>
                        <% } else { %><p style="color:red;">❗ No matching pairs provided.</p><% }
                                break;
                            }
                            case "SUMMARY_COMPLETION":
                            case "TABLE_COMPLETION":
                            case "FLOWCHART":
                            case "FORM_COMPLETION":
                            case "NOTE_COMPLETION": {
                                List<Answer> completionAnswers = questionAnswers.get(qId);
                                int completionCount = (completionAnswers != null) ? completionAnswers.size() : 1;
                        %>
                        <p><strong><%= q.getQuestionText()%></strong></p>
                        <div class="completion-questions">
                            <% for (int i = 0; i < completionCount; i++) {%>
                            <div class="completion-line">
                                <div class="completion-text">
                                    <span style="color: #666;">(<%= (i + 1)%>)</span>
                                </div>
                                <input type="text" name="answer_<%= qId%>_<%= i%>" 
                                       class="completion-input" placeholder="Your answer">
                            </div>
                            <% } %>
                        </div>
                        <% break;
                            }
                            case "MAP_LABELING":
                            case "PLAN_LABELING":
                            case "DIAGRAM_LABELING": {
                        %>
                        <div class="labeling-question">
                            <p><strong><%= q.getQuestionText()%></strong></p>
                            <input type="text" name="answer_<%= qId%>" 
                                   class="label-input" placeholder="Enter the correct label">
                        </div>
                        <% break;
                            }
                            case "SENTENCE_COMPLETION": {
                        %>
                        <div class="completion-line">
                            <div class="completion-text">
                                <strong><%= q.getQuestionText()%></strong>
                            </div>
                            <input type="text" name="answer_<%= qId%>" 
                                   class="completion-input" placeholder="Your answer">
                        </div>
                        <% break;
                            }
                            default: {
                        %>
                        <p><strong><%= q.getQuestionText()%></strong></p>
                        <input type="text" name="answer_<%= qId%>" 
                               style="width: 100%; padding: 10px; border-radius: 5px; border: 1px solid #bfc9d9;" 
                               placeholder="Your answer">
                        <% } %>
                        <% } %>
                    </div>
                    <% } %>
                    <% } %>
                </div>
            </div>
            <% } %>

            <div class="section-nav">
                <% for (Passage pa : passages) {%>
                <button type="button" class="section-btn" data-index="<%= p.getSection()%>">Section <%= p.getSection()%></button>
                <% }%>
            </div>

            <div style="text-align:center; margin-top: 20px;">
                <input type="submit" value="Submit Listening Test" class="btn-submit" />
            </div>
        </form>

        <script>
            let currentAudio = null;
            let currentAudioElement = null;
            let currentProgressBar = null;
            let currentTimeDisplay = null;
            let currentTotalTime = null;

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
                        
                        // Stop current audio when switching sections
                        if (currentAudioElement) {
                            currentAudioElement.pause();
                            currentAudioElement = null;
                        }
                    });
                });

                if (buttons.length > 0)
                    buttons[0].classList.add("active");
            });

            function togglePlay(button, audioUrl) {
                const section = button.closest('.section-content');
                const progressBar = section.querySelector('.progress-fill');
                const timeDisplay = section.querySelector('.current-time');
                const totalTimeDisplay = section.querySelector('.total-time');
                
                if (currentAudioElement && currentAudioElement.src.includes(audioUrl)) {
                    // Same audio - toggle play/pause
                    if (currentAudioElement.paused) {
                        currentAudioElement.play();
                        button.innerHTML = "⏸️";
                        button.classList.add("playing");
                    } else {
                        currentAudioElement.pause();
                        button.innerHTML = "▶️";
                        button.classList.remove("playing");
                    }
                } else {
                    // New audio - stop current and start new
                    if (currentAudioElement) {
                        currentAudioElement.pause();
                        document.querySelectorAll('.play-btn').forEach(btn => {
                            btn.innerHTML = "▶️";
                            btn.classList.remove("playing");
                        });
                    }
                    
                    currentAudioElement = new Audio(audioUrl);
                    currentProgressBar = progressBar;
                    currentTimeDisplay = timeDisplay;
                    currentTotalTime = totalTimeDisplay;
                    
                    currentAudioElement.addEventListener('loadedmetadata', function() {
                        const minutes = Math.floor(currentAudioElement.duration / 60);
                        const seconds = Math.floor(currentAudioElement.duration % 60);
                        currentTotalTime.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;
                    });
                    
                    currentAudioElement.addEventListener('timeupdate', function() {
                        const progress = (currentAudioElement.currentTime / currentAudioElement.duration) * 100;
                        currentProgressBar.style.width = progress + '%';
                        
                        const minutes = Math.floor(currentAudioElement.currentTime / 60);
                        const seconds = Math.floor(currentAudioElement.currentTime % 60);
                        currentTimeDisplay.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;
                    });
                    
                    currentAudioElement.addEventListener('ended', function() {
                        button.innerHTML = "▶️";
                        button.classList.remove("playing");
                        currentProgressBar.style.width = '0%';
                        currentTimeDisplay.textContent = '0:00';
                    });
                    
                    currentAudioElement.play();
                    button.innerHTML = "⏸️";
                    button.classList.add("playing");
                }
            }

            function seekAudio(event, progressBar) {
                if (currentAudioElement) {
                    const rect = progressBar.getBoundingClientRect();
                    const clickX = event.clientX - rect.left;
                    const width = rect.width;
                    const seekTime = (clickX / width) * currentAudioElement.duration;
                    currentAudioElement.currentTime = seekTime;
                }
            }

            function setVolume(value) {
                if (currentAudioElement) {
                    currentAudioElement.volume = value / 100;
                }
            }
        </script>

    </body>
</html> 