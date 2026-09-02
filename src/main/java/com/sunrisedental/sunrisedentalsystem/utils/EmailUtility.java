package com.sunrisedental.sunrisedentalsystem.utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtility {
    // ඊමේල් යැවීමේ Method එක
    public static void sendAppointmentConfirmation(String recipientEmail, String patientName, String date, String time) {
        final String senderEmail = "badrajithpramod@gmail.com"; // මෙතැනට ඔයාගේ ටෙස්ටින් Gmail එකක් දෙන්න
        final String senderPassword = "hwkikrkyflerqoqr"; // Gmail එකේ 2-Step Verification ඔන් කරලා ගන්න 'App Password' එක මෙතනට දෙන්න

        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");

        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Appointment Confirmation - Sunrise Dental Clinic");

            // ඊමේල් එකේ අන්තර්ගතය (HTML Design)
            String emailContent = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333;'>"
                    + "<h2 style='color: #00796b;'>Sunrise Dental Clinic</h2>"
                    + "<h3>Dear " + patientName + ",</h3>"
                    + "<p>Your appointment has been successfully registered in our system.</p>"
                    + "<p><b>Date:</b> " + date + "<br>"
                    + "<b>Time:</b> " + time + "</p>"
                    + "<p>Thank you for choosing us for your dental care!</p>"
                    + "</div>";

            message.setContent(emailContent, "text/html");
            Transport.send(message);
            System.out.println("Email sent successfully to " + recipientEmail);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}