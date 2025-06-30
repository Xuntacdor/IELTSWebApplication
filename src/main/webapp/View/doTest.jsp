<%@ page import="java.util.*, model.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>📝 Do My Test</title>
        <link rel="stylesheet" href="css/dotest.css" />
        <script src="js/dotest.js"></script>
        <style>
            .section-nav {
                text-align: center;
                margin: 30px 0 10px;
            }
            .section-nav button {
                background-color: #3498db;
                color: white;
                border: none;
                margin: 0 5px;
                padding: 10px 18px;
                border-radius: 6px;
                cursor: pointer;
            }
            .section-nav button:hover {
                background-color: #2980b9;
            }
            .section-content {
                display: flex;
                gap: 20px;
                padding: 20px;
            }
            .only-right {
                justify-content: center;
            }
            .left-panel {
                flex: 1;
            }
            .right-panel {
                flex: 2;
            }
            .section-content.only-right {
                justify-content: center;
            }
            .only-right .right-panel {
                flex: 0 0 700px;
            }
            .vbee-player {
                background: #fef2e6;
                border-radius: 10px;
                padding: 10px;
                width: 820px;
                max-width: 100%;
                margin: 20px auto;
            }

            .vbee-player .controls {
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 10px;
                font-family: sans-serif;
            }
            .vbee-player .controls button {
                background: #ff6f3c;
                color: white;
                border: none;
                border-radius: 50%;
                padding: 10px;
                cursor: pointer;
                font-size: 16px;
                min-width: 40px;
            }
            .vbee-player .controls button#speedBtn {
                border-radius: 20px;
                background: white;
                color: #333;
                border: 1px solid #ddd;
                padding: 5px 10px;
            }
            .vbee-player .controls input[type="range"] {
                width: 100px;
            }
            .vbee-player .progress-bar {
                width: 100%;
                height: 5px;
                background: #ddd;
                position: relative;
                margin-bottom: 10px;
                border-radius: 3px;
                overflow: hidden;
            }
            .vbee-player .progress-bar .progress {
                position: absolute;
                top: 0;
                left: 0;
                height: 100%;
                width: 0%;
                background: #ff6f3c;
            }
        </style>
        
       <script>
    function showSection(index) {
        const sections = document.querySelectorAll('.section-content');
        sections.forEach(div => div.style.display = 'none');
        document.getElementById('section-' + index).style.display = 'flex';
    }

    document.addEventListener("DOMContentLoaded", function () {
        const audio = document.getElementById("audioReal");
        if (!audio) return;

        const playPauseBtn = document.getElementById("playPauseBtn");
        const volumeSlider = document.getElementById("volumeSlider");
        const rewindBtn = document.getElementById("rewindBtn");
        const forwardBtn = document.getElementById("forwardBtn");
        const speedBtn = document.getElementById("speedBtn");
        const muteBtn = document.getElementById("muteBtn");
        const progressBar = document.querySelector(".progress-bar .progress");
        const trackTimeEl = document.getElementById("trackTime");

        let speeds = [1, 1.25, 1.5, 0.75];
        let speedIndex = 0;

        function formatTime(time) {
            if (!isFinite(time) || isNaN(time)) return "00:00";
            const m = Math.floor(time / 60).toString().padStart(2, "0");
            const s = Math.floor(time % 60).toString().padStart(2, "0");
            return `${m}:${s}`;
        }

        function updateTrackTime() {
            if (!trackTimeEl || !audio) {
                return;
            }
            const current = formatTime(audio.currentTime);
            const duration = isFinite(audio.duration) ? formatTime(audio.duration) : "00:00";
            trackTimeEl.textContent = `${current} / ${duration}`;
        }

        // Cập nhật khi metadata đã load
        audio.addEventListener("loadedmetadata", updateTrackTime);

        // Cập nhật khi thời gian thay đổi
        audio.addEventListener("timeupdate", () => {
            if (isFinite(audio.duration)) {
                const percent = (audio.currentTime / audio.duration) * 100;
                progressBar.style.width = percent + "%";
            }
            updateTrackTime();
        });

        playPauseBtn.onclick = () => {
            if (audio.paused) {
                audio.play();
                playPauseBtn.textContent = "⏸️";
            } else {
                audio.pause();
                playPauseBtn.textContent = "▶️";
            }
        };

        volumeSlider.oninput = () => audio.volume = volumeSlider.value;
        rewindBtn.onclick = () => audio.currentTime = Math.max(0, audio.currentTime - 5);
        forwardBtn.onclick = () => audio.currentTime = Math.min(audio.duration, audio.currentTime + 5);

        speedBtn.onclick = () => {
            speedIndex = (speedIndex + 1) % speeds.length;
            audio.playbackRate = speeds[speedIndex];
            speedBtn.textContent = `⏱ Tốc độ: ${speeds[speedIndex]}x`;
        };

        muteBtn.onclick = () => {
            audio.muted = !audio.muted;
            muteBtn.textContent = audio.muted ? "🔇" : "🔊";
        };

        // Nếu audio đã load sẵn trước đó
        updateTrackTime();
    });
