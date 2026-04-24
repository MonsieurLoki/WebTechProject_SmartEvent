package com.webtechproject.dao;

import com.webtechproject.model.OrganizerRequest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrganizerRequestDAO {

    public boolean hasPendingOrApprovedRequest(int userId) {
        String sql = "SELECT 1 FROM organizer_requests WHERE user_id = ? AND status IN ('PENDING', 'APPROVED')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean save(int userId) {
        // upsert: if a rejected request exists, re-open it
        String sql = "INSERT INTO organizer_requests (user_id) VALUES (?) " +
                     "ON CONFLICT (user_id) DO UPDATE SET status = 'PENDING', " +
                     "requested_at = CURRENT_TIMESTAMP, reviewed_at = NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<OrganizerRequest> findPending() {
        List<OrganizerRequest> list = new ArrayList<>();
        String sql = "SELECT r.id, r.user_id, r.status, r.requested_at, u.full_name, u.email " +
                     "FROM organizer_requests r JOIN users u ON r.user_id = u.id " +
                     "WHERE r.status = 'PENDING' ORDER BY r.requested_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                OrganizerRequest req = new OrganizerRequest();
                req.setId(rs.getInt("id"));
                req.setUserId(rs.getInt("user_id"));
                req.setStatus(rs.getString("status"));
                req.setRequestedAt(rs.getTimestamp("requested_at").toLocalDateTime());
                req.setUserFullName(rs.getString("full_name"));
                req.setUserEmail(rs.getString("email"));
                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean approve(int userId) {
        return updateRequestStatus(userId, "APPROVED") && updateUserRole(userId, "ORGANIZER");
    }

    public boolean reject(int userId) {
        return updateRequestStatus(userId, "REJECTED");
    }

    private boolean updateRequestStatus(int userId, String status) {
        String sql = "UPDATE organizer_requests SET status = ?, reviewed_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean updateUserRole(int userId, String role) {
        String sql = "UPDATE users SET role = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
