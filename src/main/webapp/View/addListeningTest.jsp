<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    </style>
</head>
<body>
<form action="${pageContext.request.contextPath}/AddListeningTestController" method="post" enctype="multipart/form-data">
    <div class="container mt-3">
        <label for="examTitle">📝 Exam Title:</label>
        <input type="text" name="examTitle" id="examTitle" class="form-control mb-3" required>

        <label for="examType">🗂️ Test Type:</label>
        <select name="category" id="examType" class="form-select mb-3" required>
            <option value="">-- Select Test Type --</option>
            <option value="LISTENING_FULL">Listening Full</option>
            <option value="LISTENING_SINGLE">Listening Single</option>
        </select>

        <label>🎧 Audio File:</label>
        <select name="examAudioPath" id="examAudioPath" class="form-select mb-3" required>
            <option value="">-- Select Audio --</option>
            <%
                String audioDir = application.getRealPath("/Audio");
                java.io.File dir = new java.io.File(audioDir);
                String[] audioFiles = dir.list((d, name) -> name.toLowerCase().endsWith(".mp3") || name.toLowerCase().endsWith(".wav") || name.toLowerCase().endsWith(".ogg") || name.toLowerCase().endsWith(".webm"));
                if (audioFiles != null) {
                    for (String f : audioFiles) {
            %>
                <option value="Audio/<%=f%>"><%=f%></option>
            <%
                    }
                }
            %>
        </select>

        <!-- Section selector chỉ hiện khi LISTENING_FULL -->
        <div id="sectionSelector" class="section-btns mb-3" style="display: none;">
            <label class="mb-2">📂 Select Section:</label><br/>
            <input type="hidden" name="section" id="sectionHidden" value="1" />
            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(1)">Section 1</button>
            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(2)">Section 2</button>
            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(3)">Section 3</button>
            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(4)">Section 4</button>
        </div>
    </div>

    <div class="container-flex d-flex gap-3 px-3">
        <div class="left-panel w-50">
            <h4>🎵 Section Info</h4>

            <!-- Phần nhập cho SINGLE -->
            <div id="singleAudioContainer" style="display: none">
                <label>Section Title:</label>
                <input type="text" name="sectionTitle" id="sectionTitle" class="form-control mb-2" required>
            </div>

            <!-- Group cho Listening Full -->
            <div id="sections-container"></div>
            <button type="button" class="btn btn-primary mt-2" id="addSectionBtn" onclick="addListeningSection()" style="display: none">➕ Add Section</button>
        </div>
    </div>

    <div class="text-center mt-4">
        <button type="submit" class="btn btn-success btn-lg">✅ Submit</button>
    </div>
</form>

<!-- Script điều chỉnh hiển thị tùy theo loại bài test -->
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
            } else {
                sectionSelector.style.display = "none";
                addSectionBtn.style.display = "none";
                singleAudio.style.display = "block";
            }
        }

        examType.addEventListener("change", toggleSectionMode);
        toggleSectionMode(); // gọi ngay nếu có sẵn chọn
    });
</script>

<!-- Các JS xử lý input động -->
<script src="${pageContext.request.contextPath}/js/form-listening.js"></script>
<script src="${pageContext.request.contextPath}/js/switch-section.js"></script>
</body>
</html>
