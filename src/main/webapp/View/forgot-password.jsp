<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth-forms.css">
</head>
<body>
<div class="container mt-5">
    <h3>Forgot Your Password?</h3>
    <form action="${pageContext.request.contextPath}/SendResetCodeServlet" method="post">
        <div class="mb-3">
            <label>Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Enter the CAPTCHA code</label><br>
            <img src="${pageContext.request.contextPath}/captcha" alt="CAPTCHA Image">
            <input type="text" name="captcha" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-primary">Send Reset Code</button>
    </form>
</div>
</body>
</html>
