<%@page import="java.util.List"%>
<%@page import="model.Exam"%>
<%@page import="dao.ExamDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String type = request.getParameter("type");
    ExamDAO dao = new ExamDAO();
    List<Exam> exams = dao.getExamsByType(type);
%>
<html>
<head>
    <title>Danh sách đề thi IELTS - <%= type %></title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <style>
        body {
            background: #f5f5f5;
            font-family: Arial;
        }
        .exam-card {
            border-radius: 8px;
            background: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            overflow: hidden;
            transition: transform 0.2s;
        }
        .exam-card:hover {
            transform: scale(1.02);
        }
        .exam-img {
            height: 180px;
            object-fit: cover;
            width: 100%;
        }
        .exam-body {
            padding: 15px;
        }
        .exam-title {
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        .exam-meta {
            font-size: 14px;
            color: #555;
            margin-bottom: 8px;
        }
        .exam-type {
            font-size: 13px;
            color: #007bff;
        }
        .btn-start {
            background: #007bff;
            color: white;
            padding: 5px 15px;
            border-radius: 4px;
            text-decoration: none;
        }
        .badge-pass {
            font-size: 13px;
            padding: 3px 8px;
            border-radius: 10px;
            color: white;
        }
    </style>
</head>
<body>
<div class="container mt-4">
    <h3 class="mb-4"><img src="https://cdn-icons-png.flaticon.com/512/135/135620.png" width="30"/> Danh sách đề thi IELTS - <%= type %></h3>
    <div class="row">
        <%
            for (Exam exam : exams) {
        %>
        <div class="col-md-4">
            <div class="exam-card">
                <img class="exam-img" src="<%= request.getContextPath() %>/uploads/default-cover.jpg" alt="exam-cover">
                <div class="exam-body">
                    <span class="badge badge-pass bg-warning text-dark">Passage 1</span>
                    <div class="exam-title"><%= exam.getTitle() %></div>
                    <div class="exam-meta">Loại đề: <%= exam.getType() %> | Ngày tạo: <%= exam.getCreatedAt() %></div>
                    <div class="exam-type">• Gap Filling<br/>• Matching / True-False / etc.</div>
                    <a class="btn-start mt-2 d-inline-block" href="doTest?examId=<%= exam.getExamId() %>">Làm bài</a>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
</div>
</body>
</html>
