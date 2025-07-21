<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head><title>Set Study Goal</title></head>
<body>
    <h2>Set Your Study Goal</h2>

    <c:if test="${not empty score}">
        <p>Your latest placement test score: <strong>${score}</strong></p>
    </c:if>
    <c:if test="${not empty band}">
        <p>Your estimated current band: <strong>${band}</strong></p>
    </c:if>

    <c:if test="${empty targetBand}">
        <c:set var="targetBand" value="${band}" />
    </c:if>

    <c:if test="${not empty minDays}">
        <p>🧠 GPT suggests at least <strong>${minDays}</strong> days of study.</p>
    </c:if>

    <form method="get" action="assign-plan">
        <label>Target Band:</label>
        <select name="target_band" onchange="this.form.submit()">
            <c:forEach var="b" items="${bandOptions}">
                <c:if test="${empty band || (Double.parseDouble(b) > Double.parseDouble(band))}">
                    <option value="${b}" <c:if test="${b == targetBand}">selected</c:if>>${b}</option>
                </c:if>
            </c:forEach>
        </select>
    </form>

    <br/>
    <form action="assign-plan" method="post">
        <input type="hidden" name="target_band" value="${targetBand}">
        <label>Study Duration (in days):</label>
        <input type="number" name="duration_days" min="${minDays}" value="${minDays}" required><br><br>
        <input type="submit" value="Generate Study Plan">
    </form>
</body>
</html>
