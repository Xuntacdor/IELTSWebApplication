<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Error Occurred</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #343a40;
            margin: 0;
            padding: 40px;
        }
        .error-container {
            max-width: 800px;
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
            margin-bottom: 10px;
        }
        p {
            font-size: 18px;
        }
        .stacktrace {
            background-color: #f1f1f1;
            padding: 15px;
            margin-top: 20px;
            border-radius: 5px;
            font-family: Consolas, monospace;
            color: #495057;
            overflow-x: auto;
        }
        .class-info {
            margin-top: 10px;
            font-weight: bold;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>🚨 Oops! Something went wrong.</h1>
        <p>${errorMessage}</p>

        <%
            Exception ex = (Exception) request.getAttribute("exception");
            if (ex != null) {
                String className = "Unknown Class";
                StackTraceElement[] stack = ex.getStackTrace();
                if (stack != null && stack.length > 0) {
                    className = stack[0].getClassName();
                }
        %>
            <div class="class-info">Error Source: <%= className %></div>
            <div class="stacktrace"><pre><%= ex.toString() %></pre></div>
        <%
            }
        %>
    </div>
</body>
</html>
