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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    </head>
    <body>
        <!-- Header với các chức năng -->
        <header class="test-header">
            <div class="header-left">
                <button class="exit-btn" onclick="exitTest()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="header-center">
                <div class="timer-container">
                    <span id="timer" class="tool-btn">⏱ 00:00</span>
                </div>
            </div>
            
            <div class="header-right">
                <div class="settings-dropdown">
                    <button class="settings-btn" onclick="toggleSettings()">
                        <i class="fas fa-cog"></i>
                    </button>
                    <div class="settings-menu" id="settingsMenu">
                        <div class="settings-section">
                            <h4><i class="fas fa-eye"></i> Eye Protection</h4>
                            <label class="toggle-switch">
                                <input type="checkbox" id="eyeProtection" onchange="toggleEyeProtection()">
                                <span class="slider"></span>
                            </label>
                        </div>
                        <div class="settings-section">
                            <h4><i class="fas fa-text-height"></i> Font Size</h4>
                            <div class="font-size-buttons">
                                <button class="font-btn" data-size="small" onclick="changeFontSize('small', event)">S</button>

                                <button class="font-btn" data-size="medium" onclick="changeFontSize('medium', event)">M</button>
<button class="font-btn" data-size="large" onclick="changeFontSize('large', event)">L</button>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <%
            int examId = Integer.parseInt(request.getParameter("examId"));
            Exam exam = (Exam) request.getAttribute("exam");
            List<Passage> passages = (List<Passage>) request.getAttribute("passages");
            Map<Integer, List<Question>> passageQuestions = (Map<Integer, List<Question>>) request.getAttribute("passageQuestions");
            Map<Integer, List<Answer>> questionAnswers = (Map<Integer, List<Answer>>) request.getAttribute("questionAnswers");
        %>

        <form action="<%= request.getContextPath() %>/SubmitTestServlet" method="post">
            <input type="hidden" name="examId" value="<%= request.getParameter("examId") %>" />
            <% if (passages != null && !passages.isEmpty()) { %>
                <div class="section-content" style="gap: 40px;">
                    <div class="right-panel">
                        <div class="section-info" style="display:block;">
                            <div class="section-title">Section 1</div>
                            <div class="section-description"><%= passages.get(0).getTitle() %></div>
                        </div>
                        <h4>🔍 Questions for Section 1</h4>
                        <% List<Question> questions = passageQuestions.get(passages.get(0).getPassageId()); %>
                        <% if (questions != null && !questions.isEmpty()) { %>
                            <% for (Question q : questions) { %>
                                <div class="question-box">
                                    <p><strong><%= q.getQuestionText() %></strong></p>
                                    <input type="text" name="answer_<%= q.getQuestionId() %>" class="completion-input" placeholder="Your answer">
                                </div>
                            <% } %>
                        <% } %>
                        <div class="audio-player">
                            <div class="audio-controls">
                                <button type="button" class="play-btn" onclick="togglePlay(this, '<%= passages.get(0).getAudioUrl() %>')">▶️</button>
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
            <% } else { %>
                <div style="color: red; text-align: center; margin: 40px 0; font-size: 20px;">
                    Không có dữ liệu đề thi hoặc dữ liệu bị lỗi.<br/>
                    Vui lòng quay lại và chọn đề thi hợp lệ.
                </div>
            <% } %>
            <div style="text-align:center; margin-top: 20px;">
                <input type="submit" value="Submit Listening Test" class="btn-submit" />
            </div>
        </form>

        <script>
            // Timer logic giống doTestReading.js
            document.addEventListener("DOMContentLoaded", function () {
                let elapsedTime = 0;
                const timerElement = document.getElementById("timer");
                function updateTimer() {
                    const minutes = Math.floor(elapsedTime / 60);
                    const seconds = elapsedTime % 60;
                    timerElement.textContent = '⏱ ' + String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
                    elapsedTime++;
                }
                setInterval(updateTimer, 1000);
            });
            
            // Settings functionality
            function toggleSettings() {
                const menu = document.getElementById('settingsMenu');
                menu.classList.toggle('show');
            }
            
            function toggleEyeProtection() {
                const isEnabled = document.getElementById('eyeProtection').checked;
                if (isEnabled) {
                    document.body.classList.add('eye-protection');
                } else {
                    document.body.classList.remove('eye-protection');
                }
            }
            
            function changeFontSize(size, event) {

                // Remove active class from all buttons
                document.querySelectorAll('.font-btn').forEach(btn => btn.classList.remove('active'));
                // Add active class to clicked button
                event.target.classList.add('active');
                
                // Remove existing font size classes
                document.body.classList.remove('font-small', 'font-medium', 'font-large');
                // Add new font size class
                document.body.classList.add(`font-${size}`);
            }
            
            function exitTest() {
                if (confirm('Are you sure you want to exit the test? Your progress will be lost.')) {
                    window.location.href = '${pageContext.request.contextPath}/HomeController';
                }
            }
            
            // Close settings menu when clicking outside
            document.addEventListener('click', function(event) {
                const settingsDropdown = document.querySelector('.settings-dropdown');
                const settingsBtn = document.querySelector('.settings-btn');
                
                if (!settingsDropdown.contains(event.target)) {
                    document.getElementById('settingsMenu').classList.remove('show');
                }
            });
            
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