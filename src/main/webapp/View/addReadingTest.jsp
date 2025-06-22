<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add IELTS Reading Test</title>
    <link rel="stylesheet" href="css/style.css" />
    <script src="js/form-script.js"></script>
</head>
<body>
    <h2>📝 Add IELTS Reading Test (Google Form style)</h2>
    <form action="AddExamServlet" method="post" enctype="multipart/form-data">
        <label>Exam Title:</label><br/>
        <input type="text" name="examTitle" required/><br/><br/>

        <div id="sections-container"></div>
        <button type="button" onclick="addSection()">➕ Add Section</button>
        <br/><br/>
        <input type="submit" value="Submit Exam"/>
    </form>
</body>
</html>
