package com.college.lostfound.dao;

import com.college.lostfound.config.DBConnection;
import com.college.lostfound.model.Message;
import com.college.lostfound.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatDAO {
    public boolean saveMessage(int itemId, int senderId, int receiverId, String content) {
        String sql = "INSERT INTO messages (item_id, sender_id, receiver_id, content) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setInt(2, senderId);
            ps.setInt(3, receiverId);
            ps.setString(4, content);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getChatHistory(int itemId, int user1, int user2) {
        List<Message> list = new ArrayList<>();
        String sql;
        if (user1 == user2) {
            // Allows testing self-chat
            sql = "SELECT m.*, u.username FROM messages m JOIN users u ON m.sender_id = u.id " +
                  "WHERE m.item_id = ? AND m.sender_id = ? ORDER BY m.sent_at ASC";
        } else {
            sql = "SELECT m.*, u.username FROM messages m JOIN users u ON m.sender_id = u.id " +
                  "WHERE m.item_id = ? AND ((m.sender_id = ? AND m.receiver_id = ?) OR (m.sender_id = ? AND m.receiver_id = ?)) " +
                  "ORDER BY m.sent_at ASC";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setInt(2, user1);
            if (user1 != user2) {
                ps.setInt(3, user2);
                ps.setInt(4, user2);
                ps.setInt(5, user1);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Message msg = new Message();
                msg.setId(rs.getInt("id"));
                msg.setItemId(rs.getInt("item_id"));
                msg.setSenderId(rs.getInt("sender_id"));
                msg.setReceiverId(rs.getInt("receiver_id"));
                msg.setSenderUsername(rs.getString("username"));
                msg.setContent(rs.getString("content"));
                Timestamp ts = rs.getTimestamp("sent_at");
                msg.setSentAt(ts != null ? ts.toString() : "");
                list.add(msg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Fetches all users who have sent a message regarding this item to the owner
    public List<User> getChatPartnersForItem(int itemId, int ownerId) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT DISTINCT u.id, u.username, u.email FROM messages m " +
                     "JOIN users u ON (CASE WHEN m.sender_id = ? THEN m.receiver_id ELSE m.sender_id END) = u.id " +
                     "WHERE m.item_id = ? AND u.id != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setInt(2, itemId);
            ps.setInt(3, ownerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new User(rs.getInt("id"), rs.getString("username"), rs.getString("email")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
