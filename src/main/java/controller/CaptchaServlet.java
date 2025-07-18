/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.Random;
import javax.imageio.ImageIO;


@WebServlet(name = "CaptchaServlet", urlPatterns = {"/captcha"})
public class CaptchaServlet extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
           
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CaptchaServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CaptchaServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        int width = 150, height = 50;
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = image.createGraphics();
        g2d.setColor(Color.WHITE);
        g2d.fillRect(0, 0, width, height);

        String chars = "ABCDEFGHJKLMNPQRSTUVWXYZ123456789";
        String captchaCode = "";
        Random rand = new Random();

        for (int i = 0; i < 5; i++) {
            char ch = chars.charAt(rand.nextInt(chars.length()));
            captchaCode += ch;
            g2d.setFont(new Font("Arial", Font.BOLD, 30));
            g2d.setColor(Color.BLACK);
            g2d.drawString(String.valueOf(ch), 20 + i * 25, 35);
        }

        req.getSession().setAttribute("captcha_code", captchaCode);
        g2d.dispose();

        res.setContentType("image/png");
        ImageIO.write(image, "png", res.getOutputStream());
    }

    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
