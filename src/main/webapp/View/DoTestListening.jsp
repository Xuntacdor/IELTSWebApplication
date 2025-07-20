<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="model.*" %>
<html>
    <head>
        <title>🎧 Listening Test</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dotestListening.css" />

    </head>
    <body>

        <%
            int examId = Integer.parseInt(request.getParameter("examId"));
            Exam exam = (Exam) request.getAttribute("exam");
            List<Passage> passages = (List<Passage>) request.getAttribute("passages");
            Map<Integer, List<Question>> passageQuestions = (Map<Integer, List<Question>>) request.getAttribute("passageQuestions");
            Map<Integer, List<Answer>> questionAnswers = (Map<Integer, List<Answer>>) request.getAttribute("questionAnswers");
        %>


        <form action="${pageContext.request.contextPath}/SubmitTestServlet" method="post">
            <input type="hidden" name="examId" value="${param.examId}" />
            <div class="section-content" style="gap: 40px;">

                <div class="right-panel">
                    <div class="section-info" style="display:block;">
                        <div class="section-title">Section 1</div>
                        <div class="section-description">${passages[0].title}</div>
                    </div>
                    <h4>🔍 Questions for Section 1</h4>
                    <c:set var="questions" value="${passageQuestions[passages[0].passageId]}" />
                    <c:if test="${not empty questions}">
                        <c:forEach var="q" items="${questions}" varStatus="status">
                            <c:set var="qId" value="${q.questionId}" />
                            <div class="question-box">
                                <p><strong>${q.questionText}</strong></p>
                                <input type="text" name="answer_${qId}" class="completion-input" placeholder="Your answer">
                            </div>
                        </c:forEach>
                    </c:if>
                    <div class="audio-player">
                        <div class="audio-controls">
                            <button type="button" class="play-btn" onclick="togglePlay(this, '${passages[0].audioUrl}')">▶️</button>
                            <div class="progress-bar" onclick="seekAudio(event, this)">
                                <div class="progress-fill"></div>
                            </div>
                            <div class="time-display">
                                <span class="current-time">0:00</span> / <span class="total-time">0:00</span>
                            </div>
                        </div>
                        <div class="volume-control">
                            <span>🔊</span>
                            <input type="range" class="volume-slider" min="0" max="100" value="50" onchange="setVolume(this.value)">
                        </div>
                        <div class="speed-control" style="margin-top: 10px;">
                            <label for="audioSpeed">Speed:</label>
                            <select id="audioSpeed" onchange="setAudioSpeed(this.value)">
                                <option value="0.75">0.75x</option>
                                <option value="1" selected>1x</option>
                                <option value="1.25">1.25x</option>
                                <option value="1.5">1.5x</option>
                                <option value="2.0">2.0x</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div style="text-align:center; margin-top: 20px;">
                <input type="submit" value="Submit Listening Test" class="btn-submit" />
            </div>
        </form>


        <script>
            let currentAudioElement = null;
            let currentProgressBar = null;
            let currentTimeDisplay = null;
            let currentTotalTime = null;
            let currentSpeed = 1;
            function togglePlay(button, audioUrl) {
                if (currentAudioElement && currentAudioElement.src.includes(audioUrl)) {
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
                    if (currentAudioElement) {
                        currentAudioElement.pause();
                        document.querySelectorAll('.play-btn').forEach(btn => {
                            btn.innerHTML = "▶️";
                            btn.classList.remove("playing");
                        });
                    }
                    currentAudioElement = new Audio(audioUrl);
                    currentAudioElement.playbackRate = currentSpeed;
                    currentProgressBar = document.querySelector('.progress-fill');
                    currentTimeDisplay = document.querySelector('.current-time');
                    currentTotalTime = document.querySelector('.total-time');
                    currentAudioElement.addEventListener('loadedmetadata', function () {
                        const minutes = Math.floor(currentAudioElement.duration / 60);
                        const seconds = Math.floor(currentAudioElement.duration % 60);
                        currentTotalTime.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;
                                    });
                                    currentAudioElement.addEventListener('timeupdate', function () {
                                        const progress = (currentAudioElement.currentTime / currentAudioElement.duration) * 100;
                                        currentProgressBar.style.width = progress + '%';
                                        const minutes = Math.floor(currentAudioElement.currentTime / 60);
                                        const seconds = Math.floor(currentAudioElement.currentTime % 60);
                                        currentTimeDisplay.textContent = `${minutes}:${seconds.toString().padStart(2, '0')}`;
                                                    });
                                                    currentAudioElement.addEventListener('ended', function () {
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
                                            function setAudioSpeed(value) {
                                                currentSpeed = parseFloat(value);
                                                if (currentAudioElement) {
                                                    currentAudioElement.playbackRate = currentSpeed;
                                                }
                                            }
        </script>

    </body>
</html> 