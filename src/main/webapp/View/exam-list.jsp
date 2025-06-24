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
        <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet"/>
        <script src="${pageContext.request.contextPath}/js/sakura.js"></script>
        <style>
            body {
                font-family: 'ADLaM Display', cursive;
                background-color: var(--pale-pink);
            }

            .exam-card {
                width: 100%;
                display: flex;
                flex-direction: column;
                border-radius: 16px;
                background: white;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                overflow: hidden;
                transition: 0.3s ease;
            }

            .exam-card:hover {
                transform: translateY(-5px);
            }

            .exam-img {
                width: 100%;
                height: 140px;
                object-fit: cover;
            }

            .exam-body {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                padding: 12px 14px;
                flex: 1;
            }

            .exam-title {
                font-size: 14px;
                font-weight: bold;
                color: var(--primary-text);
                line-height: 1.3em;
                margin-bottom: 5px;
                height: 2.6em;
                overflow: hidden;
            }

            .exam-type {
                font-size: 13px;
                color: var(--highlight-text);
                margin-bottom: 8px;
                line-height: 1.4;
            }

            .badge-pass {
                background-color: var(--deep-purple);
                color: white;
                font-size: 11px;
                padding: 3px 10px;
                border-radius: 12px;
                display: inline-block;
                margin-bottom: 6px;
            }

            .btn-start {
                background: linear-gradient(90deg, var(--deep-purple), var(--soft-purple));
                color: white;
                font-size: 13px;
                font-weight: bold;
                border-radius: 20px;
                padding: 5px 16px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                margin-top: auto;
                transition: 0.3s;
            }

            .btn-start:hover {
                background: linear-gradient(90deg, var(--soft-purple), var(--deep-purple));
            }

            .testbox {
                padding-top: 30px;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid home_container">
            <div class="web_page row">
                <jsp:include page="/includes/navbar.jsp" />

                <div class="col-md-9">
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
                            <div class="col-lg-3 col-md-4 col-sm-6 mb-4 d-flex testbox">
                                <div class="exam-card w-100">
                                    <img class="exam-img" src="<%= request.getContextPath()%>/uploads/default-cover.jpg" alt="exam-cover">
                                    <div class="exam-body">
                                        <div>
                                            <span class="badge-pass">
                                                <%
                                                    if ("READING_FULL".equals(category)) {
                                                        out.print("Reading Full Test");
                                                    } else if ("LISTENING_FULL".equals(category)) {
                                                        out.print("Listening Full Test");
                                                    } else {
                                                        out.print("Passage " + passageIndex);
                                                    }
                                                %>
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
                                        <a class="btn-start" href="doTest?examId=<%= exam.getExamId()%>">Start</a>
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
