<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
<%@ page import="com.sunrisedental.sunrisedentalsystem.dao.AppointmentDAO" %>
<%@ page import="com.sunrisedental.sunrisedentalsystem.models.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    User activeUser = (User) session.getAttribute("activeUser");
    if (activeUser == null) {
        response.sendRedirect("index.jsp?error=invalid");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sunrise Dental Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f4f7f6; color: #333; display: flex; flex-direction: column; min-height: 100vh; }
        .navbar { background-color: #00796b; color: white; padding: 15px 5%; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1); flex-wrap: wrap; gap: 15px; }
        .navbar h2 { font-weight: 600; font-size: 1.4rem; letter-spacing: 0.5px; }
        .user-info { display: flex; align-items: center; gap: 15px; flex-wrap: wrap; }
        .role-badge { background: #4db6ac; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; text-transform: uppercase; }
        .logout-btn { background: #e53935; color: white; text-decoration: none; padding: 8px 18px; border-radius: 8px; font-weight: 500; font-size: 0.9rem; transition: 0.3s; }
        .logout-btn:hover { background: #c62828; }
        .main-container { flex: 1; padding: 40px 5%; width: 100%; max-width: 1300px; margin: 0 auto; }

        /* Stats Box for 70-100 Band */
        .stats-container { display: flex; gap: 20px; margin-bottom: 30px; flex-wrap: wrap; }
        .stat-box { flex: 1; min-width: 200px; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); border-left: 5px solid #00796b; }
        .stat-box h4 { color: #607d8b; font-size: 0.9rem; margin-bottom: 5px; text-transform: uppercase; }
        .stat-box h2 { color: #004d40; font-size: 1.8rem; }

        .action-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .card { background: white; padding: 25px; border-radius: 12px; text-align: center; text-decoration: none; color: #00796b; box-shadow: 0 6px 15px rgba(0,0,0,0.04); transition: 0.3s; border-top: 5px solid #4db6ac; }
        .card:hover { transform: translateY(-8px); box-shadow: 0 12px 25px rgba(0,0,0,0.1); }
        .card h3 { margin-bottom: 8px; font-size: 1.25rem; }
        .card p { color: #78909c; font-size: 0.9rem; }

        .table-section { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 6px 15px rgba(0,0,0,0.04); }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px; }
        .table-header h3 { color: #37474f; font-size: 1.2rem; }

        /* Search Bar */
        .search-bar { padding: 10px 15px; border: 1px solid #cfd8dc; border-radius: 8px; width: 100%; max-width: 300px; outline: none; transition: 0.3s; }
        .search-bar:focus { border-color: #00796b; box-shadow: 0 0 5px rgba(0,121,107,0.2); }

        .table-responsive { width: 100%; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 800px; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #eceff1; font-size: 0.95rem; }
        th { background-color: #e0f2f1; color: #004d40; font-weight: 600; }
        tr:hover { background-color: #f9fbe7; }
        .status-msg { background: #e8f5e9; color: #2e7d32; padding: 15px; border-radius: 8px; margin-bottom: 25px; text-align: center; font-weight: 500; border: 1px solid #c8e6c9; }
        .btn-print { background: #fb8c00; color: white; padding: 8px 14px; text-decoration: none; border-radius: 6px; font-size: 0.85rem; font-weight: 500; transition: 0.3s; display: inline-block; }
        .btn-print:hover { background: #e65100; }
        .footer { text-align: center; padding: 20px; color: #607d8b; font-size: 0.85rem; font-weight: 500; background: #ffffff; border-top: 1px solid #eceff1; }
    </style>
    <% if ("success".equals(request.getParameter("login"))) { %>
        <script>
            window.addEventListener('DOMContentLoaded', (event) => {
                Swal.fire({
                    icon: 'success',
                    title: 'Login Successful!',
                    text: 'Welcome back to Sunrise Dental Clinic Portal.',
                    timer: 2000,
                    showConfirmButton: false
                });
            });
        </script>
        <% } %>
</head>
<body>
    <div class="navbar">
        <h2>Sunrise Dental Clinic</h2>
        <div class="user-info">
            <span>Welcome, <b><%= activeUser.getUsername() %></b></span>
            <span class="role-badge"><%= activeUser.getRole() %></span>
            <a href="LogoutServlet" class="logout-btn">Logout</a>
        </div>
    </div>

    <div class="main-container">
        <% if ("added".equals(request.getParameter("status"))) { %>
            <div class="status-msg">✅ New Appointment Successfully Registered!</div>
        <% } %>

        <%
            AppointmentDAO dao = new AppointmentDAO();
            List<Appointment> appList = dao.getAllAppointments();
            int totalPatients = 0;
            double totalRevenue = 0;
            if(appList != null) {
                totalPatients = appList.size();
                for(Appointment a : appList) { totalRevenue += a.getTotalCost(); }
            }
        %>

        <!-- Live Statistics for Decision Making -->
        <div class="stats-container">
            <div class="stat-box">
                <h4>Total Registered Patients</h4>
                <h2><%= totalPatients %></h2>
            </div>
            <div class="stat-box" style="border-left-color: #fb8c00;">
                <h4>Total Projected Revenue</h4>
                <h2 style="color: #e65100;">Rs. <%= String.format("%.2f", totalRevenue) %></h2>
            </div>
        </div>

        <div class="action-cards">
            <a href="add_appointment.jsp" class="card">
                <h3>+ New Appointment</h3><p>Register a new patient securely</p>
            </a>
            <a href="patients_hub.jsp" class="card" style="border-top-color: #29b6f6; color: #0277bd;">
                <h3>Patients Hub</h3><p>View & manage patient records</p>
            </a>
            <a href="help.jsp" class="card" style="border-top-color: #9ccc65; color: #558b2f;">
                <h3>System Help</h3><p>Guidelines for Staff Members</p>
            </a>
        </div>

        <div class="table-section">
            <div class="table-header">
                <h3>Recent Appointments Overview</h3>
                <!-- Search Bar functionality -->
                <input type="text" id="searchInput" class="search-bar" onkeyup="searchTable()" placeholder="Search by App No or Name...">
            </div>

            <div class="table-responsive">
                <table id="appointmentsTable">
                    <thead>
                        <tr>
                            <th>App. No</th><th>Patient Name</th><th>Contact</th><th>Treatment</th><th>Date & Time</th><th>Total Bill</th><th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if(appList != null && !appList.isEmpty()) {
                                for(Appointment app : appList) {
                        %>
                        <tr>
                            <td><b>#<%= app.getAppointmentNo() %></b></td>
                            <td><%= app.getPatientName() %></td>
                            <td><%= app.getContactNumber() %></td>
                            <td><%= app.getTreatmentName() %></td>
                            <td><%= app.getAppointmentDate() %> at <%= app.getAppointmentTime() %></td>
                            <td style="color: #c62828; font-weight: 600;">Rs. <%= String.format("%.2f", app.getTotalCost()) %></td>
                            <td><a href="print_bill.jsp?id=<%= app.getAppointmentNo() %>" class="btn-print">🖨️ Print Bill</a></td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="7" style="text-align: center; color: #90a4ae; padding: 30px;">No appointments registered yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br>
        Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>

    <script>
        // JS Search Function
        function searchTable() {
            let input = document.getElementById("searchInput").value.toUpperCase();
            let tr = document.getElementById("appointmentsTable").getElementsByTagName("tr");
            for (let i = 1; i < tr.length; i++) {
                let tdID = tr[i].getElementsByTagName("td")[0];
                let tdName = tr[i].getElementsByTagName("td")[1];
                if (tdID || tdName) {
                    let txtValue = (tdID.textContent || tdID.innerText) + " " + (tdName.textContent || tdName.innerText);
                    tr[i].style.display = txtValue.toUpperCase().indexOf(input) > -1 ? "" : "none";
                }
            }
        }

        // Prevent Browser Back Button
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function () {
            window.history.pushState(null, null, window.location.href);
            Swal.fire({ icon: 'warning', title: 'Action Blocked!', text: "For security reasons, the browser's back button is disabled. Please use the system buttons.", confirmButtonColor: '#00796b' });
        };
    </script>
</body>
</html>