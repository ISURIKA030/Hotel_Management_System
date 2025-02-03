/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package app.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Shashin Malinda
 */
public class Payment {

    private int id;
    private int userId;
    private String email;
    private String userName;
    private String roomType;
    private String bedType;
    private String checkIn;
    private String checkOut;
    private int noOfRooms;
    private double roomRent;
    private double bedRent;
    private double mealPrice;

    public Payment(int id, int userId, String email, String userName, String roomType, String bedType, String checkIn, String checkOut, int noOfRooms, double roomRent, double bedRent, double mealPrice) {
        this.id = id;
        this.userId = userId;
        this.userName = userName;
        this.roomType = roomType;
        this.bedType = bedType;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.noOfRooms = noOfRooms;
        this.roomRent = roomRent;
        this.bedRent = bedRent;
        this.mealPrice = mealPrice;
    }

    public Payment(int userId, String email, String userName, String roomType, String bedType, String checkIn, String checkOut, int noOfRooms, double roomRent, double bedRent, double mealPrice) {
        this.userId = userId;
        this.email = email;
        this.userName = userName;
        this.roomType = roomType;
        this.bedType = bedType;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.noOfRooms = noOfRooms;
        this.roomRent = roomRent;
        this.bedRent = bedRent;
        this.mealPrice = mealPrice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
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

    public double getRoomRent() {
        return roomRent;
    }

    public void setRoomRent(double roomRent) {
        this.roomRent = roomRent;
    }

    public double getBedRent() {
        return bedRent;
    }

    public void setBedRent(double bedRent) {
        this.bedRent = bedRent;
    }

    public double getMealPrice() {
        return mealPrice;
    }

    public void setMealPrice(double mealPrice) {
        this.mealPrice = mealPrice;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean addPayment() {
        boolean status = false;
        try {
            Connection con = DbConnector.getConnection();
            String query = "INSERT INTO payment (user_id, email, user_name, room_type, bed_type, check_in, check_out, no_of_rooms, room_rent, bed_rent, meal_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);

            pst.setInt(1, this.userId);
            pst.setString(2, this.email);
            pst.setString(3, this.userName);
            pst.setString(4, this.roomType);
            pst.setString(5, this.bedType);
            pst.setString(6, this.checkIn);
            pst.setString(7, this.checkOut);
            pst.setInt(8, this.noOfRooms);
            pst.setDouble(9, this.roomRent);
            pst.setDouble(10, this.bedRent);
            pst.setDouble(11, this.mealPrice);

            status = pst.executeUpdate() > 0;
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public boolean deletePayment(int paymentId) {
        boolean status = false;
        try {
            Connection con = DbConnector.getConnection();
            String query = "DELETE FROM payment WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, paymentId);

            status = pst.executeUpdate() > 0;
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    public static List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        try {
            Connection con = DbConnector.getConnection();
            String query = "SELECT * FROM payment";
            PreparedStatement pst = con.prepareStatement(query);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Payment payment = new Payment(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("email"),
                        rs.getString("user_name"),
                        rs.getString("room_type"),
                        rs.getString("bed_type"),
                        rs.getString("check_in"),
                        rs.getString("check_out"),
                        rs.getInt("no_of_rooms"),
                        rs.getDouble("room_rent"),
                        rs.getDouble("bed_rent"),
                        rs.getDouble("meal_price")
                );
                payments.add(payment);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payments;
    }

    public static List<Payment> getAllPaymentsByEmail(String email) {
        List<Payment> payments = new ArrayList<>();
        try {
            Connection con = DbConnector.getConnection();
            String query = "SELECT * FROM payment WHERE email = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Payment payment = new Payment(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("email"),
                        rs.getString("user_name"),
                        rs.getString("room_type"),
                        rs.getString("bed_type"),
                        rs.getString("check_in"),
                        rs.getString("check_out"),
                        rs.getInt("no_of_rooms"),
                        rs.getDouble("room_rent"),
                        rs.getDouble("bed_rent"),
                        rs.getDouble("meal_price")
                );
                payments.add(payment);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payments;
    }

    public static Payment getPaymentById(int paymentId) {
        Payment payment = null;
        try {
            Connection con = DbConnector.getConnection();
            String query = "SELECT * FROM payment WHERE id = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setInt(1, paymentId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                payment = new Payment(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("email"),
                        rs.getString("user_name"),
                        rs.getString("room_type"),
                        rs.getString("bed_type"),
                        rs.getString("check_in"),
                        rs.getString("check_out"),
                        rs.getInt("no_of_rooms"),
                        rs.getDouble("room_rent"),
                        rs.getDouble("bed_rent"),
                        rs.getDouble("meal_price")
                );
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payment;
    }

}
