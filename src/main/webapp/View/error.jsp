<%-- 
    Document   : error
    Created on : Jun 22, 2025, 9:13:00 PM
    Author     : NTKC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error - IELTS Application</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f8f9fa;
                margin: 0;
                padding: 40px;
                text-align: center;
            }
            .error-container {
                max-width: 600px;
                margin: auto;
                background-color: #fff;
                border-left: 6px solid #dc3545;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h1 {
                color: #dc3545;
                font-size: 28px;
                margin-bottom: 20px;
            }
            .error-message {
                font-size: 18px;
                color: #666;
                margin-bottom: 20px;
            }
            .back-link {
                display: inline-block;
                padding: 10px 20px;
                background-color: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 5px;
                margin-top: 20px;
            }
            .back-link:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <h1>🚨 Error Occurred</h1>
            <div class="error-message">
                <% 
                    String errorMsg = request.getParameter("msg");
                    if (errorMsg != null && !errorMsg.isEmpty()) {
                        out.print(errorMsg);
                    } else {
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        if (errorMessage != null && !errorMessage.isEmpty()) {
                            out.print(errorMessage);
                        } else {
                            out.print("An unexpected error occurred. Please try again.");
                        }
                    }
                %>
            </div>
            <a href="${pageContext.request.contextPath}/HomeServlet" class="back-link">← Back to Home</a>
        </div>
    </body>
</html>
