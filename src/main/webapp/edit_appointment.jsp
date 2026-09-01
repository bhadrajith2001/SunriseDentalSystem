<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
<%@ page import="com.sunrisedental.sunrisedentalsystem.dao.AppointmentDAO" %>
<%@ page import="com.sunrisedental.sunrisedentalsystem.models.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    if (session.getAttribute("activeUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    Appointment app = null;
    if (idParam != null) {
        AppointmentDAO dao = new AppointmentDAO();
        app = dao.getAppointmentById(Integer.parseInt(idParam));
    }
    if (app == null) {
        response.sendRedirect("patients_hub.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Appointment - Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f4f7f6; color: #333; display: flex; flex-direction: column; min-height: 100vh; }
        .navbar { background-color: #00796b; color: white; padding: 15px 5%; display: flex; justify-content: space-between; align-items: center; }
        .back-btn { background: white; color: #00796b; text-decoration: none; padding: 6px 15px; border-radius: 6px; font-weight: 600; font-size: 0.9rem; }
        .main-container { flex: 1; padding: 40px 20px; display: flex; justify-content: center; align-items: center; }
        .form-wrapper { background: white; padding: 30px 40px; border-radius: 12px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); width: 100%; max-width: 700px; border-top: 5px solid #fb8c00; }
        .form-wrapper h3 { color: #e65100; margin-bottom: 25px; text-align: center; }
        .form-row { display: flex; gap: 20px; margin-bottom: 20px; flex-wrap: wrap; }
        .input-group { flex: 1; min-width: 250px; display: flex; flex-direction: column; }
        .input-group label { margin-bottom: 8px; color: #455a64; font-weight: 500; }
        .input-group input, .input-group select, .input-group textarea { padding: 12px; border: 1px solid #cfd8dc; border-radius: 8px; font-size: 1rem; background: #fcfcfc; }
        .submit-btn { width: 100%; padding: 14px; background: #fb8c00; color: white; border: none; border-radius: 8px; font-size: 1.1rem; font-weight: 600; cursor: pointer; margin-top: 15px; transition: 0.3s; }
        .submit-btn:hover { background: #e65100; }
        .footer { text-align: center; padding: 20px; color: #607d8b; font-size: 0.85rem; background: white; border-top: 1px solid #eceff1; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Sunrise Dental Clinic</h2>
        <a href="patients_hub.jsp" class="back-btn">← Back to Hub</a>
    </div>

    <div class="main-container">
        <div class="form-wrapper">
            <h3>Update Appointment Record (#<%= app.getAppointmentNo() %>)</h3>
            <form action="UpdateAppointmentServlet" method="POST">
                <input type="hidden" name="appointmentNo" value="<%= app.getAppointmentNo() %>">

                <div class="form-row">
                    <div class="input-group">
                        <label>Patient Full Name</label>
                        <input type="text" name="patientName" value="<%= app.getPatientName() %>" required>
                    </div>
                    <div class="input-group">
                        <label>Contact Number</label>
                        <input type="text" name="contactNumber" value="<%= app.getContactNumber() %>" required>
                    </div>
                </div>

                <div class="input-group" style="margin-bottom: 20px;">
                    <label>Patient Address</label>
                    <textarea name="address" rows="2" required><%= app.getAddress() %></textarea>
                </div>

                <div class="form-row">
                    <div class="input-group">
                        <label>Dentist Name</label>
                        <select name="dentistName" required>
                            <option value="Dr. Perera" <%= "Dr. Perera".equals(app.getDentistName()) ? "selected" : "" %>>Dr. Perera</option>
                            <option value="Dr. Silva" <%= "Dr. Silva".equals(app.getDentistName()) ? "selected" : "" %>>Dr. Silva</option>
                            <option value="Dr. Fernando" <%= "Dr. Fernando".equals(app.getDentistName()) ? "selected" : "" %>>Dr. Fernando</option>
                        </select>
                    </div>
                    <div class="input-group">
                        <label>Treatment Type</label>
                        <select name="treatmentId" required>
                            <option value="1" <%= app.getTreatmentId() == 1 ? "selected" : "" %>>Teeth Cleaning (Rs. 2500)</option>
                            <option value="2" <%= app.getTreatmentId() == 2 ? "selected" : "" %>>Tooth Extraction (Rs. 3500)</option>
                            <option value="3" <%= app.getTreatmentId() == 3 ? "selected" : "" %>>Root Canal (Rs. 15000)</option>
                            <option value="4" <%= app.getTreatmentId() == 4 ? "selected" : "" %>>Dental Braces (Rs. 50000)</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="input-group">
                        <label>Appointment Date</label>
                        <input type="date" name="appointmentDate" value="<%= app.getAppointmentDate() %>" required>
                    </div>
                    <div class="input-group">
                                            <label>Appointment Time</label>
                                            <input type="time" name="appointmentTime" value="<%= app.getAppointmentTime() != null ? app.getAppointmentTime().toString().substring(0, 5) : "" %>" required>
                                        </div>
                </div>

                <button type="submit" class="submit-btn">Update Changes</button>
            </form>
        </div>
    </div>

    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br> Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>
</body>
</html>