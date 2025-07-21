<%@ page import="java.util.List" %>
<%@ page import="model.Exam" %>
<%@ page import="dao.ExamDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String category = request.getParameter("category");
    if (category == null || category.isEmpty()) {
        category = "READING_FULL";
    }
    int currentPage = 1;
    int pageSize = 8;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) {
                currentPage = 1;
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    int offset = (currentPage - 1) * pageSize;
    ExamDAO dao = new ExamDAO();
    List<Exam> exams = (List<Exam>) request.getAttribute("exams");
    if (exams == null) exams = dao.getAllExams();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý tất cả đề thi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: #f6f8fb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .main-header {
            background: linear-gradient(120deg, #7f55b1 0%, #6dd5fa 100%);
            color: #fff;
            padding: 48px 0 32px 0;
            text-align: center;
            border-radius: 0 0 32px 32px;
            box-shadow: 0 8px 32px 0 rgba(127,85,177,0.10);
        }
        .main-header h1 {
            font-size: 2.8rem;
            font-weight: 700;
            margin-bottom: 8px;
            letter-spacing: 1px;
        }
        .main-header p {
            font-size: 1.2rem;
            opacity: 0.95;
        }
        .back-btn {
            background: #fff;
            color: #7f55b1;
            padding: 12px 32px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 32px;
            margin-top: -24px;
            border: 2px solid #7f55b1;
            transition: background 0.2s, color 0.2s;
            display: inline-block;
            font-size: 1.15rem;
        }
        .back-btn:hover {
            background: #7f55b1;
            color: #fff;
            text-decoration: none;
        }
        .stats-row {
            display: flex;
            justify-content: center;
            gap: 32px;
            margin-bottom: 40px;
        }
        .stats-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 24px rgba(127,85,177,0.08);
            padding: 32px 36px;
            min-width: 180px;
            text-align: center;
        }
        .stats-number {
            font-size: 2.2rem;
            font-weight: bold;
            color: #7f55b1;
        }
        .stats-label {
            color: #6c757d;
            font-size: 1.1rem;
        }
        .exam-list-container {
            width: 100%;
            max-width: 900px;
            margin: 0 auto 48px auto;
        }
        .exam-box {
            background: #fff;
            border: none;
            padding: 36px 36px 24px 36px;
            margin-bottom: 36px;
            border-radius: 22px;
            box-shadow: 0 8px 32px 0 rgba(127,85,177,0.13);
            transition: transform 0.18s, box-shadow 0.18s;
            position: relative;
        }
        .exam-box:hover {
            transform: translateY(-4px) scale(1.025);
            box-shadow: 0 16px 40px 0 rgba(127,85,177,0.18);
        }
        .exam-title {
            font-size: 1.45rem;
            font-weight: 700;
            color: #7f55b1;
            margin-bottom: 8px;
            letter-spacing: 0.5px;
        }
        .exam-meta {
            color: #666;
            font-size: 1.1rem;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 18px;
        }
        .badge-type {
            background: #7f55b1;
            color: #fff;
            padding: 6px 18px;
            border-radius: 16px;
            font-size: 1.05rem;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .exam-date {
            color: #6c757d;
            font-size: 1.05rem;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .start-btn, .btn-edit, .btn-delete {
            display: inline-block;
            padding: 12px 32px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 10px;
            border: none;
            transition: background 0.18s, color 0.18s, box-shadow 0.18s;
        }
        .btn-edit {
            background: #28a745;
            color: #fff;
            margin-right: 12px;
        }
        .btn-edit:hover {
            background: #218838;
            color: #fff;
            box-shadow: 0 2px 12px #28a74555;
        }
        .btn-delete {
            background: #dc3545;
            color: #fff;
        }
        .btn-delete:hover {
            background: #c82333;
            color: #fff;
            box-shadow: 0 2px 12px #dc354555;
        }
        .badge-question {
            background: #6c757d;
            color: #fff;
            padding: 7px 18px;
            border-radius: 16px;
            font-size: 1.05rem;
            font-weight: 600;
            margin-right: 8px;
            margin-bottom: 4px;
            display: inline-block;
        }
        @media (max-width: 1100px) {
            .exam-list-container { max-width: 99vw; padding: 0 2vw; }
            .exam-box { padding: 18px 4vw 16px 4vw; }
        }
        @media (max-width: 700px) {
            .main-header h1 { font-size: 2rem; }
            .stats-row { flex-direction: column; gap: 18px; }
            .stats-card { padding: 18px 10px; min-width: 120px; }
            .exam-title { font-size: 1.1rem; }
            .exam-meta { font-size: 0.95rem; }
            .start-btn, .btn-edit, .btn-delete { font-size: 1rem; padding: 10px 18px; }
        }
    </style>
</head>
<body>
    <div class="main-header">
        <h1>📚 Quản lý tất cả đề thi</h1>
        <p>Xem và quản lý tất cả đề thi trong hệ thống</p>
    </div>
    <div class="container mt-4 mb-5">
        <a href="../admin.jsp" class="back-btn">← Quay lại Admin Panel</a>
        <div class="stats-row">
            <div class="stats-card">
                <div class="stats-number"><%= exams.size() %></div>
                <div class="stats-label">Tổng số đề thi</div>
            </div>
            <div class="stats-card">
                <div class="stats-number"><%= exams.stream().filter(e -> e.getType().contains("READING")).count() %></div>
                <div class="stats-label">Đề Reading</div>
            </div>
            <div class="stats-card">
                <div class="stats-number"><%= exams.stream().filter(e -> e.getType().contains("LISTENING")).count() %></div>
                <div class="stats-label">Đề Listening</div>
            </div>
            <div class="stats-card">
                <div class="stats-number"><%= exams.stream().filter(e -> e.getType().contains("SINGLE")).count() %></div>
                <div class="stats-label">Đề Single</div>
            </div>
        </div>
        <h2 class="mb-4" style="font-size:2rem;font-weight:700;">Danh sách đề thi</h2>
        <div class="exam-list-container">
            <% if (exams.isEmpty()) { %>
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i> Chưa có đề thi nào trong hệ thống.
                </div>
            <% } else { %>
                <% for (Exam e : exams) { %>
                <div class="exam-box">
                    <div class="exam-title"><%= e.getTitle() %></div>
                    <div class="exam-meta">
                        <span class="badge-type"><%= e.getType() %></span>
                        <span class="exam-date">
                            <svg width="18" height="18" fill="#7f55b1" style="margin-bottom:2px;" viewBox="0 0 16 16"><path d="M3.5 0a.5.5 0 0 1 .5.5V2h8V.5a.5.5 0 0 1 1 0V2h1a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5zM1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1zm2.5 2a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0v-6a.5.5 0 0 1 .5-.5zm3 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0v-6a.5.5 0 0 1 .5-.5zm3 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0v-6a.5.5 0 0 1 .5-.5z"/></svg>
                            <%= e.getCreatedAt() %>
                        </span>
                    </div>
                    <div style="margin-bottom: 12px;">
                        <span style="font-weight:600; color:#444;">Loại câu hỏi:</span>
                        <% if (e.getQuestionTypes() != null) for (String qt : e.getQuestionTypes()) { %>
                            <span class="badge-question"><%= qt %></span>
                        <% } %>
                    </div>
                    <div class="d-flex justify-content-end align-items-center mt-2">
                        <a href="exam-management?action=edit&examId=<%= e.getExamId() %>" class="btn-edit">✏️ Sửa</a>
                        <a href="javascript:void(0)" onclick="confirmDelete(<%= e.getExamId() %>, '<%= e.getTitle() %>')" class="btn-delete">🗑️ Xóa</a>
                    </div>
                </div>
                <% } %>
            <% } %>
        </div>
    </div>
    <script>
        function confirmDelete(examId, examTitle) {
            if (confirm('Bạn có chắc chắn muốn xóa đề thi "' + examTitle + '" không?\n\nHành động này không thể hoàn tác!')) {
                window.location.href = 'exam-management?action=delete&examId=' + examId;
            }
        }
    </script>
</body>
</html> 