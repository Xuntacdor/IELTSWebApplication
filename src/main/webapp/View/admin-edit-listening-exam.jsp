<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Listening Exam - Admin</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="../css/AddTest.css">
        <style>
            body {
                background: linear-gradient(120deg, #e0eafc 0%, #cfdef3 100%);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                min-height: 100vh;
            }
            .admin-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 28px 0 18px 0;
                margin-bottom: 30px;
                box-shadow: 0 4px 24px rgba(102,126,234,0.10);
            }
            .back-btn {
                background: #fff;
                color: #764ba2;
                padding: 10px 24px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                margin-bottom: 18px;
                margin-right: 12px;
                border: 1.5px solid #764ba2;
                transition: background 0.2s, color 0.2s;
                display: inline-block;
            }
            .back-btn:hover {
                background: #764ba2;
                color: #fff;
                text-decoration: none;
            }
            .edit-form-container {
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 24px rgba(102,126,234,0.10);
                padding: 32px 24px 24px 24px;
                margin-bottom: 30px;
            }
            .section-btns button {
                margin-right: 10px;
                min-width: 100px;
            }
            .section-btns .active {
                background-color: #198754;
                color: white;
            }
            .question-group {
                border: 2px solid #e9ecef;
                border-radius: 8px;
                margin-bottom: 20px;
                padding: 15px;
                background: #f8f9fa;
            }
            .question-block {
                background-color: white;
                border-radius: 6px;
                padding: 10px;
                margin: 10px 0;
            }
            .option-row {
                background-color: #f8f9fa;
                border-radius: 4px;
                padding: 8px;
                margin: 5px 0;
            }
            .form-label {
                font-weight: 600;
                color: #764ba2;
            }
            .btn-primary, .btn-success, .btn-secondary {
                font-weight: 600;
                border-radius: 8px;
            }
            .btn-primary:hover, .btn-success:hover {
                box-shadow: 0 2px 12px #764ba2aa;
            }
            @media (max-width: 900px) {
                .container-flex {
                    flex-direction: column !important;
                }
                .left-panel, .right-panel {
                    width: 100% !important;
                }
            }
        </style>
    </head>
    <body>
        <div class="admin-header">
            <div class="container d-flex align-items-center justify-content-between">
                <a href="../admin.jsp" class="back-btn">← Back to Admin Panel</a>
                <h1 class="mb-0">Edit Listening Exam</h1>
            </div>
        </div>
        <div class="container">
            <%
                Exam exam = (Exam) request.getAttribute("exam");
                List<Passage> passages = (List<Passage>) request.getAttribute("passages");
                Map<Integer, List<Question>> passageQuestions = (Map<Integer, List<Question>>) request.getAttribute("passageQuestions");
                Map<Integer, List<Option>> questionOptions = (Map<Integer, List<Option>>) request.getAttribute("questionOptions");
                Map<Integer, List<Answer>> questionAnswers = (Map<Integer, List<Answer>>) request.getAttribute("questionAnswers");
                if (exam != null) {
            %>
            <form action="${pageContext.request.contextPath}/admin/exam-management" method="post" enctype="multipart/form-data" class="edit-form-container">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="examId" value="<%= exam.getExamId()%>">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <label for="examTitle" class="form-label">Exam Title:</label>
                        <input type="text" name="title" id="examTitle" class="form-control mb-3" value="<%= exam.getTitle()%>" required>
                        <label for="examType" class="form-label">Test Type:</label>
                        <select name="type" id="examType" class="form-select mb-3" required>
                            <option value="LISTENING_FULL" <%= "LISTENING_FULL".equals(exam.getType()) ? "selected" : ""%>>Listening Full Test (4 Sections)</option>
                            <option value="LISTENING_SINGLE" <%= "LISTENING_SINGLE".equals(exam.getType()) ? "selected" : ""%>>Listening Single Section</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Audio File:</label>
                        <select name="examAudioPath" id="examAudioPath" class="form-select mb-3" required>
                            <option value="">-- Select Audio --</option>
                            <%
                                String audioDir = application.getRealPath("/Audio");
                                java.io.File dir = new java.io.File(audioDir);
                                String[] audioFiles = dir.list(( d,     name) -> name.toLowerCase().endsWith(".mp3")
                                        || name.toLowerCase().endsWith(".wav")
                                        || name.toLowerCase().endsWith(".ogg")
                                        || name.toLowerCase().endsWith(".webm")
                                        || name.toLowerCase().endsWith(".m4a"));
                                if (audioFiles != null) {
                                    for (String f : audioFiles) {
                                        String selected = "";
                                        for (Passage passage : passages) {
                                            if (passage.getAudioUrl() != null && passage.getAudioUrl().contains(f)) {
                                                selected = "selected";
                                                break;
                                            }
                                        }
                            %>
                            <option value="Audio/<%=f%>" <%= selected%>><%=f%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                        <div class="card">
                            <div class="card-header bg-light text-primary">
                                <h5 class="mb-0">Exam Info</h5>
                            </div>
                            <div class="card-body">
                                <p><strong>ID:</strong> <%= exam.getExamId()%></p>
                                <p><strong>Created:</strong> <%= exam.getCreatedAt() != null ? exam.getCreatedAt().toString() : "N/A"%></p>
                                <p><strong>Sections:</strong> <%= passages.size()%></p>
                            </div>
                        </div>
                    </div>
                </div>
                <% if ("LISTENING_FULL".equals(exam.getType()) && passages.size() > 1) { %>
                <div id="sectionSelector" class="section-btns mb-3">
                    <label class="mb-2">Select Section:</label><br/>
                    <% for (Passage passage : passages) {%>
                    <button type="button" class="btn btn-outline-secondary" onclick="switchSection(<%= passage.getSection()%>)">
                        Section <%= passage.getSection()%>
                    </button>
                    <% } %>
                </div>
                <% } %>
                <% for (Passage passage : passages) {%>
                <div class="section-container" id="section-<%= passage.getSection()%>" style="<%= passage.getSection() == 1 ? "" : "display: none;"%>">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h4>Section <%= passage.getSection()%> - Audio Info</h4>
                                    </div>
                                    <div class="card-body">
                                        <input type="hidden" name="passageId_<%= passage.getSection()%>" value="<%= passage.getPassageId()%>">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label class="form-label">Section Number:</label>
                                                <select name="section_<%= passage.getSection()%>" class="form-select mb-2" required>
                                                    <option value="1" <%= passage.getSection() == 1 ? "selected" : ""%>>Section 1</option>
                                                    <option value="2" <%= passage.getSection() == 2 ? "selected" : ""%>>Section 2</option>
                                                    <option value="3" <%= passage.getSection() == 3 ? "selected" : ""%>>Section 3</option>
                                                    <option value="4" <%= passage.getSection() == 4 ? "selected" : ""%>>Section 4</option>
                                                </select>
                                            </div>
                                            <div class="col-md-8">
                                                <label class="form-label">Section Title:</label>
                                                <input type="text" name="sectionTitle_<%= passage.getSection()%>" value="<%= passage.getTitle() != null ? passage.getTitle() : ""%>" class="form-control mb-2" required>
                                            </div>
                                        </div>
                                        <div class="mt-3">
                                            <h5 class="form-label">Section <%= passage.getSection()%> - Question Groups</h5>
                                            <div id="questionGroupContainer_<%= passage.getSection()%>">
                                                <%
                                                    List<Question> questions = passageQuestions.get(passage.getPassageId());
                                                    if (questions != null && !questions.isEmpty()) {
                                                        Map<String, List<Question>> questionGroups = new HashMap<>();
                                                        for (Question q : questions) {
                                                            questionGroups.computeIfAbsent(q.getQuestionType(), k -> new ArrayList<>()).add(q);
                                                        }
                                                        for (Map.Entry<String, List<Question>> entry : questionGroups.entrySet()) {
                                                            String questionType = entry.getKey();
                                                            List<Question> groupQuestions = entry.getValue();
                                                %>
                                                <div class="question-group">
                                                    <h5><%= questionType.replace("_", " ")%></h5>
                                                    <% for (Question question : groupQuestions) {%>
                                                    <div class="question-block">
                                                        <input type="hidden" name="questionId_<%= question.getQuestionId()%>" value="<%= question.getQuestionId()%>">
                                                        <label class="form-label">Question Text:</label>
                                                        <input type="text" name="questionText_<%= question.getQuestionId()%>" value="<%= question.getQuestionText() != null ? question.getQuestionText() : ""%>" class="form-control mb-2">
                                                        <label class="form-label">Instruction:</label>
                                                        <input type="text" name="instruction_<%= question.getQuestionId()%>" value="<%= question.getInstruction() != null ? question.getInstruction() : ""%>" class="form-control mb-2">
                                                        <%
                                                            List<Option> options = questionOptions.get(question.getQuestionId());
                                                            List<Answer> answers = questionAnswers.get(question.getQuestionId());
                                                            if (options != null && !options.isEmpty()) {
                                                        %>
                                                        <label class="form-label">Options:</label>
                                                        <% for (Option option : options) {%>
                                                        <div class="option-row">
                                                            <input type="text" name="optionText_<%= option.getOptionId()%>" value="<%= option.getOptionText() != null ? option.getOptionText() : ""%>" class="form-control">
                                                            <input type="hidden" name="optionId_<%= option.getOptionId()%>" value="<%= option.getOptionId()%>">
                                                        </div>
                                                        <% } %>
                                                        <% } %>
                                                        <% if (answers != null && !answers.isEmpty()) { %>
                                                        <label class="form-label">Correct Answers:</label>
                                                        <% for (Answer answer : answers) {%>
                                                        <div class="option-row">
                                                            <input type="text" name="answerText_<%= answer.getAnswerId()%>" value="<%= answer.getAnswerText() != null ? answer.getAnswerText() : ""%>" class="form-control">
                                                            <input type="hidden" name="answerId_<%= answer.getAnswerId()%>" value="<%= answer.getAnswerId()%>">
                                                            <input type="checkbox" name="isCorrect_<%= answer.getAnswerId()%>" <%= answer.isCorrect() ? "checked" : ""%>> Correct
                                                        </div>
                                                        <% } %>
                                                        <% } %>
                                                    </div>
                                                    <% } %>
                                                </div>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </div>
                                            <button type="button" class="btn btn-primary mt-3" onclick="addQuestionGroup(<%= passage.getSection()%>)">
                                                Add Question Group
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
                <div class="text-center mt-4 mb-4">
                    <button type="submit" class="btn btn-success btn-lg">Save Changes</button>
                    <a href="../admin.jsp" class="btn btn-secondary btn-lg ml-2">Back to Admin Panel</a>
                </div>
            </form>
            <% } else { %>
            <div class="alert alert-danger">
                ⚠️ Không tìm thấy đề thi để sửa.
            </div>
            <% }%>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                function switchSection(sectionNum) {
                                                    document.querySelectorAll('.section-container').forEach(container => {
                                                        container.style.display = 'none';
                                                    });
                                                    document.getElementById('section-' + sectionNum).style.display = 'block';
                                                    document.querySelectorAll('.section-btns button').forEach(btn => {
                                                        btn.classList.remove('active');
                                                    });
                                                    event.target.classList.add('active');
                                                }
                                                function addQuestionGroup(sectionNum) {
                                                    const container = document.getElementById('questionGroupContainer_' + sectionNum);
                                                    const groupDiv = document.createElement('div');
                                                    groupDiv.className = 'question-group';
                                                    groupDiv.innerHTML = `
                    <h5>New Question Group</h5>
                    <div class="question-block">
                        <label>Question Text:</label>
                        <input type="text" name="newQuestionText" class="form-control mb-2">
                        <label>Instruction:</label>
                        <input type="text" name="newInstruction" class="form-control mb-2">
                    </div>
                `;
                                                    container.appendChild(groupDiv);
                                                }
        </script>
    </body>
</html> 