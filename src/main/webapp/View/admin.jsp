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
            
            <div class="admin-section">
                <h3>📊 Quản lý đề thi</h3>
                <a href="${pageContext.request.contextPath}/admin/exam-management" class="admin-btn-link">📚 View All Exams</a>
            </div>
            <hr class="divider"/>
        </div>
    </body>
</html>
