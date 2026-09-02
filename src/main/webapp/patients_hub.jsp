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
    <title>Patients Hub - Sunrise Dental Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f4f7f6; color: #333; display: flex; flex-direction: column; min-height: 100vh; }
        .navbar { background-color: #00796b; color: white; padding: 15px 5%; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1); flex-wrap: wrap; gap: 15px; }
        .navbar h2 { font-weight: 600; font-size: 1.4rem; }
        .back-btn { background: white; color: #00796b; text-decoration: none; padding: 6px 15px; border-radius: 6px; font-weight: 600; font-size: 0.9rem; transition: 0.3s; }
        .back-btn:hover { background: #e0f2f1; }
        .container { flex: 1; padding: 40px 5%; max-width: 1300px; margin: 0 auto; width: 100%; }

        .card-box { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }

        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px; }
        .table-header h3 { color: #37474f; font-size: 1.25rem; }

        /* Search Bar with Icon wrapper */
        .search-box-wrapper {
            position: relative;
            width: 100%;
            max-width: 320px;
        }
        .search-bar {
            padding: 10px 15px 10px 40px;
            border: 1px solid #cfd8dc;
            border-radius: 8px;
            width: 100%;
            outline: none;
            transition: 0.3s;
            font-size: 0.95rem;
        }
        .search-bar:focus { border-color: #00796b; box-shadow: 0 0 5px rgba(0,121,107,0.2); }
        .search-icon {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            color: #90a4ae;
            pointer-events: none;
        }

        .table-responsive { width: 100%; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 900px; }
        th, td { padding: 14px 15px; text-align: left; border-bottom: 1px solid #eceff1; font-size: 0.95rem; }
        th { background-color: #e0f2f1; color: #004d40; font-weight: 600; }
        tr:hover { background-color: #f9fbe7; }

        .btn-edit { background: #0288d1; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 0.85rem; margin-right: 5px; display: inline-block; transition: 0.3s; }
        .btn-edit:hover { background: #0277bd; }
        .btn-del { background: #e53935; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 0.85rem; display: inline-block; border: none; cursor: pointer; transition: 0.3s; }
        .btn-del:hover { background: #c62828; }

        .footer { text-align: center; padding: 20px; color: #607d8b; font-size: 0.85rem; background: white; border-top: 1px solid #eceff1; }
    </style>

    <% if ("deleted".equals(request.getParameter("status"))) { %>
        <script>
            window.addEventListener('DOMContentLoaded', (event) => {
                Swal.fire({
                    icon: 'success',
                    title: 'Deleted Successfully!',
                    text: 'The patient record has been removed from the system.',
                    confirmButtonColor: '#00796b'
                });
                window.history.replaceState({}, document.title, window.location.pathname);
            });
        </script>
    <% } else if ("updated".equals(request.getParameter("status"))) { %>
        <script>
            window.addEventListener('DOMContentLoaded', (event) => {
                Swal.fire({
                    icon: 'success',
                    title: 'Updated Successfully!',
                    text: 'Patient appointment details have been modified.',
                    confirmButtonColor: '#00796b'
                });
                window.history.replaceState({}, document.title, window.location.pathname);
            });
        </script>
    <% } %>
</head>
<body>
    <div class="navbar">
        <h2>Patients Hub - Record Management</h2>
        <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>

    <div class="container">
        <div class="card-box">
            <div class="table-header">
                <h3>Registered Patient Records</h3>
                <!-- Search Bar with Icon -->
                <div class="search-box-wrapper">
                    <span class="search-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                    </span>
                    <input type="text" id="searchInput" class="search-bar" onkeyup="searchTable()" placeholder="Search by ID or Name...">
                </div>
            </div>

            <div class="table-responsive">
                <table id="patientsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Patient Name</th>
                            <th>Address</th>
                            <th>Contact</th>
                            <th>Dentist</th>
                            <th>Treatment</th>
                            <th>Action</th>
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
                            <td><b>#<%= a.getAppointmentNo() %></b></td>
                            <td><%= a.getPatientName() %></td>
                            <td><%= a.getAddress() %></td>
                            <td><%= a.getContactNumber() %></td>
                            <td><%= a.getDentistName() %></td>
                            <td><%= a.getTreatmentName() %></td>
                            <td>
                                <a href="edit_appointment.jsp?id=<%= a.getAppointmentNo() %>" class="btn-edit">Edit</a>
                                <button type="button" class="btn-del" onclick="confirmDelete(<%= a.getAppointmentNo() %>)">Delete</button>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="7" style="text-align:center; color:#90a4ae; padding:30px;">No patient records found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br> Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>

    <script>
        // Safe JS Search Function for Patients Hub
        function searchTable() {
            let input = document.getElementById("searchInput").value.toUpperCase();
            let table = document.getElementById("patientsTable");
            let tr = table.getElementsByTagName("tr");
            for (let i = 1; i < tr.length; i++) {
                let tdID = tr[i].getElementsByTagName("td")[0];
                let tdName = tr[i].getElementsByTagName("td")[1];

                if (tdID && tdID.hasAttribute("colspan")) {
                    continue;
                }

                if (tdID || tdName) {
                    let idText = tdID ? (tdID.textContent || tdID.innerText) : "";
                    let nameText = tdName ? (tdName.textContent || tdName.innerText) : "";
                    let txtValue = idText + " " + nameText;
                    tr[i].style.display = txtValue.toUpperCase().indexOf(input) > -1 ? "" : "none";
                }
            }
        }

        // Modern SweetAlert Delete Confirmation Dialog
        function confirmDelete(id) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this record!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e53935',
                cancelButtonColor: '#78909c',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'DeleteAppointmentServlet?id=' + id;
                }
            });
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