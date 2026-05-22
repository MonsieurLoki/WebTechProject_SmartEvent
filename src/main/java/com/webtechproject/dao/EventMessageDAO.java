package com.webtechproject.dao;

import com.webtechproject.model.EventMessage;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventMessageDAO {

    public int createMessage(EventMessage message) {
        String sql = "INSERT INTO event_messages (event_id, sender_id, receiver_id, parent_message_id, subject, message) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, message.getEventId());
            stmt.setInt(2, message.getSenderId());
            stmt.setInt(3, message.getReceiverId());
            if (message.getParentMessageId() == null) {
                stmt.setNull(4, Types.INTEGER);
            } else {
                stmt.setInt(4, message.getParentMessageId());
            }
            stmt.setString(5, message.getSubject());
            stmt.setString(6, message.getMessage());
            if (stmt.executeUpdate() == 0) return 0;
            try (ResultSet keys = stmt.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<EventMessage> getMessagesForUser(int userId) {
        List<EventMessage> messages = new ArrayList<>();
        String sql = baseSelect() +
                     "WHERE m.parent_message_id IS NULL AND " +
                     "(m.sender_id = ? OR m.receiver_id = ? OR EXISTS (" +
                     "  SELECT 1 FROM event_messages replies " +
                     "  WHERE replies.parent_message_id = m.id " +
                     "  AND (replies.sender_id = ? OR replies.receiver_id = ?)" +
                     ")) ORDER BY m.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);
            stmt.setInt(4, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(mapMessage(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return messages;
    }

    public List<EventMessage> getMessagesForOrganizer(int organizerId) {
        List<EventMessage> messages = new ArrayList<>();
        String sql = baseSelect() +
                     "WHERE m.parent_message_id IS NULL AND m.receiver_id = ? AND e.organizer_id = ? " +
                     "ORDER BY m.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, organizerId);
            stmt.setInt(2, organizerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(mapMessage(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return messages;
    }

    public List<EventMessage> getMessagesForEventAndUser(int eventId, int userId) {
        List<EventMessage> messages = new ArrayList<>();
        String sql = baseSelect() +
                     "WHERE m.event_id = ? AND (m.sender_id = ? OR m.receiver_id = ?) " +
                     "ORDER BY m.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(mapMessage(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return messages;
    }

    public List<EventMessage> getRepliesForMessage(int parentMessageId) {
        List<EventMessage> replies = new ArrayList<>();
        String sql = baseSelect() + "WHERE m.parent_message_id = ? ORDER BY m.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, parentMessageId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    replies.add(mapMessage(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return replies;
    }

    public EventMessage getMessageById(int messageId) {
        String sql = baseSelect() + "WHERE m.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, messageId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapMessage(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean markAsRead(int messageId, int userId) {
        String sql = "UPDATE event_messages SET is_read = TRUE, read_at = CURRENT_TIMESTAMP " +
                     "WHERE id = ? AND receiver_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, messageId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countUnreadMessages(int userId) {
        String sql = "SELECT COUNT(*) FROM event_messages WHERE receiver_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int replyToMessage(EventMessage reply) {
        return createMessage(reply);
    }

    private String baseSelect() {
        return "SELECT m.id, m.event_id, m.sender_id, m.receiver_id, m.parent_message_id, " +
               "m.subject, m.message, m.is_read, m.created_at, m.read_at, " +
               "e.title AS event_title, s.full_name AS sender_name, s.email AS sender_email, " +
               "r.full_name AS receiver_name " +
               "FROM event_messages m " +
               "JOIN events e ON m.event_id = e.id " +
               "JOIN users s ON m.sender_id = s.id " +
               "JOIN users r ON m.receiver_id = r.id ";
    }

    private EventMessage mapMessage(ResultSet rs) throws SQLException {
        EventMessage message = new EventMessage();
        message.setId(rs.getInt("id"));
        message.setEventId(rs.getInt("event_id"));
        message.setSenderId(rs.getInt("sender_id"));
        message.setReceiverId(rs.getInt("receiver_id"));
        int parentId = rs.getInt("parent_message_id");
        if (!rs.wasNull()) {
            message.setParentMessageId(parentId);
        }
        message.setSubject(rs.getString("subject"));
        message.setMessage(rs.getString("message"));
        message.setRead(rs.getBoolean("is_read"));
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            message.setCreatedAt(createdAt.toLocalDateTime());
        }
        Timestamp readAt = rs.getTimestamp("read_at");
        if (readAt != null) {
            message.setReadAt(readAt.toLocalDateTime());
        }
        message.setEventTitle(rs.getString("event_title"));
        message.setSenderName(rs.getString("sender_name"));
        message.setSenderEmail(rs.getString("sender_email"));
        message.setReceiverName(rs.getString("receiver_name"));
        return message;
    }
}
