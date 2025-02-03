<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page import="app.classes.Reservation" %>
<%@ page import="app.classes.Payment" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Handle reservation form submission
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("guestdetailsubmit") != null) {
        String name = request.getParameter("Name");
        String email = (String) session.getAttribute("email");
        String phone = request.getParameter("Phone");
        String roomType = request.getParameter("RoomType");
        String bedType = request.getParameter("Bed");
        int noOfRooms = Integer.parseInt(request.getParameter("NoofRoom"));
        String meal = request.getParameter("Meal");
        String checkIn = request.getParameter("cin");
        String checkOut = request.getParameter("cout");
        int price = Integer.parseInt(request.getParameter("price"));

        // Save reservation
        Reservation newRes = new Reservation(name, email, phone, roomType, bedType, noOfRooms, meal, checkIn, checkOut, price);
        boolean reservationStatus = newRes.saveReservation();

        if (reservationStatus) {
            // Calculate payment details
            double roomRent = 0, bedRent = 0, mealPrice = 0;

            if ("Superior Room".equals(roomType)) {
                roomRent = 25000;
            } else if ("Deluxe Room".equals(roomType)) {
                roomRent = 18000;
            } else if ("Guest House".equals(roomType)) {
                roomRent = 15000;
            } else if ("Single Room".equals(roomType)) {
                roomRent = 10000;
            }

            if ("Single".equals(bedType)) {
                bedRent = 500;
            } else if ("Double".equals(bedType)) {
                bedRent = 1200;
            } else if ("Triple".equals(bedType)) {
                bedRent = 1700;
            } else if ("Quad".equals(bedType)) {
                bedRent = 2500;
            } else if ("None".equals(bedType)) {
                bedRent = 0;
            }

            if ("Room only".equals(meal)) {
                mealPrice = 0;
            } else if ("Breakfast".equals(meal)) {
                mealPrice = 700;
            } else if ("Half Board".equals(meal)) {
                mealPrice = 2300;
            } else if ("Full Board".equals(meal)) {
                mealPrice = 4900;
            }

            // Calculate number of days
            long noOfDays = calculateNumberOfDays(checkIn, checkOut);

            // Calculate total price
            double totalPrice = (roomRent + bedRent + mealPrice) * noOfRooms * noOfDays;

            // Fix: Correct type conversion for session attribute
            Integer userIdObj = (Integer) session.getAttribute("userId");
            int userId = (userIdObj != null) ? userIdObj : 0;

            Payment newPayment = new Payment(userId, email, name, roomType, bedType, checkIn, checkOut, noOfRooms, roomRent, bedRent, mealPrice);
            boolean paymentStatus = newPayment.addPayment();

            if (paymentStatus) {
                out.println("<script>swal('Success!', 'Reservation and payment saved successfully!', 'success');</script>");
            } else {
                out.println("<script>swal('Error!', 'Reservation saved, but payment failed!', 'error');</script>");
            }
        } else {
            out.println("<script>swal('Error!', 'Failed to save reservation!', 'error');</script>");
        }
    }

    // Handle logout logic
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("logout") != null) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }

    // Get all payments
    List<Payment> payments = Payment.getAllPaymentsByEmail((String) session.getAttribute("email"));
    request.setAttribute("payments", payments);

    // Create date formatter
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    request.setAttribute("dateFormatter", formatter);
%>
<%!
    // Function to calculate the number of days between two dates
    public long calculateNumberOfDays(String checkIn, String checkOut) {
        if (checkIn == null || checkOut == null || checkIn.isEmpty() || checkOut.isEmpty()) {
            return 0;
        }

        java.time.LocalDate checkInDate = java.time.LocalDate.parse(checkIn);
        java.time.LocalDate checkOutDate = java.time.LocalDate.parse(checkOut);

        return java.time.temporal.ChronoUnit.DAYS.between(checkInDate, checkOutDate);
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./css/home.css">
        <title>Hotel</title>
        <!-- boot -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <!-- fontowesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer"/>
        <!-- sweet alert -->
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <link rel="stylesheet" href="./admin/css/roombook.css">
        <style>
            #guestdetailpanel{
                display: none;
            }
            #guestdetailpanel .middle{
                height: 450px;
            }
            .price-display {
                margin-top: 10px;
                font-size: 18px;
                font-weight: bold;
                color: green;
            }
            thead {
                background-color: black;
                color: white;
            } 
        </style>
    </head>

    <body>
        <nav>
            <div class="logo">
                <p>Hotel Management System</p>
            </div>
            <ul style="display: flex; align-items: center; gap: 30px; list-style: none; padding: 0;">
                <li><a href="#firstsection">Home</a></li>
                <li><a href="#secondsection">Rooms</a></li>
                <li><a href="#thirdsection">Facilities</a></li>
                <li><a href="#fourthsection">My Bookings</a></li>
                <li><a href="#contactus">Contact Us</a></li>
                <li>
                    <form action="home.jsp" method="POST">
                        <button type="submit" name="logout" class="btn btn-danger">Logout</button>
                    </form>
                </li>
            </ul>

        </nav>

        <section id="firstsection" class="carousel slide carousel_section" data-bs-ride="carousel">
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

                <div class="welcomeline">
                    <h1 class="welcometag">Welcome to heaven on earth</h1>
                </div>

                <!-- bookbox -->
                <div id="guestdetailpanel">
                    <form action="" method="POST" class="guestdetailpanelform">
                        <div class="head">
                            <h3>RESERVATION</h3>
                            <i class="fa-solid fa-circle-xmark" onclick="closebox()"></i>
                        </div>
                        <div class="middle">
                            <div class="guestinfo">
                                <h4>Enter your information</h4>
                                <input type="text" name="Name" placeholder="Enter Full name" required>
                                <input type="text" name="Phone" placeholder="Enter Phone no" required>
                            </div>

                            <div class="line"></div>

                            <div class="reservationinfo">
                                <h4>Reservation information</h4>
                                <select name="RoomType" class="selectinput" required onchange="calculatePrice()">
                                    <option value="">Type Of Room</option>
                                    <option value="Superior Room">SUPERIOR ROOM</option>
                                    <option value="Deluxe Room">DELUXE ROOM</option>
                                    <option value="Guest House">GUEST HOUSE</option>
                                    <option value="Single Room">SINGLE ROOM</option>
                                </select>
                                <select name="Bed" class="selectinput" required onchange="calculatePrice()">
                                    <option value="">Bedding Type</option>
                                    <option value="Single">Single</option>
                                    <option value="Double">Double</option>
                                    <option value="Triple">Triple</option>
                                    <option value="Quad">Quad</option>
                                    <option value="None">None</option>
                                </select>
                                <select name="NoofRoom" class="selectinput" required onchange="calculatePrice()">
                                    <option value="">No of Room</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                </select>
                                <select name="Meal" class="selectinput" required onchange="calculatePrice()">
                                    <option value="">Meal</option>
                                    <option value="Room only">Room only</option>
                                    <option value="Breakfast">Breakfast</option>
                                    <option value="Half Board">Half Board</option>
                                    <option value="Full Board">Full Board</option>
                                </select>
                                <div class="datesection">
                                    <span>
                                        <label for="cin"> Check-In</label>
                                        <input name="cin" type="date" required>
                                    </span>
                                    <span>
                                        <label for="cout"> Check-Out</label>
                                        <input name="cout" type="date" required>
                                    </span>
                                </div>
                                <div class="price-display">
                                    <h3>
                                        Total Price: Rs. <span id="totalPrice">0</span>
                                    </h3>
                                </div>
                                <input type="hidden" name="price" id="price" value="0">
                            </div>
                        </div>
                        <div class="footer">
                            <button class="btn btn-success" name="guestdetailsubmit">Submit</button>
                        </div>
                    </form>
                </div>

            </div>
        </section>

        <section id="secondsection"> 
            <img src="./image/homeanimatebg.svg">
            <div class="ourroom">
                <h1 class="head">Our room</h1>
                <div class="roomselect">
                    <div class="roombox">
                        <div class="hotelphoto h1"></div>
                        <div class="roomdata">
                            <h2>Superior Room</h2>
                            <div class="services">
                                <i class="fa-solid fa-wifi"></i>
                                <i class="fa-solid fa-burger"></i>
                                <i class="fa-solid fa-spa"></i>
                                <i class="fa-solid fa-dumbbell"></i>
                                <i class="fa-solid fa-person-swimming"></i>
                            </div>
                            <button class="btn btn-primary bookbtn" onclick="openbookbox()">Book</button>
                        </div>
                    </div>
                    <div class="roombox">
                        <div class="hotelphoto h2"></div>
                        <div class="roomdata">
                            <h2>Delux Room</h2>
                            <div class="services">
                                <i class="fa-solid fa-wifi"></i>
                                <i class="fa-solid fa-burger"></i>
                                <i class="fa-solid fa-spa"></i>
                                <i class="fa-solid fa-dumbbell"></i>
                            </div>
                            <button class="btn btn-primary bookbtn" onclick="openbookbox()">Book</button>
                        </div>
                    </div>
                    <div class="roombox">
                        <div class="hotelphoto h3"></div>
                        <div class="roomdata">
                            <h2>Guest Room</h2>
                            <div class="services">
                                <i class="fa-solid fa-wifi"></i>
                                <i class="fa-solid fa-burger"></i>
                                <i class="fa-solid fa-spa"></i>
                            </div>
                            <button class="btn btn-primary bookbtn" onclick="openbookbox()">Book</button>
                        </div>
                    </div>
                    <div class="roombox">
                        <div class="hotelphoto h4"></div>
                        <div class="roomdata">
                            <h2>Single Room</h2>
                            <div class="services">
                                <i class="fa-solid fa-wifi"></i>
                                <i class="fa-solid fa-burger"></i>
                            </div>
                            <button class="btn btn-primary bookbtn" onclick="openbookbox()">Book</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="thirdsection">
            <h1 class="head"> Facilities </h1>
            <div class="facility">
                <div class="box">
                    <h2>Swiming pool</h2>
                </div>
                <div class="box">
                    <h2>Spa</h2>
                </div>
                <div class="box">
                    <h2>Restaurants</h2>
                </div>
                <div class="box">
                    <h2>Gym</h2>
                </div>
                <div class="box">
                    <h2>Heli service</h2>
                </div>
            </div>
        </section>

        <section id="fourthsection">
            <h1 class="head"> My Bookings </h1>

            <div class="table-responsive-lg">
                <table class="table table-bordered" id="table-data">
                    <thead class="">
                        <tr>
                            <th scope="col">Id</th>
                            <th scope="col">Name</th>
                            <th scope="col">Room Type</th>
                            <th scope="col">Bed Type</th>
                            <th scope="col">Check In</th>
                            <th scope="col">Check Out</th>
                            <th scope="col">No of Days</th>
                            <th scope="col">No of Room</th>
                            <th scope="col">Room Rent</th>
                            <th scope="col">Bed Rent</th>
                            <th scope="col">Meals</th>
                            <th scope="col">Total Bill</th>
                        </tr>
                    </thead>

                    <tbody>
                        <%
                            for (Payment payment : payments) {
                                String checkInStr = payment.getCheckIn();
                                String checkOutStr = payment.getCheckOut();

                                LocalDate checkIn = LocalDate.parse(checkInStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                                LocalDate checkOut = LocalDate.parse(checkOutStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));

                                long days = ChronoUnit.DAYS.between(checkIn, checkOut);
                                if (days < 0) {
                                    days = 0; // Ensure non-negative days
                                }

                                int noOfRooms = payment.getNoOfRooms();
                                double roomRent = payment.getRoomRent();
                                double bedRent = payment.getBedRent();
                                double mealPrice = payment.getMealPrice();

                                double totalRoomRent = roomRent * days * noOfRooms;
                                double totalBedRent = bedRent * days * noOfRooms;
                                double totalMealPrice = mealPrice * days * noOfRooms;
                                double totalBill = totalRoomRent + totalBedRent + totalMealPrice;
                        %>
                        <tr>
                            <td><%= payment.getId()%></td>
                            <td><%= payment.getUserName()%></td>
                            <td><%= payment.getRoomType()%></td>
                            <td><%= payment.getBedType()%></td>
                            <td><%= payment.getCheckIn()%></td>
                            <td><%= payment.getCheckOut()%></td>
                            <td><%= days%></td>
                            <td><%= noOfRooms%></td>
                            <td><%= totalRoomRent%></td>
                            <td><%= totalBedRent%></td>
                            <td><%= totalMealPrice%></td>
                            <td><%= totalBill%></td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
        </section>

        <section id="contactus">
            <div class="social">
                <i class="fa-brands fa-instagram"></i>
                <i class="fa-brands fa-facebook"></i>
                <i class="fa-solid fa-envelope"></i>
            </div>
            <div class="createdby">
                <h6>Copyright Â© 2024 All About Web Co. All rights reserved</h6>
            </div>
        </section>
    </body>

    <script>
        var bookbox = document.getElementById("guestdetailpanel");

        openbookbox = () => {
            bookbox.style.display = "flex";
        };
        closebox = () => {
            bookbox.style.display = "none";
        };

        // Price calculation logic
        function calculatePrice() {
            const roomType = document.querySelector('select[name="RoomType"]').value;
            const bedType = document.querySelector('select[name="Bed"]').value;
            const noOfRooms = parseInt(document.querySelector('select[name="NoofRoom"]').value) || 0; // Default to 0 if invalid
            const meal = document.querySelector('select[name="Meal"]').value;
            const checkIn = document.querySelector('input[name="cin"]').value;
            const checkOut = document.querySelector('input[name="cout"]').value;

            // Define base prices for each option
            const roomPrices = {
                "Superior Room": 25000,
                "Deluxe Room": 18000,
                "Guest House": 15000,
                "Single Room": 10000
            };

            const bedPrices = {
                "Single": 500,
                "Double": 1200,
                "Triple": 1700,
                "Quad": 2500,
                "None": 0
            };

            const mealPrices = {
                "Room only": 0,
                "Breakfast": 700,
                "Half Board": 2300,
                "Full Board": 4900
            };

            // Calculate total price
            const roomPrice = roomPrices[roomType] || 0; // Default to 0 if roomType is not selected
            const bedPrice = bedPrices[bedType] || 0; // Default to 0 if bedType is not selected
            const mealPrice = mealPrices[meal] || 0; // Default to 0 if meal is not selected

            // Calculate number of days
            const noOfDays = calculateNumberOfDays(checkIn, checkOut);

            // Calculate total price
            const totalPrice = (roomPrice + bedPrice + mealPrice) * noOfRooms * noOfDays;

            // Update the displayed price
            document.getElementById('totalPrice').textContent = totalPrice || 0; // Default to 0 if totalPrice is NaN
            document.getElementById('price').value = totalPrice || 0; // Default to 0 if totalPrice is NaN
        }

        // Function to calculate the number of days between two dates
        function calculateNumberOfDays(checkIn, checkOut) {
            if (!checkIn || !checkOut)
                return 0; // Return 0 if dates are not selected

            const checkInDate = new Date(checkIn);
            const checkOutDate = new Date(checkOut);

            // Calculate the difference in milliseconds
            const timeDifference = checkOutDate - checkInDate;

            // Convert milliseconds to days
            const noOfDays = Math.ceil(timeDifference / (1000 * 60 * 60 * 24));

            return noOfDays > 0 ? noOfDays : 0; // Ensure positive number of days
        }

        // Attach event listeners to all dropdowns
        document.querySelectorAll('select').forEach(select => {
            select.addEventListener('change', calculatePrice);
        });

        // Attach event listeners to date inputs
        document.querySelectorAll('input[type="date"]').forEach(input => {
            input.addEventListener('change', calculatePrice);
        });

        // Initialize price calculation on page load
        calculatePrice();
    </script>
</html>