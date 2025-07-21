<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Success</title>
        <link rel="stylesheet" href="../css/AddTest.css" />
        <style>
            body {
                background: linear-gradient(135deg, #e0eafc 0%, #cfdef3 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: 'Segoe UI', 'ADLaM Display', cursive, sans-serif;
            }
            .success-container {
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18);
                padding: 48px 36px 36px 36px;
                text-align: center;
                max-width: 400px;
                width: 100%;
                animation: popIn 0.7s cubic-bezier(.68,-0.55,.27,1.55);
            }
            @keyframes popIn {
                0% { transform: scale(0.7); opacity: 0; }
                100% { transform: scale(1); opacity: 1; }
            }
            .success-container h2 {
                color: #27ae60;
                font-size: 2rem;
                margin-bottom: 24px;
                letter-spacing: 1px;
            }
            .success-btns {
                display: flex;
                flex-direction: column;
                gap: 18px;
                margin-top: 24px;
            }
            .btn-beauty {
                display: inline-block;
                padding: 12px 0;
                border-radius: 8px;
                background: linear-gradient(90deg, #6dd5ed 0%, #2193b0 100%);
                color: #fff;
                font-size: 1.1rem;
                font-weight: 600;
                border: none;
                box-shadow: 0 4px 16px rgba(33,147,176,0.12);
                transition: transform 0.15s, box-shadow 0.15s, background 0.2s;
                cursor: pointer;
                text-decoration: none;
                letter-spacing: 0.5px;
            }
            .btn-beauty:hover {
                background: linear-gradient(90deg, #2193b0 0%, #6dd5ed 100%);
                transform: translateY(-2px) scale(1.04);
                box-shadow: 0 8px 24px rgba(33,147,176,0.18);
                color: #fff;
                text-decoration: none;
            }
            .btn-add {
                background: linear-gradient(90deg, #f7971e 0%, #ffd200 100%);
                color: #333;
            }
            .btn-add:hover {
                background: linear-gradient(90deg, #ffd200 0%, #f7971e 100%);
                color: #222;
            }
            .icon-home {
                margin-right: 8px;
                font-size: 1.2em;
                vertical-align: middle;
            }
        </style>
    </head>
    <body>
        <div class="success-container">
            <h2>✅ Exam added successfully!</h2>
            <div class="success-btns">
                <a href="addReadingTest.jsp" class="btn-beauty btn-add">➕ Add another exam</a>
                <a href="Home.jsp" class="btn-beauty"><span class="icon-home">🏠</span>Back to Home</a>
            </div>
        </div>
    </body>
</html>