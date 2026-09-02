package com.sunrisedental.sunrisedentalsystem.dao;

import com.sunrisedental.sunrisedentalsystem.models.User;
import com.sunrisedental.sunrisedentalsystem.utils.DBConnection;
import com.sunrisedental.sunrisedentalsystem.utils.MD5Utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    // Method to authenticate user during Login
    public User authenticateUser(String username, String password) {
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }

        User user = null;
        String hashedPassword = MD5Utils.getMd5(password); // Hash the inputted password

        String query = "SELECT * FROM users WHERE username = ? AND password_hash = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setString(1, username);
            pst.setString(2, hashedPassword);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    user = new User(
                            rs.getInt("user_id"),
                            rs.getString("username"),
                            rs.getString("password_hash"),
                            rs.getString("role")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}