<%@ page import="java.util.List" %>
<%@ page import="model.Exam" %>
<%@ page import="dao.ExamDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String category = request.getParameter("category");
    if (category == null || category.isEmpty()) {
        category = "READING_FULL";
    }

    String titleText;
    switch (category) {
        case "READING_FULL":
            titleText = "Reading (Full Test)";
            break;
        case "READING_SINGLE":
            titleText = "Reading (Single Passage)";
            break;
        case "LISTENING_FULL":
            titleText = "Listening (Full Test)";
            break;
        case "LISTENING_SINGLE":
            titleText = "Listening (Single Section)";
            break;
        default:
            titleText = "IELTS Practice Test";
            break;
    }

    ExamDAO dao = new ExamDAO();
    List<Exam> exams = dao.getExamsByCategory(category);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>IELTS Test List - <%= titleText%></title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Home.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TestList.css"/>
        <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet"/>
        <script src="${pageContext.request.contextPath}/js/sakura.js"></script>
    </head>
    <body>
        <div class="background-noise-layer"></div>

        <div class="container-fluid home_container">
            <div class="web_page row">
                <jsp:include page="/includes/navbar.jsp" />

                <div class="col-md-9 middle">
                    <div class="main-content p-4">
                        <h3 class="mb-4 d-flex align-items-center">
                            <img src="https://cdn-icons-png.flaticon.com/512/135/135620.png" width="30" class="me-2"/>
                            IELTS Test List - <%= titleText%>
                        </h3>

                        <div class="row">
                            <%
                                int passageIndex = 1;
                                for (Exam exam : exams) {
                            %>
                            <div class="col-lg-3 col-md-4 col-sm-6 mb-4 d-flex">
                                <div class="exam-card w-100 d-flex flex-column h-100">
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
                                                    }%>
                                                </span>
                                                <div class="exam-title"><%= exam.getTitle()%></div>
                                                <% if (!"READING_FULL".equals(category) && !"LISTENING_FULL".equals(category)) { %>
                                                <div class="exam-type">
                                                    <% for (String type : exam.getQuestionTypes()) {%>
                                                    • <%= type%><br/>
                                                    <% } %>
                                                </div>
                                                <% }%>
                                            </div>
                                           
                                        </div>
                                    </div>
                                    <!-- Hover -->
                                    <div class="card-hover d-flex flex-column h-100 justify-content-between align-items-center">
                                        <div class="exam-body d-flex flex-column justify-content-between w-100">
                                            <div>
                                                <div class="exam-title"><%= exam.getTitle()%></div>
                                                <% if (!"READING_FULL".equals(category) && !"LISTENING_FULL".equals(category)) { %>
                                                <div class="exam-type">
                                                    <%
                                                        List<String> types = exam.getQuestionTypes();
                                                        int shown = 0;
                                                        for (String type : types) {
                                                            if (shown >= 2)
                                                                break;
                                                    %>
                                                    • <%= type%><br/>
                                                    <%
                                                            shown++;
                                                        }
                                                    %>
                                                </div>
                                                <% }%>
                                            </div>
                                            <form action="doTest" method="post" class="w-100">
                                                <input type="hidden" name="examId" value="<%= exam.getExamId()%>"/>
                                                <button type="submit" class="btn-hover-start">Làm bài</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    passageIndex++;
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
