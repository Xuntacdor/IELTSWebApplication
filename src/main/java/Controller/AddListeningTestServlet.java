package Controller;

import dao.AnswerDAO;
import dao.ExamDAO;
import dao.PassageDAO;
import dao.QuestionDAO;
import Model.Answer;
import Model.Exam;
import Model.Passage;
import Model.Question;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet(name = "AddListeningTestServlet", urlPatterns = {"/AddListeningTestServlet"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 50 * 1024 * 1024,
    maxRequestSize = 100 * 1024 * 1024
)
public class AddListeningTestServlet extends HttpServlet {

    private final ExamDAO examDAO = new ExamDAO();
    private final PassageDAO passageDAO = new PassageDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final AnswerDAO answerDAO = new AnswerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String examTitle = request.getParameter("examTitle");
        Part audioPart = request.getPart("fullAudio");

        if (examTitle == null || examTitle.trim().isEmpty()) {
            response.sendRedirect("addListeningTest.jsp?error=missingTitle");
            return;
        }

        // ✅ Lưu audio
        String audioUrl = "";
        if (audioPart != null && audioPart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + audioPart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("/uploads/audio");
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();
            audioPart.write(uploadPath + File.separator + fileName);
            audioUrl = "uploads/audio/" + fileName;
        }

        // ✅ Tạo Exam
        Exam exam = new Exam();
        exam.setTitle(examTitle);
        exam.setType("LISTENING");
        exam.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        int examId = examDAO.insertExam(exam);

        // ✅ Duyệt từng Section
        for (int s = 1;; s++) {
            String sectionTitle = request.getParameter("sectionTitle" + s);
            String sectionContent = request.getParameter("sectionContent" + s);
            if (sectionTitle == null && sectionContent == null) break;

            Passage passage = new Passage();
            passage.setTitle(sectionTitle);
            passage.setContent(sectionContent);
            passage.setType("LISTENING");
            passage.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            passage.setExamId(examId);
            passage.setAudioUrl(audioUrl);
            int passageId = passageDAO.insertPassage(passage);

            for (int q = 1;; q++) {
                String prefix = "type_s" + s + "_q" + q;
                String questionType = request.getParameter(prefix);
                if (questionType == null) break;

                String instruction = request.getParameter("instruction_s" + s + "_q" + q);
                Part imagePart = request.getPart("image_s" + s + "_q" + q);

                String imageUrl = "";
                if (imagePart != null && imagePart.getSize() > 0) {
                    String rawName = imagePart.getSubmittedFileName();
                    String fileName = "listen_s" + s + "_q" + q + "_" + System.currentTimeMillis() + "_" + rawName.replaceAll("\\s+", "_");
                    String uploadPath = getServletContext().getRealPath("/uploads");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    imagePart.write(uploadPath + File.separator + fileName);
                    imageUrl = "uploads/" + fileName;
                }

                int questionId = -1;

                for (int i = 0;; i++) {
                    String questionText = request.getParameter("questionText_s" + s + "_q" + q + "_i" + i);
                    String answerText = request.getParameter("answers_s" + s + "_q" + q + "_i" + i);

                    if (questionText == null && answerText == null) break;

                    boolean shouldCreateQuestion = questionId == -1 && (
                            (questionText != null && !questionText.trim().isEmpty()) ||
                            (!imageUrl.isEmpty() && answerText != null && !answerText.trim().isEmpty())
                    );

                    if (shouldCreateQuestion) {
                        Question question = new Question();
                        question.setPassageId(passageId);
                        question.setQuestionType(questionType);
                        question.setInstruction(instruction);
                        question.setQuestionText(questionText != null ? questionText.trim() : "");
                        question.setExplanation("");
                        question.setNumberInPassage(-1);
                        question.setImageUrl(imageUrl);
                        questionId = questionDAO.insertQuestion(question);
                    }

                    if (questionId != -1 && answerText != null && !answerText.trim().isEmpty()) {
                        Answer answer = new Answer();
                        answer.setQuestionId(questionId);
                        answer.setAnswerText(answerText.trim());
                        answerDAO.insertAnswer(answer);
                    }
                }
            }
        }

        response.sendRedirect("addSuccess.jsp");
    }
}
