<%-- 
    Document   : result
    Created on : Jun 9, 2025, 8:32:50 AM
    Author     : NTKC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head><title>Kết quả</title>
<style>
    body {
        font-family: 'Segoe UI', 'ADLaM Display', Arial, sans-serif;
        background: linear-gradient(120deg, #e0eafc 0%, #cfdef3 100%);
        min-height: 100vh;
        margin: 0;
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
    .result-summary {
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.13);
        padding: 32px 40px 24px 40px;
        margin-bottom: 36px;
        text-align: center;
        max-width: 420px;
        width: 100%;
    }
    .result-summary p {
        font-size: 1.18rem;
        margin: 18px 0;
    }
    .wrong-list-container {
        width: 100%;
        max-width: 900px;
        margin-bottom: 48px;
    }
    .wrong-table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 14px;
        overflow: hidden;
        box-shadow: 0 4px 18px rgba(33,147,176,0.10);
    }
    .wrong-table th, .wrong-table td {
        padding: 16px 12px;
        border-bottom: 1px solid #e0eafc;
        text-align: left;
        font-size: 1.05rem;
    }
    .wrong-table th {
        background: linear-gradient(90deg, #6dd5ed 0%, #2193b0 100%);
        color: #fff;
        font-weight: 700;
        letter-spacing: 0.5px;
    }
    .wrong-table tr:last-child td {
        border-bottom: none;
    }
    .wrong-table td {
        color: #333;
    }
    .wrong-table .your-answer {
        color: #e74c3c;
        font-weight: 600;
    }
    .wrong-table .correct-answer {
        color: #2193b0;
        font-weight: 600;
    }
    @media (max-width: 700px) {
        .result-summary {
            padding: 18px 4vw 16px 4vw;
        }
        .wrong-list-container {
            max-width: 99vw;
            padding: 0 1vw;
        }
        .wrong-table th, .wrong-table td {
            padding: 10px 4px;
            font-size: 0.98rem;
        }
    }
</style>
</head>
<body>
    <h2>🎯 KẾT QUẢ BÀI LÀM</h2>
    <div class="result-summary">
        <p>✅ Số câu đúng: <strong><%= request.getAttribute("correct") %></strong></p>
        <p>📋 Tổng số câu: <strong><%= request.getAttribute("total") %></strong></p>
        <p>🏁 Điểm: <strong><%= String.format("%.2f", request.getAttribute("score")) %> %</strong></p>
    </div>
    <%
        List<Map<String, String>> wrongList = (List<Map<String, String>>) request.getAttribute("wrongList");
        if (wrongList != null && !wrongList.isEmpty()) {
    %>
    <div class="wrong-list-container">
        <h3 style="color:#e74c3c; margin-bottom:18px;">❌ Các câu bạn làm sai</h3>
        <table class="wrong-table">
            <tr>
                <th>STT</th>
                <th>Câu hỏi</th>
                <th>Đáp án đúng</th>
                <th>Đáp án của bạn</th>
            </tr>
            <% int idx = 1; for (Map<String, String> wrong : wrongList) { %>
            <tr>
                <td><%= idx++ %></td>
                <td><%= wrong.get("question") %></td>
                <td class="correct-answer"><%= wrong.get("correct") %></td>
                <td class="your-answer"><%= wrong.get("your") %></td>
            </tr>
            <% } %>
        </table>
    </div>
    <% } else { %>
    <div style="color:#27ae60; font-size:1.2rem; margin-bottom:32px;">🎉 Bạn đã trả lời đúng tất cả các câu hỏi!</div>
    <% } %>
</body>
</html>

