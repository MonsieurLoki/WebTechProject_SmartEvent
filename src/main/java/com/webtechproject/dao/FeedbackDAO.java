package com.webtechproject.dao;

import com.webtechproject.model.Feedback;
import com.webtechproject.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean save(Feedback feedback) {
        String sql = "INSERT INTO feedback (user_id, event_id, rating, comment) " +
                     "SELECT ?, ?, ?, ? FROM events WHERE id = ? AND date_time < CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, feedback.getUserId());
            stmt.setInt(2, feedback.getEventId());
            stmt.setInt(3, feedback.getRating());
            stmt.setString(4, feedback.getComment());
            stmt.setInt(5, feedback.getEventId());
            return stmt.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Feedback findByUserAndEvent(int userId, int eventId) {
        String sql = "SELECT f.id, f.user_id, f.event_id, f.rating, f.comment, f.created_at " +
                     "FROM feedback f WHERE f.user_id = ? AND f.event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapFeedback(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Feedback> findByEventId(int eventId) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.id, f.user_id, f.event_id, f.rating, f.comment, f.created_at, " +
                     "u.full_name, u.email, u.role " +
                     "FROM feedback f JOIN users u ON f.user_id = u.id " +
                     "WHERE f.event_id = ? ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Feedback feedback = mapFeedback(rs);
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                feedback.setUser(user);
                feedbackList.add(feedback);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public double getAverageRatingByEventId(int eventId) {
        String sql = "SELECT COALESCE(AVG(rating), 0) FROM feedback WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countByEventId(int eventId) {
        String sql = "SELECT COUNT(*) FROM feedback WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean isEventFinished(int eventId) {
        String sql = "SELECT 1 FROM events WHERE id = ? AND date_time < CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean canUserLeaveFeedback(int userId, int eventId) {
        String sql = "SELECT 1 " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "LEFT JOIN feedback f ON f.user_id = r.user_id AND f.event_id = r.event_id " +
                     "WHERE r.user_id = ? " +
                     "AND r.event_id = ? " +
                     "AND u.role = 'ATTENDEE' " +
                     "AND r.status = 'CONFIRMED' " +
                     "AND r.registered_at < e.date_time " +
                     "AND e.date_time < CURRENT_TIMESTAMP " +
                     "AND f.id IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, eventId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Feedback mapFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getInt("id"));
        feedback.setUserId(rs.getInt("user_id"));
        feedback.setEventId(rs.getInt("event_id"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setComment(rs.getString("comment"));
        feedback.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        return feedback;
    }
}
