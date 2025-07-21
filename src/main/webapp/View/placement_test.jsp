<%-- 
    Document   : placement_test
    Created on : Jul 21, 2025, 12:01:04 AM
    Author     : hmqua
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Placement Test</title>
        <link rel="stylesheet" href="../css/bootstrap.min.css">
        <style>
            body {
                background: #f8f9fa;
                min-height: 100vh;
            }
            .placement-container {
                max-width: 700px;
                margin: 40px auto;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 24px rgba(0,0,0,0.08);
                padding: 32px 24px;
            }
            .test-section {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 32px;
                padding: 24px 16px;
                border-radius: 12px;
                background: #f1f3f6;
                box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            }
            .test-section:last-child {
                margin-bottom: 0;
            }
            .test-info {
                flex: 1;
            }
            .test-title {
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 8px;
            }
            .test-desc {
                color: #555;
                margin-bottom: 0;
            }
            .start-btn {
                min-width: 120px;
                font-size: 1.1rem;
            }
            @media (max-width: 600px) {
                .test-section {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .start-btn {
                    width: 100%;
                    margin-top: 16px;
                }
            }
        </style>
    </head>
    <body>
        <div class="placement-container">
            <h2 class="text-center mb-4">Placement Test</h2>
            <div class="test-section">
                <div class="test-info">
                    <div class="test-title">Reading Test</div>
                    <p class="test-desc">Đánh giá kỹ năng đọc hiểu tiếng Anh của bạn qua một bài kiểm tra ngắn.</p>
                </div>
                <a href="/doTest?type=reading&mode=single" class="btn btn-primary start-btn">Bắt đầu</a>
            </div>
            <div class="test-section">
                <div class="test-info">
                    <div class="test-title">Listening Test</div>
                    <p class="test-desc">Kiểm tra khả năng nghe hiểu tiếng Anh với bài Listening ngắn gọn.</p>
                </div>
                <a href="/doTest?type=listening&mode=single" class="btn btn-success start-btn">Bắt đầu</a>
            </div>
        </div>
    </body>
</html>
