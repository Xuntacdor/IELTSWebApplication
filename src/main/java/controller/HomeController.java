
package controller;

import model.PracticeHistoryItem;
import model.User;
import model.Goal;
import dao.GoalDAO;
import dao.UserProgressDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Map;

@WebServlet(name = "HomeServlet", urlPatterns = {"/HomeServlet"})
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        System.out.println("userId in session: " + user.getUserId());
        if (user == null) {
            response.sendRedirect("View/Login.jsp");
            return;
        }

        int camBalance = dao.UserDAO.getCamBalanceById(user.getUserId());
        user.setCamBalance(camBalance);
        request.getSession().setAttribute("user", user);

        java.util.List<model.PremiumPlan> plans = dao.PremiumPlanDAO.getAllPlans();
        request.getSession().setAttribute("plans", plans);

        int userId = user.getUserId();

        List<LocalDate> completedDates = UserProgressDAO.getSubmittedDatesByUser(userId);
        List<PracticeHistoryItem> historyList = UserProgressDAO.getPracticeHistory(userId);
        Map<String, Float> outcome = UserProgressDAO.getAverageScoreByType(userId);
        request.setAttribute("completedDates", completedDates);
        request.setAttribute("historyList", historyList);
        request.setAttribute("outcome", outcome);
        Goal goal = GoalDAO.getGoalByUserId(userId);
        request.setAttribute("goal", goal);

        request.getRequestDispatcher("View/Home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
