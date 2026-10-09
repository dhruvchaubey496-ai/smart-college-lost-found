package com.college.lostfound.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Cloud TiDB MySQL connection
    private static final String URL = System.getenv("DB_URL") != null 
        ? System.getenv("DB_URL") 
        : "jdbc:mysql://gateway01.ap-northeast-1.prod.aws.tidbcloud.com:4000/college_lost_found?sslMode=VERIFY_IDENTITY";
    private static final String USER = System.getenv("DB_USER") != null 
        ? System.getenv("DB_USER") 
        : "6hgBg6iaANQdFjs.root";
    private static final String PASS = System.getenv("DB_PASS") != null 
        ? System.getenv("DB_PASS") 
        : "31bT4jY7NeOtCova";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
                 java.sql.Statement st = conn.createStatement()) {
                st.execute("ALTER TABLE messages MODIFY COLUMN content MEDIUMTEXT");
            } catch (Exception ignored) {
            }
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
