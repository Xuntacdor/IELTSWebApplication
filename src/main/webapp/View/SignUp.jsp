<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sign Up - IELTS Ocean</title>
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="./css/bootstrap.min.css" />
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SignUp.css">
    </head>
    <body>
        <script>window.contextPath = "${pageContext.request.contextPath}";</script>
        <canvas id="fishCanvas" style="position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:0;pointer-events:none;"></canvas>
        <!-- Underwater Background Elements -->
        <div class="ocean-bg">
            <div class="bubble bubble1"></div>
            <div class="bubble bubble2"></div>
            <div class="bubble bubble3"></div>
            <div class="bubble bubble4"></div>
            <div class="bubble bubble5"></div>
            <div class="coral coral-left"></div>
            <div class="coral coral-right"></div>
            <div class="seaweed seaweed-left"></div>
            <div class="seaweed seaweed-right"></div>
        </div>
        <!-- Header with IELTS branding -->
        <header class="signup-header">
            <span class="ielts-icon"><i class="fa fa-graduation-cap"></i></span>
            <span class="ielts-logo">IELTS</span>
            <span class="ielts-icon"><i class="fa fa-book"></i></span>
        </header>
        <!-- Glassy Bubble Form -->
        <div class="form-bubble-container">
            <form class="form-bubble" action="${pageContext.request.contextPath}/SignUpController" method="post" autocomplete="off">
                <h2 class="bubble-title">Sign Up</h2>
                <div class="input-icon">
                    <i class="fa fa-user"></i>
                    <input type="text" name="name" placeholder="Full Name" required>
                </div>
                <div class="input-icon">
                    <i class="fa fa-envelope"></i>
                    <input type="email" name="email" placeholder="Email" required>
                </div>
                <div class="input-icon">
                    <i class="fa fa-lock"></i>
                    <input type="password" id="password" name="password" placeholder="Password" required>
                    <i class="fa fa-eye toggle-password" onclick="togglePassword('password', this)"></i>
                </div>
                <div class="input-icon">
                    <i class="fa fa-lock"></i>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirmed Password" required>
                    <i class="fa fa-eye toggle-password" onclick="togglePassword('confirmPassword', this)"></i>
                </div>
                <div class="input-icon">
                    <i class="fa fa-venus-mars"></i>
                    <select name="gender" required>
                        <option value="" disabled selected hidden>Gender</option>
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                    </select>
                </div>

                <div class="input-icon">
                    <i class="fa fa-calendar"></i>
                    <input type="date" name="dateOfBirth" required />
                </div>

                <button type="submit" class="signUp-btn">Sign Up</button>
                <div class="login-link">
                    <p><a href="${pageContext.request.contextPath}/View/Login.jsp">Already have an account? Login</a></p>
                </div>
            </form>
        </div>
        <!-- Script for password toggle and ripple -->
        <script src="${pageContext.request.contextPath}/js/SignUp.js"></script>
        <script src="${pageContext.request.contextPath}/js/FishTank.js"></script>
    </body>
</html>
