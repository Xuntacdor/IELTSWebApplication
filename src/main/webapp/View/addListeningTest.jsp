<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Add IELTS Listening Test</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AddTest.css">
        <style>
            .section-btns button {
                margin-right: 10px;
                min-width: 100px;
            }
            .section-btns .active {
                background-color: #198754;
                color: white;
            }
            .question-group {
                border: 2px solid #e9ecef;
                border-radius: 8px;
                margin-bottom: 20px;
                padding: 15px;
            }
            .question-block {
                background-color: #f8f9fa;
                border-radius: 6px;
                padding: 10px;
                margin: 10px 0;
            }
            .option-row {
                background-color: white;
                border-radius: 4px;
                padding: 8px;
                margin: 5px 0;
            }
            .matching-pair {
                background-color: #e3f2fd;
                border-radius: 4px;
                padding: 8px;
                margin: 5px 0;
            }
            .completion-line {
                background-color: #fff3e0;
                border-radius: 4px;
                padding: 8px;
                margin: 5px 0;
            }
        </style>
    </head>
    <body>
        <form action="${pageContext.request.contextPath}/AddListeningTestController" method="post" enctype="multipart/form-data" accept-charset="UTF-8">
            <div class="container mt-3">
                <h2 class="text-center mb-4">🎧 Add IELTS Listening Test</h2>

                <div class="row">
                    <div class="col-md-6">
                        <label for="examTitle">📝 Exam Title:</label>
                        <input type="text" name="examTitle" id="examTitle" class="form-control mb-3" required>

                        <label for="examType">🗂️ Test Type:</label>
                        <select name="category" id="examType" class="form-select mb-3" required>
                            <option value="">-- Select Test Type --</option>
                            <option value="LISTENING_FULL">Listening Full Test (4 Sections)</option>
                            <option value="LISTENING_SINGLE">Listening Single Section</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label>🎧 Audio File:</label>
                        <select name="examAudioPath" id="examAudioPath" class="form-select mb-3" required>
                            <option value="">-- Select Audio --</option>
                            <%
                                String audioDir = application.getRealPath("/Audio");
                                java.io.File dir = new java.io.File(audioDir);
                                String[] audioFiles = dir.list(( d,   name) -> name.toLowerCase().endsWith(".mp3")
                                        || name.toLowerCase().endsWith(".wav")
                                        || name.toLowerCase().endsWith(".ogg")
                                        || name.toLowerCase().endsWith(".webm")
                                        || name.toLowerCase().endsWith(".m4a"));
                                if (audioFiles != null) {
                                    for (String f : audioFiles) {
                            %>
                            <option value="Audio/<%=f%>"><%=f%></option>
                            <%
                                    }
                                }
                            %>
                        </select>

                        <!-- Section selector for LISTENING_FULL -->
                        <div id="sectionSelector" class="section-btns mb-3" style="display: none;">
                            <label class="mb-2">📂 Select Section:</label><br/>
                            <input type="hidden" name="section" id="sectionHidden" value="1" />
                            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(1)">Section 1</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(2)">Section 2</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(3)">Section 3</button>
                            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(4)">Section 4</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-12">
                        <!-- Single section container -->
                        <div id="singleAudioContainer" style="display: none">
                            <div class="card">
                                <div class="card-header">
                                    <h4>🎵 Single Section Info</h4>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <label>Section Number:</label>
                                            <select name="section" id="section" class="form-select mb-2" required>
                                                <option value="1">Section 1</option>
                                                <option value="2">Section 2</option>
                                                <option value="3">Section 3</option>
                                                <option value="4">Section 4</option>
                                            </select>
                                        </div>
                                        <div class="col-md-8">
                                            <label>Section Title:</label>
                                            <input type="text" name="sectionTitle" id="sectionTitle" class="form-control mb-2" required>
                                        </div>
                                    </div>

                                    <!-- Question groups for single section -->
                                    <div id="singleGroupContainer" class="mt-3">
                                        <h5>📝 Question Groups</h5>
                                        <div id="singleGroups"></div>
                                        <button type="button" class="btn btn-sm btn-outline-primary mt-2" onclick="addSingleGroup()">
                                            ➕ Add Question Group
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Sections container for LISTENING_FULL -->
                        <div id="sections-container"></div>
                        <button type="button" class="btn btn-primary mt-2" id="addSectionBtn" onclick="addListeningSection()" style="display: none">
                            ➕ Add Section
                        </button>
                    </div>
                </div>
            </div>

            <div class="text-center mt-4 mb-4">
                <button type="submit" class="btn btn-success btn-lg">✅ Submit Listening Test</button>
            </div>
        </form>

        <!-- Script to handle exam type changes -->
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const examType = document.getElementById("examType");
                const sectionSelector = document.getElementById("sectionSelector");
                const addSectionBtn = document.getElementById("addSectionBtn");
                const singleAudio = document.getElementById("singleAudioContainer");

                function toggleSectionMode() {
                    const type = examType.value;
                    if (type === "LISTENING_FULL") {
                        sectionSelector.style.display = "block";
                        addSectionBtn.style.display = "inline-block";
                        singleAudio.style.display = "none";
                    } else if (type === "LISTENING_SINGLE") {
                        sectionSelector.style.display = "none";
                        addSectionBtn.style.display = "none";
                        singleAudio.style.display = "block";
                    } else {
                        sectionSelector.style.display = "none";
                        addSectionBtn.style.display = "none";
                        singleAudio.style.display = "none";
                    }
                }

                examType.addEventListener("change", toggleSectionMode);
                toggleSectionMode(); // Call immediately if there's already a selection
            });
        </script>

        <!-- JavaScript files for dynamic form handling -->
        <script src="${pageContext.request.contextPath}/js/form-listening.js"></script>
        <script src="${pageContext.request.contextPath}/js/switch-section.js"></script>
    </body>
</html>
