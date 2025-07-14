<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Duyệt nạp CAM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body {
            background: linear-gradient(to right, #f0f2f5, #ffffff);
            font-family: 'Segoe UI', sans-serif;
        }
        h2 {
            text-align: center;
            font-weight: 600;
            color: #333;
            margin-bottom: 30px;
        }
        .table-hover tbody tr:hover {
            background-color: #f2f9ff;
        }
        .btn-approve {
            background-color: #28a745;
            color: white;
        }
        .btn-reject {
            background-color: #dc3545;
            color: white;
        }
        .badge-money {
            font-size: 0.95rem;
            background-color: #ffc107;
            color: #000;
        }
    </style>
    <script>
        function confirmReject() {
            return confirm("Bạn chắc chắn muốn từ chối yêu cầu này?");
        }
    </script>
</head>
<body>
<div class="container mt-5 mb-5">
    <h2>📋 Yêu cầu nạp CAM đang chờ duyệt</h2>

    <c:if test="${not empty message}">
        <div class="alert alert-success text-center fw-semibold">${message}</div>
    </c:if>

    <div class="table-responsive shadow rounded">
        <table class="table table-hover align-middle table-bordered">
            <thead class="table-primary text-center">
            <tr>
                <th>ID</th>
                <th>User ID</th>
                <th>Số tiền</th>
                <th>Thời gian yêu cầu</th>
                <th>Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${pendingList}">
                <tr class="text-center">
                    <td><span class="fw-bold text-primary">#${p.id}</span></td>
                    <td><span class="text-dark">${p.userId}</span></td>
                    <td><span class="badge badge-money px-3 py-2">${p.amount} đ</span></td>
                    <td><span class="text-muted">${p.createdAt}</span></td>
                    <td>
                        <form action="${pageContext.request.contextPath}/ApproveTopUpServlet" method="post" class="d-inline">
                            <input type="hidden" name="requestId" value="${p.id}">
                            <input type="hidden" name="userId" value="${p.userId}">
                            <input type="hidden" name="amount" value="${p.amount}">
                            <input type="hidden" name="action" value="approve">
                            <button class="btn btn-approve btn-sm rounded-pill px-3" title="Duyệt nạp">
                                ✅ Duyệt
                            </button>
                        </form>

                        <form action="${pageContext.request.contextPath}/ApproveTopUpServlet" method="post" class="d-inline ms-2" onsubmit="return confirmReject();">
                            <input type="hidden" name="requestId" value="${p.id}">
                            <input type="hidden" name="userId" value="${p.userId}">
                            <input type="hidden" name="amount" value="${p.amount}">
                            <input type="hidden" name="action" value="reject">
                            <button class="btn btn-reject btn-sm rounded-pill px-3" title="Từ chối nạp">
                                ❌ Không duyệt
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
