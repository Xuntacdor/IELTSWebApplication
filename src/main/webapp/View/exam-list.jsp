<%@ page import="java.util.List" %>
<%@ page import="model.Exam" %>
<%@ page import="dao.ExamDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String category = request.getParameter("category");
    if (category == null || category.isEmpty()) {
        category = "READING_FULL";
    }

    int currentPage = 1;
    int pageSize = 8;
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) {
                currentPage = 1;
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    int offset = (currentPage - 1) * pageSize;

    String titleText;
    switch (category) {
        case "READING_FULL":
            titleText = "Reading (Full Test)";
            break;
        case "READING_SINGLE":
            titleText = "Reading (Single Passage)";
            break;
        case "LISTENING_FULL":
            titleText = "Listening";
            break;
        case "LISTENING_SINGLE":
            titleText = "Listening (Single Section)";
            break;
        default:
            titleText = "IELTS Practice Test";
            break;
    }

    ExamDAO dao = new ExamDAO();
    int totalExams = dao.countExamsByCategory(category);
    int totalPages = (int) Math.ceil((double) totalExams / pageSize);
    if (currentPage > totalPages && totalPages > 0) {
        currentPage = totalPages;
    }
    List<Exam> exams = dao.getExamsByCategoryWithPaging(category, pageSize, offset);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>IELTS Test List - <%= titleText%></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Home.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TestList.css"/>
    <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet"/>
    <script src="${pageContext.request.contextPath}/js/sakura.js"></script>
</head>
<body>
    <div class="background-noise-layer"></div>

    <div class="container-fluid home_container">
        <jsp:include page="/includes/navbar.jsp" />

        <div class="col-md-9 exam-part">
            <div class="main-content p-4">
                <h3 class="mb-4 d-flex align-items-center" style="text-align:center; margin:0px;">
                    <img src="https://cdn-icons-png.flaticon.com/512/135/135620.png" width="30" class="me-2"/>
                    IELTS Test List - <%= titleText%>
                </h3>

                <div class="exam-list-grid">
                    <%
                        int passageIndex = 1;
                        for (Exam exam : exams) {
                    %>
                    <div class="exam-card">
                        <!-- Bình thường -->
                        <div class="card-normal d-flex flex-column h-100">
                            <img class="exam-img" src="${pageContext.request.contextPath}/Sources/Others/test_back.png" alt="exam-cover">
                            <div class="exam-body d-flex flex-column justify-content-between">
                                <div>
                                    <span class="badge-pass">
                                        <% if ("READING_FULL".equals(category)) {
                                            out.print("Reading Full Test");
                                        } else if ("LISTENING_FULL".equals(category)) {
                                            out.print("Listening Full Test");
                                        } else {
                                            out.print("Passage " + passageIndex);
                                        } %>
                                    </span>
                                    <div class="exam-title"><%= exam.getTitle() %></div>
                                    <% if (!"READING_FULL".equals(category) && !"LISTENING_FULL".equals(category)) { %>
                                    <div class="exam-type">
                                        <% for (String type : exam.getQuestionTypes()) { %>
                                        • <%= type %><br/>
                                        <% } %>
                                    </div>
                                    <% } %>
                                </div>
                                <form action="${pageContext.request.contextPath}/doTest" method="post">
                                    <input type="hidden" name="examId" value="<%= exam.getExamId() %>"/>
                                    <button type="submit" class="btn-start">Start</button>
                                </form>
                            </div>
                        </div>
                        <!-- Hover -->
                        <div class="card-hover d-flex flex-column h-100 justify-content-between align-items-center">
                            <div class="exam-body d-flex flex-column justify-content-between w-100">
                                <div>
                                    <div class="exam-title"><%= exam.getTitle() %></div>
                                    <% if (!"READING_FULL".equals(category) && !"LISTENING_FULL".equals(category)) { %>
                                    <div class="exam-type">
                                        <% for (String type : exam.getQuestionTypes()) { %>
                                        • <%= type %><br/>
                                        <% } %>
                                    </div>
                                    <% } %>
                                </div>
                                <form action="${pageContext.request.contextPath}/doTest" method="post" class="w-100">
                                    <input type="hidden" name="examId" value="<%= exam.getExamId() %>"/>
                                    <button type="submit" class="btn-hover-start">Làm bài</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <%
                        passageIndex++;
                        }
                    %>
                </div>

                <!-- Pagination -->
                <div style="text-align:center; margin:0px;">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                                <a class="page-link" href="${pageContext.request.contextPath}/View/exam-list.jsp?category=<%= category %>&page=<%= currentPage - 1 %>">&lt; Previous Page</a>
                            </li>
                            <%
                                int maxShow = 5;
                                int start = Math.max(1, currentPage - 2);
                                int end = Math.min(totalPages, start + maxShow - 1);
                                if (end - start < maxShow - 1) {
                                    start = Math.max(1, end - maxShow + 1);
                                }
                                if (start > 1) {
                            %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            <% } 
                                for (int i = start; i <= end; i++) {
                            %>
                            <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                                <a class="page-link" href="${pageContext.request.contextPath}/View/exam-list.jsp?category=<%= category %>&page=<%= i %>"><%= i %></a>
                            </li>
                            <% } 
                                if (end < totalPages) {
                            %>
                            <li class="page-item disabled"><span class="page-link">...</span></li>
                            <% } %>
                            <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                                <a class="page-link" href="${pageContext.request.contextPath}/View/exam-list.jsp?category=<%= category %>&page=<%= currentPage + 1 %>">Next Page &gt;</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
