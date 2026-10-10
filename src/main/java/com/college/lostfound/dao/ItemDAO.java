package com.college.lostfound.dao;

import com.college.lostfound.config.DBConnection;
import com.college.lostfound.model.Item;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {
    public boolean addItem(Item item) {
        String sql = "INSERT INTO items (title, category, type, classroom, description, user_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getTitle());
            ps.setString(2, item.getCategory());
            ps.setString(3, item.getType());
            ps.setString(4, item.getClassroom());
            ps.setString(5, item.getDescription());
            ps.setInt(6, item.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Item> getOfficialAdminNotices() {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT i.*, u.username FROM items i JOIN users u ON i.user_id = u.id " +
                     "WHERE i.status = 'OPEN' AND (u.username = 'admin' OR i.title LIKE '%OFFICIAL%') " +
                     "AND i.title != 'Campus Central Admin Helpdesk' " +
                     "ORDER BY i.created_at DESC LIMIT 6";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setTitle(rs.getString("title"));
                item.setCategory(rs.getString("category"));
                item.setType(rs.getString("type"));
                item.setClassroom(rs.getString("classroom"));
                item.setDescription(rs.getString("description"));
                item.setUserId(rs.getInt("user_id"));
                item.setFinderUsername(rs.getString("username"));
                item.setStatus(rs.getString("status"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Item> getItems(String keyword, String category, String type) {
        List<Item> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT i.*, u.username FROM items i JOIN users u ON i.user_id = u.id " +
            "WHERE i.status = 'OPEN' AND i.title != 'Campus Central Admin Helpdesk' "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (i.title LIKE ? OR i.classroom LIKE ? OR i.description LIKE ?) ");
        }
        if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
            sql.append("AND i.category = ? ");
        }
        if (type != null && !type.trim().isEmpty() && !"ALL".equalsIgnoreCase(type)) {
            sql.append("AND i.type = ? ");
        }
        sql.append("ORDER BY i.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String search = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, search);
                ps.setString(paramIndex++, search);
                ps.setString(paramIndex++, search);
            }
            if (category != null && !category.trim().isEmpty() && !"ALL".equalsIgnoreCase(category)) {
                ps.setString(paramIndex++, category);
            }
            if (type != null && !type.trim().isEmpty() && !"ALL".equalsIgnoreCase(type)) {
                ps.setString(paramIndex++, type);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setTitle(rs.getString("title"));
                item.setCategory(rs.getString("category"));
                item.setType(rs.getString("type"));
                item.setClassroom(rs.getString("classroom"));
                item.setDescription(rs.getString("description"));
                item.setUserId(rs.getInt("user_id"));
                item.setFinderUsername(rs.getString("username"));
                item.setStatus(rs.getString("status"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Item> getAllItemsForAdmin() {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT i.*, u.username FROM items i JOIN users u ON i.user_id = u.id ORDER BY i.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setTitle(rs.getString("title"));
                item.setCategory(rs.getString("category"));
                item.setType(rs.getString("type"));
                item.setClassroom(rs.getString("classroom"));
                item.setDescription(rs.getString("description"));
                item.setUserId(rs.getInt("user_id"));
                item.setFinderUsername(rs.getString("username"));
                item.setStatus(rs.getString("status"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateItemStatus(int id, String status) {
        String sql = "UPDATE items SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteItem(int id) {
        String sql = "DELETE FROM items WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Item getItemById(int id) {
        String sql = "SELECT i.*, u.username FROM items i JOIN users u ON i.user_id = u.id WHERE i.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setTitle(rs.getString("title"));
                item.setCategory(rs.getString("category"));
                item.setType(rs.getString("type"));
                item.setClassroom(rs.getString("classroom"));
                item.setDescription(rs.getString("description"));
                item.setUserId(rs.getInt("user_id"));
                item.setFinderUsername(rs.getString("username"));
                item.setStatus(rs.getString("status"));
                item.setCreatedAt(rs.getTimestamp("created_at"));
                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getOrCreateAdminHelpdeskItemId(int adminUserId) {
        String selectSql = "SELECT id FROM items WHERE title = 'Campus Central Admin Helpdesk' AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setInt(1, adminUserId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String insertSql = "INSERT INTO items (title, category, type, classroom, description, user_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "Campus Central Admin Helpdesk");
            ps.setString(2, "Other");
            ps.setString(3, "FOUND");
            ps.setString(4, "Admin Block - Gate 1 Security Desk");
            ps.setString(5, "Official direct communication channel for student inquiries, reporting campus lost/found disputes, and reaching administration.");
            ps.setInt(6, adminUserId);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }
}
