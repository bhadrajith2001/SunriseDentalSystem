<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
<%@ page import="com.sunrisedental.sunrisedentalsystem.dao.AppointmentDAO" %>
<%@ page import="com.sunrisedental.sunrisedentalsystem.models.Appointment" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    User activeUser = (User) session.getAttribute("activeUser");
    if (activeUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Safely parse the Appointment ID from the URL
    String idParam = request.getParameter("id");
    Appointment app = null;
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            AppointmentDAO dao = new AppointmentDAO();
            app = dao.getAppointmentById(Integer.parseInt(idParam.trim()));
        } catch (NumberFormatException e) {
            e.printStackTrace(); // Invalid ID format, app remains null
        }
    }

    // If no appointment found, send back to dashboard
    if (app == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice #<%= app.getAppointmentNo() %> - Sunrise Dental</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background-color: #f4f7f6; display: flex; flex-direction: column; min-height: 100vh; }

        /* Consistent Navbar (Hidden on Print) */
        .navbar { background-color: #00796b; color: white; padding: 15px 5%; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .navbar h2 { font-weight: 600; font-size: 1.4rem; }
        .nav-back-btn { background: white; color: #00796b; text-decoration: none; padding: 6px 15px; border-radius: 6px; font-weight: 600; font-size: 0.9rem; transition: 0.3s; }
        .nav-back-btn:hover { background: #e0f2f1; }

        .main-container { flex: 1; padding: 40px 20px; display: flex; flex-direction: column; align-items: center; }

        .invoice-box {
            background: white;
            max-width: 700px;
            width: 100%;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            border-top: 8px solid #00796b;
        }

        .header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 40px; border-bottom: 2px solid #eeeeee; padding-bottom: 20px; }
        .header-left h2 { color: #00796b; font-weight: 700; font-size: 1.8rem; }
        .header-left p { color: #607d8b; font-size: 0.9rem; margin-top: 5px; }
        .header-right { text-align: right; }
        .header-right h1 { color: #37474f; font-size: 2rem; font-weight: 300; letter-spacing: 2px; }
        .header-right p { font-size: 0.95rem; color: #546e7a; margin-top: 5px; }

        .patient-info { margin-bottom: 30px; display: flex; justify-content: space-between; }
        .info-block h4 { color: #90a4ae; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; }
        .info-block p { color: #37474f; font-weight: 500; font-size: 1.05rem; }

        .details-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .details-table th { background: #e0f2f1; color: #004d40; text-align: left; padding: 12px; font-weight: 600; }
        .details-table td { padding: 15px 12px; border-bottom: 1px solid #eeeeee; color: #455a64; }

        .total-section { text-align: right; margin-top: 20px; padding: 20px; background: #f9fbe7; border-radius: 8px; border: 1px solid #f0f4c3; }
        .total-section h3 { color: #33691e; font-size: 1.5rem; }
        .total-section p { font-size: 0.85rem; color: #7cb342; margin-top: 5px; }

        .footer-note { text-align: center; margin-top: 40px; color: #90a4ae; font-size: 0.9rem; }

        .action-buttons { margin-top: 30px; text-align: center; width: 100%; max-width: 700px; display: flex; justify-content: center; gap: 20px; }
        .btn { padding: 10px 25px; border-radius: 6px; font-weight: 600; text-decoration: none; cursor: pointer; transition: 0.3s; border: none; font-size: 1rem; display: inline-block; }
        .btn-print { background: #fb8c00; color: white; box-shadow: 0 4px 10px rgba(251, 140, 0, 0.2); }
        .btn-print:hover { background: #e65100; transform: translateY(-2px); }

        .credit-footer { text-align: center; padding: 20px; margin-top: auto; font-size: 0.85rem; color: #607d8b; background: white; border-top: 1px solid #eceff1; width: 100%; }

        /* CSS for Print Mode: Hides Navbar, Buttons, and Footer when actually printing */
        @media print {
            body { background: white; padding: 0; }
            .main-container { padding: 0; }
            .invoice-box { box-shadow: none; border-top: none; max-width: 100%; padding: 20px; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body>

    <!-- Professional Navbar (Hidden in Print Mode) -->
    <div class="navbar no-print">
        <h2>Sunrise Dental Clinic</h2>
        <a href="dashboard.jsp" class="nav-back-btn">← Back to Dashboard</a>
    </div>

    <div class="main-container">
        <div class="invoice-box">
            <div class="header">
                <div class="header-left">
                    <h2>Sunrise Dental</h2>
                    <p>No. 45, Galle Road, Colombo 03</p>
                    <p>Hotline: +94 11 234 5678</p>
                </div>
                <div class="header-right">
                    <h1>INVOICE</h1>
                    <p><b>Date:</b> <%= app.getAppointmentDate() %></p>
                    <p><b>Invoice #:</b> INV-<%= app.getAppointmentNo() %></p>
                </div>
            </div>

            <div class="patient-info">
                <div class="info-block">
                    <h4>Bill To</h4>
                    <p><%= app.getPatientName() %></p>
                    <p style="font-size: 0.9rem; font-weight: 400; color: #546e7a;"><%= app.getContactNumber() %></p>
                </div>
                <div class="info-block" style="text-align: right;">
                    <h4>Consulting Doctor</h4>
                    <p><%= app.getDentistName() %></p>
                </div>
            </div>

            <table class="details-table">
                <thead>
                    <tr>
                        <th>Description</th>
                        <th style="text-align: right;">Amount (Rs.)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <b>Treatment:</b> <%= app.getTreatmentName() %><br>
                            <span style="font-size: 0.85rem; color: #78909c;">Appointment Time: <%= app.getAppointmentTime() %></span>
                        </td>
                        <td style="text-align: right; font-weight: 500;">
                            <%= String.format("%.2f", app.getTotalCost()) %>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="total-section">
                <h3>Total Payable: Rs. <%= String.format("%.2f", app.getTotalCost()) %></h3>
                <p>Includes all consultation and treatment fees.</p>
            </div>

            <div class="footer-note">
                Thank you for choosing Sunrise Dental Clinic! <br>
                <span style="font-size: 0.8rem;">This is a computer-generated invoice and requires no signature.</span>
            </div>
        </div>

        <!-- Buttons (Hidden during print) -->
        <div class="action-buttons no-print">
            <button onclick="window.print()" class="btn btn-print">🖨️ Print Invoice</button>
        </div>
    </div>

    <!-- Designed By Footer (Hidden during print) -->
    <div class="credit-footer no-print">
        Sunrise Dental Management System &copy; 2026 <br>
        Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // Prevent Browser Back Button via Browser Controls (Forces user to use UI buttons)
        window.history.pushState(null, null, window.location.href);
        window.onpopstate = function () {
            window.history.pushState(null, null, window.location.href);
            Swal.fire({
                icon: 'warning',
                title: 'Action Blocked!',
                text: "For security reasons, the browser's back button is disabled. Please use the 'Back to Dashboard' button.",
                confirmButtonColor: '#00796b'
            });
        };
    </script>
</body>
</html>