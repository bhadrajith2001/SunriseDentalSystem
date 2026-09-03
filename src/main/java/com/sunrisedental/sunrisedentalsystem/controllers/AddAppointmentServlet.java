package com.sunrisedental.sunrisedentalsystem.controllers;

import com.sunrisedental.sunrisedentalsystem.dao.AppointmentDAO;
import com.sunrisedental.sunrisedentalsystem.models.Appointment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

@WebServlet("/AddAppointmentServlet")
public class AddAppointmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Ensure proper encoding for special characters
        request.setCharacterEncoding("UTF-8");

        try {
            Appointment app = new Appointment();
            app.setPatientName(request.getParameter("patientName"));
            app.setAddress(request.getParameter("address"));
            app.setContactNumber(request.getParameter("contactNumber"));
            app.setEmail(request.getParameter("email"));
            app.setDentistName(request.getParameter("dentistName"));

            String treatmentId = request.getParameter("treatmentId");
            if (treatmentId != null && !treatmentId.isEmpty()) {
                app.setTreatmentId(Integer.parseInt(treatmentId));
            }

            // Parsing Date safely
            String dateStr = request.getParameter("appointmentDate");
            if (dateStr != null && !dateStr.isEmpty()) {
                app.setAppointmentDate(Date.valueOf(dateStr));
            }

            // Safe Time Parsing (handles missing seconds or empty checks)
            String timeStr = request.getParameter("appointmentTime");
            if (timeStr != null && !timeStr.isEmpty()) {
                if (timeStr.length() == 5) {
                    timeStr += ":00";
                }
                app.setAppointmentTime(Time.valueOf(timeStr));
            }

            AppointmentDAO dao = new AppointmentDAO();
            boolean success = dao.addAppointment(app);

            if (success) {
                final String pEmail = app.getEmail();
                final String pName = app.getPatientName();
                final String pDate = dateStr;
                final String pTime = timeStr;

                new Thread(() -> {
                    com.sunrisedental.sunrisedentalsystem.utils.EmailUtility.sendAppointmentConfirmation(pEmail, pName, pDate, pTime);
                }).start();

                response.sendRedirect("dashboard.jsp?status=added");
            } else {
                response.sendRedirect("add_appointment.jsp?status=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_appointment.jsp?status=failed");
        }
    }
}