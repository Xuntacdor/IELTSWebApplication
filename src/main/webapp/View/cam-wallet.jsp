<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="user" value="${sessionScope.user}" />

<!DOCTYPE html>
<html>
    <head>
        <title>Cam Wallet</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cam-wallet.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Home.css" />
        <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet"/>
    </head>
    <body>

        <div class="wallet-wrapper">
            <jsp:include page="/includes/navbar.jsp" />

            <div style="flex: 1; padding: 40px;">
                <div class="wallet-box">
                    <div style="text-align: right; margin-bottom: 20px;">
                        <a href="${pageContext.request.contextPath}/TopUpServlet" class="btn-topup-cam">
                            💰 Top Up CAM
                        </a>
                    </div>
                    <div class="cam-balance">
                        Your balance: <span style="color:#E182EA;"><c:out value="${user.camBalance}" /></span> CAM
                    </div>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success text-center">
                            <strong>${successMessage}</strong>
                        </div>
                    </c:if>

                    <h5 style="margin-top: 20px; color: #7F55B1;">Transaction History:</h5>

                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Type</th>
                                    <th>Amount</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty transactions}">
                                        <c:forEach var="tran" items="${transactions}">
                                            <tr>
                                                <td>${tran.createdAt}</td>
                                                <td>${tran.type}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${tran.type == 'REJECTED'}">
                                                            <span style="color:gray; font-weight:bold;">
                                                                <c:out value="${tran.amount}" />
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${tran.amount > 0}">
                                                            <span class="positive">+<c:out value="${tran.amount}" /></span>
                                                        </c:when>
                                                        <c:when test="${tran.amount < 0}">
                                                            <span class="negative"><c:out value="${tran.amount}" /></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span><c:out value="${tran.amount}" /></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${tran.description}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4">No transactions found.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
