package com.webtechproject.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Event {
    private static final DateTimeFormatter DISPLAY_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private int id;
    private String title;
    private String description;
    private LocalDateTime dateTime;
    private String location;
    private int capacity;
    private double price;
    private boolean isVirtual;

    public Event() {}

    public Event(int id, String title, String description,
                 LocalDateTime dateTime, String location,
                 int capacity, double price, boolean isVirtual) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.dateTime = dateTime;
        this.location = location;
        this.capacity = capacity;
        this.price = price;
        this.isVirtual = isVirtual;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public LocalDateTime getDateTime() { return dateTime; }
    public void setDateTime(LocalDateTime dateTime) { this.dateTime = dateTime; }
    public String getFormattedDateTime() { return dateTime == null ? "" : dateTime.format(DISPLAY_FORMATTER); }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public boolean isVirtual() { return isVirtual; }
    public void setVirtual(boolean isVirtual) { this.isVirtual = isVirtual; }
    private int organizerId;
    public int getOrganizerId() { return organizerId; }
    public void setOrganizerId(int organizerId) { this.organizerId = organizerId; }
}
