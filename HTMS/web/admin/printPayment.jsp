<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="app.classes.Payment" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Print Payment Receipt</title>
        <style>
            body { font-family: Arial, sans-serif; padding: 20px; }
            .receipt { max-width: 800px; margin: 0 auto; }
            .table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
            .table th, .table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            .table th { background-color: #f8f9fa; }
            .text-center { text-align: center; }
            .signature { margin-top: 50px; }
        </style>
    </head>
    <body>
        <%
            String paymentId = request.getParameter("id");
            Payment payment = Payment.getPaymentById(Integer.parseInt(paymentId));

            if (payment != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                LocalDate checkIn = LocalDate.parse(payment.getCheckIn(), formatter);
                LocalDate checkOut = LocalDate.parse(payment.getCheckOut(), formatter);
                long days = java.time.temporal.ChronoUnit.DAYS.between(checkIn, checkOut);
                if (days < 0) days = 0;

                double totalBill = (payment.getRoomRent() + payment.getBedRent() + payment.getMealPrice()) * days * payment.getNoOfRooms();
        %>
        <div class="receipt">
            <h2 class="text-center">Hotel Payment Receipt</h2>
            <hr>
            <div>
                <strong>Date:</strong> <%= LocalDate.now().format(formatter) %><br>
                <strong>Receipt No:</strong> <%= payment.getId() %>
            </div>
            
            <div style="margin-bottom: 20px;">
                <strong>Guest Name:</strong> <%= payment.getUserName() %><br>
                <strong>Room Type:</strong> <%= payment.getRoomType() %><br>
                <strong>Bed Type:</strong> <%= payment.getBedType() %><br>
                <strong>Check In:</strong> <%= payment.getCheckIn() %><br>
                <strong>Check Out:</strong> <%= payment.getCheckOut() %><br>
                <strong>Number of Days:</strong> <%= days %><br>
                <strong>Number of Rooms:</strong> <%= payment.getNoOfRooms() %>
            </div>

            <table class="table">
                <tr>
                    <th>Description</th>
                    <th>Amount</th>
                </tr>
                <tr>
                    <td>Room Rent <%= payment.getRoomType() %></td>
                    <td>Rs. <%= payment.getRoomRent() * days * payment.getNoOfRooms() %></td>
                </tr>
                <tr>
                    <td>Bed Rent <%= payment.getBedType() %></td>
                    <td>Rs. <%= payment.getBedRent() * days * payment.getNoOfRooms() %></td>
                </tr>
                <tr>
                    <td>Meals</td>
                    <td>Rs. <%= payment.getMealPrice() * days * payment.getNoOfRooms() %></td>
                </tr>
                <tr style="font-weight: bold;">
                    <td>Total</td>
                    <td>Rs. <%= totalBill %></td>
                </tr>
            </table>

            <hr>
            <div class="text-center signature">
                <p>Thank you for your booking!</p>
                <p>____________________<br>Authorized Signature</p>
            </div>
        </div>
        <%
            } else {
        %>
        <div class="text-center">
            <h2>Payment not found!</h2>
        </div>
        <%
            }
        %>
        <script>
            window.print();
        </script>
    </body>
</html>