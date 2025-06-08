<%@page import="java.util.List"%>
<%@page import="dao.ExamDAO"%>
<%@page import="Model.Exam"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>📚 Danh sách đề thi IELTS</title>
    <style>
        body {
            font-family: Arial;
            margin: 30px;
            background-color: #f5f5f5;
        }
        h2 {
            color: #2c3e50;
        }
        .exam-box {
            background: #ffffff;
            border: 1px solid #ccc;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            box-shadow: 1px 1px 4px rgba(0,0,0,0.1);
        }
        .exam-title {
            font-size: 18px;
            font-weight: bold;
        }
        .exam-meta {
            color: #666;
            font-size: 14px;
        }
        .start-btn {
            margin-top: 10px;
            display: inline-block;
            padding: 6px 12px;
            background-color: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .start-btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <h2>📚 Danh sách đề thi IELTS</h2>

    <%
        ExamDAO examDAO = new ExamDAO();
        List<Exam> exams = examDAO.getAllExams();
        for (Exam e : exams) {
    %>
    <div class="exam-box">
        <div class="exam-title"><%= e.getTitle() %></div>
        <div class="exam-meta">
            Loại đề: <%= e.getType() %> |
            Ngày tạo: <%= e.getCreatedAt() %>
        </div>
        <a class="start-btn" href="doTest?examId=<%= e.getExamId() %>">▶ Làm bài</a>

    </div>
    <%
        }
    %>
</body>
</html>
