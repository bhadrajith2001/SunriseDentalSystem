package com.sunrisedental.sunrisedentalsystem.controllers;

import com.sunrisedental.sunrisedentalsystem.dao.UserDAO;
import com.sunrisedental.sunrisedentalsystem.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddStaffServlet")
public class AddStaffServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            if (username != null && password != null && role != null && !username.trim().isEmpty() && !password.trim().isEmpty()) {
                UserDAO dao = new UserDAO();
                User user = new User();
                user.setUsername(username.trim());
                user.setPasswordHash(password.trim());
                user.setRole(role);

                boolean success = dao.addUser(user);
                if (success) {
                    response.sendRedirect("manage_staff.jsp?status=added");
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