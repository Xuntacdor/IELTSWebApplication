<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Verify Reset Code</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth-forms.css">
</head>
<body>
<div class="container mt-5">
    <h3>Enter the verification code sent to your email</h3>
    
    <form action="${pageContext.request.contextPath}/VerifyResetCodeServlet" method="post">
        <div class="mb-3">
            <label>Verification Code</label>
            <input type="text" name="code" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary">Verify</button>

        <c:if test="${not empty error}">
            <p style="color:red">${error}</p>
        </c:if>
    </form>
</div>
</body>
</html>
