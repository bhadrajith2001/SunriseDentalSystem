<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Security to prevent Back Button issue
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
    <title>Add Appointment - Sunrise Dental Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <!-- SweetAlert2 for Popups -->
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

        .main-container {
            flex: 1;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
        }

        .form-wrapper {
            background: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 700px;
            border-top: 5px solid #00897b;
        }
        .form-wrapper h3 {
            color: #00695c;
            margin-bottom: 25px;
            text-align: center;
            font-size: 1.5rem;
        }

        .form-row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 20px;
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
        .input-group input, .input-group select, .input-group textarea {
            padding: 12px;
            border: 1px solid #cfd8dc;
            border-radius: 8px;
            font-size: 1rem;
            background: #fcfcfc;
            transition: 0.3s;
        }
        .input-group input:focus, .input-group select:focus, .input-group textarea:focus {
            border-color: #00897b;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0, 137, 123, 0.1);
            background: white;
        }

        .submit-btn {
            width: 100%;
            padding: 14px;
            background: #00897b;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 15px;
            transition: 0.3s;
        }
        .submit-btn:hover { background: #00695c; }

        .error-msg {
            color: #d32f2f;
            font-size: 0.85rem;
            margin-top: 5px;
            display: none;
        }

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

    <div class="navbar">
        <h2>Sunrise Dental Clinic</h2>
        <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>

    <div class="main-container">
        <div class="form-wrapper">
            <h3>Register New Appointment</h3>

            <% if ("failed".equals(request.getParameter("status"))) { %>
                <div style="color: #c62828; background: #ffebee; padding: 10px; border-radius: 5px; text-align: center; margin-bottom: 20px;">
                    Failed to save appointment. Please try again!
                </div>
            <% } %>

            <form action="AddAppointmentServlet" method="POST" onsubmit="return validateForm()">

                <div class="form-row">
                    <div class="input-group">
                        <label>Patient Full Name</label>
                        <input type="text" name="patientName" id="patientName" required placeholder="Enter name">
                    </div>
                    <div class="input-group">
                        <label>Contact Number</label>
                        <input type="text" name="contactNumber" id="contactNumber" required placeholder="07XXXXXXXX">
                        <small class="error-msg" id="phoneError">Must be exactly 10 digits.</small>
                    </div>
                </div>

                <div class="input-group" style="margin-bottom: 20px;">
                    <label>Patient Address</label>
                    <textarea name="address" rows="2" required placeholder="Enter full address"></textarea>
                </div>

                <div class="form-row">
                    <div class="input-group">
                        <label>Dentist Name</label>
                        <select name="dentistName" required>
                            <option value="Dr. Perera">Dr. Perera</option>
                            <option value="Dr. Silva">Dr. Silva</option>
                            <option value="Dr. Fernando">Dr. Fernando</option>
                        </select>
                    </div>
                    <div class="input-group">
                        <label>Treatment Type</label>
                        <select name="treatmentId" required>
                            <option value="1">Teeth Cleaning (Rs. 2500)</option>
                            <option value="2">Tooth Extraction (Rs. 3500)</option>
                            <option value="3">Root Canal (Rs. 15000)</option>
                            <option value="4">Dental Braces (Rs. 50000)</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="input-group">
                        <label>Appointment Date</label>
                        <input type="date" name="appointmentDate" id="appointmentDate" required>
                        <small class="error-msg" id="dateError">Cannot select past dates.</small>
                    </div>
                    <div class="input-group">
                        <label>Appointment Time</label>
                        <input type="time" name="appointmentTime" required>
                    </div>
                </div>

                <button type="submit" class="submit-btn">Save Appointment</button>
            </form>
        </div>
    </div>

    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br>
        Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>

    <!-- Client-Side Validation Script -->
    <script>
        // Set minimum date to today
        let today = new Date().toISOString().split('T')[0];
        document.getElementById("appointmentDate").setAttribute('min', today);

        function validateForm() {
            let isValid = true;

            // Phone Validation
            let phone = document.getElementById("contactNumber").value;
            let phoneRegex = /^[0-9]{10}$/;
            if (!phoneRegex.test(phone)) {
                document.getElementById("phoneError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("phoneError").style.display = "none";
            }

            // Date Validation
            let appDate = document.getElementById("appointmentDate").value;
            if (appDate < today) {
                document.getElementById("dateError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("dateError").style.display = "none";
            }

            return isValid;
        }
        // Prevent Browser Back Button with SweetAlert2
                window.history.pushState(null, null, window.location.href);
                window.onpopstate = function () {
                    window.history.pushState(null, null, window.location.href);

                    // Modern Custom Popup instead of boring browser alert
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