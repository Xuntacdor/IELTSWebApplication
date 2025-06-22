<%-- 
    Document   : result
    Created on : Jun 9, 2025, 8:32:50 AM
    Author     : NTKC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>Kết quả</title></head>
<body>
    <h2>🎯 KẾT QUẢ BÀI LÀM</h2>
    <p>✅ Số câu đúng: <strong><%= request.getAttribute("correct") %></strong></p>
    <p>📋 Tổng số câu: <strong><%= request.getAttribute("total") %></strong></p>
    <p>🏁 Điểm: <strong><%= String.format("%.2f", request.getAttribute("score")) %> %</strong></p>
</body>
</html>

