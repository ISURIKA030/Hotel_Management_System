<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="app.classes.Payment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hotel - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"/>
        <link rel="stylesheet" href="css/roombook.css">

        <style>
            @media print {
                .no-print {
                    display: none !important;
                }
                .action {
                    display: none !important;
                }
            }
            .toast {
                position: fixed;
                top: 20px;
                right: 20px;
                background: #333;
                color: white;
                padding: 15px;
                border-radius: 5px;
                display: none;
            }
        </style>
    </head>

    <body>
        <%
            // Handle delete operation if requested
            String deleteId = request.getParameter("delete");
            if (deleteId != null) {
                Payment payment = new Payment(0, 0, "", "", "", "", "", "", 0, 0, 0, 0);
                boolean deleted = payment.deletePayment(Integer.parseInt(deleteId));
                if (deleted) {
        %><div id="toast" class="toast">Payment deleted successfully</div><%
                }
            }

            // Get all payments
            List<Payment> payments = Payment.getAllPayments();
            request.setAttribute("payments", payments);

            // Create date formatter
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            request.setAttribute("dateFormatter", formatter);
        %>

        <div class="searchsection no-print">
            <input type="text" name="search_bar" id="search_bar" placeholder="search..." onkeyup="searchFun()">
        </div>

        <div class="roombooktable table-responsive-xl">
            <table class="table table-bordered" id="table-data">
                <thead>
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
                        <th scope="col" class="action">Action</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="payment" items="${payments}">
                        <%
                            Payment payment = (Payment) pageContext.getAttribute("payment");
                            String checkInStr = payment.getCheckIn();
                            String checkOutStr = payment.getCheckOut();

                            LocalDate checkIn = LocalDate.parse(checkInStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                            LocalDate checkOut = LocalDate.parse(checkOutStr, DateTimeFormatter.ofPattern("yyyy-MM-dd"));

                            long days = ChronoUnit.DAYS.between(checkIn, checkOut);
                            if (days < 0) {
                                days = 0; // Ensure non-negative days
                            }
                            pageContext.setAttribute("numberOfDays", days);
                        %>

                        <c:set var="totalBill" value="${(payment.roomRent + payment.bedRent + payment.mealPrice) * numberOfDays * payment.noOfRooms }" />

                        <tr id="row-<%=payment.getId()%>">
                            <td>${payment.id}</td>
                            <td>${payment.userName}</td>
                            <td>${payment.roomType}</td>
                            <td>${payment.bedType}</td>
                            <td>${payment.checkIn}</td>
                            <td>${payment.checkOut}</td>
                            <td>${numberOfDays}</td>
                            <td>${payment.noOfRooms}</td>
                            <td>${payment.roomRent * numberOfDays * payment.noOfRooms}</td>
                            <td>${payment.bedRent * numberOfDays * payment.noOfRooms}</td>
                            <td>${payment.mealPrice * numberOfDays * payment.noOfRooms}</td>
                            <td>${totalBill}</td>
                            <td class="action">
                                <a href="printPayment.jsp?id=${payment.id}" class="btn btn-primary">
                                    <i class="fa-solid fa-print"></i> Print
                                </a>
                                <button class="btn btn-danger" onclick="deletePayment(${payment.id})">
                                    Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <script>
            // Search functionality
            const searchFun = () => {
                let filter = document.getElementById('search_bar').value.toUpperCase();
                let myTable = document.getElementById("table-data");
                let tr = myTable.getElementsByTagName('tr');

                for (var i = 1; i < tr.length; i++) {
                    let td = tr[i].getElementsByTagName('td')[1];
                    if (td) {
                        let textvalue = td.textContent || td.innerHTML;
                        if (textvalue.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }

            // Delete functionality
            function deletePayment(paymentId) {
                if (confirm('Are you sure you want to delete this payment?')) {
                    // Create form and submit it
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'payment.jsp';

                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'delete';
                    input.value = paymentId;

                    form.appendChild(input);
                    document.body.appendChild(form);
                    form.submit();
                }
            }

            // Show toast message if exists
            const toast = document.getElementById('toast');
            if (toast) {
                toast.style.display = 'block';
                setTimeout(() => {
                    toast.style.display = 'none';
                }, 3000);
            }
        </script>
    </body>
</html>