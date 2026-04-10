package com.webtechproject.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:postgresql://localhost:5432/smartevent";
    private static final String USER = "postgres";
    private static final String PASSWORD = "Loki2502!f";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}