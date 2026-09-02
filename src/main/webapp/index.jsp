<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    User existingUser = (User) session.getAttribute("activeUser");
    if (existingUser != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic - Staff Portal Login</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body {
            background-color: #f4f7f6;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Pro-level Navbar Header */
        .navbar {
            background-color: #00796b;
            color: white;
            padding: 15px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .navbar h2 { font-weight: 600; font-size: 1.4rem; letter-spacing: 0.5px; }

        .main-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .login-card {
            background: white;
            padding: 40px 30px;
            border-radius: 16px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 420px;
            text-align: center;
            border-top: 5px solid #00897b;
            transition: transform 0.3s ease;
        }
        .login-card:hover {
            transform: translateY(-5px);
        }
        .logo-area { margin-bottom: 25px; }
        .logo-area h2 {
            color: #00796b;
            font-weight: 600;
            font-size: 1.7rem;
            margin-bottom: 5px;
        }
        .logo-area p { color: #546e7a; font-size: 0.95rem; }

        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }
        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: #37474f;
            font-weight: 500;
            font-size: 0.9rem;
        }
        .input-group input {
            width: 100%;
            padding: 14px;
            border: 1.5px solid #cfd8dc;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
            background: #fcfcfc;
        }
        .input-group input:focus {
            border-color: #00897b;
            outline: none;
            box-shadow: 0 0 0 4px rgba(0, 137, 123, 0.1);
            background: white;
        }

        /* Password container with eye toggle icon */
        .password-container {
            position: relative;
        }
        .password-container input {
            padding-right: 45px;
        }
        .toggle-password {
            position: absolute;
            top: 50%;
            right: 15px;
            transform: translateY(-50%);
            cursor: pointer;
            color: #78909c;
            display: flex;
            align-items: center;
        }
        .toggle-password:hover {
            color: #00796b;
        }

        .login-btn {
            width: 100%;
            padding: 14px;
            background: #00897b;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.05rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s, transform 0.2s;
            margin-top: 10px;
        }
        .login-btn:hover { background: #00695c; transform: scale(1.02); }

        .error-msg {
            color: #c62828;
            background: #ffebee;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            display: none;
            border-left: 4px solid #c62828;
            text-align: left;
        }
        <% if ("invalid".equals(request.getParameter("error"))) { %>
        .error-msg { display: block; }
        <% } %>

        .info-note {
            margin-top: 20px;
            font-size: 0.82rem;
            color: #78909c;
            background: #f9fbe7;
            padding: 10px;
            border-radius: 6px;
            border: 1px dashed #c0ca33;
        }

        .footer {
            text-align: center;
            padding: 20px;
            color: #607d8b;
            font-size: 0.85rem;
            font-weight: 500;
            width: 100%;
            background: #ffffff;
            border-top: 1px solid #eceff1;
        }
    </style>
</head>
<body>

    <!-- Professional Header Navbar -->
    <div class="navbar">
        <h2>Sunrise Dental Clinic</h2>
    </div>

    <div class="main-wrapper">
        <div class="login-card">
            <div class="logo-area">
                <h2>Staff Portal</h2>
                <p>Secure System Authentication</p>
            </div>

            <div class="error-msg" id="errorBox">
                Invalid Username or Password! Access Denied.
            </div>

            <form action="LoginServlet" method="POST" onsubmit="return validateLogin()">
                <div class="input-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username">
                </div>

                <div class="input-group">
                    <label for="password">Password</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" placeholder="Enter your password">
                        <span class="toggle-password" onclick="togglePasswordVisibility()">
                            <!-- Eye Icon SVG -->
                            <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                        </span>
                    </div>
                </div>

                <button type="submit" class="login-btn">Secure Login</button>
            </form>

            <div class="info-note">
                <b>Note:</b> Authorized staff members only. Contact System Admin for credentials or account creation.
            </div>
        </div>
    </div>

    <!-- Customized Footer -->
    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br>
        Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>

    <script>
        function togglePasswordVisibility() {
            let passInput = document.getElementById("password");
            let eyeIcon = document.getElementById("eyeIcon");
            if (passInput.type === "password") {
                passInput.type = "text";
                eyeIcon.innerHTML = `<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line>`;
            } else {
                passInput.type = "password";
                eyeIcon.innerHTML = `<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle>`;
            }
        }

        function validateLogin() {
            let uname = document.getElementById("username").value.trim();
            let pass = document.getElementById("password").value.trim();
            let errorBox = document.getElementById("errorBox");
            if (uname === "" || pass === "") {
                errorBox.style.display = "block";
                errorBox.innerHTML = "Fields cannot be empty!";
                return false;
            }
            return true;
        }
    </script>
</body>
</html>