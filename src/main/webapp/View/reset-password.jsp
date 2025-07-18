<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth-forms.css">
</head>
<body>
<div class="container mt-5">
    <h3>Reset Your Password</h3>
    <form action="${pageContext.request.contextPath}/ResetPasswordServlet" method="post">
        <div class="mb-3">
            <label>New Password</label>
            <input type="password" name="newPassword" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Confirm Password</label>
            <input type="password" name="confirmPassword" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-success">Reset Password</button>
        <a href="${pageContext.request.contextPath}/HomeServlet" class="btn btn-secondary">← Back to Home</a>

        <c:if test="${not empty error}">
            <p style="color:red">${error}</p>
        </c:if>
        <c:if test="${not empty success}">
            <p style="color:green">${success}</p>
        </c:if>
    </form>
</div>
</body>
</html>
