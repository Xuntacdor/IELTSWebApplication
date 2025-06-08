<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng ký tài khoản</title>

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="./css/bootstrap.min.css" />

        <!-- CSS riêng -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SignUp.css">    

    </head>
    <body>
        <!-- Form đăng ký -->
        <div class="form-container">
            <h2 style="color: #b8860b;">Sign Up</h2>
            <form action="${pageContext.request.contextPath}/SignUpController" method="post">

                <div class="input-icon">
                    <i class="fa fa-user"></i>
                    <input type="text" name="name" placeholder="Full Name" required>
                </div>

                <div class="input-icon">
                    <i class="fa fa-envelope"></i>
                    <input type="email" name="email" placeholder="Email" required>
                </div>

                <div class="input-icon">
                    <i class="fa fa-lock "></i>
                    <input type="password" id="password" name="password" placeholder="Password" required>
                    <i class="fa fa-eye icon-left toggle-password" onclick="togglePassword('password', this)"></i>
                </div>

                <div class="input-icon">
                    <i class="fa fa-lock "></i>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
                    <i class="fa fa-eye icon-left toggle-password" onclick="togglePassword('confirmPassword', this)"></i>
                </div>

                <div class="gender-group">
                    <label class="gender-option">
                        <input type="radio" name="gender" value="male" required>
                        <i class="fa-solid fa-person"></i> Male
                    </label>
                    <label class="gender-option">
                        <input type="radio" name="gender" value="female">
                        <i class="fa-solid fa-person-dress"></i> Female
                    </label>
                </div>

                <div class="input-icon">
                    <i class="fa fa-calendar"></i>
                    <input type="date" name="dateOfBirth" required>
                </div>

                <input type="submit" value="Submit">
            </form>

            <div class="error-message">
                <% if (request.getAttribute("error") != null) {%>
                <%= request.getAttribute("error")%>
                <% }%>
            </div>
            <div style="text-align: center;">
                <p><a href="${pageContext.request.contextPath}/View/Login.jsp">Already have an account? Sign in</a></p>
            </div>
        </div>

        <!-- Script -->
        <script src="${pageContext.request.contextPath}/js/PasswordHidden.js"></script>
    </body>
</html>