</script>

    </head>
    <body>
        <%
            int examId = Integer.parseInt(request.getParameter("examId"));
            Exam exam = (Exam) request.getAttribute("exam");
            String examType = exam.getType();
            String examCategory = exam.getExamCategory();
            int totalSeconds = "LISTENING".equals(examType) ? 40 * 60 : 60 * 60;
            List<Passage> passages = (List<Passage>) request.getAttribute("passages");
            Map<Integer, List<Question>> passageQuestions = (Map<Integer, List<Question>>) request.getAttribute("passageQuestions");
            Map<Integer, List<Answer>> questionAnswers = (Map<Integer, List<Answer>>) request.getAttribute("questionAnswers");
            Map<Integer, List<Option>> questionOptions = (Map<Integer, List<Option>>) request.getAttribute("questionOptions");
        %>

        <div class="header-bar">
            <button type="button" class="exit-btn" onclick="confirmExit()">✖</button>
            <div class="timer" id="timer">
                ⏱ <span id="countdown">00:30:00</span>
            </div>
        </div>

        <h2 style="margin: 20px;">📝 Do Test: <%= exam.getTitle()%></h2>

        <% if ("LISTENING".equals(examType)) {
                Passage first = (passages != null && passages.size() > 0) ? passages.get(0) : null;
                if (first != null && first.getAudioUrl() != null && !first.getAudioUrl().isEmpty()) {
        %>
        <div id="customAudioPlayer" class="vbee-player">
            <div class="progress-bar"><span class="progress"></span></div>
            <div class="controls">
                <span id="trackTime">00:00 / 00:00</span>
                <button id="muteBtn">🔊</button>
                <input type="range" id="volumeSlider" min="0" max="1" step="0.01" value="1"/>
                <button id="rewindBtn">↺</button>
                <button id="playPauseBtn">⏸️</button>
                <button id="forwardBtn">↻</button>
                <button id="speedBtn">⏱ Tốc độ: 1x</button>
            </div>
            <audio id="audioReal" src="<%= first.getAudioUrl()%>"></audio>
        </div>

        <% }
            }%>

        <form action="SubmitTestServlet" method="post">
            <input type="hidden" id="timeLimit" value="<%= totalSeconds%>"/>
            <input type="hidden" name="examId" value="<%= examId%>"/>

            <%
                int passageNumber = 1;
                for (Passage p : passages) {
            %>
            <div class="section-content <%= "LISTENING".equals(examType) ? "only-right" : ""%>" id="section-<%= passageNumber%>" style="<%= passageNumber == 1 ? "display:flex;" : "display:none;"%>">

                <% if (!"LISTENING".equals(examType)) {%>
                <div class="left-panel">
                    <div class="section-box">
                        <h3>📄 Passage <%= passageNumber%>: <%= p.getTitle()%></h3>
                        <% if (p.getAudioUrl() != null && !p.getAudioUrl().isEmpty()) {%>
                        <audio controls style="margin:10px 0;">
                            <source src="<%= p.getAudioUrl()%>" type="audio/mpeg">
                        </audio><br/>
                        <% }%>
                        <p><%= p.getContent().replaceAll("\n", "<br/>")%></p>
                    </div>
                </div>
                <% } %>

                <div class="right-panel">
                    <%
                        List<Question> questions = passageQuestions.get(p.getPassageId());
                        if (questions != null) {
                    %>
                    <h3>📌 Questions for: <%= p.getTitle()%></h3>
                    <% for (Question q : questions) {
                            String type = q.getQuestionType();
                            int qId = q.getQuestionId();
                    %>
                    <div class="question-box">
                        <% if (q.getInstruction() != null && !q.getInstruction().isEmpty()) {%>
                        <p><strong><%= q.getInstruction()%></strong></p>
                        <% } %>

                        <% if (q.getImageUrl() != null && !q.getImageUrl().isEmpty()) {%>
                        <img src="<%= q.getImageUrl()%>" width="400px"/><br/>
                        <% } %>

                        <% if (q.getQuestionText() != null && !q.getQuestionText().isEmpty()) {%>
                        <p><%= q.getQuestionText()%></p>
                        <% } %>

                        <% if ("MULTIPLE_CHOICE".equals(type)) {
                                List<Option> options = questionOptions.get(qId);
                                if (options != null) {
                                    for (Option o : options) {
                        %>
                        <label>
                            <input type="checkbox" name="answer_<%= qId%>" value="<%= o.getOptionText()%>"/>
                            <%= o.getOptionLabel()%>. <%= o.getOptionText()%>
                        </label><br/>
                        <% }
                        } else {%>
                        <p style="color:red">❗ No options found for question ID <%= qId%></p>
                        <% }
                        } else if ("TRUE_FALSE_NOT_GIVEN".equals(type)) {%>
                        <label><input type="radio" name="answer_<%= qId%>" value="TRUE"/> TRUE</label><br/>
                        <label><input type="radio" name="answer_<%= qId%>" value="FALSE"/> FALSE</label><br/>
                        <label><input type="radio" name="answer_<%= qId%>" value="NOT GIVEN"/> NOT GIVEN</label><br/>
                            <% } else if ("SUMMARY_COMPLETION".equals(type) || "MATCHING".equals(type)
                                    || "FLOWCHART".equals(type) || "TABLE_COMPLETION".equals(type)) {
                                List<Answer> answerList = questionAnswers.get(qId);
                                if (answerList != null) {
                                    for (int i = 0; i < answerList.size(); i++) {
                            %>
                        <input type="text" name="answer_<%= qId%>_<%= i%>" title="Your answer" /><br/>
                        <% }
                        } else {%>
                        <p style="color:red;">❗ No answers found for question ID <%= qId%></p>
                        <% }
                        } else {%>
                        <input type="text" name="answer_<%= qId%>" placeholder="Your answer"/><br/>
                        <% } %>
                    </div>
                    <% }
                        } %>
                </div>
            </div>
            <% passageNumber++;
                } %>

            <div class="section-nav">
                <% for (int i = 1; i <= passages.size(); i++) {%>
                <button type="button" onclick="showSection(<%= i%>)">Section <%= i%></button>
                <% }%>
            </div>

            <div style="text-align:center;
                 margin-top: 20px;">
                <input type="submit" value="✅ Hoàn thành bài làm" class="btn-submit"/>
            </div>
        </form>
    </body>
</html>
