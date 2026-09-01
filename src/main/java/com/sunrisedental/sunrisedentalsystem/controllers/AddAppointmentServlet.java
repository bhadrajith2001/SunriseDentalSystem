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

        Appointment app = new Appointment();
        app.setPatientName(request.getParameter("patientName"));
        app.setAddress(request.getParameter("address"));
        app.setContactNumber(request.getParameter("contactNumber"));
        app.setDentistName(request.getParameter("dentistName"));
        app.setTreatmentId(Integer.parseInt(request.getParameter("treatmentId")));

        // Parsing Date and Time properly
        app.setAppointmentDate(Date.valueOf(request.getParameter("appointmentDate")));
        // Adding ":00" for seconds as HTML time input only sends HH:MM
        app.setAppointmentTime(Time.valueOf(request.getParameter("appointmentTime") + ":00"));

        AppointmentDAO dao = new AppointmentDAO();
        boolean success = dao.addAppointment(app);

        if (success) {
            response.sendRedirect("dashboard.jsp?status=added");
        } else {
            response.sendRedirect("add_appointment.jsp?status=failed");
        }
    }
}