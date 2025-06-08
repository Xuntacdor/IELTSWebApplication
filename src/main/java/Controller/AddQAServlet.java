package Controller;

import dao.AnswerDAO;
import dao.QuestionDAO;
import Model.Answer;
import Model.Question;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.Paths;

@WebServlet(name = "AddQAServlet", urlPatterns = {"/AddQA"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024)
public class AddQAServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Lấy dữ liệu từ form
        int passageId = Integer.parseInt(request.getParameter("passageId"));
        String questionType = request.getParameter("questionType");
        String questionText = request.getParameter("questionText");
        String instruction = request.getParameter("instruction");
        int numberInPassage = Integer.parseInt(request.getParameter("numberInPassage"));
        String answerText = request.getParameter("answerText");

        // ✅ Xử lý upload file ảnh
        String imageUrl = "";
        Part filePart = request.getPart("imageFile");

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadDir = getServletContext().getRealPath("/uploads/");
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) {
                uploadFolder.mkdirs();
            }

            String filePath = uploadDir + File.separator + fileName;
            filePart.write(filePath);

            imageUrl = "uploads/" + fileName;
        }

        // ✅ Tạo đối tượng Question
        Question question = new Question();
        question.setPassageId(passageId);
        question.setQuestionType(questionType);
        question.setQuestionText(questionText);
        question.setInstruction(instruction);
        question.setExplanation("");
        question.setNumberInPassage(numberInPassage);
        question.setImageUrl(imageUrl); // ← đường dẫn tương đối

        // ✅ Insert question
        QuestionDAO questionDAO = new QuestionDAO();
        int questionId = questionDAO.insertQuestion(question);

        if (questionId > 0) {
            // ✅ Insert answer
            Answer answer = new Answer();
            answer.setQuestionId(questionId);
            answer.setAnswerText(answerText);

            AnswerDAO answerDAO = new AnswerDAO();
            int result = answerDAO.insertAnswer(answer);

            if (result > 0) {
                response.getWriter().println("✅ Thêm câu hỏi và ảnh thành công!");
            } else {
                response.getWriter().println("❌ Thêm câu trả lời thất bại!");
            }
        } else {
            response.getWriter().println("❌ Thêm câu hỏi thất bại!");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý thêm câu hỏi và upload ảnh";
    }
}
