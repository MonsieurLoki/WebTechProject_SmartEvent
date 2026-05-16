package com.webtechproject.dao;

import java.sql.*;

public class PaymentDAO {

    public boolean save(int registrationId, double amount) {
        String sql = "INSERT INTO payments (registration_id, amount, payment_status, provider, transaction_ref, paid_at) " +
                     "VALUES (?, ?, 'PAID', 'SIMULATED', ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, registrationId);
            stmt.setDouble(2, amount);
            stmt.setString(3, "SIM-" + System.currentTimeMillis());
            return stmt.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
