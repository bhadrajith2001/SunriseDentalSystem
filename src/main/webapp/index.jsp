<%@ page import="com.sunrisedental.sunrisedentalsystem.models.User" %>
<%
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
    <title>Sunrise Dental Clinic - Login</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
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
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 420px;
            text-align: center;
            transition: transform 0.3s ease;
        }
        .login-card:hover {
            transform: translateY(-5px);
        }
        .logo-area { margin-bottom: 30px; }
        .logo-area h2 {
            color: #00796b;
            font-weight: 600;
            font-size: 1.8rem;
            margin-bottom: 5px;
        }
        .logo-area p { color: #546e7a; font-size: 0.95rem; }

        .input-group {
            margin-bottom: 22px;
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
        }
        <% if ("invalid".equals(request.getParameter("error"))) { %>
        .error-msg { display: block; }
        <% } %>

        .footer {
            text-align: center;
            padding: 20px;
            color: #607d8b;
            font-size: 0.85rem;
            font-weight: 500;
            width: 100%;
        }
    </style>

</head>
<body>

    <div class="main-wrapper">
        <div class="login-card">
            <div class="logo-area">
                <h2>Sunrise Dental</h2>
                <p>Authorized Staff Portal</p>
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
                    <input type="password" id="password" name="password" placeholder="Enter your password">
                </div>

                <button type="submit" class="login-btn">Secure Login</button>
            </form>
        </div>
    </div>

    <!-- Customized Footer -->
    <div class="footer">
        Sunrise Dental Management System &copy; 2026 <br>
        Designed By: <b>Badrajith D Kumarasinghe</b>
    </div>

    <script>
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