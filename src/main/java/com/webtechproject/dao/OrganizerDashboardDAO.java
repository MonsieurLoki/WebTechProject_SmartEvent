package com.webtechproject.dao;

import com.webtechproject.model.Attendee;
import com.webtechproject.model.EventStats;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrganizerDashboardDAO {

    public List<EventStats> getEventStats(int organizerId) {
        List<EventStats> stats = new ArrayList<>();
        String sql = "SELECT e.id, e.title, e.date_time, e.location, e.is_virtual, e.capacity, " +
                     "COUNT(DISTINCT r.id) AS registrations, COALESCE(SUM(r.price_paid), 0) AS revenue, " +
                     "COALESCE(AVG(f.rating), 0) AS avg_rating, COUNT(DISTINCT f.id) AS rating_count " +
                     "FROM events e " +
                     "LEFT JOIN registrations r ON r.event_id = e.id AND r.status = 'CONFIRMED' " +
                     "LEFT JOIN feedback f ON f.event_id = e.id " +
                     "WHERE e.organizer_id = ? " +
                     "GROUP BY e.id, e.title, e.date_time, e.location, e.is_virtual, e.capacity " +
                     "ORDER BY e.date_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, organizerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                EventStats es = new EventStats();
                es.setId(rs.getInt("id"));
                es.setTitle(rs.getString("title"));
                es.setDateTime(rs.getTimestamp("date_time").toLocalDateTime());
                es.setLocation(rs.getString("location"));
                es.setVirtual(rs.getBoolean("is_virtual"));
                es.setCapacity(rs.getInt("capacity"));
                es.setRegistrations(rs.getInt("registrations"));
                es.setRevenue(rs.getDouble("revenue"));
                es.setAvgRating(rs.getDouble("avg_rating"));
                es.setRatingCount(rs.getInt("rating_count"));
                stats.add(es);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<Attendee> getAttendeesForEvent(int eventId, int organizerId) {
        List<Attendee> attendees = new ArrayList<>();
        String sql = "SELECT u.full_name, u.email, r.registered_at, r.price_paid " +
                     "FROM registrations r " +
                     "JOIN users u ON u.id = r.user_id " +
                     "JOIN events e ON e.id = r.event_id " +
                     "WHERE r.event_id = ? AND e.organizer_id = ? AND r.status = 'CONFIRMED' " +
                     "ORDER BY r.registered_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            stmt.setInt(2, organizerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Attendee a = new Attendee();
                a.setFullName(rs.getString("full_name"));
                a.setEmail(rs.getString("email"));
                a.setRegisteredAt(rs.getTimestamp("registered_at").toLocalDateTime());
                a.setPricePaid(rs.getDouble("price_paid"));
                attendees.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return attendees;
    }
}
