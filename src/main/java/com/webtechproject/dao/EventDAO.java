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

    public Event getEventById(int id) {
        String sql = "SELECT * FROM events WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            Class.forName("org.postgresql.Driver");
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Event event = new Event();
                event.setId(rs.getInt("id"));
                event.setTitle(rs.getString("title"));
                event.setDescription(rs.getString("description"));
                event.setDateTime(rs.getTimestamp("date_time").toLocalDateTime());
                event.setLocation(rs.getString("location"));
                event.setCapacity(rs.getInt("capacity"));
                event.setPrice(rs.getDouble("price"));
                event.setVirtual(rs.getBoolean("is_virtual"));
                return event;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean save(Event event) {
        String sql = "INSERT INTO events (title, description, date_time, location, capacity, price, is_virtual, organizer_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            Class.forName("org.postgresql.Driver");
            stmt.setString(1, event.getTitle());
            stmt.setString(2, event.getDescription());
            stmt.setTimestamp(3, Timestamp.valueOf(event.getDateTime()));
            stmt.setString(4, event.getLocation());
            stmt.setInt(5, event.getCapacity());
            stmt.setDouble(6, event.getPrice());
            stmt.setBoolean(7, event.isVirtual());
            stmt.setInt(8, event.getOrganizerId());
            stmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}