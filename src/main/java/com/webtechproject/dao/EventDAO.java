package com.webtechproject.dao;

import com.webtechproject.model.Event;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Event event = new Event();
                event.setId(rs.getInt("id"));
                event.setTitle(rs.getString("title"));
                event.setDescription(rs.getString("description"));
                event.setDateTime(rs.getTimestamp("date_time").toLocalDateTime());
                event.setLocation(rs.getString("location"));
                event.setCapacity(rs.getInt("capacity"));
                event.setPrice(rs.getDouble("price"));
                event.setVirtual(rs.getBoolean("is_virtual"));
                events.add(event);
            }

        } catch (SQLException e) {
            System.out.println("SQL ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Events found: " + events.size());
        return events;
    }
}