package com.webtechproject.model;

import java.time.LocalDateTime;

public class EventStats {
    private int id;
    private String title;
    private LocalDateTime dateTime;
    private String location;
    private boolean isVirtual;
    private int capacity;
    private int registrations;
    private double revenue;
    private double avgRating;
    private int ratingCount;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public LocalDateTime getDateTime() { return dateTime; }
    public void setDateTime(LocalDateTime dateTime) { this.dateTime = dateTime; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public boolean isVirtual() { return isVirtual; }
    public void setVirtual(boolean isVirtual) { this.isVirtual = isVirtual; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public int getRegistrations() { return registrations; }
    public void setRegistrations(int registrations) { this.registrations = registrations; }
    public double getRevenue() { return revenue; }
    public void setRevenue(double revenue) { this.revenue = revenue; }
    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }
    public int getRatingCount() { return ratingCount; }
    public void setRatingCount(int ratingCount) { this.ratingCount = ratingCount; }

    public int getFillPercent() {
        if (capacity == 0) return 0;
        return Math.min(100, (int) Math.round((double) registrations / capacity * 100));
    }
}
