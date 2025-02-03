<%@ page import="java.sql.*" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page import="app.classes.User" %>
<%
    Connection con = DbConnector.getConnection();
    if (con == null) {
        out.println("Database connection failed");
        return;
    }
    
    String username = request.getParameter("Username");
    String email = request.getParameter("Email");
    String password = request.getParameter("Password");
    String message = "";
    String user_type = "user";
    
    
     if (request.getParameter("user_login_submit") != null) {
        User user = new User();
        user = user.authenticateUser(email, password);
        
        if (user != null && "user".equals(user.getUser_type())) {
            session.setAttribute("email", email);
            response.sendRedirect("home.jsp");
            return;
        } 
        else if (user != null && "admin".equals(user.getUser_type())) {
            session.setAttribute("user", user);
            response.sendRedirect("admin/admin.jsp");
            return;
        }
        else {
            message = "Invalid email or password";
        }
    }
    
    if (request.getParameter("user_signup_submit") != null) {
        User newUser = new User(username, email, password, user_type);
        boolean success = newUser.registerUser(newUser);
        if (success) {
            response.sendRedirect("index.jsp");
            return;
        } else {
            message = "Registration failed. Please try again.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./css/login.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <!-- sweet alert -->
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <!-- aos animation -->
    <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
    <!-- loading bar -->
    <script src="https://cdn.jsdelivr.net/npm/pace-js@latest/pace.min.js"></script>
    <link rel="stylesheet" href="./css/flash.css">
    <title>Hotel Management System</title>
</head>

<body>
    <!--  carousel -->
    <section id="carouselExampleControls" class="carousel slide carousel_section" data-bs-ride="carousel">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img class="carousel-image" src="./image/hotel01.jpg">
            </div>
            <div class="carousel-item">
                <img class="carousel-image" src="./image/hotel02.jpg">
            </div>
            <div class="carousel-item">
                <img class="carousel-image" src="./image/hotel03.jpg">
            </div>
            <div class="carousel-item">
                <img class="carousel-image" src="./image/hotel4.jpg">
            </div>
        </div>
    </section>

    <!-- main section -->
    <section id="auth_section">

        <div class="logo">
            <p>Hotel Management System</p>
        </div>

        <div class="auth_container">
            <!--============ login =============-->

            <div id="Log_in">
                <h2>Log In</h2>

                <form class="user_login authsection active" id="userlogin" action="index.jsp" method="POST">
                    <div class="form-floating">
                        <input type="email" class="form-control" name="Email" placeholder=" ">
                        <label for="Email">Email</label>
                    </div>
                    <div class="form-floating">
                        <input type="password" class="form-control" name="Password" placeholder=" ">
                        <label for="Password">Password</label>
                    </div>
                    <button type="submit" name="user_login_submit" class="auth_btn">Log in</button>
                    <p><%= message %></p>
                    <div class="footer_line">
                        <h6>Don't have an account? <span class="page_move_btn" onclick="signuppage()">sign up</span></h6>
                    </div>
                </form>
            </div>

            <div id="sign_up">
                <h2>Sign Up</h2>

                <form class="user_signup" id="usersignup" action="index.jsp" method="POST">
                    <div class="form-floating">
                        <input type="text" class="form-control" name="Username" placeholder=" ">
                        <label for="Username">Username</label>
                    </div>
                    <div class="form-floating">
                        <input type="email" class="form-control" name="Email" placeholder=" ">
                        <label for="Email">Email</label>
                    </div>
                    <div class="form-floating">
                        <input type="password" class="form-control" name="Password" placeholder=" ">
                        <label for="Password">Password</label>
                    </div>
                    <button type="submit" name="user_signup_submit" class="auth_btn">Sign up</button>
                    <p><%= message %></p>
                    <div class="footer_line">
                        <h6>Already have an account? <span class="page_move_btn" onclick="loginpage()">Log in</span></h6>
                    </div>
                </form>
            </div>
    </section>
</body>

<script src="./javascript/index.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
    AOS.init();
</script>
</html>