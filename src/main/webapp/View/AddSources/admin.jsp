<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Page</title>
    </head>
    <body>
        <h2>📘 IELTS Admin Panel</h2>

        <form method="post" action="<%= request.getContextPath() %>/admin-redirect">
            <button name="action" value="addReading">Add Reading Test</button>
            <button name="action" value="addListening">Add Listening Test</button>
        </form>

        <hr/>
        <a href="<%= request.getContextPath() %>/View/AddSources/viewExam.jsp">View All Exams</a>
    </body>
</html>
