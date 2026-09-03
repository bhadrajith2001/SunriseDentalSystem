<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
<%@ page import="com.sunrisedental.sunrisedentalsystem.dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%
    // Security to prevent Back Button issue
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    User activeUser = (User) session.getAttribute("activeUser");
    if (activeUser == null || !"ADMIN".equalsIgnoreCase(activeUser.getRole())) {
        response.sendRedirect("dashboard.jsp?error=unauthorized");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Management - Sunrise Dental Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <!-- SweetAlert2 for Pro-Level Popups -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            background-color: #f4f7f6;
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .navbar {
            background-color: #00796b;
            color: white;
            padding: 15px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .navbar h2 { font-weight: 600; font-size: 1.4rem; }
        .back-btn {
            background: #ffffff;
            color: #00796b;
            text-decoration: none;
            padding: 6px 15px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: 0.3s;
        }
        .back-btn:hover { background: #e0f2f1; }

        .container {
            flex: 1;
            padding: 40px 5%;
            max-width: 1000px;
            margin: 0 auto;
            width: 100%;
        }

        .card {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            border-top: 5px solid #00897b;
        }
        .card h3 {
            color: #00695c;
            margin-bottom: 25px;
            font-size: 1.4rem;
        }

        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .input-group {
            flex: 1;
            min-width: 250px;
            display: flex;
            flex-direction: column;
        }
        .input-group label {
            margin-bottom: 8px;
            color: #455a64;
            font-weight: 500;
            font-size: 0.95rem;
        }
        .input-group input, .input-group select {
            padding: 12px;
            border: 1px solid #cfd8dc;
            border-radius: 8px;
            font-size: 1rem;
            background: #fcfcfc;
            transition: 0.3s;
        }
        .input-group input:focus, .input-group select:focus {
            border-color: #00897b;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 137, 123, 0.1);
            background: white;
        }

        .btn-submit {
            background: #00897b;
            color: white;
            padding: 14px 20px;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            transition: 0.3s;
        }
        .btn-submit:hover { background: #00695c; }

        .btn-del {
            background: #e53935;
            color: white;
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 0.85rem;
            border: none;
            cursor: pointer;
            transition: 0.3s;
            display: inline-block;
        }
        .btn-del:hover { background: #c62828; }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid #eceff1;
        }
        th {
            background: #e0f2f1;
            color: #004d40;
            font-weight: 600;
        }
        tr:hover { background: #f9fbfb; }

        .footer {
            text-align: center;
            padding: 20px;
            color: #607d8b;
            font-size: 0.85rem;
            font-weight: 500;
            background: #ffffff;
            border-top: 1px solid #eceff1;
        }
    </style>
    <script type="text/javascript">
        window.history.forward();
        function noBack() { window.history.forward(); }
    </script>
</head>
<body>

    <!-- Popup Status Handlers -->
    <% if ("added".equals(request.getParameter("status"))) { %>
        <script>
            window.addEventListener('DOMContentLoaded', (event) => {
                Swal.fire({
                    icon: 'success',
                    title: 'Staff Added!',
                    text: 'New staff account created successfully.',
                    confirmButtonColor: '#00796b'
                });
            });
        </script>
    <% } else if ("deleted".equals(request.getParameter("status"))) { %>
        <script>
            window.addEventListener('DOMContentLoaded', (event) => {
                Swal.fire({
                    icon: 'success',
                    title: 'User Deleted!',
                    text: 'Staff member has been removed from the system.',
                    confirmButtonColor: '#00796b'
                });
            });
        </script>
    <% } %>

    <div class="navbar">
        <h2>Admin - Staff Management</h2>
        <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>

    <div class="container">
        <div class="card">
            <h3>Register New Staff Member</h3>
            <form action="AddStaffServlet" method="POST" onsubmit="return validateStaffForm()">
                <div class="form-row">
                    <div class="input-group">
                        <label>Username</label>
                        <input type="text" name="username" id="username" required placeholder="Enter username">
                    </div>
                    <div class="input-group">
                        <label>Password</label>
                        <input type="password" name="password" id="password" required placeholder="Enter password">
                    </div>
                    <div class="input-group">
                        <label>Role</label>
                        <select name="role">
                            <option value="STAFF">STAFF</option>
                            <option value="ADMIN">ADMIN</option>
                        </select>
                    </div>
                </div>
                <button type="submit" class="btn-submit">Create Account</button>
            </form>
        </div>

        <div class="card">
            <h3>Existing System Users</h3>
            <table>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        UserDAO udao = new UserDAO();
                        List<User> users = udao.getAllUsers();
                        if(users != null) {
                            for(User u : users) {
                    %>
                    <tr>
                        <td><b>#<%= u.getUserId() %></b></td>
                        <td><%= u.getUsername() %></td>
                        <td><span style="background: #e0f2f1; padding: 4px 12px; border-radius: 12px; color: #00796b; font-weight: 600; font-size: 0.85rem;"><%= u.getRole() %></span></td>
                        <td>
                            <% if (u.getUserId() != activeUser.getUserId()) { %>
                                <button type="button" class="btn-edit" style="background: #0288d1; color: white; padding: 6px 12px; border:none; border-radius:6px; cursor:pointer; margin-right:5px;" onclick="openEditModal(<%= u.getUserId() %>, '<%= u.getUsername() %>', '<%= u.getRole() %>')">Edit</button>
                                <button type="button" class="btn-del" onclick="confirmDelete(<%= u.getUserId() %>)">Delete</button>
                            <% } else { %>
                                <span style="font-size: 0.85rem; color: #90a4ae; font-style: italic;">Current Admin</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br>
        Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>

    <!-- Pro-Level Scripts -->
    <script>
        function validateStaffForm() {
            Swal.fire({
                title: 'Creating Account...',
                text: 'Please wait while we set up the staff profile.',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            return true;
        }

        function openEditModal(id, currentName, currentRole) {
            Swal.fire({
                title: 'Update Staff Member',
                html:
                    '<input id="swal-input-name" class="swal2-input" placeholder="Username" value="' + currentName + '">' +
                    '<select id="swal-input-role" class="swal2-input">' +
                        '<option value="STAFF" ' + (currentRole === 'STAFF' ? 'selected' : '') + '>STAFF</option>' +
                        '<option value="ADMIN" ' + (currentRole === 'ADMIN' ? 'selected' : '') + '>ADMIN</option>' +
                    '</select>',
                focusConfirm: false,
                showCancelButton: true,
                confirmButtonColor: '#00796b',
                preConfirm: () => {
                    return {
                        username: document.getElementById('swal-input-name').value,
                        role: document.getElementById('swal-input-role').value
                    }
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    const data = result.value;
                    // Send data via dynamic form submission to UpdateStaffServlet
                    let form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'UpdateStaffServlet';

                    let inputId = document.createElement('input');
                    inputId.type = 'hidden';
                    inputId.name = 'userId';
                    inputId.value = id;
                    form.appendChild(inputId);

                    let inputName = document.createElement('input');
                    inputName.type = 'hidden';
                    inputName.name = 'username';
                    inputName.value = data.username;
                    form.appendChild(inputName);

                    let inputRole = document.createElement('input');
                    inputRole.type = 'hidden';
                    inputRole.name = 'role';
                    inputRole.value = data.role;
                    form.appendChild(inputRole);

                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }

        // Modern SweetAlert Delete Confirmation Dialog
        function confirmDelete(id) {
            Swal.fire({
                title: 'Are you sure?',
                text: "This staff account will be permanently deleted!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#e53935',
                cancelButtonColor: '#78909c',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = 'DeleteStaffServlet?id=' + id;
                }
            });
        }

        // Prevent Browser Back Button with SweetAlert2 Warning
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function () {
            window.history.pushState(null, null, window.location.href);

            Swal.fire({
                icon: 'warning',
                title: 'Action Blocked!',
                text: "For security reasons, the browser's back button is disabled. Please use the 'Back to Dashboard' button.",
                confirmButtonColor: '#00796b',
                background: '#ffffff',
                backdrop: `rgba(0,0,0,0.4)`
            });
        };
    </script>
</body>
</html>