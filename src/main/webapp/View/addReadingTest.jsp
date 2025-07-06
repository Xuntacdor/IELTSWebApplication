<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add IELTS Reading Test</title>
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

        <label for="examType">🗂️ Exam Type:</label>
        <select name="category" id="examType" class="form-select mb-3" required>
            <option value="">-- Select Exam Type --</option>
            <option value="READING_FULL">Reading Full</option>
            <option value="READING_SINGLE">Reading Single</option>
        </select>

        <div id="sectionSelector" class="section-btns mb-3" style="display: none;">
            <label class="mb-2">📂 Select Section:</label><br/>
            <input type="hidden" name="section" id="sectionHidden" value="1" />
            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(1)">Section 1</button>
            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(2)">Section 2</button>
            <button type="button" class="btn btn-outline-secondary" onclick="switchSection(3)">Section 3</button>
        </div>
    </div>

    <div class="container-flex d-flex gap-3 px-3">
        <div class="left-panel w-50">
            <h4>📘 Passage Editor</h4>
            <label>Title:</label>
            <input type="text" name="passageTitle" id="passageTitle" class="form-control" required>

            <label class="mt-2">Content:</label>
            <textarea name="passageContent" id="passageContent" rows="15" class="form-control" required></textarea>
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

<!-- JavaScript -->
<script>
    CKEDITOR.replace('passageContent');

    const sections = {
        1: { title: '', content: '', questions: '' },
        2: { title: '', content: '', questions: '' },
        3: { title: '', content: '', questions: '' }
    };
    let currentSection = 1;

    document.getElementById("examType").addEventListener("change", function () {
        const show = this.value === "READING_FULL";
        document.getElementById("sectionSelector").style.display = show ? "block" : "none";
    });

    function switchSection(num) {
        sections[currentSection].title = document.getElementById("passageTitle").value;
        sections[currentSection].content = CKEDITOR.instances["passageContent"].getData();
        sections[currentSection].questions = document.getElementById("questionGroupContainer").innerHTML;

        currentSection = num;
        document.getElementById("sectionHidden").value = num;
        document.getElementById("passageTitle").value = sections[num].title || "";
        CKEDITOR.instances["passageContent"].setData(sections[num].content || "");
        document.getElementById("questionGroupContainer").innerHTML = sections[num].questions || "";

        document.querySelectorAll(".section-btns button").forEach(btn => btn.classList.remove("active"));
        document.querySelector(`.section-btns button:nth-child(${num + 1})`).classList.add("active");
    }
</script>
<script src="${pageContext.request.contextPath}/js/form-script.js"></script>
</body>
</html>
