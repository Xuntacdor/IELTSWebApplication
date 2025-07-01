<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>📝 Do My Test</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dotest.css" />
    <script src="${pageContext.request.contextPath}/js/doTestReading.js"></script>
    <script src="${pageContext.request.contextPath}/js/doTestListening.js"></script>
</head>
<body class="${exam.type == 'LISTENING' ? 'listening-mode' : 'reading-mode'}">
    <jsp:include page="doTestContent.jsp"/>
</body>y<
/html>
