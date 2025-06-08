<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Add IELTS Listening Test</title>
        <link rel="stylesheet" href="css/style.css" />
        <script src="js/form-listening.js"></script>


    </head>
    <body>
        <h2>➕ Add IELTS Listening Test (Google Form style)</h2>
        <form action="AddListeningTestServlet" method="post" enctype="multipart/form-data">
            <label>Exam Title:</label><br/>
            <input type="text" name="examTitle" required/><br/>

            <label>Upload Full Audio File:</label><br/>
            <input type="file" name="fullAudio" accept="audio/*" required/><br/><br/>

            <div id="sections-container"></div>

            <button type="button" onclick="addSection()">➕ Add Section</button><br/><br/>
            <input type="submit" value="Submit Listening Test"/>
        </form>

    </body>
</html>
