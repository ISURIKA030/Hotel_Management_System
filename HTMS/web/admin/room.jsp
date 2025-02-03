<%@ page import="app.classes.Room" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Handle add room request
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("addroom") != null) {
        String roomType = request.getParameter("troom");
        String bedType = request.getParameter("bed");

        Room newRoom = new Room(roomType, bedType);
        boolean status = newRoom.addRoom();
        if (status) {
            out.println("<script>Swal.fire('Success!', 'Room added successfully!', 'success');</script>");
        } else {
            out.println("<script>Swal.fire('Error!', 'Failed to add room!', 'error');</script>");
        }
    }

    // Handle delete room request
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("delete") != null) {
        int id = Integer.parseInt(request.getParameter("delete"));
        boolean status = Room.deleteRoom(id);
        if (status) {
            out.println("<script>Swal.fire('Success!', 'Room deleted successfully!', 'success');</script>");
        } else {
            out.println("<script>Swal.fire('Error!', 'Failed to delete room!', 'error');</script>");
        }
    }

    // Fetch all rooms
    List<Room> roomList = Room.getAllRoom();
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hotel - Admin</title>
        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- SweetAlert2 CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <link rel="stylesheet" href="css/room.css">
        <style>
            /* Base roombox style */
            .roombox {
                padding: 10px;
                margin: 10px;
                border-radius: 5px;
                text-align: center;
            }

            /* Room-specific colors */
            .roombox-superior {
                background-color: #ffcccc; /* Light red */
            }

            .roombox-deluxe {
                background-color: #ccffcc; /* Light green */
            }

            .roombox-guest {
                background-color: #ccccff; /* Light blue */
            }

            .roombox-single {
                background-color: #ffffcc; /* Light yellow */
            }
            .roombox:hover {
                transform: scale(1.05);
                transition: transform 0.3s ease;
            }
        </style>
    </head>
    <body>
        <div class="addroomsection">
            <form action="" method="POST">
                <label for="troom">Type of Room :</label>
                <select name="troom" class="form-control" required>
                    <option value selected disabled>Select Room Type</option>
                    <option value="Superior Room">SUPERIOR ROOM</option>
                    <option value="Deluxe Room">DELUXE ROOM</option>
                    <option value="Guest House">GUEST HOUSE</option>
                    <option value="Single Room">SINGLE ROOM</option>
                </select>

                <label for="bed">Type of Bed :</label>
                <select name="bed" class="form-control" required>
                    <option value selected disabled>Select Bed Type</option>
                    <option value="Single">Single</option>
                    <option value="Double">Double</option>
                    <option value="Triple">Triple</option>
                    <option value="Quad">Quad</option>
                    <option value="None">None</option>
                </select>

                <button type="submit" class="btn btn-success" name="addroom">Add Room</button>
            </form>
        </div>

        <div class="room">
            <% for (Room room : roomList) { %>
            <%
                // Determine the CSS class based on room type
                String roomTypeClass = "";

                if (room.getRoomType().equals("Superior Room")) {
                    roomTypeClass = "roombox-superior";
                } else if (room.getRoomType().equals("Deluxe Room")) {
                    roomTypeClass = "roombox-deluxe";
                } else if (room.getRoomType().equals("Guest House")) {
                    roomTypeClass = "roombox-guest";
                } else if (room.getRoomType().equals("Single Room")) {
                    roomTypeClass = "roombox-single";
                } else {
                    roomTypeClass = "roombox"; // Default class
                }

            %>
            <div class='roombox <%= roomTypeClass%>'>
                <div class='text-center no-boder'>
                    <i class='fa-solid fa-bed fa-4x mb-2'></i>
                    <h3><%= room.getRoomType()%></h3>
                    <div class='mb-1'><%= room.getBedType()%></div>
                    <form action="" method="POST" style="display:inline;">
                        <input type="hidden" name="delete" value="<%= room.getId()%>">
                        <button type="submit" class='btn btn-danger'>Delete</button>
                    </form>
                </div>
            </div>
            <% }%>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        <!-- SweetAlert2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    </body>
</html>