package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminRedirectServlet", urlPatterns = {"/admin-redirect"})
public class AdminRedirectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể redirect về admin.jsp nếu ai đó truy cập GET
        response.sendRedirect("View/AddSources/admin.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            // Nếu không có action -> quay về admin
            response.sendRedirect("View/AddSources/admin.jsp");
            return;
        }

        switch (action) {
            case "addReading":
                response.sendRedirect("View/AddSources/addReadingTest.jsp");
                break;
            case "addListening":
                response.sendRedirect("View/AddSources/addListeningTest.jsp");
                break;
            default:
                response.sendRedirect("View/AddSources/admin.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin redirect controller for managing JSP routing";
    }
}
