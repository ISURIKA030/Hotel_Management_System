package app.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Staff {
    private int id;
    private String name;
    private String duty;

    public Staff(int id, String name, String duty) {
        this.id = id;
        this.name = name;
        this.duty = duty;
    }

    public Staff(String name, String duty) {
        this.name = name;
        this.duty = duty;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDuty() {
        return duty;
    }

    public void setDuty(String duty) {
        this.duty = duty;
    }

    // Method to add a new staff worker
    public boolean addStaffworker() {
        boolean status = false;
        try {
            Connection con = DbConnector.getConnection();
            String query = "INSERT INTO staff (name, duty) VALUES (?, ?)";
            PreparedStatement pst = con.prepareStatement(query);

            pst.setString(1, this.name);
            pst.setString(2, this.duty);

            status = pst.executeUpdate() > 0;
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Method to delete a staff worker
    public static boolean deleteStaffworker(int id) {
        boolean status = false;
        try {
            Connection con = DbConnector.getConnection();
            String query = "DELETE FROM staff WHERE id=?";
            PreparedStatement pst = con.prepareStatement(query);

            pst.setInt(1, id);

            status = pst.executeUpdate() > 0;
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // Method to fetch all staff workers
    public static List<Staff> getAllStaff() {
        List<Staff> staffList = new ArrayList<>();
        try {
            Connection con = DbConnector.getConnection();
            String query = "SELECT * FROM staff";
            PreparedStatement pst = con.prepareStatement(query);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Staff staff = new Staff(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("duty")
                );
                staffList.add(staff);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return staffList;
    }
}