<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add IELTS Listening Test</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AddTest.css">
    <script src="https://cdn.ckeditor.com/4.22.1/standard/ckeditor.js"></script>
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
<form action="${pageContext.request.contextPath}/AddExamServlet" method="post" enctype="multipart/form-data">
    <div class="container mt-3">
        <label for="examTitle">📝 Exam Title:</label>
        <input type="text" name="examTitle" id="examTitle" class="form-control mb-3" required>

        <label for="examType">🗂️ Test Type:</label>
        <select name="category" id="examType" class="form-select mb-3" required>
            <option value="">-- Select Test Type --</option>
            <option value="LISTENING_FULL">Listening Full</option>
            <option value="LISTENING_SINGLE">Listening Single</option>
        </select>

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
            <h4>🎧 Section Info</h4>
            <label>Section Title:</label>
            <input type="text" name="sectionTitle" id="sectionTitle" class="form-control" required>

            <label class="mt-2">Section Audio:</label>
            <input type="file" name="sectionAudio" id="sectionAudio" class="form-control" accept="audio/*">

            <label class="mt-2">Script (optional):</label>
            <textarea name="sectionScript" id="sectionScript" rows="8" class="form-control"></textarea>
        </div>

        <div class="right-panel w-50">
            <h4>🧠 Question Groups</h4>
            <div id="questionGroupContainer"></div>
            <button type="button" class="btn btn-primary mt-3" onclick="addQuestionGroup()">➕ Add Question Group</button>
        </div>
    </div>

    <div class="text-center mt-4">
        <button type="submit" class="btn btn-success btn-lg">✅ Submit</button>
    </div>
</form>

<script>
    CKEDITOR.replace('sectionScript');

    const sections = {
        1: { title: '', script: '', questions: '', audio: null },
        2: { title: '', script: '', questions: '', audio: null },
        3: { title: '', script: '', questions: '', audio: null },
        4: { title: '', script: '', questions: '', audio: null }
    };
    let currentSection = 1;

    document.getElementById("examType").addEventListener("change", function () {
        const show = this.value === "LISTENING_FULL";
        document.getElementById("sectionSelector").style.display = show ? "block" : "none";
    });

    function switchSection(num) {
        // Lưu lại dữ liệu section hiện tại
        sections[currentSection].title = document.getElementById("sectionTitle").value;
        sections[currentSection].script = CKEDITOR.instances["sectionScript"].getData();
        sections[currentSection].questions = document.getElementById("questionGroupContainer").innerHTML;
        // Không lưu audio ở đây vì file input không thể set lại value qua JS

        currentSection = num;
        document.getElementById("sectionHidden").value = num;
        document.getElementById("sectionTitle").value = sections[num].title || "";
        CKEDITOR.instances["sectionScript"].setData(sections[num].script || "");
        document.getElementById("questionGroupContainer").innerHTML = sections[num].questions || "";

        document.querySelectorAll(".section-btns button").forEach(btn => btn.classList.remove("active"));
        document.querySelector(`.section-btns button:nth-child(${num + 1})`).classList.add("active");
    }
</script>
<script src="${pageContext.request.contextPath}/js/form-listening.js"></script>
</body>
</html>