package com.webtechproject.dao;

import com.webtechproject.model.Event;
import com.webtechproject.model.Registration;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegistrationDAO {

    public boolean save(Registration registration) {
        String sql = "INSERT INTO registrations (user_id, event_id, ticket_type, price_paid, status) VALUES (?, ?, ?, ?, 'CONFIRMED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, registration.getUserId());
            stmt.setInt(2, registration.getEventId());
            stmt.setString(3, registration.getTicketType());
            stmt.setDouble(4, registration.getPricePaid());
            stmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean existsByUserAndEvent(int userId, int eventId) {
        String sql = "SELECT 1 FROM registrations WHERE user_id = ? AND event_id = ?";
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

    public int countByEventId(int eventId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE event_id = ? AND status != 'CANCELLED'";
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

    public List<Registration> findByUserId(int userId) {
        List<Registration> registrations = new ArrayList<>();
        String sql = "SELECT r.id, r.user_id, r.event_id, r.ticket_type, r.price_paid, r.status, r.registered_at, " +
                     "e.title, e.date_time, e.location, e.is_virtual " +
                     "FROM registrations r JOIN events e ON r.event_id = e.id " +
                     "WHERE r.user_id = ? ORDER BY r.registered_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Registration reg = new Registration();
                reg.setId(rs.getInt("id"));
                reg.setUserId(rs.getInt("user_id"));
                reg.setEventId(rs.getInt("event_id"));
                reg.setTicketType(rs.getString("ticket_type"));
                reg.setPricePaid(rs.getDouble("price_paid"));
                reg.setStatus(rs.getString("status"));
                reg.setRegisteredAt(rs.getTimestamp("registered_at").toLocalDateTime());

                Event event = new Event();
                event.setId(rs.getInt("event_id"));
                event.setTitle(rs.getString("title"));
                event.setDateTime(rs.getTimestamp("date_time").toLocalDateTime());
                event.setLocation(rs.getString("location"));
                event.setVirtual(rs.getBoolean("is_virtual"));
                reg.setEvent(event);

                registrations.add(reg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return registrations;
    }
}
