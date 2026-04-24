package com.webtechproject.model;

import java.time.LocalDateTime;

public class Registration {
    private int id;
    private int userId;
    private int eventId;
    private String ticketType;
    private double pricePaid;
    private String status;
    private LocalDateTime registeredAt;
    private Event event;

    public Registration() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
    public String getTicketType() { return ticketType; }
    public void setTicketType(String ticketType) { this.ticketType = ticketType; }
    public double getPricePaid() { return pricePaid; }
    public void setPricePaid(double pricePaid) { this.pricePaid = pricePaid; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getRegisteredAt() { return registeredAt; }
    public void setRegisteredAt(LocalDateTime registeredAt) { this.registeredAt = registeredAt; }
    public Event getEvent() { return event; }
    public void setEvent(Event event) { this.event = event; }
}
