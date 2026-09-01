<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Help & Guidelines - Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f4f7f6; padding: 40px 20px; display: flex; flex-direction: column; align-items: center; }
        .help-container { background: white; max-width: 800px; width: 100%; padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); border-top: 8px solid #9ccc65; }
        h2 { color: #33691e; margin-bottom: 20px; }
        .step { margin-bottom: 20px; padding: 15px; background: #f9fbe7; border-left: 4px solid #7cb342; border-radius: 4px; }
        .step h4 { color: #558b2f; margin-bottom: 5px; }
        .step p { font-size: 0.95rem; color: #455a64; }
        .btn-back { display: inline-block; margin-top: 20px; padding: 10px 20px; background: #00796b; color: white; text-decoration: none; border-radius: 6px; }
        .btn-back:hover { background: #004d40; }
        .footer { margin-top: 30px; text-align: center; color: #607d8b; font-size: 0.85rem; }
    </style>
</head>
<body>
    <div class="help-container">
        <h2>System Guidelines for Staff</h2>

        <div class="step">
            <h4>1. How to Add a New Appointment?</h4>
            <p>Click on the "+ New Appointment" card on the Dashboard. Fill in the patient details, select the treatment, and ensure the phone number is exactly 10 digits before saving.</p>
        </div>

        <div class="step">
            <h4>2. How to Search for a Patient?</h4>
            <p>On the Dashboard, use the Search bar above the table. You can type the Patient's Name or the Appointment Number (e.g., #1) to instantly filter the records.</p>
        </div>

        <div class="step">
            <h4>3. How to Generate a Bill/Invoice?</h4>
            <p>Find the required appointment from the Dashboard table and click the orange "Print Bill" button. A printable invoice will be generated automatically based on the treatment cost.</p>
        </div>

        <a href="dashboard.jsp" class="btn-back">← Back to Dashboard</a>
    </div>

    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br>
        Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            window.history.pushState(null, null, window.location.href);
            window.onpopstate = function () {
                window.history.pushState(null, null, window.location.href);
                Swal.fire({
                    icon: 'warning',
                    title: 'Action Blocked!',
                    text: "For security reasons, the browser's back button is disabled. Please use the system navigation buttons.",
                    confirmButtonColor: '#00796b'
                });
            };
        </script>
</body>
</html>