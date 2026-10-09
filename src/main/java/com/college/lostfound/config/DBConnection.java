package com.college.lostfound.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Cloud and Local environment variables support
    private static final String URL = System.getenv("DB_URL") != null 
        ? System.getenv("DB_URL") 
        : "jdbc:mysql://localhost:3306/college_lost_found?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = System.getenv("DB_USER") != null 
        ? System.getenv("DB_USER") 
        : "root";
    private static final String PASS = System.getenv("DB_PASS") != null 
        ? System.getenv("DB_PASS") 
        : "root";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
