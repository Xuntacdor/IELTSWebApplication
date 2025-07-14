<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    model.User user = (model.User) session.getAttribute("user");
%>
<html>
<head>
    <title>User Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Home.css" />
    <style>
        body {
            background: linear-gradient(135deg, var(--pale-pink, #FCECEC) 0%, #fff5f5 50%, var(--pale-pink, #FCECEC) 100%);
            font-family: 'ADLaM Display', sans-serif;
        }
        .settings-container {
            max-width: 420px;
            margin: 60px auto 0 auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 6px 32px rgba(127,85,177,0.10);
            padding: 36px 32px 28px 32px;
        }
        h2 {
            color: var(--highlight-text, #7F55B1);
            font-weight: 900;
            text-align: center;
            margin-bottom: 28px;
        }
        .form-label {
            color: var(--primary-text, #4B3B60);
            font-weight: 600;
        }
        .btn-primary {
            background: linear-gradient(90deg, var(--deep-purple, #7F55B1), var(--soft-purple, #9D80BE));
            border: none;
            font-weight: 700;
            border-radius: 20px;
            padding: 10px 28px;
            transition: background 0.2s, transform 0.2s;
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, var(--soft-purple, #9D80BE), var(--deep-purple, #7F55B1));
            transform: translateY(-2px) scale(1.03);
        }
        .alert-info {
            border-radius: 12px;
            font-weight: 600;
            color: var(--deep-purple, #7F55B1);
            background: var(--pale-pink, #FCECEC);
            border: 1px solid var(--soft-pink, #E4A4AF);
        }
    </style>
</head>
<body>
    <div class="settings-container">
        <h2>User Settings</h2>
        <form action="SettingsServlet" method="post">
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" value="${user.email}" required>
            </div>
            <button type="submit" class="btn btn-primary w-100 mt-2">Update</button>
        </form>
        <c:if test="${not empty message}">
            <div class="alert alert-info mt-3 text-center">${message}</div>
        </c:if>
    </div>
</body>
</html> 