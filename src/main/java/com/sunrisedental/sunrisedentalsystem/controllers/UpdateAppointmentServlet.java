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

@WebServlet("/UpdateAppointmentServlet")
public class UpdateAppointmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            Appointment app = new Appointment();

            String idParam = request.getParameter("appointmentNo");
            if (idParam != null && !idParam.isEmpty()) {
                app.setAppointmentNo(Integer.parseInt(idParam));
            }

            app.setPatientName(request.getParameter("patientName"));
            app.setAddress(request.getParameter("address"));
            app.setContactNumber(request.getParameter("contactNumber"));
            app.setDentistName(request.getParameter("dentistName"));

            String treatmentIdParam = request.getParameter("treatmentId");
            if (treatmentIdParam != null && !treatmentIdParam.isEmpty()) {
                app.setTreatmentId(Integer.parseInt(treatmentIdParam));
            }

            String dateStr = request.getParameter("appointmentDate");
            if (dateStr != null && !dateStr.isEmpty()) {
                app.setAppointmentDate(Date.valueOf(dateStr));
            }

            String timeStr = request.getParameter("appointmentTime");
            if (timeStr != null && !timeStr.isEmpty()) {
                if (timeStr.length() == 5) {
                    timeStr += ":00"; // Add seconds if missing
                }
                app.setAppointmentTime(Time.valueOf(timeStr));
            }

            AppointmentDAO dao = new AppointmentDAO();
            boolean success = dao.updateAppointment(app);

            if (success) {
                response.sendRedirect("patients_hub.jsp?status=updated");
            } else {
                response.sendRedirect("patients_hub.jsp?status=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patients_hub.jsp?status=update_failed");
        }
    }
}