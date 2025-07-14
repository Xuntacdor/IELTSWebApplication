<%@ page import="java.util.List" %>
<%@ page import="model.PremiumPlan" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Mua Premium</title>
    <style>
        body {
            background-color: #fcecec;
            font-family: 'ADLaM Display', sans-serif;
            padding: 50px;
            color: #4B3B60;
        }
        .plan-box {
            background: white;
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 6px 12px rgba(127, 85, 177, 0.15);
            margin-bottom: 20px;
            transition: 0.3s;
            text-align: center;
        }
        .plan-box:hover {
            transform: scale(1.03);
            border: 2px solid #7F55B1;
        }
        .btn-buy {
            background: linear-gradient(90deg, #7F55B1, #9D80BE);
            border: none;
            color: white;
            padding: 10px 24px;
            border-radius: 30px;
            font-weight: bold;
            box-shadow: 0 4px 10px rgba(127, 85, 177, 0.3);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="text-center mb-5">Chọn gói Premium</h2>
        <div class="row">
            <c:forEach var="plan" items="${plans}">
                <div class="col-md-4">
                    <div class="plan-box">
                        <h4>${plan.name}</h4>
                        <p><strong>${plan.camCost}</strong> CAM</p>
                        <form action="BuyPremiumServlet" method="post">
                            <input type="hidden" name="planId" value="${plan.id}">
                            <button class="btn-buy">Mua ngay</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>
