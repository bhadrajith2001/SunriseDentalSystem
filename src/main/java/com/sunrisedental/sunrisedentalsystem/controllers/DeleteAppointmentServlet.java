package com.sunrisedental.sunrisedentalsystem.controllers;

import com.sunrisedental.sunrisedentalsystem.dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteAppointmentServlet")
public class DeleteAppointmentServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                AppointmentDAO dao = new AppointmentDAO();
                boolean success = dao.deleteAppointment(id);

                if (success) {
                    response.sendRedirect("patients_hub.jsp?status=deleted");
                } else {
                    response.sendRedirect("patients_hub.jsp?status=failed");
                }
            } else {
                response.sendRedirect("patients_hub.jsp?status=invalid");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("patients_hub.jsp?status=invalid");
        }
    }
}