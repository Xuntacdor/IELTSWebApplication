<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Exam, dao.ExamDAO" %>
<html>
<head>
    <title>📚 Danh sách đề thi IELTS</title>
    <style>
        body {
            font-family: 'Segoe UI', 'ADLaM Display', Arial, sans-serif;
            margin: 0;
            background: linear-gradient(120deg, #e0eafc 0%, #cfdef3 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        h2 {
            color: #2193b0;
            font-size: 2.3rem;
            margin-top: 48px;
            margin-bottom: 32px;
            letter-spacing: 1px;
            text-shadow: 0 2px 8px rgba(33,147,176,0.08);
        }
        .exam-list-container {
            width: 100%;
            max-width: 600px;
            margin-bottom: 48px;
        }
        .exam-box {
            background: rgba(255,255,255,0.95);
            border: none;
            padding: 28px 28px 20px 28px;
            margin-bottom: 28px;
            border-radius: 18px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.13);
            transition: transform 0.18s, box-shadow 0.18s;
            position: relative;
        }
        .exam-box:hover {
            transform: translateY(-4px) scale(1.025);
            box-shadow: 0 16px 40px 0 rgba(33,147,176,0.18);
        }
        .exam-title {
            font-size: 1.35rem;
            font-weight: 700;
            color: #2980ef;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
        .exam-meta {
            color: #666;
            font-size: 1rem;
            margin-bottom: 16px;
        }
        .start-btn {
            display: inline-block;
            padding: 10px 28px;
            background: linear-gradient(90deg, #6dd5ed 0%, #2193b0 100%);
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
            font-size: 1.08rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(33,147,176,0.10);
            border: none;
            transition: background 0.18s, transform 0.15s, box-shadow 0.18s;
        }
        .start-btn:hover {
            background: linear-gradient(90deg, #2193b0 0%, #6dd5ed 100%);
            color: #fff;
            transform: scale(1.04);
            box-shadow: 0 8px 24px rgba(33,147,176,0.18);
        }
        @media (max-width: 700px) {
            .exam-list-container {
                max-width: 98vw;
                padding: 0 2vw;
            }
            .exam-box {
                padding: 18px 8vw 16px 8vw;
            }
        }
    </style>
</head>
<body>
    <h2>📚 Danh sách đề thi IELTS</h2>
    <div class="exam-list-container">
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
        <a class="start-btn" href="${pageContext.request.contextPath}/doTest?examId=<%= e.getExamId() %>">▶ Làm bài</a>
    </div>
    <%
        }
    %>
    </div>
</body>
</html>
