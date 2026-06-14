package com.webtechproject.dao;

import com.webtechproject.model.Event;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY date_time ASC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                events.add(mapEvent(rs));
            }
            
        } catch (SQLException e) {
            System.out.println("SQL ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        System.out.println("Events found: " + events.size());
        return events;
    }

    public List<Event> searchEvents(String keyword, String category) {
        List<Event> events = new ArrayList<>();
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM events WHERE 1=1");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title ILIKE ? OR description ILIKE ? OR location ILIKE ?)");
            String searchTerm = "%" + keyword.trim() + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        if (category != null && !category.trim().isEmpty() && !"All".equals(category)) {
            sql.append(" AND category = ?");
            params.add(category.trim());
        }

        sql.append(" ORDER BY date_time ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                events.add(mapEvent(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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
                return mapEvent(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean save(Event event) {
        String sql = "INSERT INTO events (title, description, date_time, location, capacity, price, is_virtual, organizer_id, category, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
            stmt.setString(9, event.getCategory());
            stmt.setString(10, event.getImageUrl());
            stmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Event event) {
        String sql = "UPDATE events SET title = ?, description = ?, date_time = ?, location = ?, capacity = ?, price = ?, is_virtual = ?, category = ?, image_url = ? WHERE id = ?";
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
            stmt.setString(8, event.getCategory());
            stmt.setString(9, event.getImageUrl());
            stmt.setInt(10, event.getId());
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteById(int id) {
        String sql = "DELETE FROM events WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            Class.forName("org.postgresql.Driver");
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Event mapEvent(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setId(rs.getInt("id"));
        event.setOrganizerId(rs.getInt("organizer_id"));
        event.setTitle(rs.getString("title"));
        event.setDescription(rs.getString("description"));
        event.setDateTime(rs.getTimestamp("date_time").toLocalDateTime());
        event.setLocation(rs.getString("location"));
        event.setCapacity(rs.getInt("capacity"));
        event.setPrice(rs.getDouble("price"));
        event.setVirtual(rs.getBoolean("is_virtual"));
        event.setCategory(rs.getString("category"));
        event.setImageUrl(rs.getString("image_url"));
        return event;
    }
}
