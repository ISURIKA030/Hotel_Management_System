package app.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Room {
    private int id;
    private String roomType;
    private String bedType;

    public Room(int id, String roomType, String bedType) {
        this.id = id;
        this.roomType = roomType;
        this.bedType = bedType;
    }

    public Room(String roomType, String bedType) {
        this.roomType = roomType;
        this.bedType = bedType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
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

    // Method to add a new room
    public boolean addRoom() {
        boolean status = false;
        try {
            Connection con = DbConnector.getConnection();
            String query = "INSERT INTO room (room_type, bed_type) VALUES (?, ?)";
            PreparedStatement pst = con.prepareStatement(query);

            pst.setString(1, this.roomType);
            pst.setString(2, this.bedType);

            status = pst.executeUpdate() > 0;
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Method to delete a room
    public static boolean deleteRoom(int id) {
        boolean status = false;
        try {
            Connection con = DbConnector.getConnection();
            String query = "DELETE FROM room WHERE id=?";
            PreparedStatement pst = con.prepareStatement(query);

            pst.setInt(1, id);

            status = pst.executeUpdate() > 0;
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Method to fetch all rooms
    public static List<Room> getAllRoom() {
        List<Room> roomList = new ArrayList<>();
        try {
            Connection con = DbConnector.getConnection();
            String query = "SELECT * FROM room";
            PreparedStatement pst = con.prepareStatement(query);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Room room = new Room(
                    rs.getInt("id"),
                    rs.getString("room_type"),
                    rs.getString("bed_type")
                );
                roomList.add(room);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roomList;
    }
}