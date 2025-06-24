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
        <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet" />
    </head>

    <script src="${pageContext.request.contextPath}/js/sakura.js"></script>


    <body>
        <div class="container-fluid home_container">
            <div class="web_page row">

                <%-- Sidebar (nav-bar) đã được tách --%>
                <jsp:include page="/includes/navbar.jsp" />

                <%-- Main Content --%>
                <div class="col-md-5">
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
                                    <c:forEach var="item" items="${historyList}">
                                        <tr>
                                            <td>${item.completedAt}</td>
                                            <td>${item.title}</td>
                                            <td data-score="${item.score}"></td>
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
                                    <div class="goal-card">Reading<br><span>${goal.reading}</span></div>
                                    <div class="goal-card">Listening<br><span>${goal.listening}</span></div>
                                    <div class="goal-card overall">Overall<br><span>${goal.overall}</span></div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="outcome-summary mt-4">
                        <h4>Your Performance Outcome 📊</h4>
                        <c:if test="${not empty outcome}">
                            <div style="font-size: 14px; color: gray;">
                                Entries in outcome: ${fn:length(outcome)}
                            </div>
                            <div class="goal-cards">
                                <c:forEach var="entry" items="${outcome}">
                                    <div class="goal-card">
                                        ${entry.key}<br>
                                        <span><fmt:formatNumber value="${entry.value}" minFractionDigits="1" maxFractionDigits="1"/></span>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
