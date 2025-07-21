package util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {
    public static void sendEmail(String toEmail, String subject, String body) {
        final String fromEmail = ""; // Gmail của bạn
        final String password = "";    

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); // SMTP host
        props.put("mail.smtp.port", "587");            // TLS Port
        props.put("mail.smtp.auth", "true");           // Enable authentication
        props.put("mail.smtp.starttls.enable", "true");// Enable STARTTLS

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, "IELTSWebApp CAM Support"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setText(body);
            Transport.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
