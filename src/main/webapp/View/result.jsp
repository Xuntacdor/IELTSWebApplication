<%-- 
    Document   : result
    Created on : Jun 9, 2025, 8:32:50 AM
    Author     : NTKC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Kết quả bài làm</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .result-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 800px;
            width: 100%;
            animation: slideIn 0.8s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .score-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .score-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            transition: transform 0.3s ease;
            animation: fadeInUp 0.6s ease-out;
        }

        .score-card:hover {
            transform: translateY(-5px);
        }

        .score-card:nth-child(1) { animation-delay: 0.1s; }
        .score-card:nth-child(2) { animation-delay: 0.2s; }
        .score-card:nth-child(3) { animation-delay: 0.3s; }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .score-card i {
            font-size: 2.5rem;
            margin-bottom: 10px;
            display: block;
        }

        .score-card h3 {
            font-size: 1.2rem;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .score-card .value {
            font-size: 2rem;
            font-weight: 700;
        }

        .progress-bar {
            width: 100%;
            height: 10px;
            background: #e0e0e0;
            border-radius: 5px;
            overflow: hidden;
            margin-top: 15px;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #4CAF50, #45a049);
            border-radius: 5px;
            transition: width 1.5s ease;
        }

        .wrong-answers-section {
            margin-top: 40px;
        }

        .section-title {
            color: #2c3e50;
            font-size: 1.8rem;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 600;
        }

        .wrong-answer-card {
            background: #fff;
            border: 2px solid #ff6b6b;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 4px 15px rgba(255, 107, 107, 0.1);
            transition: all 0.3s ease;
            animation: slideInLeft 0.5s ease-out;
        }

        .wrong-answer-card:hover {
            transform: translateX(5px);
            box-shadow: 0 6px 20px rgba(255, 107, 107, 0.2);
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .question-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .question-number {
            background: #ff6b6b;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .question-type {
            background: #f39c12;
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .answer-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 15px;
        }

        .answer-item {
            padding: 12px;
            border-radius: 8px;
            font-weight: 500;
        }

        .your-answer {
            background: #ffe6e6;
            border: 2px solid #ff6b6b;
            color: #d63031;
        }

        .correct-answer {
            background: #e6ffe6;
            border: 2px solid #00b894;
            color: #00b894;
        }

        .answer-label {
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 5px;
            display: block;
        }

        .no-wrong-answers {
            text-align: center;
            color: #27ae60;
            font-size: 1.2rem;
            font-weight: 600;
            padding: 30px;
            background: #e8f5e8;
            border-radius: 12px;
            border: 2px solid #27ae60;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 40px;
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #ecf0f1;
            color: #2c3e50;
        }

        .btn-secondary:hover {
            background: #bdc3c7;
            transform: translateY(-2px);
        }

        .performance-indicator {
            text-align: center;
            margin: 20px 0;
            padding: 15px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .excellent {
            background: linear-gradient(135deg, #00b894, #00cec9);
            color: white;
        }

        .good {
            background: linear-gradient(135deg, #fdcb6e, #e17055);
            color: white;
        }

        .average {
            background: linear-gradient(135deg, #e17055, #d63031);
            color: white;
        }

        .needs-improvement {
            background: linear-gradient(135deg, #d63031, #6c5ce7);
            color: white;
        }

        .wrong-list-container {
            background: #f9f9f9;
            border: 1px solid #eee;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .wrong-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .wrong-table th, .wrong-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .wrong-table th {
            background-color: #667eea;
            color: white;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .wrong-table tr:last-child td {
            border-bottom: none;
        }

        .wrong-table tr:hover {
            background-color: #f8f9fa;
        }

        .wrong-table td.correct-answer {
            color: #27ae60;
            font-weight: 600;
        }

        .wrong-table td.your-answer {
            color: #e74c3c;
            font-weight: 600;
        }

        .wrong-table td:first-child {
            font-weight: 600;
            color: #667eea;
            text-align: center;
        }

        @media (max-width: 768px) {
            .result-container {
                padding: 20px;
                margin: 10px;
            }

            .header h1 {
                font-size: 2rem;
            }

            .score-section {
                grid-template-columns: 1fr;
            }

            .answer-details {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <div class="result-container">
        <div class="header">
            <h1><i class="fas fa-trophy"></i> KẾT QUẢ BÀI LÀM</h1>
        </div>

        <div class="score-section">
            <div class="score-card">
                <i class="fas fa-check-circle"></i>
                <h3>Số câu đúng</h3>
                <div class="value"><%= request.getAttribute("correct") %></div>
            </div>
            <div class="score-card">
                <i class="fas fa-list"></i>
                <h3>Tổng số câu</h3>
                <div class="value"><%= request.getAttribute("total") %></div>
            </div>
            <div class="score-card">
                <i class="fas fa-star"></i>
                <h3>Điểm số</h3>
                <div class="value"><%= String.format("%.1f", request.getAttribute("score")) %>%</div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: <%= request.getAttribute("score") %>%"></div>
                </div>
            </div>
        </div>

        <% 
            double score = (Double) request.getAttribute("score");
            String performanceClass = "";
            String performanceText = "";
            
            if (score >= 90) {
                performanceClass = "excellent";
                performanceText = "🎉 Xuất sắc! Bạn đã làm rất tốt!";
            } else if (score >= 70) {
                performanceClass = "good";
                performanceText = "👍 Tốt! Hãy tiếp tục phát huy!";
            } else if (score >= 50) {
                performanceClass = "average";
                performanceText = "📚 Khá! Cần ôn tập thêm một chút!";
            } else {
                performanceClass = "needs-improvement";
                performanceText = "📖 Cần cải thiện! Hãy ôn tập kỹ hơn!";
            }
        %>

        <div class="performance-indicator <%= performanceClass %>">
            <%= performanceText %>
        </div>

        <div class="wrong-answers-section">
            <h2 class="section-title"><i class="fas fa-exclamation-triangle"></i> Chi tiết lỗi sai</h2>
            
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
        </div>

        <div class="action-buttons">
            <a href="View/Home.jsp" class="btn btn-primary">
                <i class="fas fa-home"></i>
                Về trang chủ
            </a>
            <a href="View/exam-list.jsp" class="btn btn-secondary">
                <i class="fas fa-list"></i>
                Làm bài khác
            </a>
        </div>
    </div>

    <script>
        // Animation cho progress bar
        setTimeout(() => {
            const progressFill = document.querySelector('.progress-fill');
            const score = <%= request.getAttribute("score") %>;
            progressFill.style.width = '0%';
            setTimeout(() => {
                progressFill.style.width = score + '%';
            }, 100);
        }, 500);

        // Thêm hiệu ứng hover cho các card
        document.querySelectorAll('.score-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-8px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    </script>
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

