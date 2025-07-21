<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.StudyTask" %> 

<%
    String startDateStr = (String) request.getAttribute("startDate");
    LocalDate startDate;
    if (startDateStr != null && !startDateStr.isEmpty()) {
        startDate = LocalDate.parse(startDateStr);
    } else {
        startDate = LocalDate.now();
    }
%>

<html>
<head>
    <title>Your Study Plan</title>
    <style>
        table { border-collapse: collapse; width: 80%; }
        th, td { padding: 8px; border: 1px solid #999; text-align: left; }
    </style>
</head>
<body>
    <h2>Your Study Plan</h2>

    <table>
        <tr>
            <th>Date</th>
            <th>Task</th>
            <th>Completed</th>
        </tr>
        <c:forEach var="task" items="${taskList}">
            <%
                model.StudyTask t = (model.StudyTask) pageContext.findAttribute("task");
                int dayOffset = t.getDueDay() - 1;
                LocalDate taskDate = startDate.plusDays(dayOffset);
                String realDate = taskDate.toString();
                boolean completed = t.isCompleted();
            %>
            <tr>
                <td><%= realDate %></td>
                <td>
                    <a href="task-detail?taskId=${task.taskId}">
                        ${task.taskTitle}
                    </a>
                </td>
                <td>
                    <input type="checkbox" disabled <%= completed ? "checked" : "" %> />
                </td>
            </tr>
        </c:forEach>
    </table>

    <br/><br/>
    <form action="final-test" method="get">
        <input type="submit" value="🧪 Take Final Test" style="padding: 10px 20px; font-size: 16px;">
    </form>
</body>
</html>
