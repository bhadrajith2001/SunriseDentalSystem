package com.sunrisedental.sunrisedentalsystem.controllers;

import com.sunrisedental.sunrisedentalsystem.dao.UserDAO;
import com.sunrisedental.sunrisedentalsystem.models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User loggedUser = userDAO.authenticateUser(uname, pass);

        if (loggedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("activeUser", loggedUser);
            response.sendRedirect("dashboard.jsp?login=success");
        } else {
            // Send back to login with error
            response.sendRedirect("index.jsp?error=invalid");
        }
    }
}