package com.sunrisedental.sunrisedentalsystem.dao;

import com.sunrisedental.sunrisedentalsystem.models.User;
import com.sunrisedental.sunrisedentalsystem.utils.DBConnection;
import com.sunrisedental.sunrisedentalsystem.utils.MD5Utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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

    // Method to Add a New Staff/Admin User
    public boolean addUser(User user) {
        boolean isSuccess = false;
        String hashedPassword = MD5Utils.getMd5(user.getPasswordHash()); // Password එක MD5 Hash කිරීම
        String query = "INSERT INTO users (username, password_hash, role) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setString(1, user.getUsername());
            pst.setString(2, hashedPassword);
            pst.setString(3, user.getRole());

            if (pst.executeUpdate() > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Method to Get All Users (Staff List)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String query = "SELECT * FROM users ORDER BY user_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUsername(rs.getString("username"));
                u.setRole(rs.getString("role"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Method to Delete Staff User
    public boolean deleteUser(int userId) {
        boolean isSuccess = false;
        String query = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId);
            if (pst.executeUpdate() > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // Method to Get User By ID (For Editing)
    public User getUserById(int userId) {
        User user = null;
        String query = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId);
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

    // Method to Update Staff User Details
    public boolean updateUser(User user) {
        boolean isSuccess = false;
        String query = "UPDATE users SET username = ?, role = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setString(1, user.getUsername());
            pst.setString(2, user.getRole());
            pst.setInt(3, user.getUserId());

            if (pst.executeUpdate() > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

}