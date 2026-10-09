package com.college.lostfound.dao;

import com.college.lostfound.config.DBConnection;
import com.college.lostfound.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    // Ensures default admin exists
    private void ensureAdminExists() {
        String checkSql = "SELECT id FROM users WHERE username = 'admin'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                String insertAdmin = "INSERT INTO users (username, email, password) VALUES ('admin', 'admin@college.edu', 'admin123')";
                try (PreparedStatement insertPs = conn.prepareStatement(insertAdmin)) {
                    insertPs.executeUpdate();
                }
            }
        } catch (SQLException e) {
            // Ignore
        }
    }

    public String registerUser(String username, String email, String password) {
        if (username == null || username.trim().isEmpty() || email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            return "All fields are required.";
        }
        username = username.trim();
        email = email.trim();

        // Check if username already exists
        String checkUserSql = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkUserSql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return "Username @" + username + " is already taken. Please choose a different username (e.g. " + username + "99).";
            }
        } catch (SQLException e) {
            return "Connection check error: " + e.getMessage();
        }

        // Check if email already exists
        String checkEmailSql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkEmailSql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return "Email " + email + " is already registered! Please sign in or use a different email.";
            }
        } catch (SQLException e) {
            return "Connection check error: " + e.getMessage();
        }

        // Insert new user
        String sql = "INSERT INTO users (username, email, password) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            return ps.executeUpdate() > 0 ? "SUCCESS" : "Registration could not be completed. Try again.";
        } catch (SQLException e) {
            return "Registration error: " + e.getMessage();
        }
    }

    public User login(String identifier, String password) {
        ensureAdminExists();
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

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT id, username, email FROM users ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new User(rs.getInt("id"), rs.getString("username"), rs.getString("email")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ? AND username != 'admin'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
        return "Student";
    }
}
