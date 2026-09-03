package com.sunrisedental.sunrisedentalsystem.controllers;

import com.sunrisedental.sunrisedentalsystem.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteStaffServlet")
public class DeleteStaffServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int userId = Integer.parseInt(idParam);
                UserDAO dao = new UserDAO();
                boolean success = dao.deleteUser(userId);

                if (success) {
                    response.sendRedirect("manage_staff.jsp?status=deleted");
                } else {
                    response.sendRedirect("manage_staff.jsp?status=failed");
                }
            } else {
                response.sendRedirect("manage_staff.jsp?status=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_staff.jsp?status=failed");
        }
    }
}