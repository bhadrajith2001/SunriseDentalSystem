<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
<%@ page import="com.sunrisedental.sunrisedentalsystem.dao.AppointmentDAO" %>
<%@ page import="com.sunrisedental.sunrisedentalsystem.models.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% if ("deleted".equals(request.getParameter("status"))) { %>
                <div style="background:#ffebee; color:#c62828; padding:10px; border-radius:6px; margin-top:15px; text-align:center;">Record successfully deleted!</div>
            <% } else if ("updated".equals(request.getParameter("status"))) { %>
                <div style="background:#e8f5e9; color:#2e7d32; padding:10px; border-radius:6px; margin-top:15px; text-align:center;">Record successfully updated!</div>
            <% } %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    if (session.getAttribute("activeUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patients Hub - Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f4f7f6; color: #333; display: flex; flex-direction: column; min-height: 100vh; }
        .navbar { background-color: #00796b; color: white; padding: 15px 5%; display: flex; justify-content: space-between; align-items: center; }
        .back-btn { background: white; color: #00796b; text-decoration: none; padding: 6px 15px; border-radius: 6px; font-weight: 600; font-size: 0.9rem; }
        .container { flex: 1; padding: 40px 5%; max-width: 1300px; margin: 0 auto; width: 100%; }
        .card-box { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #eceff1; }
        th { background-color: #e0f2f1; color: #004d40; }
        .btn-del { background: #e53935; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 0.85rem; }
        .footer { text-align: center; padding: 20px; color: #607d8b; font-size: 0.85rem; background: white; border-top: 1px solid #eceff1; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Patients Hub - Record Management</h2>
        <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>

    <div class="container">
        <div class="card-box">
            <h3>Registered Patient Records</h3>
            <% if ("deleted".equals(request.getParameter("status"))) { %>
                <div style="background:#ffebee; color:#c62828; padding:10px; border-radius:6px; margin-top:15px; text-align:center;">Record successfully deleted!</div>
            <% } %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th><th>Patient Name</th><th>Address</th><th>Contact</th><th>Dentist</th><th>Treatment</th><th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        AppointmentDAO dao = new AppointmentDAO();
                        List<Appointment> list = dao.getAllAppointments();
                        if(list != null && !list.isEmpty()) {
                            for(Appointment a : list) {
                    %>
                    <tr>
                        <td>#<%= a.getAppointmentNo() %></td>
                        <td><b><%= a.getPatientName() %></b></td>
                        <td><%= a.getAddress() %></td>
                        <td><%= a.getContactNumber() %></td>
                        <td><%= a.getDentistName() %></td>
                        <td><%= a.getTreatmentName() %></td>
                        <td>
                                                    <a href="edit_appointment.jsp?id=<%= a.getAppointmentNo() %>" style="background:#0288d1; color:white; padding:6px 12px; text-decoration:none; border-radius:4px; font-size:0.85rem; margin-right:5px; display:inline-block;">Edit</a>
                                                    <a href="DeleteAppointmentServlet?id=<%= a.getAppointmentNo() %>" class="btn-del" onclick="return confirm('Are you sure you want to delete this record?');">Delete</a>
                                                </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="7" style="text-align:center; color:#90a4ae; padding:20px;">No patient records found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br> Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>
</body>
</html>