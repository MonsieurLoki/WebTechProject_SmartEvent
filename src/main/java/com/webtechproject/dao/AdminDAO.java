package com.webtechproject.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {

    public int countUsers() {
        return countQuery("SELECT COUNT(*) FROM users");
    }

    public int countOrganizers() {
        return countQuery("SELECT COUNT(*) FROM users WHERE role = 'ORGANIZER'");
    }

    public int countEvents() {
        return countQuery("SELECT COUNT(*) FROM events");
    }

    public int countRegistrations() {
        return countQuery("SELECT COUNT(*) FROM registrations");
    }

    public List<OrganizerRow> getAllOrganizers() {
        List<OrganizerRow> list = new ArrayList<>();
        String sql = "SELECT u.id, u.full_name, u.email, " +
                     "COUNT(DISTINCT e.id) AS event_count, " +
                     "COUNT(DISTINCT r.id) AS registration_count " +
                     "FROM users u " +
                     "LEFT JOIN events e ON e.organizer_id = u.id " +
                     "LEFT JOIN registrations r ON r.event_id = e.id " +
                     "WHERE u.role = 'ORGANIZER' " +
                     "GROUP BY u.id, u.full_name, u.email " +
                     "ORDER BY u.full_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                OrganizerRow row = new OrganizerRow(
                    rs.getInt("id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getInt("event_count"),
                    rs.getInt("registration_count")
                );
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<EventRow> getAllEvents() {
        List<EventRow> list = new ArrayList<>();
        String sql = "SELECT e.id, e.title, e.date_time, e.location, e.is_virtual, " +
                     "u.full_name AS organizer_name, " +
                     "COUNT(r.id) AS registration_count, e.capacity " +
                     "FROM events e " +
                     "JOIN users u ON u.id = e.organizer_id " +
                     "LEFT JOIN registrations r ON r.event_id = e.id " +
                     "GROUP BY e.id, e.title, e.date_time, e.location, e.is_virtual, u.full_name " +
                     "ORDER BY e.date_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String dt = rs.getTimestamp("date_time").toLocalDateTime().toString().replace("T", " ").substring(0, 16);
                EventRow row = new EventRow(
                    rs.getInt("id"),
                    rs.getString("title"),
                    dt,
                    rs.getString("location"),
                    rs.getBoolean("is_virtual"),
                    rs.getString("organizer_name"),
                    rs.getInt("registration_count"),
                    rs.getInt("capacity")
                );
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean revokeOrganizer(int userId) {
        String sql = "UPDATE users SET role = 'ATTENDEE' WHERE id = ? AND role = 'ORGANIZER'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private int countQuery(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static class OrganizerRow {
        private final int id;
        private final String fullName;
        private final String email;
        private final int eventCount;
        private final int registrationCount;

        public OrganizerRow(int id, String fullName, String email, int eventCount, int registrationCount) {
            this.id = id;
            this.fullName = fullName;
            this.email = email;
            this.eventCount = eventCount;
            this.registrationCount = registrationCount;
        }

        public int getId() { return id; }
        public String getFullName() { return fullName; }
        public String getEmail() { return email; }
        public int getEventCount() { return eventCount; }
        public int getRegistrationCount() { return registrationCount; }
    }

    public static class EventRow {
        private final int id;
        private final String title;
        private final String dateTime;
        private final String location;
        private final boolean isVirtual;
        private final String organizerName;
        private final int registrationCount;
        private final int capacity;

        public EventRow(int id, String title, String dateTime, String location,
                        boolean isVirtual, String organizerName, int registrationCount, int capacity) {
            this.id = id;
            this.title = title;
            this.dateTime = dateTime;
            this.location = location;
            this.isVirtual = isVirtual;
            this.organizerName = organizerName;
            this.registrationCount = registrationCount;
            this.capacity = capacity;
        }

        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getDateTime() { return dateTime; }
        public String getLocation() { return location; }
        public boolean isVirtual() { return isVirtual; }
        public String getOrganizerName() { return organizerName; }
        public int getRegistrationCount() { return registrationCount; }
        public int getCapacity() { return capacity; }
    }
}
