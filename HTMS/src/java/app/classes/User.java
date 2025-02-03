package app.classes;

import java.sql.*;

public class User {

    private int id;
    private String username;
    private String email;
    private String password;
    private String user_type;

    // Constructors
    public User() {
    }

    public User(String username, String email, String password, String user_type) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.user_type = user_type;
    }
    

    public User(int id, String username, String email, String password, String user_type) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.user_type = user_type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUser_type() {
        return user_type;
    }

    public void setUser_type(String user_type) {
        this.user_type = user_type;
    }

    public boolean registerUser(User user) {
        String query = "INSERT INTO users (username, email, password, user_type) VALUES (?, ?, ?, ?)";
        try (Connection conn = DbConnector.getConnection();
                PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setString(1, user.getUsername());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPassword()); // In production, hash password
            pst.setString(4, user.getUser_type());

            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User authenticateUser(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DbConnector.getConnection();
                PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setString(1, email);
            pst.setString(2, password); // In production, verify hashed password

            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setUser_type(rs.getString("user_type"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
