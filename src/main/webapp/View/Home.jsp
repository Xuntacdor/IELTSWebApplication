<%@ page import="java.util.List" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Home.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
        <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet" />
        <style>
            .nav-link.active {
                background-color: #0d6efd;
                color: white !important;
                font-weight: bold;
                border-radius: 5px;
            }
        </style>
    </head>

    <body>
        <div class="container-fluid home_container">
            <div class="web_page row">

                <c:set var="activePage" value="home" />
                <jsp:include page="/includes/navbar.jsp" />

                <%-- Main Content --%>
                <div class="col-md-5 middle_part">
                    <h2>Summary of your hard work</h2>

                    <div class="dedication_chart">
                        <h4>Your Dedication Chart</h4>
                        <%
                            java.time.LocalDate today = java.time.LocalDate.now();
                            java.time.YearMonth month = java.time.YearMonth.now();
                            java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("'Month:' MMMM / yyyy");
                            String monthHeader = today.format(formatter);
                        %>
                        <h5 style="margin-bottom: 15px; font-weight: bold;"><%= monthHeader%></h5>

                        <table class="calendar table table-bordered text-center">
                            <thead>
                                <tr>
                                    <th>Mon</th><th>Tue</th><th>Wed</th><th>Thu</th><th>Fri</th><th>Sat</th><th>Sun</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    java.time.LocalDate firstDay = month.atDay(1);
                                    int length = month.lengthOfMonth();
                                    int dayOfWeekValue = firstDay.getDayOfWeek().getValue(); // Mon = 1
                                    int currentDay = 1;
                                    List<java.time.LocalDate> completedDates = (List<java.time.LocalDate>) request.getAttribute("completedDates");

                                    outer:
                                    for (int row = 0; row < 6; row++) {
                                        out.println("<tr>");
                                        for (int col = 1; col <= 7; col++) {
                                            if (row == 0 && col < dayOfWeekValue) {
                                                out.println("<td></td>");
                                            } else if (currentDay > length) {
                                                out.println("<td></td>");
                                            } else {
                                                java.time.LocalDate date = java.time.LocalDate.of(month.getYear(), month.getMonthValue(), currentDay);
                                                boolean submitted = completedDates != null && completedDates.contains(date);
                                                if (submitted) {
                                                    out.println("<td style='background-color: #e0f7e9; color: #2e7d32; font-weight: bold; position: relative;'>"
                                                            + currentDay
                                                            + "<span style='position: absolute; top: 2px; right: 4px; font-size: 14px; color: #2e7d32;'>✔</span>"
                                                            + "</td>");
                                                } else {
                                                    out.println("<td>" + currentDay + "</td>");
                                                }
                                                currentDay++;
                                            }
                                        }
                                        out.println("</tr>");
                                        if (currentDay > length) {
                                            break outer;
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <div class="test_history">
                        <h4>Practice History</h4>
                        <c:if test="${not empty historyList}">
                            <table class="table table-striped table-bordered">
                                <thead>
                                    <tr><th>Date</th><th>Exam</th><th>Score</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${historyList}" begin="0" end="4">
                                        <tr>
                                            <td>${item.completedAt}</td>
                                            <td>${item.title}</td>
                                            <td data-score="${item.score}">${item.score}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                    </div>
                </div>

                <div class="col-md-4 goal-box">
                    <p>Role: ${sessionScope.role}</p>

                    <c:choose>
                        <c:when test="${empty goal}">
                            <div class="set-goal-btn-container">
                                <button class="btn-set-goal">🎯 Set Your Goal</button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="goals-section">
                                <h4>Goals 🎯</h4>
                                <div class="goal-cards">
                                    <div class="goal-card">Reading<br><span>${goal.goalReading}</span></div>
                                    <div class="goal-card">Listening<br><span>${goal.goalListening}</span></div>
                                    <div class="goal-card overall">Overall<br><span>${goal.goalOverall}</span></div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="outcome-summary mt-4">
                        <h4>Your Performance Outcome <span style="font-size:22px;">📊</span></h4>
                        <c:if test="${not empty outcome}">
                            <div style="font-size: 14px; color: gray; text-align:center;">
                                Entries in outcome: ${fn:length(outcome)}
                            </div>
                            <c:set var="readingScore" value="" />
                            <c:set var="listeningScore" value="" />
                            <c:forEach var="entry" items="${outcome}">
                                <c:set var="label" value="${fn:toLowerCase(entry.key)}" />
                                <c:choose>
                                    <c:when test="${label eq 'reading'}">
                                        <c:set var="readingScore" value="${entry.value}" />
                                    </c:when>
                                    <c:when test="${label eq 'listening'}">
                                        <c:set var="listeningScore" value="${entry.value}" />
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                            <c:set var="overallScore" value="" />
                            <c:if test="${not empty readingScore and not empty listeningScore}">
                                <c:set var="overallScore" value="${(readingScore + listeningScore) / 2}" />
                            </c:if>
                            <div class="outcome-progress-list">
                                <c:if test="${not empty readingScore}">
                                    <div class="outcome-progress-item">
                                        <span class="outcome-icon" style="background:#ffe0b2; color:#e67e22;">📖</span>
                                        <span class="outcome-label">Reading</span>
                                        <div class="outcome-bar-bg">
                                            <div class="outcome-bar reading" style="width: ${readingScore * 10}%;"></div>
                                        </div>
                                        <span class="outcome-score"><fmt:formatNumber value="${readingScore}" minFractionDigits="1" maxFractionDigits="1"/></span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty listeningScore}">
                                    <div class="outcome-progress-item">
                                        <span class="outcome-icon" style="background:#d0f5e8; color:#27ae60;">🎧</span>
                                        <span class="outcome-label">Listening</span>
                                        <div class="outcome-bar-bg">
                                            <div class="outcome-bar listening" style="width: ${listeningScore * 10}%;"></div>
                                        </div>
                                        <span class="outcome-score"><fmt:formatNumber value="${listeningScore}" minFractionDigits="1" maxFractionDigits="1"/></span>
                                    </div>
                                </c:if>
                                <c:if test="${not empty overallScore}">
                                    <div class="outcome-progress-item">
                                        <span class="outcome-icon" style="background:#e3eaff; color:#2980ef;">🏆</span>
                                        <span class="outcome-label">Overall</span>
                                        <div class="outcome-bar-bg">
                                            <div class="outcome-bar overall" style="width: ${overallScore * 10}%;"></div>
                                        </div>
                                        <span class="outcome-score"><fmt:formatNumber value="${overallScore}" minFractionDigits="1" maxFractionDigits="1"/></span>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </div>
                <c:if test="${sessionScope.user.role eq 'admin'}">
                    <div style="text-align:center; margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/admin/pending-topup"
                           class="btn btn-warning btn-lg">
                            🔍 Duyệt thanh toán CAM
                        </a>
                    </div>
                </c:if>


                <a href="WalletServlet" class="cam-balance-display" title="Xem ví CAM của bạn">
                    <img src="${pageContext.request.contextPath}/Sources/Others/orange.png" alt="Cam" />
                    <span>${sessionScope.user.camBalance} CAM</span>
                </a>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/sakura.js"></script>
    </body>
</html>
