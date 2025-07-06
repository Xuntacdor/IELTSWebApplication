<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add IELTS Listening Test</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AddTest.css" />
    <script src="${pageContext.request.contextPath}/js/form-listening.js"></script>
</head>
<body>
    <h2>➕ Add IELTS Listening Test (Google Form style)</h2>

    <form action="${pageContext.request.contextPath}/AddExamServlet" method="post" enctype="multipart/form-data">
        <label>Exam Title:</label><br/>
        <input type="text" name="examTitle" required/><br/>

        <label>Test Type:</label><br/>
        <select name="category" required>
            <option value="LISTENING_FULL">Listening (Full Test)</option>
            <option value="LISTENING_SINGLE">Listening (Single Section)</option>
        </select><br/><br/>

        <label>Upload Full Audio File:</label><br/>
        <input type="file" name="fullAudio" accept="audio/*"/><br/><br/>

        <div id="sections-container"></div>

        <button type="button" onclick="addSection()">➕ Add Section</button><br/><br/>
        <input type="submit" value="Submit Listening Test"/>
    </form>
</body>
</html>
