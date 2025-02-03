<%@ page import="app.classes.Reservation" %>
<%@ page import="app.classes.Payment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Handle delete request
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("delete") != null) {
        int id = Integer.parseInt(request.getParameter("delete"));
        boolean status = Reservation.deleteReservation(id);
        if (status) {
            out.println("<script>swal('Success!', 'Reservation deleted successfully!', 'success');</script>");
        } else {
            out.println("<script>swal('Error!', 'Failed to delete reservation!', 'error');</script>");
        }
    }

    // Handle edit request
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("save") != null) {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String roomType = request.getParameter("roomType");
        String bedType = request.getParameter("bedType");
        int noOfRooms = Integer.parseInt(request.getParameter("noOfRooms"));
        String meal = request.getParameter("meal");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        int price = Integer.parseInt(request.getParameter("price"));

        boolean status = Reservation.updateReservation(id, name, email, phone, roomType, bedType, noOfRooms, meal, checkIn, checkOut, price);
        if (status) {
            out.println("<script>swal('Success!', 'Reservation updated successfully!', 'success');</script>");
        } else {
            out.println("<script>swal('Error!', 'Failed to update reservation!', 'error');</script>");
        }
    }

    // Handle reservation form submission
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("guestdetailsubmit") != null) {
        String name = request.getParameter("Name");
        String email = request.getParameter("email");
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

    // Fetch all reservations
    List<Reservation> reservations = Reservation.getAllReservations();
%>
<%!
    // Function to calculate the number of days between two dates
    public long calculateNumberOfDays(String checkIn, String checkOut) {
        LocalDate checkInDate = LocalDate.parse(checkIn);
        LocalDate checkOutDate = LocalDate.parse(checkOut);
        return ChronoUnit.DAYS.between(checkInDate, checkOutDate);
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- boot -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <!-- fontowesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <!-- sweet alert -->
        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <link rel="stylesheet" href="./css/roombook.css">
        <title>Hotel - Admin</title>
    </head>
    <body>
        <!-- guestdetailpanel -->
        <div id="guestdetailpanel">
            <form action="" method="POST" class="guestdetailpanelform">
                <div class="head">
                    <h3>RESERVATION</h3>
                    <i class="fa-solid fa-circle-xmark" onclick="closebox()"></i>
                </div>
                <div class="middle">
                    <div class="guestinfo">
                        <h4>Guest information</h4>
                        <input type="text" name="Name" placeholder="Enter Full name" required>
                        <input type="email" name="email" placeholder="Enter Email" required>
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



        <div class="searchsection">
            <input type="text" name="search_bar" id="search_bar" placeholder="search..." onkeyup="searchFun()">
            <button class="adduser" id="adduser" onclick="openbookbox()"><i class="fa-solid fa-bookmark"></i> Add</button>
            <form action="" method="post">
                <button class="exportexcel" id="exportexcel" name="exportexcel" type="submit"><i class="fa-solid fa-file-arrow-down"></i></button>
            </form>
        </div>

        <!-- Edit Modal -->
        <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editModalLabel">Edit Reservation</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="editForm" action="roombook.jsp" method="POST">
                            <input type="hidden" name="id" id="editId">
                            <div class="mb-3">
                                <label for="editName" class="form-label">Name</label>
                                <input type="text" class="form-control" id="editName" name="name" required>
                            </div>
                            <div class="mb-3">
                                <label for="editEmail" class="form-label">Email</label>
                                <input type="email" class="form-control" id="editEmail" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="editPhone" class="form-label">Phone</label>
                                <input type="text" class="form-control" id="editPhone" name="phone" required>
                            </div>
                            <div class="mb-3">
                                <label for="editRoomType" class="form-label">Room Type</label>
                                <select class="form-control" id="editRoomType" name="roomType" required>
                                    <option value="Superior Room">SUPERIOR ROOM</option>
                                    <option value="Deluxe Room">DELUXE ROOM</option>
                                    <option value="Guest House">GUEST HOUSE</option>
                                    <option value="Single Room">SINGLE ROOM</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editBedType" class="form-label">Bed Type</label>
                                <select class="form-control" id="editBedType" name="bedType" required>
                                    <option value="Single">Single</option>
                                    <option value="Double">Double</option>
                                    <option value="Triple">Triple</option>
                                    <option value="Quad">Quad</option>
                                    <option value="None">None</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editNoOfRooms" class="form-label">No of Rooms</label>
                                <input type="number" class="form-control" id="editNoOfRooms" name="noOfRooms" required>
                            </div>
                            <div class="mb-3">
                                <label for="editMeal" class="form-label">Meal</label>
                                <select class="form-control" id="editMeal" name="meal" required>
                                    <option value="Room only">Room only</option>
                                    <option value="Breakfast">Breakfast</option>
                                    <option value="Half Board">Half Board</option>
                                    <option value="Full Board">Full Board</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editCheckIn" class="form-label">Check-In</label>
                                <input type="date" class="form-control" id="editCheckIn" name="checkIn" required>
                            </div>
                            <div class="mb-3">
                                <label for="editCheckOut" class="form-label">Check-Out</label>
                                <input type="date" class="form-control" id="editCheckOut" name="checkOut" required>
                            </div>
                            <div class="mb-3">
                                <label for="editPrice" class="form-label">Price</label>
                                <input type="number" class="form-control" id="editPrice" name="price" required>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <form method="POST">
                                    <button type="submit" name="save" class="btn btn-primary">Save changes</button>
                                </form>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Table and other content remain the same -->

        <div class="roombooktable" class="table-responsive-xl">
            <table class="table table-bordered" id="table-data">
                <thead>
                    <tr>
                        <th scope="col">Id</th>
                        <th scope="col">Name</th>
                        <th scope="col">Email</th>
                        <th scope="col">Phone</th>
                        <th scope="col">Type of Room</th>
                        <th scope="col">Type of Bed</th>
                        <th scope="col">No of Room</th>
                        <th scope="col">Meal</th>
                        <th scope="col">Check-In</th>
                        <th scope="col">Check-Out</th>
                        <th scope="col">No of Day</th>
                        <th scope="col">Status</th>
                        <th scope="col" class="action">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Reservation reservation : reservations) {%>
                    <tr>
                        <td><%= reservation.getId()%></td>
                        <td><%= reservation.getName()%></td>
                        <td><%= reservation.getEmail()%></td>
                        <td><%= reservation.getPhone()%></td>
                        <td><%= reservation.getRoomType()%></td>
                        <td><%= reservation.getBedType()%></td>
                        <td><%= reservation.getNoOfRooms()%></td>
                        <td><%= reservation.getMeal()%></td>
                        <td><%= reservation.getCheckIn()%></td>
                        <td><%= reservation.getCheckOut()%></td>
                        <td><%= calculateNumberOfDays(reservation.getCheckIn(), reservation.getCheckOut())%></td> <!-- Calculate number of days -->
                        <td>Confirm</td>
                        <td class="action">
                            <button class="btn btn-primary edit-btn" data-id="<%= reservation.getId()%>" data-name="<%= reservation.getName()%>" data-email="<%= reservation.getEmail()%>" data-phone="<%= reservation.getPhone()%>" data-roomtype="<%= reservation.getRoomType()%>" data-bedtype="<%= reservation.getBedType()%>" data-noofrooms="<%= reservation.getNoOfRooms()%>" data-meal="<%= reservation.getMeal()%>" data-checkin="<%= reservation.getCheckIn()%>" data-checkout="<%= reservation.getCheckOut()%>" data-price="<%= reservation.getPrice()%>">Edit</button>
                            <form action="roombook.jsp" method="POST" style="display:inline;">
                                <input type="hidden" name="delete" value="<%= reservation.getId()%>">
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% }%>
                </tbody>
            </table>
        </div>

        <!-- JavaScript to handle modal population -->
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

            document.addEventListener('DOMContentLoaded', function () {
                const editButtons = document.querySelectorAll('.edit-btn');
                const editModal = new bootstrap.Modal(document.getElementById('editModal'));

                editButtons.forEach(button => {
                    button.addEventListener('click', function () {
                        const id = button.getAttribute('data-id');
                        const name = button.getAttribute('data-name');
                        const email = button.getAttribute('data-email');
                        const phone = button.getAttribute('data-phone');
                        const roomType = button.getAttribute('data-roomtype');
                        const bedType = button.getAttribute('data-bedtype');
                        const noOfRooms = button.getAttribute('data-noofrooms');
                        const meal = button.getAttribute('data-meal');
                        const checkIn = button.getAttribute('data-checkin');
                        const checkOut = button.getAttribute('data-checkout');
                        const price = button.getAttribute('data-price');

                        document.getElementById('editId').value = id;
                        document.getElementById('editName').value = name;
                        document.getElementById('editEmail').value = email;
                        document.getElementById('editPhone').value = phone;
                        document.getElementById('editRoomType').value = roomType;
                        document.getElementById('editBedType').value = bedType;
                        document.getElementById('editNoOfRooms').value = noOfRooms;
                        document.getElementById('editMeal').value = meal;
                        document.getElementById('editCheckIn').value = checkIn;
                        document.getElementById('editCheckOut').value = checkOut;
                        document.getElementById('editPrice').value = price;

                        editModal.show();
                    });
                });
            });

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
    </body>
</html>