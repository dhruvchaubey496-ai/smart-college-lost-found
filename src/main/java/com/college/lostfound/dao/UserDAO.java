package com.college.lostfound.dao;

import com.college.lostfound.config.DBConnection;
import com.college.lostfound.model.User;
import java.sql.*;

public class UserDAO {
    public boolean registerUser(String username, String email, String password) {
        String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User login(String identifier, String password) {
        // Can login with username or email
        String sql = "SELECT id, username, email FROM users WHERE (username = ? OR email = ?) AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, identifier);
            ps.setString(2, identifier);
            ps.setString(3, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("id"), rs.getString("username"), rs.getString("email"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getUsernameById(int id) {
        String sql = "SELECT username FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("username");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Unknown";
    }
}
