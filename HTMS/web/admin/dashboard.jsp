<%@ page import="app.classes.Payment" %>
<%@ page import="app.classes.Reservation" %>
<%@ page import="app.classes.Staff" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Fetch all payments
    List<Payment> payments = Payment.getAllPayments();

    // Fetch all reservations
    List<Reservation> reservations = Reservation.getAllReservations();

    // Fetch all staff
    List<Staff> staffList = Staff.getAllStaff();

    // Calculate total booked rooms
    int totalBookedRooms = 0;
    for (Payment payment : payments) {
        totalBookedRooms += payment.getNoOfRooms();
    }

    // Calculate total reservations
    int totalReservations = reservations.size();

    // Calculate total staff
    int totalStaff = staffList.size();

    // Calculate total profit
    double totalProfit = 0;
    for (Payment payment : payments) {
        totalProfit += (payment.getRoomRent() + payment.getBedRent() + payment.getMealPrice()) * payment.getNoOfRooms();
    }

    // Calculate room-wise bookings
    int superiorRooms = 0;
    int deluxeRooms = 0;
    int guestHouses = 0;
    int singleRooms = 0;

    for (Payment payment : payments) {
        if (payment.getRoomType().equals("Superior Room")) {
            superiorRooms += payment.getNoOfRooms();
        } else if (payment.getRoomType().equals("Deluxe Room")) {
            deluxeRooms += payment.getNoOfRooms();
        } else if (payment.getRoomType().equals("Guest House")) {
            guestHouses += payment.getNoOfRooms();
        } else if (payment.getRoomType().equals("Single Room")) {
            singleRooms += payment.getNoOfRooms();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./css/dashboard.css">
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <!-- Morris.js -->
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.css">
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
        <script src="//cdnjs.cloudflare.com/ajax/libs/morris.js/0.5.1/morris.min.js"></script>
        <title>Hotel - Admin</title>
    </head>
    <body>
        <div class="databox">
            <div class="box roombookbox">
                <h3>Total Booked Room</h2>  
                <h1><%= totalBookedRooms%> / 19</h1>
            </div>
            <div class="box guestbox">
                <h2>Total Reservations</h2>  
                <h1><%= totalReservations%></h1>
            </div>
            <div class="box profitbox">
                <h2>Total Staff</h2>  
                <h1><%= totalStaff%></h1>
            </div>
            <div class="box profitbox">
                <h2>Profit</h2>  
                <h2><span>RS. </span><%= String.format("%.2f", totalProfit)%></h2>
            </div>
        </div>
        <div class="chartbox">
            <div class="bookroomchart">
                <canvas id="bookroomchart"></canvas>
                <h3 style="text-align: center; margin: 10px 0;">Booked Room</h3>
            </div>
            <div class="profitchart">
                <div id="profitchart"></div>
                <h3 style="text-align: center; margin: 10px 0;">Profit</h3>
            </div>
        </div>

        <script>
            // Data for Chart.js (Booked Room Chart)
            const labels = [
                'Superior Room',
                'Deluxe Room',
                'Guest House',
                'Single Room',
            ];

            const data = {
                labels: labels,
                datasets: [{
                        label: 'Booked Rooms',
                        backgroundColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(255, 159, 64, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(153, 102, 255, 1)',
                        ],
                        borderColor: 'black',
                        data: [
            <%= superiorRooms%>,
            <%= deluxeRooms%>,
            <%= guestHouses%>,
            <%= singleRooms%>
                        ],
                    }]
            };

            const doughnutchart = {
                type: 'doughnut',
                data: data,
                options: {}
            };

            const myChart = new Chart(
                    document.getElementById('bookroomchart'),
                    doughnutchart
                    );
        </script>

        <script>
            // Data for Morris.js (Profit Chart)
            const profitData = [
                {date: '2023-10-01', profit: <%= totalProfit%>},
                        // Add more data points if needed
            ];

            Morris.Bar({
                element: 'profitchart',
                data: profitData,
                xkey: 'date',
                ykeys: ['profit'],
                labels: ['Profit'],
                hideHover: 'auto',
                stacked: true,
                barColors: [
                    'rgba(153, 102, 255, 1)',
                ]
            });
        </script>
    </body>
</html>