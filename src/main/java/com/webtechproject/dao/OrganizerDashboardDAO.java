package com.webtechproject.dao;

import com.webtechproject.model.EventStats;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrganizerDashboardDAO {

    public List<EventStats> getEventStats(int organizerId) {
        List<EventStats> stats = new ArrayList<>();
        String sql = "SELECT e.id, e.title, e.date_time, e.location, e.is_virtual, e.capacity, " +
                     "COUNT(r.id) AS registrations, COALESCE(SUM(r.price_paid), 0) AS revenue " +
                     "FROM events e " +
                     "LEFT JOIN registrations r ON r.event_id = e.id AND r.status = 'CONFIRMED' " +
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
                stats.add(es);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
}
