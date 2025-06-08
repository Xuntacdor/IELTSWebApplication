<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Simple Login Layout</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Login.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FishTank.css" />
        <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet" />

    </head>
    <body>
        <div class="container-fluid">
            <div class="row full-height">
                <div class="col-md-5 left">
                    <img src="${pageContext.request.contextPath}/Sources/LoginSources/real_back.jpg" alt="alt"/>
                    <h3 class="left_first_prompt">Start New Journey!</h3>
                    <p class="left_second_prompt">You don't have an account yet?</p>
                    <form action="${pageContext.request.contextPath}/View/SignUp.jsp" method="get">
                        <input type="submit" value="Sign Up" id="signUp"/>
                    </form>
                </div>

                <div class="col-md-7 right fish-container">
                    <canvas id="fishCanvas"></canvas>

                    <h3 class="right_first_prompt">Sign In</h3>
                    <div class="logo_container">
                        <a class="logo" href="#">
                            <img src="${pageContext.request.contextPath}/Sources/LoginSources/facebook.png" alt="facebook_icon" />
                        </a>

                        <a class="logo" href="${pageContext.request.contextPath}/LoginGoogleServlet">
                            <img src="${pageContext.request.contextPath}/Sources/LoginSources/google.png" alt="google_icon" />
                        </a>

                        <a class="logo" href="#">
                            <img src="${pageContext.request.contextPath}/Sources/LoginSources/linkin.png" alt="linkin_icon" />
                        </a>
                    </div>

                    <form class="form_container" action="${pageContext.request.contextPath}/LoginController" method="post">
                        <div class="input_group">
                            <img src="${pageContext.request.contextPath}/Sources/LoginSources/user.png" class="input_icon" alt="user" />
                            <input type="text" placeholder="Email" name="email"/>
                        </div>

                        <div class="input_group">
                            <img src="${pageContext.request.contextPath}/Sources/LoginSources/lock.png" class="input_icon" alt="lock" />
                            <input type="password" placeholder="Password" name="password"/>
                        </div>

                        <c:if test="${not empty error}">
                            <p style="color: red;">${error}</p>
                        </c:if>

                        <a href="#" id="forgot-link">Forgot your password?</a><br>
                        <button type="submit" class="signIn-btn">Sign In</button>
                    </form>
                </div>
            </div>
        </div>
        <script>
            window.contextPath = '${pageContext.request.contextPath}';
        </script>

        <script src="${pageContext.request.contextPath}/js/FishTank.js"></script>
    </body>
</html>
