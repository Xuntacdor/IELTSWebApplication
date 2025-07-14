    /*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
     */
    package controller;

    import dao.CamTransactionDAO;
    import dao.PremiumPlanDAO;
    import dao.UserDAO;
    import java.io.IOException;
    import java.io.PrintWriter;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import jakarta.servlet.http.HttpSession;
    import java.time.LocalDateTime;
    import java.time.format.DateTimeFormatter;
    import java.util.List;
    import model.PremiumPlan;
    import model.User;

    /**
     *
     * @author NTKC
     */
    @WebServlet(name = "BuyPremiumServlet", urlPatterns = {"/BuyPremiumServlet"})
    public class BuyPremiumServlet extends HttpServlet {

        protected void processRequest(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {

                out.println("<!DOCTYPE html>");
                out.println("<html>");
                out.println("<head>");
                out.println("<title>Servlet BuyPremiumServlet</title>");
                out.println("</head>");
                out.println("<body>");
                out.println("<h1>Servlet BuyPremiumServlet at " + request.getContextPath() + "</h1>");
                out.println("</body>");
                out.println("</html>");
            }
        }

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            List<PremiumPlan> plans = PremiumPlanDAO.getAllPlans();
            request.setAttribute("plans", plans);
            request.getRequestDispatcher("buy-premium.jsp").forward(request, response);
        }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
            int planId = Integer.parseInt(request.getParameter("planId"));
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            PremiumPlan plan = PremiumPlanDAO.getPlanById(planId);
            if (plan == null || user == null) {
                response.sendRedirect("error.jsp"); // Hoặc thông báo lỗi cụ thể
                return;
            }
            if (user.getCamBalance() >= plan.getCamCost()) {
                // Trừ CAM
                int newBalance = user.getCamBalance() - plan.getCamCost();
                UserDAO.updateCamBalance(user.getUserId(), newBalance);

                CamTransactionDAO.insertTransaction(
                        user.getUserId(),
                        -plan.getCamCost(),
                        "BUY_PREMIUM",
                        "Mua gói " + plan.getName()
                );

                // Cập nhật trạng thái Premium
                LocalDateTime expired = LocalDateTime.now().plusDays(plan.getDurationInDays());
                String expiredStr = expired.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                UserDAO.updatePremiumStatus(user.getUserId(), true, expiredStr);

                // Cập nhật session
                user.setCamBalance(newBalance);
                user.setIsPremium(true);
                user.setPremiumExpiredAt(expiredStr);
                session.setAttribute("user", user);

                List<model.CamTransaction> transactions = CamTransactionDAO.getByUserId(user.getUserId());
                request.setAttribute("transactions", transactions);
                request.getRequestDispatcher("/View/cam-wallet.jsp").forward(request, response);
//               response.sendRedirect(request.getContextPath() + "/View/cam-wallet.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/View/not-enough-cam.jsp");
            }
        }

        @Override
        public String getServletInfo() {
            return "Short description";
        }

    }
