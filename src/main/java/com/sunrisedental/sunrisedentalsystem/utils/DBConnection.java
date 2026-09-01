package com.sunrisedental.sunrisedentalsystem.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // 1. Private static variable to hold the single connection instance
    private static Connection connection = null;

    // Database connection details
    private static final String URL = "jdbc:mysql://localhost:3306/sunrise_dental_db";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // ඔයාගේ MySQL පාස්වර්ඩ් එකක් තියෙනවා නම් මෙතනට දාන්න

    // 2. Private constructor to prevent object creation from outside
    private DBConnection() {}

    // 3. Public static method to get the instance (Singleton Pattern)
    public static Connection getConnection() {
        try {
            // Check if connection is null or closed before creating a new one
            if (connection == null || connection.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                System.out.println("Database Connected Successfully!");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("Database Connection Failed!");
        }
        return connection;
    }
}