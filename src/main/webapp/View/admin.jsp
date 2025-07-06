<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Admin Page</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Admin.css">
        <script src="${pageContext.request.contextPath}/js/Admin.js" defer></script>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <h2>️ IELTS Admin Panel</h2>
            <form method="post" action="${pageContext.request.contextPath}/admin-redirect" class="admin-form">
                <button name="action" value="addReading" class="admin-btn">➕ Add Reading Test</button>
                <button name="action" value="addListening" class="admin-btn">🎧 Add Listening Test</button>
            </form>
            <hr class="divider"/>
            <a href="${pageContext.request.contextPath}/View/viewExam.jsp" class="view-link">📄 View All Exams</a>
        </div>
    </body>
</html>
