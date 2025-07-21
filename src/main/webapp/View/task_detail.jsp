<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%
    model.StudyTask task = (model.StudyTask) request.getAttribute("task");
    request.setAttribute("task", task);

    JSONArray activities = new JSONArray();
    JSONArray vocabulary = new JSONArray();

    if (task != null) {
        if (task.getActivitiesJson() != null && !task.getActivitiesJson().isEmpty()) {
            activities = new JSONArray(task.getActivitiesJson());
        }

        if (task.getVocabularyJson() != null && !task.getVocabularyJson().isEmpty()) {
            vocabulary = new JSONArray(task.getVocabularyJson());
        }
    } else {
        out.println("<p><strong style='color:red;'>❌ Task not found!</strong></p>");
        return;
    }
%>
<html>
    <head>
        <title>Task Detail</title>
    </head>
    <body>
        <h2>${task.taskTitle}</h2>
        <p><strong>Type:</strong> ${task.taskType}</p>
        <p><strong>Due Day:</strong> ${task.dueDay}</p>
        <p><strong>Material:</strong> ${task.materialSource} - ${task.materialSection}</p>
        <p><strong>Link:</strong> <a href="${task.materialUrl}" target="_blank">${task.materialUrl}</a></p>
        <p><strong>Estimated Time:</strong> ${task.estimatedTimeMin} minutes</p>

        <h3>📌 Activities</h3>
        <ul>
            <%
                for (int i = 0; i < activities.length(); i++) {
                    out.println("<li>" + activities.getString(i) + "</li>");
                }
            %>
        </ul>

        <h3>📘 Vocabulary</h3>
        <ul>
            <%
                for (int i = 0; i < vocabulary.length(); i++) {
                    out.println("<li>" + vocabulary.getString(i) + "</li>");
                }
            %>
        </ul>
        <form action="mark-completed" method="post">
            <input type="hidden" name="taskId" value="${task.taskId}">
            <button type="submit" style="padding: 10px 20px; font-size: 16px;">✅ Mark as Completed</button>
        </form>
    </body>
</html>
