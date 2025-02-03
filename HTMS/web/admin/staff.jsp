<%@ page import="app.classes.Staff" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Handle add staff worker request
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("addstaff") != null) {
        String name = request.getParameter("staffname");
        String duty = request.getParameter("staffwork");

        Staff newStaff = new Staff(name, duty);
        boolean status = newStaff.addStaffworker();
        if (status) {
            out.println("<script>Swal.fire('Success!', 'Staff worker added successfully!', 'success');</script>");
        } else {
            out.println("<script>Swal.fire('Error!', 'Failed to add staff worker!', 'error');</script>");
        }
    }

    // Handle delete staff worker request
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("delete") != null) {
        int id = Integer.parseInt(request.getParameter("delete"));
        boolean status = Staff.deleteStaffworker(id);
        if (status) {
            out.println("<script>Swal.fire('Success!', 'Staff worker deleted successfully!', 'success');</script>");
        } else {
            out.println("<script>Swal.fire('Error!', 'Failed to delete staff worker!', 'error');</script>");
        }
    }

    // Fetch all staff workers
    List<Staff> staffList = Staff.getAllStaff();
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
            .roombox {
                background-color: #d1d7ff;
                padding: 10px;
                margin: 10px;
                border-radius: 5px;
                text-align: center;
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
                <label for="troom">Name :</label>
                <input type="text" name="staffname" class="form-control" required>

                <label for="bed">Work :</label>
                <select name="staffwork" class="form-control" required>
                    <option value selected disabled>Select Duty</option>
                    <option value="Manager">Manager</option>
                    <option value="Cook">Cook</option>
                    <option value="Helper">Helper</option>
                    <option value="cleaner">Cleaner</option>
                    <option value="weighter">Weighter</option>
                </select>

                <button type="submit" class="btn btn-success" name="addstaff">Add Staffworker</button>
            </form>
        </div>

        <div class="room">
            <% for (Staff staff : staffList) {%>
            <div class='roombox'>
                <div class='text-center no-boder'>
                    <i class='fa fa-users fa-5x'></i>
                    <h3><%= staff.getName()%></h3>
                    <div class='mb-1'><%= staff.getDuty()%></div>
                    <form action="" method="POST" style="display:inline;">
                        <input type="hidden" name="delete" value="<%= staff.getId()%>">
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