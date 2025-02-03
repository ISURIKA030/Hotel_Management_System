package app.classes;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DbConnector {
    private static final String driver = "com.mysql.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/hotel_system";
    private static final String dbuser = "root";
    private static final String dbpw = "";
    
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName(driver);
            con = DriverManager.getConnection(URL, dbuser, dbpw);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DbConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
        return con;
    }
    
}
