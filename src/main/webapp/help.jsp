<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
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
    <title>Help & Guidelines - Sunrise Dental Clinic</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f4f7f6; color: #333; display: flex; flex-direction: column; min-height: 100vh; }

        .navbar { background-color: #00796b; color: white; padding: 15px 5%; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .navbar h2 { font-weight: 600; font-size: 1.4rem; }
        .back-btn { background: #ffffff; color: #00796b; text-decoration: none; padding: 6px 15px; border-radius: 6px; font-weight: 600; font-size: 0.9rem; transition: 0.3s; }
        .back-btn:hover { background: #e0f2f1; }

        .main-container { flex: 1; padding: 40px 20px; display: flex; justify-content: center; align-items: center; }

        .help-container { background: white; max-width: 800px; width: 100%; padding: 40px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); border-top: 8px solid #9ccc65; }
        .section-title { color: #33691e; margin-bottom: 20px; font-size: 1.5rem; }
        .step { margin-bottom: 20px; padding: 15px; background: #f9fbe7; border-left: 4px solid #7cb342; border-radius: 4px; }
        .step h4 { color: #558b2f; margin-bottom: 5px; font-size: 1.05rem; }
        .step p { font-size: 0.95rem; color: #455a64; line-height: 1.5; }

        .footer { text-align: center; padding: 20px; color: #607d8b; font-size: 0.85rem; background: #ffffff; border-top: 1px solid #eceff1; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>Sunrise Dental Clinic</h2>
        <a href="dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>

    <div class="main-container">
        <div class="help-container">
            <h2 class="section-title">System Guidelines for Staff</h2>

            <div class="step">
                <h4>1. How to Add a New Appointment?</h4>
                <p>Click on the "+ New Appointment" card on the Dashboard. Fill in the patient details, select the treatment, and ensure the phone number is exactly 10 digits before saving.</p>
            </div>

            <div class="step">
                <h4>2. How to Search for a Patient?</h4>
                <p>On the Dashboard or Patients Hub, use the Search bar above the table. You can type the Patient's Name or the Appointment Number (e.g., #1) to instantly filter the records.</p>
            </div>

            <div class="step">
                <h4>3. How to Generate a Bill/Invoice?</h4>
                <p>Find the required appointment from the Dashboard table and click the orange "Print Bill" button. A printable invoice will be generated automatically based on the treatment cost.</p>
            </div>
        </div>
    </div>

    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br>
        Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>

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