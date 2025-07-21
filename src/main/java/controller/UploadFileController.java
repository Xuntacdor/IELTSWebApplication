package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;

@WebServlet("/uploads/*")
public class UploadFileController extends HttpServlet {
    private static final String IMAGE_DIR = "C:/IELTS_Uploads/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // ví dụ: /matching.jpg
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Bỏ dấu "/" đầu tiên
        String fileName = pathInfo.substring(1); // matching.jpg
        File imageFile = new File(IMAGE_DIR + fileName);

        if (!imageFile.exists() || imageFile.isDirectory()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(imageFile.getName());
        response.setContentType(contentType != null ? contentType : "application/octet-stream");

        try (FileInputStream in = new FileInputStream(imageFile);
             OutputStream out = response.getOutputStream()) {
            in.transferTo(out);
        }
    }
}
