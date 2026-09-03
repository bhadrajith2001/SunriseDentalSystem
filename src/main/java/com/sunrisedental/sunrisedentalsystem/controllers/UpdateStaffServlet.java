package com.sunrisedental.sunrisedentalsystem.controllers;

import com.sunrisedental.sunrisedentalsystem.dao.UserDAO;
import com.sunrisedental.sunrisedentalsystem.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateStaffServlet")
public class UpdateStaffServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String idParam = request.getParameter("userId");
            String username = request.getParameter("username");
            String role = request.getParameter("role");

            if (idParam != null && username != null && role != null) {
                int userId = Integer.parseInt(idParam);
                UserDAO dao = new UserDAO();
                User user = new User();
                user.setUserId(userId);
                user.setUsername(username.trim());
                user.setRole(role);

                boolean success = dao.updateUser(user);
                if (success) {
                    response.sendRedirect("manage_staff.jsp?status=updated");
                } else {
                    response.sendRedirect("manage_staff.jsp?status=update_failed");
                }
            } else {
                response.sendRedirect("manage_staff.jsp?status=invalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_staff.jsp?status=update_failed");
        }
    }
}