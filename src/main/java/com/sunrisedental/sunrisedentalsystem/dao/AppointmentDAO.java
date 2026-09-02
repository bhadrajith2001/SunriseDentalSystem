package com.sunrisedental.sunrisedentalsystem.dao;

import com.sunrisedental.sunrisedentalsystem.models.Appointment;
import com.sunrisedental.sunrisedentalsystem.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    // 1. Method to Add a New Appointment
    public boolean addAppointment(Appointment app) {
        boolean isSuccess = false;
        // Updated query to include email and shift parameters
        String query = "INSERT INTO appointments (patient_name, email, address, contact_number, dentist_name, treatment_id, appointment_date, appointment_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setString(1, app.getPatientName());
            pst.setString(2, app.getEmail());
            pst.setString(3, app.getAddress());
            pst.setString(4, app.getContactNumber());
            pst.setString(5, app.getDentistName());
            pst.setInt(6, app.getTreatmentId());
            pst.setDate(7, app.getAppointmentDate());
            pst.setTime(8, app.getAppointmentTime());

            int rows = pst.executeUpdate();
            if (rows > 0) isSuccess = true;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    // 2. Method to Get All Appointments (For Dashboard and Billing)
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String query = "SELECT a.*, t.treatment_name FROM appointments a JOIN treatments t ON a.treatment_id = t.treatment_id ORDER BY a.appointment_no DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Appointment app = new Appointment();
                app.setAppointmentNo(rs.getInt("appointment_no"));
                app.setPatientName(rs.getString("patient_name"));
                app.setEmail(rs.getString("email")); // Fetching email from DB
                app.setAddress(rs.getString("address"));
                app.setContactNumber(rs.getString("contact_number"));
                app.setDentistName(rs.getString("dentist_name"));
                app.setTreatmentId(rs.getInt("treatment_id"));
                app.setTreatmentName(rs.getString("treatment_name"));
                app.setAppointmentDate(rs.getDate("appointment_date"));
                app.setAppointmentTime(rs.getTime("appointment_time"));
                app.setTotalCost(rs.getDouble("total_cost"));
                list.add(app);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Method to Get a Single Appointment by ID (For Printing the Bill)
    public Appointment getAppointmentById(int id) {
        Appointment app = null;
        String query = "SELECT a.*, t.treatment_name FROM appointments a JOIN treatments t ON a.treatment_id = t.treatment_id WHERE a.appointment_no = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setInt(1, id);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    app = new Appointment();
                    app.setAppointmentNo(rs.getInt("appointment_no"));
                    app.setPatientName(rs.getString("patient_name"));
                    app.setEmail(rs.getString("email")); // Fetching email from DB
                    app.setAddress(rs.getString("address"));
                    app.setContactNumber(rs.getString("contact_number"));
                    app.setDentistName(rs.getString("dentist_name"));
                    app.setTreatmentName(rs.getString("treatment_name"));
                    app.setAppointmentDate(rs.getDate("appointment_date"));
                    app.setAppointmentTime(rs.getTime("appointment_time"));
                    app.setTotalCost(rs.getDouble("total_cost"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return app;
    }

    // Method to Delete Patient Appointment Record
    public boolean deleteAppointment(int id) {
        boolean success = false;
        String query = "DELETE FROM appointments WHERE appointment_no = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, id);
            if (pst.executeUpdate() > 0) success = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    // Method to Update Existing Appointment
    public boolean updateAppointment(Appointment app) {
        boolean isSuccess = false;
        // Updated query to include email
        String query = "UPDATE appointments SET patient_name = ?, email = ?, address = ?, contact_number = ?, dentist_name = ?, treatment_id = ?, appointment_date = ?, appointment_time = ? WHERE appointment_no = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setString(1, app.getPatientName());
            pst.setString(2, app.getEmail());
            pst.setString(3, app.getAddress());
            pst.setString(4, app.getContactNumber());
            pst.setString(5, app.getDentistName());
            pst.setInt(6, app.getTreatmentId());
            pst.setDate(7, app.getAppointmentDate());
            pst.setTime(8, app.getAppointmentTime());
            pst.setInt(9, app.getAppointmentNo());

            if (pst.executeUpdate() > 0) isSuccess = true;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return isSuccess;
    }
}