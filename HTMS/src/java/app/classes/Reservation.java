package app.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Shashin Malinda
 */
public class Reservation {

    private String name, email, phone, roomType, bedType, meal, checkIn, checkOut;
    private int id, noOfRooms, price;

    // Constructor
    public Reservation(String name, String email, String phone, String roomType, String bedType, int noOfRooms, String meal, String checkIn, String checkOut, int price) {
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.roomType = roomType;
        this.bedType = bedType;
        this.noOfRooms = noOfRooms;
        this.meal = meal;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.price = price;
    }

    public Reservation(int id, String name, String email, String phone, String roomType, String bedType, int noOfRooms, String meal, String checkIn, String checkOut, int price) {
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.roomType = roomType;
        this.bedType = bedType;
        this.meal = meal;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.id = id;
        this.noOfRooms = noOfRooms;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public String getBedType() {
        return bedType;
    }

    public void setBedType(String bedType) {
        this.bedType = bedType;
    }

    public String getMeal() {
        return meal;
    }

    public void setMeal(String meal) {
        this.meal = meal;
    }

    public String getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(String checkIn) {
        this.checkIn = checkIn;
    }

    public String getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(String checkOut) {
        this.checkOut = checkOut;
    }

    public int getNoOfRooms() {
        return noOfRooms;
    }

    public void setNoOfRooms(int noOfRooms) {
        this.noOfRooms = noOfRooms;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    // Save reservation to the database
    public boolean saveReservation() {
        boolean status = false;
        Connection con = null;
        PreparedStatement pst = null;
        try {
            con = DbConnector.getConnection();
            String query = "INSERT INTO reservations (name, email, phone, room_type, bed_type, no_of_rooms, meal, check_in, check_out, price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pst = con.prepareStatement(query);

            pst.setString(1, this.name);
            pst.setString(2, this.email);
            pst.setString(3, this.phone);
            pst.setString(4, this.roomType);
            pst.setString(5, this.bedType);
            pst.setInt(6, this.noOfRooms);
            pst.setString(7, this.meal);
            pst.setString(8, this.checkIn);
            pst.setString(9, this.checkOut);
            pst.setInt(10, this.price);

            status = pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (pst != null) {
                    pst.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }

    // Method to fetch all reservations from the database
    public static List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();
        try {
            Connection con = DbConnector.getConnection();
            String query = "SELECT * FROM reservations";
            PreparedStatement pst = con.prepareStatement(query);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Reservation reservation = new Reservation(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("room_type"),
                        rs.getString("bed_type"),
                        rs.getInt("no_of_rooms"),
                        rs.getString("meal"),
                        rs.getString("check_in"),
                        rs.getString("check_out"),
                        rs.getInt("price")
                );
                reservations.add(reservation);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return reservations;
    }

    // Method to update a reservation
    public static boolean updateReservation(int id, String name, String email, String phone, String roomType, String bedType, int noOfRooms, String meal, String checkIn, String checkOut, int price) {
        boolean status = false;
        try {
            Connection con = DbConnector.getConnection();
            String query = "UPDATE reservations SET name=?, email=?, phone=?, room_type=?, bed_type=?, no_of_rooms=?, meal=?, check_in=?, check_out=?, price=? WHERE id=?";
            PreparedStatement pst = con.prepareStatement(query);

            pst.setString(1, name);
            pst.setString(2, email);
            pst.setString(3, phone);
            pst.setString(4, roomType);
            pst.setString(5, bedType);
            pst.setInt(6, noOfRooms);
            pst.setString(7, meal);
            pst.setString(8, checkIn);
            pst.setString(9, checkOut);
            pst.setInt(10, price);
            pst.setInt(11, id);

            status = pst.executeUpdate() > 0;
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Method to delete a reservation
    public static boolean deleteReservation(int id) {
        boolean status = false;
        try {
            Connection con = DbConnector.getConnection();
            String query = "DELETE FROM reservations WHERE id=?";
            PreparedStatement pst = con.prepareStatement(query);

            pst.setInt(1, id);

            status = pst.executeUpdate() > 0;
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }
}
