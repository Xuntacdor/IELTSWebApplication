<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Add Question and Answer</title>
    </head>
    <body>
        <h2>Add Question and Answer</h2>
        <form action="AddQA" method="post" enctype="multipart/form-data">
            <label>Passage ID:</label>
            <input type="number" name="passageId" required/><br/>

            <label>Question Type:</label>
            <input type="text" name="questionType" required/><br/>

            <label>Question Text:</label>
            <textarea name="questionText" required></textarea><br/>

            <label>Upload Image:</label>
            <input type="file" name="imageFile" accept="image/*"/><br/>

            <label>Instruction:</label>
            <textarea name="instruction"></textarea><br/>

            <label>Number In Passage:</label>
            <input type="number" name="numberInPassage" required/><br/>

            <label>Answer Text:</label>
            <textarea name="answerText" required></textarea><br/>

            <button type="submit">Submit</button>
        </form>
    </body>
</html>
